"""Offline regression tests for the Dr.Spider six-step pipeline."""

import importlib
import inspect
import re
import sys
from pathlib import Path

import pytest


PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))


def _load_six_step_main():
    for module_name in list(sys.modules):
        if module_name == "nl2sql_flow" or module_name.startswith("nl2sql_flow."):
            del sys.modules[module_name]
    six_step_path = str((PROJECT_ROOT / "src" / "nl2sql_6step").resolve())
    sys.path.insert(0, six_step_path)
    return importlib.import_module("nl2sql_flow.main")


def test_switching_pipeline_does_not_reuse_shared_module():
    import run_complete_nl2sql_pipeline as runner

    runner.configure_pipeline("4step")
    four_step_flow = importlib.import_module("nl2sql_flow.main").NL2SQLFlow
    four_step_file = Path(inspect.getfile(four_step_flow)).resolve()

    runner.configure_pipeline("6step")
    six_step_flow = importlib.import_module("nl2sql_flow.main").NL2SQLFlow
    six_step_file = Path(inspect.getfile(six_step_flow)).resolve()

    runner.assert_loaded_pipeline(six_step_flow)
    assert "nl2sql_4step" in four_step_file.as_posix()
    assert "nl2sql_6step" in six_step_file.as_posix()
    assert four_step_flow is not six_step_flow


def test_semantic_audit_flags_missing_set_operation():
    main = _load_six_step_main()
    analysis = {
        "set_operation": {"operator": "INTERSECT"},
        "risk_flags": ["set-operation"],
    }

    report = main.audit_sql_semantics(
        "SELECT name FROM singer",
        "Find singers appearing in both groups.",
        analysis,
    )

    assert report.parser == "sqlglot"
    assert not report.valid
    assert "SET_OPERATION_MISSING" in {
        violation["code"] for violation in report.violations
    }


def test_safe_schema_filter_preserves_semantic_labels_and_columns(monkeypatch):
    main = _load_six_step_main()
    monkeypatch.setenv("NL2SQL_SCHEMA_FILTER_MODE", "safe_superset")
    schema = main.SQLDbSchema(
        db_id="toy",
        table_names=["singers", "concerts"],
        table_names_original=["singer", "concert"],
        column_names=[
            (-1, "*"),
            (0, "singer id"),
            (0, "singer name"),
            (1, "concert id"),
        ],
        column_names_original=[
            (-1, "*"),
            (0, "Singer_ID"),
            (0, "Name"),
            (1, "Concert_ID"),
        ],
        column_types=["text", "number", "text", "number"],
        primary_keys=[1, 3],
    )

    filtered = main.rebuild_filtered_schema(
        schema,
        {
            "table_names_original": ["singer"],
            "column_names_original": [[0, "Name"]],
        },
        {"complexity": "EASY", "confidence": 0.95},
    )

    assert filtered.table_names == ["singers"]
    assert filtered.table_names_original == ["singer"]
    assert filtered.column_names == [
        (-1, "*"),
        (0, "singer id"),
        (0, "singer name"),
    ]
    assert filtered.column_names_original == [
        (-1, "*"),
        (0, "Singer_ID"),
        (0, "Name"),
    ]


def test_refiner_preference_breaks_only_audit_ties():
    main = _load_six_step_main()
    valid_deterministic = main.SQLAuditResult(valid=True)
    valid_semantic = main.SQLSemanticAuditResult(valid=True)
    invalid_semantic = main.SQLSemanticAuditResult(
        valid=False,
        violations=[{"code": "MISSING_FILTER", "message": "missing"}],
    )

    label, *_ = main.choose_best_candidate(
        [
            (
                "direct",
                main.NL2SQLResult(sql="SELECT a FROM t"),
                valid_deterministic,
                valid_semantic,
            ),
            (
                "planned",
                main.NL2SQLResult(sql="SELECT b FROM t"),
                valid_deterministic,
                valid_semantic,
            ),
        ],
        preferred_labels=["planned", "direct"],
    )
    assert label == "planned"

    label, *_ = main.choose_best_candidate(
        [
            (
                "direct",
                main.NL2SQLResult(sql="SELECT a FROM t"),
                valid_deterministic,
                valid_semantic,
            ),
            (
                "planned",
                main.NL2SQLResult(sql="SELECT b FROM t"),
                valid_deterministic,
                invalid_semantic,
            ),
        ],
        preferred_labels=["planned", "direct"],
    )
    assert label == "direct"


