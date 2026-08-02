"""Offline tests for benchmark trace, strict-mode, and model preflight guards."""

from __future__ import annotations

import json
import sys
import types
from pathlib import Path

import pytest


PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))

import run_complete_nl2sql_pipeline as runner
from scripts import smoke_test_drspider30 as smoke


@pytest.fixture(autouse=True)
def _provider_keys(monkeypatch):
    monkeypatch.setenv("OPENAI_API_KEY", "offline-openai")
    monkeypatch.setenv("GEMINI_API_KEY", "offline-gemini")
    monkeypatch.setenv("ANTHROPIC_API_KEY", "offline-anthropic")
    monkeypatch.setenv("DEEPSEEK_API_KEY", "offline-deepseek")


def _trace(step_name: str, attempt: int, **extra) -> dict:
    return {"step_name": step_name, "attempt": attempt, **extra}


def test_six_step_trace_accepts_retries_failures_and_skips():
    traces = [
        _trace("question_analysis", 1, success=False),
        _trace("question_analysis", 2, success=True),
        _trace("schema_selector", 1, success=True),
        _trace("query_planning", 0, skipped=True),
        _trace("generate_sql_direct", 1, success=True),
        _trace("generate_sql_planned", 0, skipped=True),
        _trace("refine_sql", 1, success=False),
        _trace("refine_sql", 1, success=True),
        _trace("validate_sql", 0, skipped=True),
    ]

    runner.validate_six_step_trace(traces)
    assert runner.count_trace_attempts(traces) == 6


@pytest.mark.parametrize(
    "traces, message",
    [
        (
            [
                _trace("question_analysis", 1),
                _trace("schema_selector", 1),
                _trace("query_planning", 0, skipped=True),
                _trace("generate_sql_planned", 1),
                _trace("generate_sql_direct", 1),
                _trace("refine_sql", 0, skipped=True),
                _trace("validate_sql", 0, skipped=True),
            ],
            "trace order",
        ),
        (
            [
                _trace("question_analysis", 1),
                _trace("schema_selector", 1),
                _trace("query_planning", 0, skipped=True),
                _trace("generate_sql_direct", 1),
                _trace("refine_sql", 0, skipped=True),
                _trace("validate_sql", 0, skipped=True),
            ],
            "missing logical phases",
        ),
        (
            [
                _trace("question_analysis", 1, success=True),
                _trace("schema_selector", 1, success=True),
                _trace("query_planning", 0, skipped=True),
                _trace("generate_sql_direct", 1, success=True),
                _trace("generate_sql_planned", 0, skipped=True),
                _trace("refine_sql", 1, success=False),
                _trace("validate_sql", 0, skipped=True),
            ],
            "did not finish successfully",
        ),
    ],
)
def test_six_step_trace_rejects_invalid_logical_sequence(traces, message):
    with pytest.raises(RuntimeError, match=message):
        runner.validate_six_step_trace(traces)


def test_anthropic_model_listing_uses_get_without_inference(
    monkeypatch,
):
    captured = {}

    class FakeResponse:
        def __enter__(self):
            return self

        def __exit__(self, *args):
            return False

        def read(self):
            return json.dumps(
                {
                    "data": [{"id": "claude-sonnet-test"}],
                    "has_more": False,
                }
            ).encode("utf-8")

    def fake_urlopen(request, timeout):
        captured["request"] = request
        captured["timeout"] = timeout
        return FakeResponse()

    monkeypatch.setattr(runner, "urlopen", fake_urlopen)

    model_ids = runner.fetch_anthropic_model_ids(
        "dummy-secret",
        base_url="https://api.anthropic.test",
        timeout=7,
    )

    request = captured["request"]
    headers = {key.lower(): value for key, value in request.header_items()}
    assert request.get_method() == "GET"
    assert "/v1/models?" in request.full_url
    assert headers["x-api-key"] == "dummy-secret"
    assert captured["timeout"] == 7
    assert model_ids == {"claude-sonnet-test"}


def test_refiner_preflight_skips_four_step(monkeypatch):
    monkeypatch.setattr(runner, "PIPELINE_TYPE", "4step")

    def unexpected_fetch(*args, **kwargs):
        raise AssertionError("4-step must not contact Anthropic")

    monkeypatch.setattr(runner, "fetch_anthropic_model_ids", unexpected_fetch)
    runner.preflight_configured_refiner()


def test_provider_key_validation_fails_before_inference(monkeypatch):
    monkeypatch.setattr(runner, "PIPELINE_TYPE", "6step")
    monkeypatch.delenv("DEEPSEEK_API_KEY", raising=False)

    with pytest.raises(RuntimeError, match="DEEPSEEK_API_KEY"):
        runner.validate_configured_provider_keys()


def test_refiner_preflight_can_be_explicitly_skipped(monkeypatch):
    monkeypatch.setattr(runner, "PIPELINE_TYPE", "6step")
    monkeypatch.setenv("NL2SQL_SKIP_MODEL_PREFLIGHT", "true")

    def unexpected_fetch(*args, **kwargs):
        raise AssertionError("skip flag must avoid Anthropic")

    monkeypatch.setattr(runner, "fetch_anthropic_model_ids", unexpected_fetch)
    runner.preflight_configured_refiner()


