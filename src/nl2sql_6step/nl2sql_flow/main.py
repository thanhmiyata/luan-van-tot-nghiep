#!/usr/bin/env python
import csv
import hashlib
import json
import os
import re
import sqlite3
import time
from collections import deque
from concurrent.futures import ThreadPoolExecutor, TimeoutError as FuturesTimeoutError
from datetime import datetime
from pathlib import Path
from pprint import pprint
from typing import Any, Dict, List, Optional, Set, Tuple
from pydantic import BaseModel, Field
from crewai import LLM, Crew
from crewai.flow.flow import Flow, listen, start
from nl2sql_flow.crews.nl2sql_crew.nl2sql_crew import Nl2SqlCrew


class NL2SQLOnlyResult(BaseModel):
    sql: str = ""


class NLQuestions(BaseModel):
    db_id: str = ""
    question: str = ""


class QuestionAnalysisResult(BaseModel):
    intent: str = ""
    complexity: str = ""
    expected_output_fields: List[str] = []
    field_order_critical: bool = True
    single_table_ok: bool = False
    required_tables: List[str] = []
    required_columns: List[Dict] = []
    output_fields_detailed: List[Dict] = []
    distinct: bool = False
    filters: List[Dict] = []
    literal_bindings: List[Dict] = []
    predicate_scope: List[Dict] = []
    group_by: List[Dict] = []
    having: List[Dict] = []
    order_by: List[Dict] = []
    set_operation: Dict = {}
    extreme_row: Optional[Dict] = None
    join_hints: List[Dict] = []
    entities: Dict = {}
    self_join_hint: bool = False
    set_operation_type: str = "NONE"
    null_handling: str = "UNKNOWN"
    where_condition_type: str = "EQUALS"
    confidence: float = 0.0


class NL2SQLResult(BaseModel):
    sql: str = ""
    explain: str = ""
    error: str = ""


class QueryPlanResult(BaseModel):
    steps: List[Dict] = []


class RefinedSQLResult(BaseModel):
    sql: str = ""
    notes: str = ""


class NL2SQLQualityResult(BaseModel):
    final_sql: str = ""
    quality_score: float = 0.0
    pipeline_summary: Dict = {}
    recommendations: List[str] = []
    confidence: float = 0.0


class SQLDbSchema(BaseModel):
    db_id: str = ""
    table_names_original: List[str] = []
    column_names_original: List[Tuple[int, str]] = []
    column_types: List[str] = []
    foreign_keys: List[List[int]] = []
    primary_keys: List[int] = []
    # Sample values per column (aligned with column_names_original) for value grounding
    column_sample_values: List[List[str]] = []
    question_value_matches: List[Dict[str, str]] = []
    named_foreign_keys: List[Dict[str, str]] = []
    join_plan: List[Dict[str, Any]] = []
    required_tables: List[str] = []
    join_plan_warnings: List[str] = []


class SQLAuditResult(BaseModel):
    """Deterministic checks used before accepting Refiner/Validator changes."""

    valid: bool = False
    sqlite_explain_ok: Optional[bool] = None
    database_path: str = ""
    fatal_errors: List[Dict[str, str]] = Field(default_factory=list)
    warnings: List[Dict[str, str]] = Field(default_factory=list)


def _schema_column_ref(
    schema: SQLDbSchema,
    column_index: int,
) -> Optional[Tuple[str, str]]:
    if column_index < 0 or column_index >= len(schema.column_names_original):
        return None
    table_index, column_name = schema.column_names_original[column_index]
    if table_index < 0 or table_index >= len(schema.table_names_original):
        return None
    return schema.table_names_original[table_index], column_name


def build_named_foreign_keys(schema: SQLDbSchema) -> List[Dict[str, str]]:
    """Convert Spider FK index pairs into human-readable join edges."""
    edges: List[Dict[str, str]] = []
    for foreign_index, referenced_index in schema.foreign_keys:
        foreign_ref = _schema_column_ref(schema, foreign_index)
        referenced_ref = _schema_column_ref(schema, referenced_index)
        if foreign_ref is None or referenced_ref is None:
            continue
        foreign_table, foreign_column = foreign_ref
        referenced_table, referenced_column = referenced_ref
        edges.append(
            {
                "foreign_table": foreign_table,
                "foreign_column": foreign_column,
                "referenced_table": referenced_table,
                "referenced_column": referenced_column,
                "condition": (
                    f"{foreign_table}.{foreign_column} = "
                    f"{referenced_table}.{referenced_column}"
                ),
            }
        )
    return edges


def enrich_schema_metadata(
    schema: SQLDbSchema,
    *,
    join_plan: Optional[List[Dict[str, Any]]] = None,
    required_tables: Optional[List[str]] = None,
    join_plan_warnings: Optional[List[str]] = None,
) -> SQLDbSchema:
    payload = schema.model_dump()
    payload.update(
        {
            "named_foreign_keys": build_named_foreign_keys(schema),
            "join_plan": join_plan if join_plan is not None else schema.join_plan,
            "required_tables": (
                required_tables
                if required_tables is not None
                else schema.required_tables
            ),
            "join_plan_warnings": (
                join_plan_warnings
                if join_plan_warnings is not None
                else schema.join_plan_warnings
            ),
        }
    )
    return SQLDbSchema(**payload)


