#!/usr/bin/env python
import csv
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
from typing import Any, Callable, Dict, List, Optional, Set, Tuple
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
    confidence: float = 0.0


class NL2SQLResult(BaseModel):
    sql: str = ""
    explain: str = ""
    error: str = ""


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
    # Exact database values whose complete spans occur in the current question.
    question_value_matches: List[Dict[str, str]] = []
    # Human-readable FK metadata prevents agents from decoding Spider index pairs incorrectly.
    named_foreign_keys: List[Dict[str, str]] = []
    # Each step contains from_table, to_table, and all allowed parallel FK edges.
    join_plan: List[Dict[str, Any]] = []
    required_tables: List[str] = []
    join_plan_warnings: List[str] = []


class SQLAuditResult(BaseModel):
    """Deterministic checks used to constrain, not replace, the LLM validator."""

    valid: bool = False
    sqlite_explain_ok: Optional[bool] = None
    database_path: str = ""
    fatal_errors: List[Dict[str, str]] = Field(default_factory=list)
    warnings: List[Dict[str, str]] = Field(default_factory=list)
    checked_join_conditions: List[str] = Field(default_factory=list)


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
    """Convert Spider FK index pairs into stable, human-readable edges."""
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
    """Extract table endpoints from the typed analysis while preserving schema order."""
    candidates: Set[str] = set()

    def add(value: Any) -> None:
        if isinstance(value, str) and value.strip():
            candidates.add(value.strip().lower())

    for value in analysis.get("required_tables", []):
        if isinstance(value, dict):
            add(value.get("table"))
        else:
            add(value)

    structured_sections = (
        "output_fields_detailed",
        "filters",
        "group_by",
        "order_by",
        "literal_bindings",
        "having",
    )
    for section in structured_sections:
        values = analysis.get(section, [])
        if isinstance(values, dict):
            values = [values]
        for value in values if isinstance(values, list) else []:
            if isinstance(value, dict):
                add(value.get("table"))

    entities = analysis.get("entities", {})
    if isinstance(entities, dict):
        for value in entities.get("tables", []):
            add(value)

    set_operation = analysis.get("set_operation", {})
    if isinstance(set_operation, dict):
        for branch in set_operation.get("branches", []):
            if not isinstance(branch, dict):
                continue
            for value in branch.get("required_tables", []):
                add(value)
            for value in branch.get("required_columns", []):
                if isinstance(value, dict):
                    add(value.get("table"))

    for hint in analysis.get("join_hints", []):
        if isinstance(hint, dict):
            add(hint.get("from_table"))
            add(hint.get("to_table"))

    extreme_row = analysis.get("extreme_row")
    if isinstance(extreme_row, dict):
        for key in ("rank_by", "project"):
            value = extreme_row.get(key)
            if isinstance(value, dict):
                add(value.get("table"))

    table_lookup = {
        table_name.lower(): table_name
        for table_name in schema.table_names_original
    }
    return [
        table_name
        for table_name in schema.table_names_original
        if table_name.lower() in candidates
        and table_name.lower() in table_lookup
    ]


def _analysis_column_names(analysis: Dict[str, Any]) -> Set[str]:
    """Collect requested column names as a safe filtering superset."""
    columns: Set[str] = set()

    def add(value: Any) -> None:
        if not isinstance(value, str):
            return
        column_name = value.rsplit(".", 1)[-1].strip().lower()
        if column_name and column_name != "*":
            columns.add(column_name)

    for value in analysis.get("required_columns", []):
        if isinstance(value, dict):
            add(value.get("column"))
        else:
            add(value)

    structured_sections = (
        "output_fields_detailed",
        "filters",
        "group_by",
        "order_by",
        "literal_bindings",
        "having",
    )
    for section in structured_sections:
        values = analysis.get(section, [])
        if isinstance(values, dict):
            values = [values]
        for value in values if isinstance(values, list) else []:
            if isinstance(value, dict):
                add(value.get("column"))

    extreme_row = analysis.get("extreme_row")
    if isinstance(extreme_row, dict):
        for key in ("rank_by", "project"):
            value = extreme_row.get(key)
            if isinstance(value, dict):
                add(value.get("column"))

    set_operation = analysis.get("set_operation", {})
    if isinstance(set_operation, dict):
        for branch in set_operation.get("branches", []):
            if not isinstance(branch, dict):
                continue
            for value in branch.get("required_columns", []):
                if isinstance(value, dict):
                    add(value.get("column"))
                else:
                    add(value)
    return columns