def test_choose_best_candidate_prefers_fewer_tables_on_audit_tie():
    main = _load_six_step_main()
    valid_deterministic = main.SQLAuditResult(valid=True)
    direct_semantic = main.SQLSemanticAuditResult(
        valid=True,
        signature={"tables": ["matches"]},
    )
    planned_semantic = main.SQLSemanticAuditResult(
        valid=True,
        signature={"tables": ["matches", "players"]},
        risk_reasons=["JOIN_OVERGENERATION: players"],
    )

    label, *_ = main.choose_best_candidate(
        [
            (
                "planned",
                main.NL2SQLResult(
                    sql=(
                        "SELECT p.first_name FROM players p "
                        "JOIN matches m ON p.player_id = m.winner_id"
                    )
                ),
                valid_deterministic,
                planned_semantic,
            ),
            (
                "direct",
                main.NL2SQLResult(
                    sql="SELECT winner_name FROM matches WHERE year = 2013"
                ),
                valid_deterministic,
                direct_semantic,
            ),
        ],
        preferred_labels=["planned", "direct"],
    )
    assert label == "direct"


def test_direct_anchor_blocks_join_bloat_and_set_op_regression():
    main = _load_six_step_main()
    valid = main.SQLAuditResult(valid=True)
    direct = main.NL2SQLResult(
        sql=(
            "SELECT winner_name FROM matches WHERE year = 2013 "
            "INTERSECT SELECT winner_name FROM matches WHERE year = 2016"
        )
    )
    planned = main.NL2SQLResult(
        sql=(
            "SELECT T1.first_name, T1.last_name FROM players AS T1 "
            "JOIN matches AS T2 ON T1.player_id = T2.winner_id "
            "WHERE T2.year = 2013 INTERSECT "
            "SELECT T1.first_name, T1.last_name FROM players AS T1 "
            "JOIN matches AS T2 ON T1.player_id = T2.winner_id "
            "WHERE T2.year = 2016"
        )
    )
    planned_semantic = main.SQLSemanticAuditResult(
        valid=True,
        risk_reasons=["JOIN_OVERGENERATION: players"],
    )
    reason = main.direct_candidate_anchor_reason(
        "Find winners in both 2013 and 2016",
        direct,
        valid,
        planned,
        alternative_semantic=planned_semantic,
    )
    assert "fewer-table" in reason or "set-operation" in reason


def test_repair_population_count_as_sum_and_bogus_order_by_alias():
    main = _load_six_step_main()
    fixed = main.repair_population_count_as_sum(
        "SELECT COUNT(*) FROM city WHERE District = 'Gelderland'",
        "How many people live in Gelderland district?",
    )
    assert "SUM(POPULATION)" in fixed.upper().replace(" ", "")

    ordered = main.repair_bogus_order_by_aggregate_alias(
        "SELECT Country, count(id) FROM TV_Channel "
        "GROUP BY Country ORDER BY number_of_TV_Channels DESC LIMIT 1"
    )
    ordered_l = re.sub(r"\s+", "", ordered.lower())
    assert "orderbycount(*)" in ordered_l
    assert "number_of_tv_channels" not in ordered_l


def test_seed_mapper_can_skip_direct_for_analyzer_schema_only(monkeypatch):
    main = _load_six_step_main()
    four_raw = {
        "steps": [
            {
                "step_name": "question_analysis",
                "raw_response": '{"intent":"LIST"}',
                "success": True,
            },
            {
                "step_name": "schema_selector",
                "raw_response": '{"table_names_original":["t"]}',
                "success": True,
            },
            {
                "step_name": "generate_sql",
                "raw_response": '{"sql":"SELECT 1"}',
                "success": True,
            },
        ]
    }
    monkeypatch.setenv("NL2SQL_SEED_INCLUDE_DIRECT", "0")
    mapped = main.map_four_step_seed_to_six_steps(four_raw)
    assert set(mapped) == {"question_analysis", "schema_selector"}
    monkeypatch.setenv("NL2SQL_SEED_INCLUDE_DIRECT", "1")
    mapped_full = main.map_four_step_seed_to_six_steps(four_raw)
    assert "generate_sql_direct" in mapped_full