def _analysis_table_names(
    analysis: Dict[str, Any],
    schema: SQLDbSchema,
) -> List[str]:
    candidates: Set[str] = set()

    def add(value: Any) -> None:
        if isinstance(value, str) and value.strip():
            candidates.add(value.strip().lower())

    for value in analysis.get("required_tables", []):
        add(value.get("table") if isinstance(value, dict) else value)
    for section in (
        "required_columns",
        "output_fields_detailed",
        "filters",
        "literal_bindings",
        "group_by",
        "having",
        "order_by",
        "scalar_comparisons",
    ):
        values = analysis.get(section, [])
        if isinstance(values, dict):
            values = [values]
        for value in values if isinstance(values, list) else []:
            if isinstance(value, dict):
                add(value.get("table"))
                scalar_value = value.get("value")
                if isinstance(scalar_value, dict):
                    add(scalar_value.get("table"))
    entities = analysis.get("entities", {})
    if isinstance(entities, dict):
        for value in entities.get("tables", []):
            add(value)
    for hint in analysis.get("join_hints", []):
        if isinstance(hint, dict):
            add(hint.get("from_table"))
            add(hint.get("to_table"))
    set_operation = analysis.get("set_operation", {})
    if isinstance(set_operation, dict):
        for branch in set_operation.get("branches", []):
            if isinstance(branch, dict):
                for value in branch.get("required_tables", []):
                    add(value)
                for value in branch.get("required_columns", []):
                    if isinstance(value, dict):
                        add(value.get("table"))
    extreme_row = analysis.get("extreme_row")
    if isinstance(extreme_row, dict):
        for key in ("rank_by", "project"):
            value = extreme_row.get(key)
            if isinstance(value, dict):
                add(value.get("table"))

    lookup = {
        table.lower(): table for table in schema.table_names_original
    }
    return [
        lookup[table.lower()]
        for table in schema.table_names_original
        if table.lower() in candidates
    ]


def _analysis_column_names(analysis: Dict[str, Any]) -> Set[str]:
    names: Set[str] = set()
    for section in (
        "required_columns",
        "output_fields_detailed",
        "filters",
        "literal_bindings",
        "group_by",
        "having",
        "order_by",
        "scalar_comparisons",
    ):
        values = analysis.get(section, [])
        if isinstance(values, dict):
            values = [values]
        for value in values if isinstance(values, list) else []:
            if not isinstance(value, dict):
                continue
            column = value.get("column")
            if isinstance(column, str) and column.strip() and column != "*":
                names.add(column.strip().lower())
            scalar_value = value.get("value")
            if isinstance(scalar_value, dict):
                scalar_column = scalar_value.get("column")
                if (
                    isinstance(scalar_column, str)
                    and scalar_column.strip()
                    and scalar_column != "*"
                ):
                    names.add(scalar_column.strip().lower())
    return names


def build_join_plan(
    schema: SQLDbSchema,
    required_tables: List[str],
) -> Tuple[List[Dict[str, Any]], List[str]]:
    """Connect required endpoints through shortest declared-FK paths."""
    order = {
        table.lower(): index
        for index, table in enumerate(schema.table_names_original)
    }
    canonical = {
        table.lower(): table for table in schema.table_names_original
    }
    endpoints = [
        canonical[table.lower()]
        for table in required_tables
        if table.lower() in canonical
    ]
    endpoints = list(dict.fromkeys(endpoints))
    if len(endpoints) <= 1:
        return [], []

    edge_groups: Dict[Tuple[str, str], List[Dict[str, str]]] = {}
    adjacency: Dict[str, Set[str]] = {
        table: set() for table in schema.table_names_original
    }
    for edge in build_named_foreign_keys(schema):
        left = edge["foreign_table"]
        right = edge["referenced_table"]
        pair = tuple(
            sorted((left, right), key=lambda name: order[name.lower()])
        )
        edge_groups.setdefault(pair, []).append(edge)
        adjacency[left].add(right)
        adjacency[right].add(left)

    connected: Set[str] = {endpoints[0]}
    planned: List[Dict[str, Any]] = []
    seen_pairs: Set[Tuple[str, str]] = set()
    warnings: List[str] = []
    for target in endpoints[1:]:
        if target in connected:
            continue
        queue = deque(sorted(connected, key=lambda name: order[name.lower()]))
        previous: Dict[str, Optional[str]] = {
            source: None for source in queue
        }
        while queue and target not in previous:
            current = queue.popleft()
            for neighbor in sorted(
                adjacency.get(current, set()),
                key=lambda name: order[name.lower()],
            ):
                if neighbor not in previous:
                    previous[neighbor] = current
                    queue.append(neighbor)
        if target not in previous:
            warnings.append(
                f"No declared FK path connects required table: {target}"
            )
            continue

        path: List[str] = []
        cursor: Optional[str] = target
        while cursor is not None:
            path.append(cursor)
            cursor = previous[cursor]
        path.reverse()
        for left, right in zip(path, path[1:]):
            pair = tuple(
                sorted((left, right), key=lambda name: order[name.lower()])
            )
            if pair not in seen_pairs:
                allowed_edges = sorted(
                    edge_groups[pair],
                    key=lambda edge: edge["condition"].lower(),
                )
                planned.append(
                    {
                        "from_table": left,
                        "to_table": right,
                        "allowed_edges": allowed_edges,
                        "ambiguous": len(allowed_edges) > 1,
                    }
                )
                seen_pairs.add(pair)
            connected.add(left)
            connected.add(right)
    return planned, warnings