def _table_graph(
    schema: SQLDbSchema,
) -> Dict[str, List[Tuple[str, List[Dict[str, str]]]]]:
    """Build an undirected table graph without collapsing parallel FK edges."""
    graph: Dict[str, List[Tuple[str, List[Dict[str, str]]]]] = {
        table_name: [] for table_name in schema.table_names_original
    }
    schema_order = {
        table_name: index
        for index, table_name in enumerate(schema.table_names_original)
    }
    parallel_edges: Dict[
        Tuple[str, str],
        List[Dict[str, str]],
    ] = {}
    for edge in build_named_foreign_keys(schema):
        foreign_table = edge["foreign_table"]
        referenced_table = edge["referenced_table"]
        pair = tuple(
            sorted(
                (foreign_table, referenced_table),
                key=lambda table_name: schema_order[table_name],
            )
        )
        parallel_edges.setdefault(pair, []).append(edge)

    for (first_table, second_table), edges in parallel_edges.items():
        ordered_edges = sorted(
            edges,
            key=lambda edge: edge["condition"].lower(),
        )
        graph.setdefault(first_table, []).append(
            (second_table, ordered_edges)
        )
        if first_table != second_table:
            graph.setdefault(second_table, []).append(
                (first_table, ordered_edges)
            )
    for table_name in graph:
        graph[table_name].sort(
            key=lambda item: (
                schema_order[item[0]],
                tuple(edge["condition"].lower() for edge in item[1]),
            )
        )
    return graph


def shortest_join_path(
    schema: SQLDbSchema,
    start_table: str,
    end_table: str,
) -> Optional[List[Dict[str, Any]]]:
    """Return shortest table-pair steps while preserving parallel FK choices."""
    table_lookup = {
        table_name.lower(): table_name
        for table_name in schema.table_names_original
    }
    start = table_lookup.get(start_table.lower())
    end = table_lookup.get(end_table.lower())
    if start is None or end is None:
        return None
    if start == end:
        return []

    graph = _table_graph(schema)
    queue = deque([start])
    previous: Dict[str, Tuple[str, List[Dict[str, str]]]] = {}
    visited = {start}
    while queue:
        current = queue.popleft()
        for neighbor, allowed_edges in graph.get(current, []):
            if neighbor in visited:
                continue
            visited.add(neighbor)
            previous[neighbor] = (current, allowed_edges)
            if neighbor == end:
                path: List[Dict[str, Any]] = []
                cursor = end
                while cursor != start:
                    parent, path_edges = previous[cursor]
                    path.append(
                        {
                            "from_table": parent,
                            "to_table": cursor,
                            "allowed_edges": path_edges,
                            "ambiguous": len(path_edges) > 1,
                        }
                    )
                    cursor = parent
                path.reverse()
                return path
            queue.append(neighbor)
    return None


def build_join_plan(
    schema: SQLDbSchema,
    required_tables: List[str],
) -> Tuple[List[Dict[str, Any]], List[str]]:
    """Connect required tables with a deterministic, FK-only path forest."""
    schema_order = {
        table_name: index
        for index, table_name in enumerate(schema.table_names_original)
    }
    table_lookup = {
        table_name.lower(): table_name
        for table_name in schema.table_names_original
    }
    endpoints: List[str] = []
    warnings: List[str] = []
    for requested_table in required_tables:
        resolved = table_lookup.get(requested_table.lower())
        if resolved is None:
            warnings.append(f"Unknown required table: {requested_table}")
        elif resolved not in endpoints:
            endpoints.append(resolved)
    endpoints.sort(key=lambda table_name: schema_order[table_name])
    if len(endpoints) <= 1:
        return [], warnings

    connected = {endpoints[0]}
    remaining = set(endpoints[1:])
    planned_steps: List[Dict[str, Any]] = []
    seen_table_pairs: Set[Tuple[str, str]] = set()

    while remaining:
        candidates: List[
            Tuple[
                int,
                int,
                Tuple[str, ...],
                str,
                List[Dict[str, Any]],
            ]
        ] = []
        for source in sorted(connected, key=lambda name: schema_order[name]):
            for target in sorted(remaining, key=lambda name: schema_order[name]):
                path = shortest_join_path(schema, source, target)
                if path is None:
                    continue
                candidates.append(
                    (
                        len(path),
                        schema_order[target],
                        tuple(
                            (
                                f"{step['from_table'].lower()}->"
                                f"{step['to_table'].lower()}:"
                                + "|".join(
                                    edge["condition"].lower()
                                    for edge in step["allowed_edges"]
                                )
                            )
                            for step in path
                        ),
                        target,
                        path,
                    )
                )
        if not candidates:
            for target in sorted(remaining, key=lambda name: schema_order[name]):
                warnings.append(
                    f"No declared FK path connects required table: {target}"
                )
            break

        _, _, _, target, chosen_path = min(
            candidates,
            key=lambda candidate: candidate[:4],
        )
        for step in chosen_path:
            table_pair = tuple(
                sorted(
                    (step["from_table"], step["to_table"]),
                    key=lambda table_name: schema_order[table_name],
                )
            )
            if table_pair not in seen_table_pairs:
                seen_table_pairs.add(table_pair)
                planned_steps.append(step)
            connected.add(step["from_table"])
            connected.add(step["to_table"])
        connected.add(target)
        remaining = {table for table in remaining if table not in connected}

    return planned_steps, warnings