def test_semantic_identifiers_are_canonicalized_for_sql():
    main = _load_six_step_main()
    schema = main.SQLDbSchema(
        db_id="network",
        table_names=["high schooler"],
        table_names_original=["Highschooler"],
        column_names=[(-1, "*"), (0, "student id"), (0, "grade")],
        column_names_original=[(-1, "*"), (0, "ID"), (0, "grade")],
        column_types=["text", "number", "number"],
    )

    analysis = main.canonicalize_structured_identifiers(
        {
            "required_tables": ["high schooler"],
            "output_fields_detailed": [
                {"table": "high schooler", "column": "grade"}
            ],
            "having": [
                {"table": "high schooler", "column": "student id"}
            ],
        },
        schema,
    )
    sql = main.canonicalize_sql_identifiers(
        "SELECT grade FROM 'high schooler' "
        'GROUP BY grade HAVING COUNT("student id") >= 4',
        schema,
    )

    assert analysis["required_tables"] == ["Highschooler"]
    assert analysis["having"][0] == {
        "table": "Highschooler",
        "column": "ID",
    }
    assert '"Highschooler"' not in sql
    assert "FROM Highschooler" in sql
    assert 'COUNT("student id")' not in sql
    assert "COUNT(ID)" in sql


def test_executable_schema_hides_semantic_labels():
    main = _load_six_step_main()
    schema = main.SQLDbSchema(
        table_names=["template types"],
        table_names_original=["Ref_Template_Types"],
        column_names=[(-1, "*"), (0, "template type code")],
        column_names_original=[(-1, "*"), (0, "Template_Type_Code")],
        column_types=["text", "text"],
    )

    result = main.executable_schema(schema)

    assert result.table_names == ["Ref_Template_Types"]
    assert result.column_names == [(-1, "*"), (0, "Template_Type_Code")]


def test_direct_candidate_schema_withholds_analysis_derived_plan():
    main = _load_six_step_main()
    schema = main.SQLDbSchema(
        table_names=["teachers", "courses"],
        table_names_original=["teacher", "course"],
        column_names=[(-1, "*"), (0, "teacher id"), (1, "teacher id")],
        column_names_original=[
            (-1, "*"),
            (0, "Teacher_ID"),
            (1, "Teacher_ID"),
        ],
        named_foreign_keys=[
            {
                "foreign_table": "course",
                "foreign_column": "Teacher_ID",
                "referenced_table": "teacher",
                "referenced_column": "Teacher_ID",
                "condition": "course.Teacher_ID = teacher.Teacher_ID",
            }
        ],
        join_plan=[{"from_table": "teacher", "to_table": "course"}],
        required_tables=["teacher", "course"],
        join_plan_warnings=["analysis-derived warning"],
    )

    direct = main.direct_candidate_schema(schema)

    assert direct.table_names == ["teacher", "course"]
    assert direct.named_foreign_keys == schema.named_foreign_keys
    assert direct.join_plan == []
    assert direct.required_tables == []
    assert direct.join_plan_warnings == []


def test_semantic_audit_rejects_unjustified_left_join():
    main = _load_six_step_main()

    report = main.audit_sql_semantics(
        "SELECT teacher.Name, COUNT(course.ID) "
        "FROM teacher LEFT JOIN course ON teacher.ID = course.Teacher_ID "
        "GROUP BY teacher.ID",
        "Show teacher names and how many courses they teach.",
        {
            "output_fields_detailed": [
                {"table": "teacher", "column": "Name", "agg": "NONE"},
                {"table": "course", "column": "ID", "agg": "COUNT"},
            ]
        },
    )

    assert "UNJUSTIFIED_LEFT_JOIN" in {
        violation["code"] for violation in report.violations
    }