def rebuild_filtered_schema(
    raw: SQLDbSchema,
    parsed: Dict,
    analysis: Optional[Dict[str, Any]] = None,
) -> SQLDbSchema:
    """Trust selector names only; rebuild indices and bridge paths in code."""
    analysis = analysis or {}
    raw = enrich_schema_metadata(raw)
    try:
        kept_table_names = {
            str(table).lower()
            for table in parsed.get("table_names_original", [])
            if str(table).strip()
        }
        required_tables = _analysis_table_names(analysis, raw)
        kept_table_names.update(table.lower() for table in required_tables)
        plan_endpoints = required_tables or [
            table
            for table in raw.table_names_original
            if table.lower() in kept_table_names
        ]
        join_plan, plan_warnings = build_join_plan(raw, plan_endpoints)
        for step in join_plan:
            kept_table_names.add(step["from_table"].lower())
            kept_table_names.add(step["to_table"].lower())

        kept_table_idxs = {
            index
            for index, table in enumerate(raw.table_names_original)
            if table.lower() in kept_table_names
        }
        if not kept_table_idxs:
            return enrich_schema_metadata(
                raw,
                required_tables=required_tables,
                join_plan=join_plan,
                join_plan_warnings=plan_warnings,
            )

        kept_col_names = _analysis_column_names(analysis)
        for entry in parsed.get("column_names_original", []):
            if isinstance(entry, (list, tuple)) and len(entry) >= 2:
                name = str(entry[1]).lower()
            else:
                name = str(entry).lower()
            if name and name != "*":
                kept_col_names.add(name)

        keep_cols: Set[int] = set()
        for column_index, (table_index, column_name) in enumerate(
            raw.column_names_original
        ):
            if table_index in kept_table_idxs and (
                not kept_col_names or column_name.lower() in kept_col_names
            ):
                keep_cols.add(column_index)
        for primary_key in raw.primary_keys:
            if raw.column_names_original[primary_key][0] in kept_table_idxs:
                keep_cols.add(primary_key)
        for left, right in raw.foreign_keys:
            if (
                raw.column_names_original[left][0] in kept_table_idxs
                and raw.column_names_original[right][0] in kept_table_idxs
            ):
                keep_cols.add(left)
                keep_cols.add(right)
        if not keep_cols:
            return raw

        old_tables = sorted(kept_table_idxs)
        new_tables = [raw.table_names_original[index] for index in old_tables]
        table_remap = {
            old_index: new_index
            for new_index, old_index in enumerate(old_tables)
        }
        new_columns: List[Tuple[int, str]] = [(-1, "*")]
        new_types: List[str] = ["text"]
        new_samples: List[List[str]] = [[]]
        column_remap: Dict[int, int] = {}
        has_samples = (
            len(raw.column_sample_values)
            == len(raw.column_names_original)
        )
        for column_index, (table_index, column_name) in enumerate(
            raw.column_names_original
        ):
            if column_index not in keep_cols or table_index < 0:
                continue
            column_remap[column_index] = len(new_columns)
            new_columns.append((table_remap[table_index], column_name))
            new_types.append(
                raw.column_types[column_index]
                if column_index < len(raw.column_types)
                else "text"
            )
            new_samples.append(
                raw.column_sample_values[column_index] if has_samples else []
            )
        new_fks = [
            [column_remap[left], column_remap[right]]
            for left, right in raw.foreign_keys
            if left in column_remap and right in column_remap
        ]
        new_pks = [
            column_remap[key]
            for key in raw.primary_keys
            if key in column_remap
        ]
        retained_columns = {
            (new_tables[table_index].lower(), column_name.lower())
            for table_index, column_name in new_columns
            if table_index >= 0
        }
        filtered = SQLDbSchema(
            db_id=raw.db_id,
            table_names_original=new_tables,
            column_names_original=new_columns,
            column_types=new_types,
            foreign_keys=new_fks,
            primary_keys=new_pks,
            column_sample_values=new_samples,
            question_value_matches=[
                match
                for match in raw.question_value_matches
                if (
                    match.get("table", "").lower(),
                    match.get("column", "").lower(),
                )
                in retained_columns
            ],
            join_plan=join_plan,
            required_tables=required_tables,
            join_plan_warnings=plan_warnings,
        )
        return enrich_schema_metadata(
            filtered,
            join_plan=join_plan,
            required_tables=required_tables,
            join_plan_warnings=plan_warnings,
        )
    except Exception as error:
        print(
            "[schema_selector] rebuild_filtered_schema failed "
            f"({error}); falling back to raw schema"
        )
        return raw


def resolve_database_path(
    db_id: str,
    explicit_path: Optional[Path] = None,
) -> Optional[Path]:
    """Resolve the canonical Spider SQLite file independently of cwd."""
    if explicit_path is not None:
        candidate = Path(explicit_path).expanduser()
        return candidate.resolve() if candidate.is_file() else None

    project_root = Path(__file__).resolve().parents[3]
    candidates = [
        project_root
        / "data"
        / "spider_data"
        / "database"
        / db_id
        / f"{db_id}.sqlite",
        project_root
        / "experiments"
        / "test-suite-sql-eval"
        / "database"
        / db_id
        / f"{db_id}.sqlite",
    ]
    database_root = os.getenv("SPIDER_DATABASE_DIR")
    if database_root:
        root = Path(database_root).expanduser()
        candidates.extend(
            [root / db_id / f"{db_id}.sqlite", root / f"{db_id}.sqlite"]
        )
    for candidate in candidates:
        if candidate.is_file():
            return candidate.resolve()
    return None


def _quoted_identifier(identifier: str) -> str:
    return '"' + identifier.replace('"', '""') + '"'


def enrich_question_value_grounding(
    schema: SQLDbSchema,
    question: str,
    db_path: Optional[Path] = None,
) -> SQLDbSchema:
    """Prepend exact database values occurring as complete question spans."""
    resolved_path = resolve_database_path(schema.db_id, explicit_path=db_path)
    if resolved_path is None or not question.strip():
        return schema

    samples = [list(values) for values in schema.column_sample_values]
    if len(samples) != len(schema.column_names_original):
        samples = [[] for _ in schema.column_names_original]
    matches: List[Dict[str, str]] = []
    database_uri = f"{resolved_path.as_uri()}?mode=ro"
    try:
        with sqlite3.connect(database_uri, uri=True) as connection:
            connection.execute("PRAGMA query_only = ON")
            for column_index, (table_index, column_name) in enumerate(
                schema.column_names_original
            ):
                if (
                    table_index < 0
                    or table_index >= len(schema.table_names_original)
                    or column_index >= len(schema.column_types)
                    or schema.column_types[column_index].lower() != "text"
                ):
                    continue
                table_name = schema.table_names_original[table_index]
                quoted_table = _quoted_identifier(table_name)
                quoted_column = _quoted_identifier(column_name)
                query = (
                    f"SELECT DISTINCT {quoted_column} FROM {quoted_table} "
                    f"WHERE {quoted_column} IS NOT NULL "
                    f"AND length(trim(CAST({quoted_column} AS TEXT))) >= 3 "
                    f"AND instr(lower(?), "
                    f"lower(trim(CAST({quoted_column} AS TEXT)))) > 0 "
                    f"ORDER BY length(trim(CAST({quoted_column} AS TEXT))) DESC "
                    "LIMIT 8"
                )
                matched_values: List[str] = []
                for (raw_value,) in connection.execute(query, (question,)):
                    value = str(raw_value).strip()
                    if not value or not re.search(
                        rf"(?<!\w){re.escape(value)}(?!\w)",
                        question,
                        flags=re.IGNORECASE,
                    ):
                        continue
                    matched_values.append(value)
                    matches.append(
                        {
                            "table": table_name,
                            "column": column_name,
                            "value": value,
                            "evidence": "QUESTION_EXACT_DB_MATCH",
                        }
                    )
                if matched_values:
                    matched_casefold = {
                        value.casefold() for value in matched_values
                    }
                    samples[column_index] = [
                        *matched_values,
                        *[
                            sample
                            for sample in samples[column_index]
                            if str(sample).casefold() not in matched_casefold
                        ],
                    ][:8]
    except sqlite3.Error as error:
        print(f"[grounding] Exact-value lookup skipped: {error}")
        return schema

    payload = schema.model_dump()
    payload["column_sample_values"] = samples
    payload["question_value_matches"] = sorted(
        matches,
        key=lambda match: (
            -len(match["value"]),
            match["table"].lower(),
            match["column"].lower(),
        ),
    )
    return SQLDbSchema(**payload)