def rebuild_filtered_schema(
    raw: SQLDbSchema,
    parsed: Dict,
    analysis: Optional[Dict[str, Any]] = None,
) -> SQLDbSchema:
    """Deterministically rebuild a filtered schema from the selector's table/column NAMES.

    LLM selectors frequently emit corrupted table/column indices and stale FK/PK
    indices after filtering. We therefore trust only the *names* it kept and
    rebuild all indices from the raw schema in code. Required endpoint tables
    and bridge tables on their shortest declared FK paths are added in code.
    On any failure, fall back to the raw schema (safe superset).
    """
    analysis = analysis or {}
    raw = enrich_schema_metadata(raw)
    try:
        kept_table_names = {
            str(t).lower() for t in parsed.get("table_names_original", []) if str(t).strip()
        }
        required_tables = _analysis_table_names(analysis, raw)
        kept_table_names.update(table.lower() for table in required_tables)

        plan_endpoints = required_tables or [
            table_name
            for table_name in raw.table_names_original
            if table_name.lower() in kept_table_names
        ]
        join_plan, plan_warnings = build_join_plan(raw, plan_endpoints)
        for step in join_plan:
            kept_table_names.add(step["from_table"].lower())
            kept_table_names.add(step["to_table"].lower())

        raw_tables_lower = [t.lower() for t in raw.table_names_original]
        kept_table_idxs = {
            i for i, t in enumerate(raw_tables_lower) if t in kept_table_names
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

        keep_cols = set()
        for gidx, (t_idx, col_name) in enumerate(raw.column_names_original):
            if t_idx in kept_table_idxs and (
                not kept_col_names or col_name.lower() in kept_col_names
            ):
                keep_cols.add(gidx)
        for pk in raw.primary_keys:
            if raw.column_names_original[pk][0] in kept_table_idxs:
                keep_cols.add(pk)
        for a, b in raw.foreign_keys:
            if (raw.column_names_original[a][0] in kept_table_idxs
                    and raw.column_names_original[b][0] in kept_table_idxs):
                keep_cols.add(a)
                keep_cols.add(b)

        if not keep_cols:
            return raw

        new_tables = [raw.table_names_original[i] for i in sorted(kept_table_idxs)]
        table_remap = {old: new for new, old in enumerate(sorted(kept_table_idxs))}

        new_columns: List[Tuple[int, str]] = [(-1, "*")]
        new_types: List[str] = ["text"]
        new_samples: List[List[str]] = [[]]
        col_remap: Dict[int, int] = {}
        has_samples = len(raw.column_sample_values) == len(raw.column_names_original)
        for gidx in range(len(raw.column_names_original)):
            if gidx in keep_cols:
                t_idx, col_name = raw.column_names_original[gidx]
                if t_idx < 0:
                    continue
                col_remap[gidx] = len(new_columns)
                new_columns.append((table_remap[t_idx], col_name))
                new_types.append(raw.column_types[gidx] if gidx < len(raw.column_types) else "text")
                new_samples.append(raw.column_sample_values[gidx] if has_samples else [])

        new_fks = [
            [col_remap[a], col_remap[b]]
            for a, b in raw.foreign_keys
            if a in col_remap and b in col_remap
        ]
        new_pks = [col_remap[pk] for pk in raw.primary_keys if pk in col_remap]

        return SQLDbSchema(
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
                if match.get("table", "").lower()
                in {table.lower() for table in new_tables}
                and (
                    match.get("table", "").lower(),
                    match.get("column", "").lower(),
                )
                in {
                    (
                        new_tables[table_index].lower(),
                        column_name.lower(),
                    )
                    for table_index, column_name in new_columns
                    if table_index >= 0
                }
            ],
            named_foreign_keys=build_named_foreign_keys(
                SQLDbSchema(
                    db_id=raw.db_id,
                    table_names_original=new_tables,
                    column_names_original=new_columns,
                    column_types=new_types,
                    foreign_keys=new_fks,
                    primary_keys=new_pks,
                    column_sample_values=new_samples,
                )
            ),
            join_plan=join_plan,
            required_tables=required_tables,
            join_plan_warnings=plan_warnings,
        )
    except Exception as e:
        print(f"[schema_selector] rebuild_filtered_schema failed ({e}); falling back to raw schema")
        return raw