def test_refiner_preflight_fails_without_exposing_key(monkeypatch, capsys):
    monkeypatch.setattr(runner, "PIPELINE_TYPE", "6step")
    monkeypatch.delenv("NL2SQL_SKIP_MODEL_PREFLIGHT", raising=False)
    monkeypatch.setenv(
        "NL2SQL_SQL_REFINER_MODEL",
        "anthropic/claude-unavailable",
    )
    monkeypatch.setenv("ANTHROPIC_API_KEY", "dummy-secret")
    monkeypatch.setattr(
        runner,
        "fetch_anthropic_model_ids",
        lambda *args, **kwargs: {"claude-available"},
    )

    with pytest.raises(RuntimeError, match="claude-unavailable"):
        runner.preflight_configured_refiner()

    assert "dummy-secret" not in capsys.readouterr().out


def test_unavailable_model_aborts_before_runner_initialization(
    tmp_path,
    monkeypatch,
):
    monkeypatch.setattr(runner, "PIPELINE_TYPE", "6step")
    monkeypatch.setattr(runner, "PIPELINE_OUTPUT_DIR", tmp_path)
    monkeypatch.delenv("NL2SQL_SKIP_MODEL_PREFLIGHT", raising=False)
    monkeypatch.setenv(
        "NL2SQL_SQL_REFINER_MODEL",
        "anthropic/claude-unavailable",
    )
    monkeypatch.setenv("ANTHROPIC_API_KEY", "dummy-secret")
    monkeypatch.setattr(
        runner,
        "fetch_anthropic_model_ids",
        lambda *args, **kwargs: set(),
    )

    with pytest.raises(RuntimeError, match="claude-unavailable"):
        runner.run_nl2sql_system([])

    assert not list(tmp_path.glob("nl2sql_results_*.csv"))


def test_both_pipeline_smoke_preflights_before_paid_children(
    tmp_path,
    monkeypatch,
):
    child_calls = []
    monkeypatch.setattr(smoke.pipe, "configure_pipeline", lambda pipeline: None)
    monkeypatch.setattr(
        smoke.pipe,
        "preflight_configured_refiner",
        lambda: (_ for _ in ()).throw(RuntimeError("model unavailable")),
    )
    monkeypatch.setattr(
        smoke.subprocess,
        "run",
        lambda *args, **kwargs: child_calls.append((args, kwargs)),
    )
    args = types.SimpleNamespace(
        output_dir=str(tmp_path / "smoke"),
        fresh=False,
        seed=42,
        num_questions=34,
        all=False,
        seed_raw_from="",
    )

    with pytest.raises(RuntimeError, match="model unavailable"):
        smoke.run_isolated_both(args)

    assert child_calls == []


def test_strict_benchmark_saves_trace_and_counts_real_attempts(
    tmp_path,
    monkeypatch,
):
    class Payload:
        def __init__(self, **values):
            self.__dict__.update(values)

    class FakeFlow:
        def __init__(self, **kwargs):
            self.step_traces = [
                _trace("question_analysis", 1, success=False),
                _trace("question_analysis", 2, success=False),
            ]

        def kickoff(self):
            raise RuntimeError("synthetic flow failure")

    fake_main = types.ModuleType("nl2sql_flow.main")
    fake_main.NL2SQLFlow = FakeFlow
    fake_main.NLQuestions = Payload
    fake_main.SQLDbSchema = Payload
    fake_main.NL2SQLResult = Payload
    fake_package = types.ModuleType("nl2sql_flow")
    fake_package.__path__ = []
    monkeypatch.setitem(sys.modules, "nl2sql_flow", fake_package)
    monkeypatch.setitem(sys.modules, "nl2sql_flow.main", fake_main)

    monkeypatch.setattr(runner, "PIPELINE_TYPE", "4step")
    monkeypatch.setattr(runner, "PIPELINE_OUTPUT_DIR", tmp_path)
    monkeypatch.setattr(runner, "assert_loaded_pipeline", lambda flow: None)
    monkeypatch.setattr(
        runner,
        "compute_pipeline_signature",
        lambda: "test-signature",
    )
    monkeypatch.setattr(runner, "ai_request_count", 0)
    monkeypatch.setattr(
        runner,
        "execution_metrics",
        {"total": 0, "successful": 0, "failed": 0},
    )
    monkeypatch.setattr(
        runner,
        "api_call_details",
        {
            "per_question": [],
            "enhancement_calls": 0,
            "total_agent_calls": 0,
        },
    )
    monkeypatch.setenv("NL2SQL_STRICT_BENCHMARK", "true")

    question = {
        "question_index": 7,
        "db_id": "toy",
        "question": "Synthetic question",
        "gold_query": "SELECT value FROM toy",
        "table_names_original": ["toy"],
        "column_names_original": [(-1, "*"), (0, "value")],
        "column_types": ["text", "number"],
    }

    with pytest.raises(RuntimeError, match="synthetic flow failure"):
        runner.run_nl2sql_system([question])

    trace_path = (
        tmp_path
        / "raw_responses"
        / "toy"
        / "q0007.error.json"
    )
    trace = json.loads(trace_path.read_text(encoding="utf-8"))
    assert trace["api_calls"] == 2
    assert len(trace["steps"]) == 2
    assert runner.ai_request_count == 2
    assert runner.api_call_details["total_agent_calls"] == 2

    csv_files = list(tmp_path.glob("nl2sql_results_*.csv"))
    assert len(csv_files) == 1
    assert len(csv_files[0].read_text(encoding="utf-8").splitlines()) == 1