def _has_explicit_distinct_count(question: str) -> bool:
    normalized = " ".join(question.lower().split())
    patterns = (
        r"\bhow many(?:\s+\w+){0,3}\s+(?:different|distinct|unique)\b",
        r"\b(?:number|count) of(?:\s+\w+){0,3}\s+"
        r"(?:different|distinct|unique)\b",
        r"\b(?:different|distinct|unique)(?:\s+\w+){0,3}\s+"
        r"(?:are there|count|number)\b",
    )
    return any(re.search(pattern, normalized) for pattern in patterns)


def normalize_question_analysis(
    question: str,
    analysis: Dict[str, Any],
) -> Dict[str, Any]:
    """Normalize generic counts and unambiguous scalar aggregate operands."""
    normalized: Dict[str, Any] = json.loads(json.dumps(analysis or {}))
    notes = normalized.get("normalization_notes", [])
    if not isinstance(notes, list):
        notes = []
    question_lower = " ".join(question.lower().split())
    count_wording = bool(
        re.search(r"\b(?:how many|number of|count of)\b", question_lower)
    )
    explicit_distinct = _has_explicit_distinct_count(question)
    output_fields = normalized.get("output_fields_detailed", [])
    if not isinstance(output_fields, list):
        output_fields = []
    count_field_found = False
    for field in output_fields:
        if not isinstance(field, dict):
            continue
        aggregate = str(field.get("agg", "")).upper()
        if aggregate in {"COUNT", "COUNT_DISTINCT"}:
            count_field_found = True
            if count_wording and not explicit_distinct:
                field.update({"agg": "COUNT", "table": "", "column": "*"})
    if (
        str(normalized.get("intent", "")).upper() == "COUNT"
        and count_wording
        and not count_field_found
    ):
        output_fields.append(
            {
                "table": "",
                "column": "*",
                "agg": "COUNT",
                "alias": None,
                "order_index": 0,
            }
        )
        count_field_found = True
    if count_wording and count_field_found and not explicit_distinct:
        normalized["distinct"] = False
        for having_item in normalized.get("having", []):
            if (
                isinstance(having_item, dict)
                and str(having_item.get("agg", "")).upper()
                in {"COUNT", "COUNT_DISTINCT"}
            ):
                having_item.update(
                    {"agg": "COUNT", "table": "", "column": "*"}
                )
        notes.append(
            "Generic counting normalized to COUNT(*); no explicit "
            "different/distinct/unique wording was present."
        )
    normalized["output_fields_detailed"] = output_fields

    aggregate_words = {
        "minimum": "MIN",
        "min": "MIN",
        "lowest": "MIN",
        "maximum": "MAX",
        "max": "MAX",
        "highest": "MAX",
        "average": "AVG",
        "avg": "AVG",
    }
    scalar_comparisons = normalized.get("scalar_comparisons", [])
    if not isinstance(scalar_comparisons, list):
        scalar_comparisons = []
    converted_literals: Set[str] = set()
    filters = normalized.get("filters", [])
    for filter_item in filters if isinstance(filters, list) else []:
        if not isinstance(filter_item, dict) or not filter_item.get("column"):
            continue
        value = filter_item.get("value")
        if not isinstance(value, str):
            continue
        aggregate = aggregate_words.get(value.strip().lower())
        if aggregate is None:
            continue
        scalar_value = {
            "kind": "SCALAR_AGGREGATE",
            "agg": aggregate,
            "table": filter_item.get("table", ""),
            "column": filter_item["column"],
        }
        filter_item["value"] = scalar_value
        filter_item["value_type"] = "SUBQUERY"
        if aggregate == "MIN" and re.search(
            r"\b(?:more than|greater than|above|do not have|does not have|"
            r"don't have|doesn't have)\b",
            question_lower,
        ):
            filter_item["operator"] = ">"
        elif aggregate == "MAX" and re.search(
            r"\b(?:less than|below|do not have|does not have|"
            r"don't have|doesn't have)\b",
            question_lower,
        ):
            filter_item["operator"] = "<"
        scalar_comparisons.append(
            {
                "table": filter_item.get("table", ""),
                "column": filter_item["column"],
                "operator": filter_item.get("operator", "="),
                "value": scalar_value,
            }
        )
        converted_literals.add(value.strip().casefold())
        notes.append(
            f"Aggregate word '{value}' normalized to a scalar "
            f"{aggregate}(column) subquery."
        )
    if converted_literals:
        literal_bindings = normalized.get("literal_bindings", [])
        if isinstance(literal_bindings, list):
            normalized["literal_bindings"] = [
                binding
                for binding in literal_bindings
                if not (
                    isinstance(binding, dict)
                    and str(binding.get("literal", "")).strip().casefold()
                    in converted_literals
                )
            ]
    normalized["scalar_comparisons"] = scalar_comparisons
    normalized["normalization_notes"] = list(dict.fromkeys(notes))
    return normalized