def resolve_database_path(
    db_id: str,
    explicit_path: Optional[Path] = None,
) -> Optional[Path]:
    """Resolve the canonical Spider SQLite file without depending on the cwd."""
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
            [
                root / db_id / f"{db_id}.sqlite",
                root / f"{db_id}.sqlite",
            ]
        )

    for candidate in candidates:
        if candidate.is_file():
            return candidate.resolve()
    return None


def _quoted_identifier(identifier: str) -> str:
    """Quote a trusted schema identifier for a read-only SQLite lookup."""
    return '"' + identifier.replace('"', '""') + '"'


def enrich_question_value_grounding(
    schema: SQLDbSchema,
    question: str,
    db_path: Optional[Path] = None,
) -> SQLDbSchema:
    """Prepend exact database values found as complete spans in the question.

    The benchmark runner keeps only a few samples per text column. That can hide
    a long value that is written verbatim in the question and encourages an LLM
    to split it into shorter literals. This lookup is read-only and records the
    database-backed evidence explicitly.
    """
    resolved_path = resolve_database_path(schema.db_id, explicit_path=db_path)
    if resolved_path is None or not question.strip():
        return schema

    samples: List[List[str]] = [
        list(values) for values in schema.column_sample_values
    ]
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
    """Return true only when distinctness is stated near a counting phrase."""
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
    """Normalize a few high-confidence semantics before schema selection.

    This does not replace the Analyzer. It only corrects contracts that are
    deterministic from the wording: generic row counts and scalar aggregate
    thresholds such as "more than the minimum horsepower".
    """
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
                field["agg"] = "COUNT"
                field["table"] = ""
                field["column"] = "*"

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
                having_item["agg"] = "COUNT"
                having_item["table"] = ""
                having_item["column"] = "*"
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


def _mask_sql_literals_and_comments(sql: str) -> str:
    """Mask quoted text/comments while keeping statement separators in place."""
    masked = list(sql)
    index = 0
    state = "normal"
    while index < len(sql):
        char = sql[index]
        next_char = sql[index + 1] if index + 1 < len(sql) else ""

        if state == "normal":
            if char == "'":
                masked[index] = " "
                state = "single_quote"
            elif char == '"':
                masked[index] = " "
                state = "double_quote"
            elif char == "`":
                masked[index] = " "
                state = "backtick"
            elif char == "[":
                masked[index] = " "
                state = "bracket"
            elif char == "-" and next_char == "-":
                masked[index] = masked[index + 1] = " "
                index += 1
                state = "line_comment"
            elif char == "/" and next_char == "*":
                masked[index] = masked[index + 1] = " "
                index += 1
                state = "block_comment"
        elif state == "single_quote":
            masked[index] = " "
            if char == "'" and next_char == "'":
                masked[index + 1] = " "
                index += 1
            elif char == "'":
                state = "normal"
        elif state == "double_quote":
            masked[index] = " "
            if char == '"' and next_char == '"':
                masked[index + 1] = " "
                index += 1
            elif char == '"':
                state = "normal"
        elif state == "backtick":
            masked[index] = " "
            if char == "`":
                state = "normal"
        elif state == "bracket":
            masked[index] = " "
            if char == "]":
                state = "normal"
        elif state == "line_comment":
            if char == "\n":
                state = "normal"
            else:
                masked[index] = " "
        elif state == "block_comment":
            masked[index] = " "
            if char == "*" and next_char == "/":
                masked[index + 1] = " "
                index += 1
                state = "normal"
        index += 1
    return "".join(masked)