def test_semantic_audit_allows_explicit_zero_retention():
    main = _load_six_step_main()

    report = main.audit_sql_semantics(
        "SELECT teacher.Name, COUNT(course.ID) "
        "FROM teacher LEFT JOIN course ON teacher.ID = course.Teacher_ID "
        "GROUP BY teacher.ID",
        "Show every teacher, including teachers with no courses.",
        {
            "output_fields_detailed": [
                {"table": "teacher", "column": "Name", "agg": "NONE"},
                {"table": "course", "column": "ID", "agg": "COUNT"},
            ]
        },
    )

    assert "UNJUSTIFIED_LEFT_JOIN" not in {
        violation["code"] for violation in report.violations
    }


def test_risk_flag_alone_does_not_pay_for_refiner(monkeypatch):
    main = _load_six_step_main()
    monkeypatch.delenv("NL2SQL_REFINER_ON_RISK_ONLY", raising=False)
    deterministic = main.SQLAuditResult(valid=True)
    semantic = main.SQLSemanticAuditResult(
        valid=True,
        signature={"tables": ["t"], "projections": ["name"]},
        risk_reasons=["complexity=HARD"],
    )

    review, reasons = main.requires_semantic_review(
        deterministic,
        deterministic,
        semantic,
        semantic,
    )

    assert review is False
    assert reasons == ["complexity=HARD"]


def test_candidate_disagreement_or_violation_requires_refiner():
    main = _load_six_step_main()
    deterministic = main.SQLAuditResult(valid=True)
    direct_semantic = main.SQLSemanticAuditResult(
        valid=True,
        signature={"tables": ["t"], "projections": ["name"]},
    )
    planned_semantic = main.SQLSemanticAuditResult(
        valid=False,
        signature={"tables": ["t"], "projections": ["name", "id"]},
        violations=[
            {
                "code": "OUTPUT_FIELD_MISMATCH",
                "message": "extra output carrier",
            }
        ],
    )

    review, reasons = main.requires_semantic_review(
        deterministic,
        deterministic,
        direct_semantic,
        planned_semantic,
    )

    assert review is True
    assert "planned SQL violates semantic contract" in reasons
    assert "direct and planned SQL signatures disagree" in reasons


def test_high_impact_output_role_risk_requires_refiner():
    main = _load_six_step_main()
    deterministic = main.SQLAuditResult(valid=True)
    semantic = main.SQLSemanticAuditResult(
        valid=True,
        signature={"tables": ["t"], "projections": ["option"]},
        risk_reasons=["OUTPUT_ROLE_AMBIGUITY"],
    )

    review, reasons = main.requires_semantic_review(
        deterministic,
        deterministic,
        semantic,
        semantic,
    )

    assert review is True
    assert "high-impact risk: OUTPUT_ROLE_AMBIGUITY" in reasons


@pytest.mark.parametrize("selected", ["direct", "planned", "repaired"])
def test_refiner_candidate_preference_keeps_selected_first(selected):
    main = _load_six_step_main()

    preference = main.refiner_candidate_preference(selected)

    assert preference[0] == selected
    assert len(preference) == len(set(preference))


def test_unmatched_retention_requires_explicit_question_wording():
    main = _load_six_step_main()

    implicit = main.normalize_question_analysis(
        "Show teacher names and how many courses they teach.",
        {
            "retain_unmatched_entities": True,
            "include_zero_groups": True,
        },
    )
    explicit = main.normalize_question_analysis(
        "Show every teacher, including teachers with no courses.",
        {},
    )

    assert implicit["retain_unmatched_entities"] is False
    assert implicit["include_zero_groups"] is False
    assert implicit["null_handling"] == "INNER_JOIN"
    assert explicit["retain_unmatched_entities"] is True
    assert explicit["include_zero_groups"] is True
    assert explicit["null_handling"] == "LEFT_JOIN"


def test_boolean_concept_is_grounded_to_observed_text_sentinel():
    main = _load_six_step_main()
    schema = main.SQLDbSchema(
        table_names=["transcripts"],
        table_names_original=["Transcripts"],
        column_names=[(-1, "*"), (0, "transcript available")],
        column_names_original=[(-1, "*"), (0, "Transcript_Available")],
        column_types=["text", "text"],
        column_sample_values=[[], ["T", "F"]],
    )

    normalized = main.normalize_low_cardinality_literals(
        {
            "filters": [
                {
                    "table": "Transcripts",
                    "column": "Transcript_Available",
                    "operator": "=",
                    "value": True,
                    "value_type": "OTHER",
                }
            ],
            "literal_bindings": [],
        },
        schema,
    )

    assert normalized["filters"][0]["value"] == "T"
    assert normalized["filters"][0]["value_type"] == "STRING"
    assert normalized["literal_bindings"] == [
        {
            "literal": "T",
            "table": "Transcripts",
            "column": "Transcript_Available",
            "evidence": "SAMPLE_VALUE",
        }
    ]