def audit_sql_constraints(
    sql: str,
    schema: SQLDbSchema,
    *,
    db_id: Optional[str] = None,
    db_path: Optional[Path] = None,
) -> SQLAuditResult:
    """Run read-only statement and SQLite EXPLAIN checks."""
    stripped_sql = sql.strip()
    fatal_errors: List[Dict[str, str]] = []
    statements = [
        statement.strip()
        for statement in stripped_sql.split(";")
        if statement.strip()
    ]
    if not stripped_sql:
        fatal_errors.append(
            {"code": "EMPTY_SQL", "message": "The generated SQL is empty."}
        )
    elif len(statements) != 1:
        fatal_errors.append(
            {
                "code": "MULTIPLE_STATEMENTS",
                "message": "Exactly one SQL statement is allowed.",
            }
        )
    elif not re.match(r"\s*(?:SELECT|WITH)\b", stripped_sql, re.IGNORECASE):
        fatal_errors.append(
            {
                "code": "NON_READ_ONLY_SQL",
                "message": "Only a read-only SELECT/CTE is allowed.",
            }
        )
    elif re.search(
        r"\b(?:ALTER|ATTACH|CREATE|DELETE|DETACH|DROP|INSERT|PRAGMA|"
        r"REINDEX|UPDATE|VACUUM)\b",
        stripped_sql,
        re.IGNORECASE,
    ):
        fatal_errors.append(
            {
                "code": "NON_READ_ONLY_SQL",
                "message": "Mutation keywords are not allowed.",
            }
        )

    resolved_path = resolve_database_path(
        db_id or schema.db_id,
        explicit_path=db_path,
    )
    warnings: List[Dict[str, str]] = []
    sqlite_explain_ok: Optional[bool] = None
    if resolved_path is None:
        warnings.append(
            {
                "code": "DATABASE_NOT_FOUND",
                "message": "SQLite EXPLAIN was skipped.",
            }
        )
    elif not fatal_errors:
        try:
            database_uri = f"{resolved_path.as_uri()}?mode=ro"
            with sqlite3.connect(database_uri, uri=True) as connection:
                connection.execute("PRAGMA query_only = ON")
                connection.execute(
                    f"EXPLAIN QUERY PLAN {stripped_sql}"
                ).fetchall()
            sqlite_explain_ok = True
        except sqlite3.Error as error:
            sqlite_explain_ok = False
            fatal_errors.append(
                {"code": "SQLITE_EXPLAIN_ERROR", "message": str(error)}
            )
    return SQLAuditResult(
        valid=not fatal_errors,
        sqlite_explain_ok=sqlite_explain_ok,
        database_path=str(resolved_path) if resolved_path else "",
        fatal_errors=fatal_errors,
        warnings=warnings,
    )


def select_audited_result(
    previous: NL2SQLResult,
    previous_audit: SQLAuditResult,
    candidate: NL2SQLResult,
    candidate_audit: SQLAuditResult,
    *,
    question: str = "",
    analysis: Optional[Dict[str, Any]] = None,
    candidate_stage: str = "Validator",
) -> NL2SQLResult:
    """Reject a Refiner/Validator candidate that deterministically regresses."""
    if previous_audit.valid and not candidate_audit.valid:
        introduced_codes = ", ".join(
            issue["code"] for issue in candidate_audit.fatal_errors
        )
        return NL2SQLResult(
            sql=previous.sql,
            explain=(
                f"Kept previous SQL because {candidate_stage} introduced "
                f"fatal deterministic error(s): {introduced_codes}."
            ),
            error="",
        )
    analysis = analysis or {}
    generic_count_intent = (
        str(analysis.get("intent", "")).upper() == "COUNT"
        and not _has_explicit_distinct_count(question)
    )
    previous_has_count_star = bool(
        re.search(r"\bCOUNT\s*\(\s*\*\s*\)", previous.sql, re.IGNORECASE)
    )
    candidate_has_count = bool(
        re.search(r"\bCOUNT\s*\(", candidate.sql, re.IGNORECASE)
    )
    candidate_has_count_star = bool(
        re.search(r"\bCOUNT\s*\(\s*\*\s*\)", candidate.sql, re.IGNORECASE)
    )
    if (
        previous_audit.valid
        and candidate_audit.valid
        and generic_count_intent
        and previous_has_count_star
        and candidate_has_count
        and not candidate_has_count_star
    ):
        return NL2SQLResult(
            sql=previous.sql,
            explain=(
                f"Kept previous SQL because {candidate_stage} replaced "
                "COUNT(*) without explicit distinct or null-sensitive wording."
            ),
            error="",
        )
    # If previous SQL already passes deterministic checks, ignore stylistic/semantic
    # rewrites from Refiner/Validator (over-refinement guard).
    if (
        previous_audit.valid
        and candidate_audit.valid
        and previous.sql.strip()
        and previous.sql.strip() != candidate.sql.strip()
    ):
        return NL2SQLResult(
            sql=previous.sql,
            explain=(
                f"Kept previous SQL because constraint report was already valid; "
                f"{candidate_stage} rewrite ignored (no-op)."
            ),
            error="",
        )
    return candidate


class NL2SQLState(BaseModel):
    db_id: str = ""
    question: str = ""
    question_analysis: Dict = {}
    db_raw_schema: SQLDbSchema = SQLDbSchema()
    db_schema: SQLDbSchema = SQLDbSchema()
    query_plan: Dict = {}
    intermediate_sql: str = ""
    result: NL2SQLResult = NL2SQLResult()