_SQL_IDENTIFIER = (
    r'(?:`[^`]+`|"[^"]+"|\[[^\]]+\]|[A-Za-z_][A-Za-z0-9_$]*)'
)
_SQL_RESERVED_WORDS = {
    "AS",
    "CROSS",
    "EXCEPT",
    "FULL",
    "GROUP",
    "HAVING",
    "INNER",
    "INTERSECT",
    "JOIN",
    "LEFT",
    "LIMIT",
    "ON",
    "ORDER",
    "OUTER",
    "RIGHT",
    "UNION",
    "WHERE",
}
_SQL_RESERVED_PATTERN = "|".join(sorted(_SQL_RESERVED_WORDS))
_TABLE_REFERENCE_RE = re.compile(
    rf"\b(?:FROM|JOIN)\s+"
    rf"({_SQL_IDENTIFIER}(?:\.{_SQL_IDENTIFIER})?)"
    rf"(?:\s+(?:AS\s+)?"
    rf"((?!(?:{_SQL_RESERVED_PATTERN})\b){_SQL_IDENTIFIER}))?",
    re.IGNORECASE,
)
_QUALIFIED_EQUALITY_RE = re.compile(
    rf"({_SQL_IDENTIFIER})\.({_SQL_IDENTIFIER})\s*=\s*"
    rf"({_SQL_IDENTIFIER})\.({_SQL_IDENTIFIER})",
    re.IGNORECASE,
)


def _unquote_identifier(value: str) -> str:
    value = value.strip()
    if len(value) >= 2:
        pairs = {("`", "`"), ('"', '"'), ("[", "]")}
        if (value[0], value[-1]) in pairs:
            return value[1:-1]
    return value


def _join_signature(
    first_table: str,
    first_column: str,
    second_table: str,
    second_column: str,
) -> Tuple[Tuple[str, str], Tuple[str, str]]:
    endpoints = [
        (first_table.lower(), first_column.lower()),
        (second_table.lower(), second_column.lower()),
    ]
    endpoints.sort()
    return endpoints[0], endpoints[1]


def _join_plan_edges(
    join_plan: List[Dict[str, Any]],
) -> List[Dict[str, str]]:
    """Flatten current join-plan steps, with support for legacy flat edges."""
    edges: List[Dict[str, str]] = []
    for step in join_plan:
        allowed_edges = step.get("allowed_edges")
        if isinstance(allowed_edges, list):
            edges.extend(
                edge
                for edge in allowed_edges
                if isinstance(edge, dict)
            )
        elif {
            "foreign_table",
            "foreign_column",
            "referenced_table",
            "referenced_column",
        }.issubset(step):
            edges.append(step)
    return edges


