"""Offline tests for six-step role-specific LLM configuration."""

import importlib
import sys
from pathlib import Path

import pytest
from crewai import LLM


PROJECT_ROOT = Path(__file__).resolve().parents[1]
SIX_STEP_ROOT = str((PROJECT_ROOT / "src" / "nl2sql_6step").resolve())


@pytest.fixture(autouse=True)
def _restore_shared_nl2sql_import_state(monkeypatch):
    monkeypatch.setenv("DEEPSEEK_API_KEY", "offline-test-key")
    yield
    for module_name in list(sys.modules):
        if module_name == "nl2sql_flow" or module_name.startswith("nl2sql_flow."):
            del sys.modules[module_name]
    while SIX_STEP_ROOT in sys.path:
        sys.path.remove(SIX_STEP_ROOT)


def _load_crew_module():
    for module_name in list(sys.modules):
        if module_name == "nl2sql_flow" or module_name.startswith("nl2sql_flow."):
            del sys.modules[module_name]
    sys.path.insert(0, SIX_STEP_ROOT)
    return importlib.import_module(
        "nl2sql_flow.crews.nl2sql_crew.nl2sql_crew"
    )


def test_budget_defaults_are_role_specific(monkeypatch):
    module = _load_crew_module()
    for name in (
        "NL2SQL_LLM_TIMEOUT_SECONDS",
        "NL2SQL_MAX_COMPLETION_TOKENS",
        "NL2SQL_ENABLE_MODEL_FALLBACKS",
        "NL2SQL_QUESTION_ANALYZER_MODEL",
        "NL2SQL_QUESTION_ANALYZER_TIMEOUT_SECONDS",
        "NL2SQL_QUESTION_ANALYZER_MAX_COMPLETION_TOKENS",
        "NL2SQL_QUESTION_ANALYZER_THINKING",
        "NL2SQL_QUERY_PLANNER_MODEL",
        "NL2SQL_QUERY_PLANNER_TIMEOUT_SECONDS",
        "NL2SQL_QUERY_PLANNER_MAX_COMPLETION_TOKENS",
        "NL2SQL_QUERY_PLANNER_THINKING",
        "NL2SQL_SQL_REFINER_MODEL",
    ):
        monkeypatch.delenv(name, raising=False)

    crew = module.Nl2SqlCrew()
    analyzer = crew._llm_for("question_analyzer")
    planner = crew._llm_for("query_planner")
    refiner = crew._llm_for("sql_refiner")

    assert type(analyzer) is LLM
    assert analyzer.model == "openai/deepseek-v4-flash"
    assert analyzer.timeout == 35
    assert analyzer.max_completion_tokens == 3072
    assert analyzer.reasoning_effort is None
    assert analyzer.additional_params["extra_body"] == {
        "thinking": {"type": "disabled"}
    }

    assert planner.model == "openai/deepseek-v4-flash"
    assert planner.timeout == 30
    assert planner.max_completion_tokens == 2048
    assert planner.reasoning_effort == "high"
    assert planner.additional_params["extra_body"] == {
        "thinking": {"type": "enabled"}
    }

    assert refiner.model == "anthropic/claude-sonnet-5"
    assert refiner.timeout == 35
    assert refiner.max_completion_tokens == 1536
    assert type(refiner) is LLM


def test_role_overrides_and_deepseek_thinking_toggle(monkeypatch):
    module = _load_crew_module()
    monkeypatch.setenv(
        "NL2SQL_QUERY_PLANNER_MODEL", "deepseek/deepseek-v4-pro"
    )
    monkeypatch.setenv("NL2SQL_QUERY_PLANNER_TIMEOUT_SECONDS", "17")
    monkeypatch.setenv(
        "NL2SQL_QUERY_PLANNER_MAX_COMPLETION_TOKENS", "777"
    )
    monkeypatch.setenv("NL2SQL_QUERY_PLANNER_THINKING", "disabled")
    monkeypatch.setenv("NL2SQL_ENABLE_MODEL_FALLBACKS", "false")

    planner = module.Nl2SqlCrew()._llm_for("query_planner")

    assert type(planner) is LLM
    assert planner.model == "openai/deepseek-v4-pro"
    assert planner.timeout == 17
    assert planner.max_completion_tokens == 777
    assert planner.reasoning_effort is None
    assert planner.additional_params["extra_body"] == {
        "thinking": {"type": "disabled"}
    }


def test_instance_override_has_priority_and_generation_crews_instantiate(
    monkeypatch,
):
    module = _load_crew_module()
    monkeypatch.setenv(
        "NL2SQL_SQL_EXPERT_MODEL", "openai/environment-model"
    )
    monkeypatch.setenv("NL2SQL_ENABLE_MODEL_FALLBACKS", "false")

    direct = module.Nl2SqlCrew(
        model_overrides={"sql_expert": "openai/direct-model"}
    )
    planned = module.Nl2SqlCrew(
        model_overrides={"sql_expert": "openai/planned-model"}
    )

    assert direct._llm_for("sql_expert").model == "openai/direct-model"
    assert planned._llm_for("sql_expert").model == "openai/planned-model"
    assert direct.generated_sql_crew().__class__.__name__ == "Crew"
    assert planned.generated_sql_crew().__class__.__name__ == "Crew"


@pytest.mark.parametrize(
    "overrides, exception_type",
    [
        ({"unknown_role": "openai/model"}, ValueError),
        ({"sql_expert": ""}, ValueError),
        (["openai/model"], TypeError),
    ],
)
def test_invalid_instance_model_overrides_fail_early(
    overrides,
    exception_type,
):
    module = _load_crew_module()
    with pytest.raises(exception_type):
        module.Nl2SqlCrew(model_overrides=overrides)


def test_model_availability_error_uses_configured_fallback(monkeypatch):
    module = _load_crew_module()
    primary = module.FallbackLLM(
        model="anthropic/missing-model",
        timeout=1,
        max_completion_tokens=10,
        fallback_llm=LLM(
            model="gemini/gemini-2.5-flash",
            timeout=1,
            max_completion_tokens=10,
        ),
    )

    def fake_call(self, *args, **kwargs):
        if self.model == "anthropic/missing-model":
            raise RuntimeError("model_not_found")
        return '{"sql": "SELECT 1"}'

    monkeypatch.setattr(LLM, "call", fake_call)

    assert primary.call("test") == '{"sql": "SELECT 1"}'


def test_strict_benchmark_disables_hidden_nested_fallback(monkeypatch):
    module = _load_crew_module()
    monkeypatch.setenv("NL2SQL_ENABLE_MODEL_FALLBACKS", "true")
    monkeypatch.setenv("NL2SQL_STRICT_BENCHMARK", "true")

    analyzer = module.Nl2SqlCrew()._llm_for("question_analyzer")

    assert type(analyzer) is LLM


def test_deepseek_model_fails_before_request_without_provider_key(
    monkeypatch,
):
    module = _load_crew_module()
    monkeypatch.delenv("DEEPSEEK_API_KEY", raising=False)

    with pytest.raises(ValueError, match="DEEPSEEK_API_KEY"):
        module.Nl2SqlCrew()._llm_for("question_analyzer")