class NL2SQLFlow(Flow[NL2SQLState]):
    """Flow for generate SQL from natural language instructions."""

    STEP_TIMEOUT_SECONDS = int(os.getenv("NL2SQL_STEP_TIMEOUT_SECONDS", "40"))
    STEP_MAX_RETRIES = int(os.getenv("NL2SQL_STEP_MAX_RETRIES", "2"))

    def __init__(self, _question: NLQuestions, _raw_schema: SQLDbSchema):
        super().__init__()
        self.question = _question
        self.raw_schema = _raw_schema
        # Full trace of every agent step (raw LLM responses) for experiment logging
        self.step_traces: List[Dict] = []

    @start()
    def get_user_input(self):
        print(
            f"\nStarting create SQL for question '{self.question.question}' database {self.raw_schema.db_id}\n")
        self.state.db_id = self.raw_schema.db_id
        self.state.question = self.question.question
        enriched_schema = enrich_schema_metadata(self.raw_schema)
        self.state.db_raw_schema = enrich_question_value_grounding(
            enriched_schema,
            self.state.question,
        )
        return self.state

    def parse_json_safely(self, text: str) -> Dict:
        """Extract and parse JSON from LLM output that might contain markdown backticks."""
        def iter_json_candidates(raw_text: str):
            stripped = raw_text.strip()
            if stripped:
                yield stripped

            # Many providers wrap valid JSON in fenced code blocks.
            for match in re.finditer(r'```(?:json)?\s*(.*?)\s*```', raw_text, re.DOTALL | re.IGNORECASE):
                candidate = match.group(1).strip()
                if candidate:
                    yield candidate

            # Some models prepend prose and then append a JSON object at the end.
            stack = 0
            start_idx = None
            objects = []
            for idx, ch in enumerate(raw_text):
                if ch == "{":
                    if stack == 0:
                        start_idx = idx
                    stack += 1
                elif ch == "}":
                    if stack > 0:
                        stack -= 1
                        if stack == 0 and start_idx is not None:
                            candidate = raw_text[start_idx:idx + 1].strip()
                            if candidate:
                                objects.append(candidate)
                            start_idx = None

            # Prefer later JSON objects because the actual answer is often appended last.
            for candidate in reversed(objects):
                yield candidate

        last_error = None
        for candidate in iter_json_candidates(text):
            try:
                return json.loads(candidate)
            except Exception as e:
                last_error = e

        if last_error is not None:
            print(f"Warning: Failed to parse JSON from text. Error: {last_error}")
        return {}

    def _sanitize_text(self, value: str) -> str:
        """Remove characters that frequently break JSON serialization or provider parsing."""
        if not value:
            return value
        sanitized = value.replace("\x00", "")
        sanitized = sanitized.encode("utf-8", "replace").decode("utf-8")
        sanitized = re.sub(r"[\x01-\x08\x0b\x0c\x0e-\x1f]", " ", sanitized)
        return sanitized

    def _sanitize_inputs(self, value: Any) -> Any:
        if isinstance(value, str):
            return self._sanitize_text(value)
        if isinstance(value, list):
            return [self._sanitize_inputs(item) for item in value]
        if isinstance(value, dict):
            return {key: self._sanitize_inputs(val) for key, val in value.items()}
        return value

    def _log_input_summary(self, step_name: str, inputs: Dict[str, Any]) -> None:
        summary_parts = []
        for key, value in inputs.items():
            serialized = value if isinstance(value, str) else json.dumps(value, ensure_ascii=False)
            digest = hashlib.md5(serialized.encode("utf-8", "ignore")).hexdigest()[:8]
            preview = serialized[:120].replace("\n", " ")
            summary_parts.append(
                f"{key}:len={len(serialized)} md5={digest} preview={preview!r}"
            )
        print(f"[API][{step_name}] Input summary")
        for part in summary_parts:
            print(f"  - {part}")

    def _run_crew_step(self, step_name: str, crew_factory, inputs: Dict[str, Any]):
        sanitized_inputs = self._sanitize_inputs(inputs)
        self._log_input_summary(step_name, sanitized_inputs)
        last_error: Exception | None = None

        for attempt in range(1, self.STEP_MAX_RETRIES + 1):
            executor = ThreadPoolExecutor(max_workers=1)
            started_at = time.time()
            print(
                f"[API][{step_name}] Attempt {attempt}/{self.STEP_MAX_RETRIES} started "
                f"(timeout={self.STEP_TIMEOUT_SECONDS}s)"
            )
            try:
                future = executor.submit(lambda: crew_factory().kickoff(inputs=sanitized_inputs))
                result = future.result(timeout=self.STEP_TIMEOUT_SECONDS)
                elapsed = time.time() - started_at
                raw_text = getattr(result, "raw", "")
                print(
                    f"[API][{step_name}] Attempt {attempt} completed in {elapsed:.1f}s "
                    f"(raw_len={len(raw_text)})"
                )
                token_usage = getattr(result, "token_usage", None)
                if token_usage is not None and hasattr(token_usage, "model_dump"):
                    token_usage = token_usage.model_dump()
                self.step_traces.append({
                    "step_name": step_name,
                    "attempt": attempt,
                    "elapsed_seconds": round(elapsed, 3),
                    "raw_response": raw_text,
                    "token_usage": token_usage,
                    "timestamp": datetime.now().isoformat(),
                })
                executor.shutdown(wait=False, cancel_futures=True)
                return result
            except FuturesTimeoutError as e:
                last_error = TimeoutError(
                    f"{step_name} timed out after {self.STEP_TIMEOUT_SECONDS}s on attempt {attempt}"
                )
                print(f"[API][{step_name}] Timeout on attempt {attempt}")
                future.cancel()
                executor.shutdown(wait=False, cancel_futures=True)
            except Exception as e:
                last_error = e
                print(f"[API][{step_name}] Error on attempt {attempt}: {type(e).__name__}: {e}")
                executor.shutdown(wait=False, cancel_futures=True)

            if attempt < self.STEP_MAX_RETRIES:
                backoff = min(5 * attempt, 15)
                print(f"[API][{step_name}] Retrying after {backoff}s")
                time.sleep(backoff)

        assert last_error is not None
        raise last_error

    def _attach_deterministic_audit(
        self,
        step_name: str,
        audit: SQLAuditResult,
    ) -> None:
        for trace in reversed(self.step_traces):
            if trace.get("step_name") == step_name:
                trace["deterministic_audit"] = audit.model_dump()
                return

    @listen(get_user_input)
    def question_analysis(self):
        print(f"\nAnalyzing question for intent and complexity\n")
        result = self._run_crew_step(
            "question_analysis",
            Nl2SqlCrew().question_analysis_crew,
            {
                "question": self.state.question,
                "raw_db_schema": self.state.db_raw_schema.model_dump_json(),
            },
        )
        parsed_analysis = self.parse_json_safely(result.raw)
        self.state.question_analysis = normalize_question_analysis(
            self.state.question,
            parsed_analysis,
        )
        print(
            f"\nQuestion Analysis Results:\n{json.dumps(self.state.question_analysis, indent=2)}\n")
        return self.state

    @listen(question_analysis)
    def schema_selector(self):
        print(f"\nSelecting needed schema database for question\n")
        result = self._run_crew_step(
            "schema_selector",
            Nl2SqlCrew().select_needed_schema_crew,
            {
                "question": self.state.question,
                "raw_db_schema": self.state.db_raw_schema.model_dump_json(),
                "question_analysis": json.dumps(self.state.question_analysis),
                "named_fk_graph": json.dumps(
                    self.state.db_raw_schema.named_foreign_keys
                ),
            },
        )
        schema_dict = self.parse_json_safely(result.raw)
        # Rebuild indices/FK/PK in code: only the NAMES from the selector are trusted
        self.state.db_schema = rebuild_filtered_schema(
            self.state.db_raw_schema,
            schema_dict,
            self.state.question_analysis,
        )
        if (
            self.state.db_schema.join_plan
            or len(self.state.db_schema.required_tables) > 1
        ):
            self.state.question_analysis["single_table_ok"] = False
        print(
            f"[schema_selector] Filtered schema: {self.state.db_schema.table_names_original} "
            f"({len(self.state.db_schema.column_names_original) - 1} columns, "
            f"{len(self.state.db_schema.foreign_keys)} FKs, "
            f"{len(self.state.db_schema.join_plan)} planned join steps)"
        )
        return self.state

    @listen(schema_selector)
    def query_planning(self):
        print(f"\nPlanning query strategy\n")
        result = self._run_crew_step(
            "query_planning",
            Nl2SqlCrew().query_planning_crew,
            {
                "question": self.state.question,
                "db_schema": self.state.db_schema.model_dump_json(),
                "question_analysis": json.dumps(self.state.question_analysis),
                "join_plan": json.dumps(self.state.db_schema.join_plan),
            },
        )
        self.state.query_plan = self.parse_json_safely(result.raw)
        print(f"\nQuery Plan:\n{json.dumps(self.state.query_plan, indent=2)}\n")
        return self.state

    @listen(query_planning)
    def generate_sql(self):
        print(f"\nGenerating SQL for question\n")
        result = self._run_crew_step(
            "generate_sql",
            Nl2SqlCrew().generated_sql_crew,
            {
                "question": self.state.question,
                "db_schema": self.state.db_schema.model_dump_json(),
                "question_analysis": json.dumps(self.state.question_analysis),
                "query_plan": json.dumps(self.state.query_plan),
                "join_plan": json.dumps(self.state.db_schema.join_plan),
            },
        )
        sql_dict = self.parse_json_safely(result.raw)
        generated_sql = (sql_dict.get("sql") or "").strip()
        self.state.intermediate_sql = generated_sql if generated_sql else result.raw
        print(f"\nGenerated initial SQL:\n{self.state.intermediate_sql}\n")
        return self.state

    @listen(generate_sql)
    def refine_sql(self):
        print(f"\nRefining generated SQL\n")
        generated = NL2SQLResult(sql=self.state.intermediate_sql)
        audit_schema = enrich_schema_metadata(
            self.state.db_raw_schema,
            join_plan=self.state.db_schema.join_plan,
            required_tables=self.state.db_schema.required_tables,
            join_plan_warnings=self.state.db_schema.join_plan_warnings,
        )
        generated_audit = audit_sql_constraints(
            generated.sql,
            audit_schema,
            db_id=self.state.db_id,
        )
        self._attach_deterministic_audit("generate_sql", generated_audit)
        # No-op: do not rewrite executable SQL that already passes deterministic checks.
        if generated_audit.valid and generated.sql.strip():
            print(
                "[refine_sql] Constraint report OK — skipping Refiner "
                "(preserve Generator SQL to avoid over-refinement)"
            )
            self.state.result = NL2SQLResult(
                sql=generated.sql,
                explain="Refiner no-op: Generator SQL already constraint-valid.",
                error="",
            )
            print(f"\nRefined SQL:\n{self.state.result.sql}\n")
            return self.state
        try:
            result = self._run_crew_step(
                "refine_sql",
                Nl2SqlCrew().sql_refinement_crew,
                {
                    "question": self.state.question,
                    "db_schema": self.state.db_schema.model_dump_json(),
                    "sql": self.state.intermediate_sql,
                    "question_analysis": json.dumps(self.state.question_analysis),
                    "query_plan": json.dumps(self.state.query_plan),
                    "join_plan": json.dumps(self.state.db_schema.join_plan),
                    "constraint_report": generated_audit.model_dump_json(),
                },
            )
            result_dict = self.parse_json_safely(result.raw)
            # Empty/missing sql from the refiner must not wipe out a valid intermediate SQL
            refined_sql = (result_dict.get("sql") or "").strip()
            refined = NL2SQLResult(
                sql=refined_sql if refined_sql else self.state.intermediate_sql,
                explain=result_dict.get("notes", ""),
                error="",
            )
            refined_audit = audit_sql_constraints(
                refined.sql,
                audit_schema,
                db_id=self.state.db_id,
            )
            self._attach_deterministic_audit("refine_sql", refined_audit)
            self.state.result = select_audited_result(
                generated,
                generated_audit,
                refined,
                refined_audit,
                question=self.state.question,
                analysis=self.state.question_analysis,
                candidate_stage="Refiner",
            )
        except Exception as e:
            print(f"[API][refine_sql] Fallback to intermediate SQL due to: {type(e).__name__}: {e}")
            self.state.result = generated
        print(f"\nRefined SQL:\n{self.state.result.sql}\n")
        return self.state

    @listen(refine_sql)
    def validate_sql(self):
        print(f"\nValidate generated SQL\n")
        refined = self.state.result.model_copy(deep=True)
        audit_schema = enrich_schema_metadata(
            self.state.db_raw_schema,
            join_plan=self.state.db_schema.join_plan,
            required_tables=self.state.db_schema.required_tables,
            join_plan_warnings=self.state.db_schema.join_plan_warnings,
        )
        refined_audit = audit_sql_constraints(
            refined.sql,
            audit_schema,
            db_id=self.state.db_id,
        )
        # No-op: do not rewrite executable SQL that already passes deterministic checks.
        if refined_audit.valid and refined.sql.strip():
            print(
                "[validate_sql] Constraint report OK — skipping Validator "
                "(preserve current SQL to avoid over-refinement)"
            )
            self.state.result = NL2SQLResult(
                sql=refined.sql,
                explain="Validator no-op: current SQL already constraint-valid.",
                error="",
            )
            print(f"\nFinal SQL:\n")
            print(json.dumps(self.state.result.model_dump(), indent=4))
            return self.state
        try:
            result = self._run_crew_step(
                "validate_sql",
                Nl2SqlCrew().validate_sql_crew,
                {
                    "question": self.state.question,
                    "db_schema": self.state.db_schema.model_dump_json(),
                    "sql": self.state.result.sql,
                    "question_analysis": json.dumps(self.state.question_analysis),
                    "query_plan": json.dumps(self.state.query_plan),
                    "join_plan": json.dumps(self.state.db_schema.join_plan),
                    "constraint_report": refined_audit.model_dump_json(),
                },
            )
            result_dict = self.parse_json_safely(result.raw)
            validated = NL2SQLResult(**result_dict)
            # If the validator output could not be parsed into a usable SQL,
            # keep the refined SQL instead of ending with an empty prediction.
            if not validated.sql.strip():
                print("[API][validate_sql] Validator returned empty SQL; keeping refined SQL")
                validated.sql = self.state.result.sql
                if not validated.explain:
                    validated.explain = "Validator output unparsable; kept refined SQL."
            validated_audit = audit_sql_constraints(
                validated.sql,
                audit_schema,
                db_id=self.state.db_id,
            )
            self._attach_deterministic_audit(
                "validate_sql",
                validated_audit,
            )
            selected = select_audited_result(
                refined,
                refined_audit,
                validated,
                validated_audit,
                question=self.state.question,
                analysis=self.state.question_analysis,
                candidate_stage="Validator",
            )
            if selected.sql == refined.sql and validated.sql != refined.sql:
                print(
                    "[validate_sql] Deterministic guard rejected a Validator "
                    "regression; keeping Refiner SQL"
                )
            self.state.result = selected
        except Exception as e:
            print(f"[API][validate_sql] Fallback to current SQL due to: {type(e).__name__}: {e}")
            self.state.result = NL2SQLResult(
                sql=self.state.result.sql,
                explain="Validator fallback after API failure/timeout.",
                error="",
            )
        print(f"\nFinal SQL:\n")
        print(json.dumps(self.state.result.model_dump(), indent=4))

        return self.state