def _audit_join_conditions(
    sql: str,
    schema: SQLDbSchema,
) -> Tuple[List[Dict[str, str]], List[str]]:
    """Flag unsupported equality joins while allowing valid Spider non-FK joins."""
    table_lookup = {
        table_name.lower(): table_name
        for table_name in schema.table_names_original
    }
    aliases: Dict[str, str] = {}
    for match in _TABLE_REFERENCE_RE.finditer(sql):
        raw_table, raw_alias = match.groups()
        table_token = raw_table.rsplit(".", 1)[-1]
        table_name = _unquote_identifier(table_token)
        resolved_table = table_lookup.get(table_name.lower(), table_name)
        aliases[table_name.lower()] = resolved_table
        aliases[resolved_table.lower()] = resolved_table

        if raw_alias:
            alias = _unquote_identifier(raw_alias)
            if alias.upper() not in _SQL_RESERVED_WORDS:
                aliases[alias.lower()] = resolved_table

    declared_fk_signatures = {
        _join_signature(
            edge["foreign_table"],
            edge["foreign_column"],
            edge["referenced_table"],
            edge["referenced_column"],
        )
        for edge in build_named_foreign_keys(schema)
    }
    planned_signatures = {
        _join_signature(
            edge["foreign_table"],
            edge["foreign_column"],
            edge["referenced_table"],
            edge["referenced_column"],
        )
        for edge in _join_plan_edges(schema.join_plan)
    }

    warnings: List[Dict[str, str]] = []
    checked_conditions: List[str] = []
    seen: Set[
        Tuple[Tuple[str, str], Tuple[str, str]]
    ] = set()
    parsed_join_occurrence_count = 0
    for match in _QUALIFIED_EQUALITY_RE.finditer(sql):
        first_alias, first_column, second_alias, second_column = (
            _unquote_identifier(value) for value in match.groups()
        )
        first_table = aliases.get(first_alias.lower())
        second_table = aliases.get(second_alias.lower())
        if first_table is None or second_table is None:
            continue
        if (
            first_table.lower() not in table_lookup
            or second_table.lower() not in table_lookup
            or first_table.lower() == second_table.lower()
        ):
            continue
        parsed_join_occurrence_count += 1

        signature = _join_signature(
            first_table,
            first_column,
            second_table,
            second_column,
        )
        if signature in seen:
            continue
        seen.add(signature)
        condition = (
            f"{first_table}.{first_column} = "
            f"{second_table}.{second_column}"
        )
        checked_conditions.append(condition)

        if signature not in declared_fk_signatures:
            warnings.append(
                {
                    "code": "NON_FK_JOIN",
                    "message": (
                        f"{condition} is not a declared foreign-key edge. "
                        "Verify it semantically; this is a warning, not a fatal error."
                    ),
                }
            )
        elif planned_signatures and signature not in planned_signatures:
            warnings.append(
                {
                    "code": "OUTSIDE_JOIN_PLAN",
                    "message": (
                        f"{condition} is a declared FK edge but is outside "
                        "the deterministic plan for the analyzed tables."
                    ),
                }
            )

    masked_sql = _mask_sql_literals_and_comments(sql)
    join_count = len(re.findall(r"\bJOIN\b", masked_sql, re.IGNORECASE))
    has_using_or_natural = bool(
        re.search(
            r"\b(?:NATURAL\s+JOIN|USING\s*\()",
            masked_sql,
            re.IGNORECASE,
        )
    )
    from_clause_match = re.search(
        r"\bFROM\b(.*?)(?=\b(?:WHERE|GROUP|HAVING|ORDER|LIMIT|"
        r"UNION|INTERSECT|EXCEPT)\b|$)",
        masked_sql,
        re.IGNORECASE | re.DOTALL,
    )
    has_comma_join = bool(
        from_clause_match and "," in from_clause_match.group(1)
    )
    if (
        has_using_or_natural
        or has_comma_join
        or join_count > parsed_join_occurrence_count
    ):
        warnings.append(
            {
                "code": "UNPARSED_JOIN",
                "message": (
                    "At least one JOIN is not expressed as a fully qualified "
                    "table_alias.column = table_alias.column equality; verify it manually."
                ),
            }
        )
    return warnings, checked_conditions


