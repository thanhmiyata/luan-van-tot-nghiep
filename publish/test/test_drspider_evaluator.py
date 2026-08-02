"""Regression tests for Dr.Spider evaluation and metric reporting."""

from __future__ import annotations

import sqlite3
import subprocess
import sys
from pathlib import Path

import pytest

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))

from scripts import smoke_test_drspider30 as smoke


def test_parse_official_metrics_uses_all_column():
    output = """
                         easy     medium   hard     extra    all
    execution            0.750    0.929    1.000    0.500    0.824
    exact match          0.375    0.786    0.167    0.167    0.471
    """

    metrics = smoke.parse_official_metrics(output)

    assert metrics == {
        "execution_rate": pytest.approx(82.4),
        "exact_match_rate": pytest.approx(47.1),
    }


def test_per_group_ex_passes_prediction_before_gold(tmp_path):
    db_id = "ordered_rows"
    db_dir = tmp_path / "database" / db_id
    db_dir.mkdir(parents=True)
    db_path = db_dir / f"{db_id}.sqlite"
    connection = sqlite3.connect(db_path)
    connection.execute("CREATE TABLE numbers (value INTEGER)")
    connection.executemany("INSERT INTO numbers VALUES (?)", [(2,), (1,)])
    connection.commit()
    connection.close()

    gold_path = tmp_path / "gold.sql"
    pred_path = tmp_path / "predict.sql"
    gold_path.write_text(
        f"SELECT value FROM numbers ORDER BY value ASC\t{db_id}\n",
        encoding="utf-8",
    )
    pred_path.write_text(
        f"SELECT value FROM numbers\t{db_id}\n",
        encoding="utf-8",
    )
    questions = [
        {
            "sample_id": "order-sensitive",
            "perturbation_group": "SQL",
            "perturbation_type": "SQL_sort_order",
            "difficulty": "easy",
            "db_id": db_id,
        }
    ]

    summary, rows = smoke.per_group_ex(
        questions,
        gold_path,
        pred_path,
        tmp_path / "database",
    )

    assert rows[0]["ex"] is False
    assert summary["n_correct"] == 0
    assert summary["by_difficulty"] == {
        "easy": {"n": 1, "n_correct": 0, "ex": 0.0}
    }


def test_official_eval_failure_is_not_silently_reported(tmp_path, monkeypatch):
    gold_path = tmp_path / "gold.sql"
    pred_path = tmp_path / "predict.sql"
    tables_path = tmp_path / "tables.json"
    gold_path.write_text("SELECT 1\ttoy\n", encoding="utf-8")
    pred_path.write_text("SELECT 1\ttoy\n", encoding="utf-8")
    tables_path.write_text("[]", encoding="utf-8")

    def fake_run(*args, **kwargs):
        return subprocess.CompletedProcess(
            args=args,
            returncode=2,
            stdout="partial evaluator output",
            stderr="synthetic failure",
        )

    monkeypatch.setattr(smoke.subprocess, "run", fake_run)

    with pytest.raises(RuntimeError, match="exit code 2"):
        smoke.run_official_eval(
            gold_path,
            pred_path,
            tmp_path / "database",
            tables_path,
        )

    log_text = (tmp_path / "official_eval_stdout.txt").read_text(
        encoding="utf-8"
    )
    assert "partial evaluator output" in log_text
    assert "synthetic failure" in log_text


def test_paired_ex_comparison_reports_discordant_cases_and_mcnemar():
    four_rows = [
        {"sample_id": "both", "ex": True},
        {"sample_id": "four-only", "ex": True},
        {"sample_id": "six-only", "ex": False},
        {"sample_id": "neither", "ex": False},
    ]
    six_rows = [
        {"sample_id": "both", "ex": True},
        {"sample_id": "four-only", "ex": False},
        {"sample_id": "six-only", "ex": True},
        {"sample_id": "neither", "ex": False},
    ]

    paired = smoke.paired_ex_comparison(four_rows, six_rows)

    assert paired == {
        "n": 4,
        "both_correct": 1,
        "both_wrong": 1,
        "four_step_only": 1,
        "six_step_only": 1,
        "six_minus_four_ex_points": 0.0,
        "mcnemar_exact_p": 1.0,
    }


def test_value_grounding_includes_boolean_text_sentinels(tmp_path):
    db_path = tmp_path / "flags.sqlite"
    connection = sqlite3.connect(db_path)
    connection.execute(
        "CREATE TABLE degree_program (is_master TEXT, is_bachelor TEXT)"
    )
    connection.executemany(
        "INSERT INTO degree_program VALUES (?, ?)",
        [("T", "F"), ("F", "T")],
    )
    connection.commit()
    connection.close()
    schema = {
        "table_names_original": ["degree_program"],
        "column_names_original": [
            [-1, "*"],
            [0, "is_master"],
            [0, "is_bachelor"],
        ],
        "column_types": ["text", "boolean", "boolean"],
    }

    samples = smoke.collect_samples_from_path(db_path, schema)

    assert set(samples[1]) == {"T", "F"}
    assert set(samples[2]) == {"T", "F"}