def run_optimized_nl2sql_pipeline(question: str, db_schema: Dict, db_id: str) -> Dict:
    """
    Run the optimized NL2SQL pipeline using the enhanced CrewAI workflow.
    
    Args:
        question: Natural language question
        db_schema: Database schema dictionary
        db_id: Database identifier
        
    Returns:
        Dictionary containing the complete pipeline results
    """
    try:
        # Initialize the optimized crew
        nl2sql_crew = Nl2SqlCrew()
        crew = nl2sql_crew.nl2sql_pipeline_crew()
        
        # Prepare inputs for the pipeline
        inputs = {
            'question': question,
            'raw_db_schema': json.dumps(db_schema, indent=2),
            'db_id': db_id
        }
        
        print(f"🚀 Starting optimized NL2SQL pipeline for question: {question[:50]}...")
        
        # Execute the complete pipeline
        result = crew.kickoff(inputs=inputs)
        
        print("✅ Pipeline completed successfully!")
        
        return {
            'success': True,
            'result': result,
            'pipeline_type': 'optimized_sequential',
            'timestamp': datetime.now().isoformat()
        }
        
    except Exception as e:
        print(f"❌ Pipeline failed: {str(e)}")
        return {
            'success': False,
            'error': str(e),
            'pipeline_type': 'optimized_sequential',
            'timestamp': datetime.now().isoformat()
        }