def audit_sql_constraints(
    sql: str,
    schema: SQLDbSchema,
    *,
    db_id: Optional[str] = None,
    db_path: Optional[Path] = None,
) -> SQLAuditResult:
    """Run cheap deterministic checks before and after the LLM validator."""
    fatal_errors: List[Dict[str, str]] = []
    warnings, checked_conditions = _audit_join_conditions(sql, schema)
    stripped_sql = sql.strip()
    masked_sql = _mask_sql_literals_and_comments(sql)
    statements = [
        statement.strip()
        for statement in masked_sql.split(";")
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
    else:
        first_keyword_match = re.match(r"\s*([A-Za-z]+)", masked_sql)
        first_keyword = (
            first_keyword_match.group(1).upper()
            if first_keyword_match
            else ""
        )
        mutation_match = re.search(
            r"\b(?:ALTER|ATTACH|CREATE|DELETE|DETACH|DROP|INSERT|PRAGMA|"
            r"REINDEX|UPDATE|VACUUM)\b",
            masked_sql,
            re.IGNORECASE,
        )
        if first_keyword not in {"SELECT", "WITH"} or mutation_match:
            fatal_errors.append(
                {
                    "code": "NON_READ_ONLY_SQL",
                    "message": "Only a read-only SELECT/CTE statement is allowed.",
                }
            )

    resolved_path = resolve_database_path(
        db_id or schema.db_id,
        explicit_path=db_path,
    )
    sqlite_explain_ok: Optional[bool] = None
    if resolved_path is None:
        warnings.append(
            {
                "code": "DATABASE_NOT_FOUND",
                "message": (
                    "SQLite EXPLAIN was skipped because the benchmark "
                    "database file could not be resolved."
                ),
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
                {
                    "code": "SQLITE_EXPLAIN_ERROR",
                    "message": str(error),
                }
            )

    return SQLAuditResult(
        valid=not fatal_errors,
        sqlite_explain_ok=sqlite_explain_ok,
        database_path=str(resolved_path) if resolved_path else "",
        fatal_errors=fatal_errors,
        warnings=warnings,
        checked_join_conditions=checked_conditions,
    )


def select_audited_result(
    generated: NL2SQLResult,
    generated_audit: SQLAuditResult,
    validated: NL2SQLResult,
    validated_audit: SQLAuditResult,
    *,
    question: str = "",
    analysis: Optional[Dict[str, Any]] = None,
) -> NL2SQLResult:
    """Reject a validator change that causes a deterministic regression."""
    if generated_audit.valid and not validated_audit.valid:
        introduced_codes = ", ".join(
            issue["code"] for issue in validated_audit.fatal_errors
        )
        return NL2SQLResult(
            sql=generated.sql,
            explain=(
                "Kept Generator SQL because Validator introduced fatal "
                f"deterministic error(s): {introduced_codes}."
            ),
            error="",
        )

    analysis = analysis or {}
    generic_count_intent = (
        str(analysis.get("intent", "")).upper() == "COUNT"
        and not _has_explicit_distinct_count(question)
    )
    generated_has_count_star = bool(
        re.search(r"\bCOUNT\s*\(\s*\*\s*\)", generated.sql, re.IGNORECASE)
    )
    validated_has_count = bool(
        re.search(r"\bCOUNT\s*\(", validated.sql, re.IGNORECASE)
    )
    validated_has_count_star = bool(
        re.search(r"\bCOUNT\s*\(\s*\*\s*\)", validated.sql, re.IGNORECASE)
    )
    if (
        generated_audit.valid
        and validated_audit.valid
        and generic_count_intent
        and generated_has_count_star
        and validated_has_count
        and not validated_has_count_star
    ):
        return NL2SQLResult(
            sql=generated.sql,
            explain=(
                "Kept Generator SQL because the question asks for a generic "
                "count and Validator replaced COUNT(*) without explicit "
                "distinct or null-sensitive wording."
            ),
            error="",
        )
    # If Generator SQL already passes deterministic checks, ignore Validator rewrites.
    if (
        generated_audit.valid
        and validated_audit.valid
        and generated.sql.strip()
        and generated.sql.strip() != validated.sql.strip()
    ):
        return NL2SQLResult(
            sql=generated.sql,
            explain=(
                "Kept Generator SQL because constraint report was already valid; "
                "Validator rewrite ignored (no-op)."
            ),
            error="",
        )
    return validated


class NL2SQLState(BaseModel):
    db_id: str = ""
    question: str = ""
    question_analysis: Dict = {}
    db_raw_schema: SQLDbSchema = SQLDbSchema()
    db_schema: SQLDbSchema = SQLDbSchema()
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

    def _traced_kickoff(self, step_name: str, crew_factory: Callable[[], Any], inputs: Dict):
        """Run a crew step with timeout/retry and record its raw LLM response."""
        last_error: Exception | None = None

        for attempt in range(1, self.STEP_MAX_RETRIES + 1):
            executor = ThreadPoolExecutor(max_workers=1)
            started_at = time.time()
            print(
                f"[API][{step_name}] Attempt {attempt}/{self.STEP_MAX_RETRIES} started "
                f"(timeout={self.STEP_TIMEOUT_SECONDS}s)"
            )
            try:
                future = executor.submit(lambda: crew_factory().kickoff(inputs=inputs))
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
            except FuturesTimeoutError:
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
        """Attach local evidence without turning four agent steps into six."""
        for trace in reversed(self.step_traces):
            if trace.get("step_name") == step_name:
                trace["deterministic_audit"] = audit.model_dump()
                return

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
        """Extract JSON even when the model wraps it in prose or fences."""
        def iter_json_candidates(raw_text: str):
            stripped = raw_text.strip()
            if stripped:
                yield stripped

            for match in re.finditer(r'```(?:json)?\s*(.*?)\s*```', raw_text, re.DOTALL | re.IGNORECASE):
                candidate = match.group(1).strip()
                if candidate:
                    yield candidate

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

            for candidate in reversed(objects):
                yield candidate

        for candidate in iter_json_candidates(text):
            try:
                return json.loads(candidate)
            except Exception:
                continue
        return {}

    @listen(get_user_input)
    def question_analysis(self):
        print(f"\nAnalyzing question for intent and complexity\n")
        result = self._traced_kickoff(
            "question_analysis",
            lambda: Nl2SqlCrew().question_analysis_crew(),
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
        result = self._traced_kickoff(
            "schema_selector",
            lambda: Nl2SqlCrew().select_needed_schema_crew(),
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
            # A multi-table semantic contract overrides an inconsistent LLM flag.
            self.state.question_analysis["single_table_ok"] = False
        print(
            f"[schema_selector] Filtered schema: {self.state.db_schema.table_names_original} "
            f"({len(self.state.db_schema.column_names_original) - 1} columns, "
            f"{len(self.state.db_schema.foreign_keys)} FKs, "
            f"{len(self.state.db_schema.join_plan)} planned join steps)"
        )
        return self.state

    @listen(schema_selector)
    def generate_sql(self):
        print(f"\nGenerating SQL for question\n")
        result = self._traced_kickoff(
            "generate_sql",
            lambda: Nl2SqlCrew().generated_sql_crew(),
            {
                "question": self.state.question,
                "db_schema": self.state.db_schema.model_dump_json(),
                "question_analysis": json.dumps(self.state.question_analysis),
                "join_plan": json.dumps(self.state.db_schema.join_plan),
            },
        )
        sql_dict = self.parse_json_safely(result.raw)
        generated_sql = (sql_dict.get("sql") or "").strip()
        self.state.result.sql = generated_sql if generated_sql else result.raw
        print(f"\nGenerated SQL:\n{self.state.result.sql}\n")
        return self.state

    @listen(generate_sql)
    def validate_sql(self):
        print(f"\nValidate generated SQL\n")
        generated = self.state.result.model_copy(deep=True)
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
        self._attach_deterministic_audit(
            "generate_sql",
            generated_audit,
        )
        # No-op: do not rewrite executable SQL that already passes deterministic checks.
        if generated_audit.valid and generated.sql.strip():
            print(
                "[validate_sql] Constraint report OK — skipping Validator "
                "(preserve Generator SQL to avoid over-refinement)"
            )
            self.state.result = NL2SQLResult(
                sql=generated.sql,
                explain="Validator no-op: Generator SQL already constraint-valid.",
                error="",
            )
            print(f"\nFinal SQL:\n")
            print(json.dumps(self.state.result.model_dump(), indent=4))
            return self.state
        try:
            result = self._traced_kickoff(
                "validate_sql",
                lambda: Nl2SqlCrew().validate_sql_crew(),
                {
                    "question": self.state.question,
                    "db_schema": self.state.db_schema.model_dump_json(),
                    "sql": self.state.result.sql,
                    "question_analysis": json.dumps(self.state.question_analysis),
                    "join_plan": json.dumps(self.state.db_schema.join_plan),
                    "constraint_report": generated_audit.model_dump_json(),
                },
            )
            validated = NL2SQLResult(**self.parse_json_safely(result.raw))
            # If the validator output could not be parsed into a usable SQL,
            # keep the generated SQL instead of ending with an empty prediction.
            if not validated.sql.strip():
                print("[validate_sql] Validator returned empty SQL; keeping generated SQL")
                validated.sql = self.state.result.sql
                if not validated.explain:
                    validated.explain = "Validator output unparsable; kept generated SQL."
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
                generated,
                generated_audit,
                validated,
                validated_audit,
                question=self.state.question,
                analysis=self.state.question_analysis,
            )
            if selected.sql == generated.sql and validated.sql != generated.sql:
                print(
                    "[validate_sql] Deterministic guard rejected a Validator "
                    "regression; keeping Generator SQL"
                )
            self.state.result = selected
        except Exception as e:
            print(f"[validate_sql] Fallback to generated SQL due to: {type(e).__name__}: {e}")
            self.state.result = NL2SQLResult(
                sql=self.state.result.sql,
                explain="Validator fallback after failure.",
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
                                            foreign_keys=table.get('foreign_keys', []),
                                            primary_keys=table.get('primary_keys', []),
                                            column_sample_values=table.get(
                                                'column_sample_values',
                                                [],
                                            ),
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