def test_semantic_literal_audit_distinguishes_t_from_sql_true():
    main = _load_six_step_main()
    analysis = {
        "literal_bindings": [
            {
                "literal": "T",
                "table": "degree_program",
                "column": "is_master",
                "evidence": "SAMPLE_VALUE",
            }
        ]
    }

    wrong = main.audit_sql_semantics(
        "SELECT id FROM degree_program WHERE is_master = TRUE",
        "Show master degree identifiers.",
        analysis,
    )
    correct = main.audit_sql_semantics(
        "SELECT id FROM degree_program WHERE is_master = 'T'",
        "Show master degree identifiers.",
        analysis,
    )

    assert "LITERAL_MISSING" in {
        violation["code"] for violation in wrong.violations
    }
    assert "LITERAL_MISSING" not in {
        violation["code"] for violation in correct.violations
    }


def test_positive_related_rows_do_not_require_negation():
    main = _load_six_step_main()

    report = main.audit_sql_semantics(
        "SELECT teacher.name FROM teacher WHERE EXISTS "
        "(SELECT 1 FROM course WHERE course.teacher_id = teacher.id)",
        "Show teachers who teach courses.",
        {
            "predicate_scope": [
                {
                    "scope": "RELATED_ROWS",
                    "logic": "EXISTS",
                }
            ],
            "required_tables": ["teacher", "course"],
        },
    )

    assert "RELATED_NEGATION_UNSAFE" not in {
        violation["code"] for violation in report.violations
    }


def test_named_entity_carrier_is_removed_from_multi_field_contract():
    main = _load_six_step_main()

    normalized = main.normalize_question_analysis(
        "For the item called Alpha, which options are offered?",
        {
            "output_fields_detailed": [
                {"table": "item", "column": "name", "agg": "NONE"},
                {"table": "package", "column": "option", "agg": "NONE"},
            ],
            "literal_bindings": [
                {
                    "literal": "Alpha",
                    "table": "item",
                    "column": "name",
                    "evidence": "QUESTION",
                }
            ],
        },
    )

    assert normalized["output_fields_detailed"] == [
        {"table": "package", "column": "option", "agg": "NONE"}
    ]
    assert "OUTPUT_ROLE_AMBIGUITY" in normalized["risk_flags"]


def test_semantic_audit_rejects_named_entity_carrier_in_projection():
    main = _load_six_step_main()

    report = main.audit_sql_semantics(
        "SELECT item.name, package.option FROM item "
        "JOIN package ON item.id = package.item_id "
        "WHERE item.name = 'Alpha'",
        "For the item called Alpha, which options are offered?",
        {
            "literal_bindings": [
                {
                    "literal": "Alpha",
                    "table": "item",
                    "column": "name",
                }
            ],
            "output_fields_detailed": [
                {"table": "package", "column": "option", "agg": "NONE"}
            ],
        },
    )

    assert "ENTITY_CARRIER_PROJECTED" in {
        violation["code"] for violation in report.violations
    }


def test_semantic_audit_allows_explicitly_requested_name_carrier():
    main = _load_six_step_main()

    report = main.audit_sql_semantics(
        "SELECT item.name, package.option FROM item "
        "JOIN package ON item.id = package.item_id "
        "WHERE item.name = 'Alpha'",
        "Show the name and option for the item called Alpha.",
        {
            "literal_bindings": [
                {
                    "literal": "Alpha",
                    "table": "item",
                    "column": "name",
                }
            ],
            "output_fields_detailed": [
                {"table": "item", "column": "name", "agg": "NONE"},
                {"table": "package", "column": "option", "agg": "NONE"},
            ],
        },
    )

    assert "ENTITY_CARRIER_PROJECTED" not in {
        violation["code"] for violation in report.violations
    }