def generate_filename():
    """Tạo tên file với timestamp theo định dạng yyyymmddhhmmss"""
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    return f"output/nl2sql_results_{timestamp}.csv"


def init_csv_file(filename):
    with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['db_id', 'question', 'sql', 'explain', 'error']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
    print(f"Init result csv: {filename}")


def append_to_csv(result, filename):
    """Thêm một kết quả vào file CSV"""
    with open(filename, 'a', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['db_id', 'question', 'sql', 'explain', 'error']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writerow(result)
    print(
        f"Appended result to CSV: {result['db_id']} - {result['question'][:50]}...")


def process_single_question(question, tables, filename):
    try:
        print(f"\nProcessing question: {question['question'][:50]}...\n")
        for table in tables:
            if table['db_id'] == question['db_id']:
                raw_result = NL2SQLFlow(_question=NLQuestions(question=question['question'], db_id=question['db_id']),
                                        _raw_schema=SQLDbSchema(
                                            db_id=table['db_id'],
                                            table_names_original=table['table_names_original'],
                                            column_names_original=table['column_names_original'],
                                            column_types=table['column_types'],
                )).kickoff()
                result = {
                    'db_id': raw_result.db_id,
                    'question': raw_result.question,
                    'sql': raw_result.result.sql,
                    'explain': raw_result.result.explain,
                    'error': raw_result.result.error,
                }
                append_to_csv(result, filename)
                break
    except Exception as e:
        print(
            f"Error processing question: {question['question'][:50]}... due to {e}")


def kickoff():
    filename = generate_filename()
    init_csv_file(filename)
    cnt = 0
    with open('tables.json') as f:
        tables = json.load(f)
        with open('questions.json') as fq:
            questions = json.load(fq)
            for question in questions:
                cnt += 1
                if cnt > 50:
                    exit(0)
                process_single_question(question, tables, filename)
