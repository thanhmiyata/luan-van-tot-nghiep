from pathlib import Path

import yaml


TASKS_PATH = (
    Path(__file__).resolve().parents[1]
    / "src"
    / "nl2sql_6step"
    / "nl2sql_flow"
    / "crews"
    / "nl2sql_crew"
    / "config"
    / "tasks.yaml"
)
AGENTS_PATH = TASKS_PATH.with_name("agents.yaml")


def _descriptions() -> dict[str, str]:
    tasks = yaml.safe_load(TASKS_PATH.read_text(encoding="utf-8"))
    return {name: config["description"] for name, config in tasks.items()}


def test_analyzer_contract_covers_drspider_failure_modes() -> None:
    analyzer = _descriptions()["question_analysis_task"]

    assert "ENTITY_CARRIER/FILTER" in analyzer
    assert "called X" in analyzer
    assert "outputs the option field only" in analyzer
    assert 'null_handling="INNER_JOIN"' in analyzer
    assert 'null_handling="LEFT_JOIN"' in analyzer
    assert 'T/F -> "T"' in analyzer
    assert "never translate" in analyzer


def test_generator_contract_separates_direct_and_planned_invocations() -> None:
    generator = _descriptions()["generate_sql_task"]

    assert 'status="WITHHELD_FROM_DIRECT_CANDIDATE"' in generator
    assert "ignore Analysis and Join Plan" in generator
    assert "leave planned_sql empty" in generator
    assert "leave direct_sql empty" in generator
    assert "table_names_original" in generator
    assert "Never emit a human-readable semantic label" in generator


def test_review_prompts_reject_left_join_and_output_leakage() -> None:
    descriptions = _descriptions()

    for task_name in ("refine_sql_task", "validate_sql_task"):
        description = " ".join(descriptions[task_name].split())
        assert "ENTITY_CARRIER/FILTER" in description
        assert "Reject LEFT JOIN" in description
        assert "unmatched" in description
        assert "SQL TRUE" in description


def test_agent_backstories_do_not_override_semantic_review_contract() -> None:
    agents = yaml.safe_load(AGENTS_PATH.read_text(encoding="utf-8"))

    for role in ("sql_refiner", "sql_validator"):
        backstory = " ".join(agents[role]["backstory"].split())
        assert "deterministic and semantic reports both pass" in backstory
        assert "LEFT JOIN" in backstory