def test_normalize_strftime_year_on_born_date_column():
    main = _load_six_step_main()
    schema = main.SQLDbSchema(
        db_id="singer",
        table_names=["singer"],
        table_names_original=["singer"],
        column_names=[(-1, "*"), (0, "Name"), (0, "born_date")],
        column_names_original=[(-1, "*"), (0, "Name"), (0, "born_date")],
        column_types=["text", "text", "number"],
    )

    rewritten = main.normalize_numeric_year_predicates(
        "SELECT Name FROM singer WHERE strftime('%Y', born_date) "
        "IN ('1948', '1949')",
        schema,
    )

    assert "strftime" not in rewritten.lower()
    assert "born_dateIN(1948,1949)" in rewritten.replace(" ", "")


def test_semantic_audit_flags_year_strftime_and_order_direction():
    main = _load_six_step_main()

    year_report = main.audit_sql_semantics(
        "SELECT Name FROM singer WHERE strftime('%Y', born_date) = '1948'",
        "What are the names of singers born in 1948?",
        {"required_tables": ["singer"]},
    )
    order_report = main.audit_sql_semantics(
        "SELECT Name FROM conductor ORDER BY COUNT(*) DESC",
        "Show the name of the conductor that has conducted the least orchestras.",
        {
            "required_tables": ["conductor"],
            "order_by": [{"table": "conductor", "column": "cnt", "direction": "ASC"}],
        },
    )

    assert "YEAR_STRFTIME_PREDICATE" in {
        violation["code"] for violation in year_report.violations
    }
    assert "ORDER_BY_DIRECTION_MISMATCH" in {
        violation["code"] for violation in order_report.violations
    }


def test_extended_route_triggers_on_ranking_and_year_wording():
    main = _load_six_step_main()
    schema = main.SQLDbSchema(
        db_id="toy",
        table_names=["t"],
        table_names_original=["t"],
        column_names=[(-1, "*"), (0, "id")],
        column_names_original=[(-1, "*"), (0, "id")],
        column_types=["text", "number"],
    )

    reasons = main.extended_route_reasons(
        {"complexity": "EASY", "risk_flags": []},
        schema,
        question="What is the lightest weight of eight-cylinder cars made in 1974?",
    )

    assert "ranking/extremum wording" in reasons
    assert "year-valued filter wording" in reasons


def test_join_overgeneration_risk_requires_refiner():
    main = _load_six_step_main()
    deterministic = main.SQLAuditResult(valid=True)
    semantic = main.SQLSemanticAuditResult(
        valid=True,
        signature={"tables": ["matches", "rankings"], "projections": ["winner_name"]},
        risk_reasons=["JOIN_OVERGENERATION: rankings"],
    )

    review, reasons = main.requires_semantic_review(
        deterministic,
        deterministic,
        semantic,
        semantic,
    )

    assert review is True
    assert any("JOIN_OVERGENERATION" in reason for reason in reasons)


def test_strict_final_invariant_requires_real_sqlite_explain(monkeypatch):
    main = _load_six_step_main()
    schema = main.SQLDbSchema(
        db_id="definitely_missing_database",
        table_names=["toy"],
        table_names_original=["toy"],
        column_names=[(-1, "*"), (0, "value")],
        column_names_original=[(-1, "*"), (0, "value")],
        column_types=["text", "number"],
    )
    flow = main.NL2SQLFlow(
        _question=main.NLQuestions(
            db_id=schema.db_id,
            question="Show values.",
        ),
        _raw_schema=schema,
    )
    flow.state.db_id = schema.db_id
    flow.state.db_raw_schema = schema
    flow.state.result = main.NL2SQLResult(sql="SELECT value FROM toy")
    flow.step_traces = [
        {
            "step_name": "validate_sql",
            "attempt": 0,
            "skipped": True,
        }
    ]
    monkeypatch.setenv("NL2SQL_STRICT_BENCHMARK", "true")
    monkeypatch.delenv("SPIDER_DATABASE_DIR", raising=False)

    with pytest.raises(RuntimeError, match="DATABASE_NOT_FOUND"):
        flow._enforce_final_executable_result(schema)
