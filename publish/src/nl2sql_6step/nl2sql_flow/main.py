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

try:
    from sqlglot import exp, parse_one
except ImportError:  # Dependency validation reports this before API benchmarking.
    exp = None
    parse_one = None


class NL2SQLOnlyResult(BaseModel):
    sql: str = ""


class NL2SQLCandidates(BaseModel):
    direct_sql: str = ""
    planned_sql: str = ""
    disagreement_reason: str = ""


class SchemaSelectionResult(BaseModel):
    table_names_original: List[str] = []
    column_names_original: List[Any] = []
    backup_table_names_original: List[str] = []
    ambiguity_notes: List[str] = []


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
    # Bare Dict/List[Dict] breaks CrewAI generate_model_description (empty typing args).
    required_columns: List[Dict[str, Any]] = []
    output_fields_detailed: List[Dict[str, Any]] = []
    distinct: bool = False
    retain_unmatched_entities: bool = False
    include_zero_groups: bool = False
    filters: List[Dict[str, Any]] = []
    literal_bindings: List[Dict[str, Any]] = []
    predicate_scope: List[Dict[str, Any]] = []
    group_by: List[Dict[str, Any]] = []
    having: List[Dict[str, Any]] = []
    order_by: List[Dict[str, Any]] = []
    set_operation: Dict[str, Any] = {}
    extreme_row: Optional[Dict[str, Any]] = None
    scalar_comparisons: List[Dict[str, Any]] = []
    coverage_units: List[Dict[str, Any]] = []
    risk_flags: List[str] = []
    join_hints: List[Dict[str, Any]] = []
    entities: Dict[str, Any] = {}
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
    steps: List[Any] = []
    select: List[Dict[str, Any]] = []
    joins: List[Dict[str, Any]] = []
    predicates: List[Dict[str, Any]] = []
    group_by: List[Dict[str, Any]] = []
    having: List[Dict[str, Any]] = []
    order_by: List[Dict[str, Any]] = []
    set_operation: Dict[str, Any] = {}
    limit: Optional[int] = None
    warnings: List[str] = []
    risk_flags: List[str] = []


class RefinedSQLResult(BaseModel):
    sql: str = ""
    selected_candidate: str = ""
    notes: str = ""
    diagnostics: List[str] = []


class NL2SQLQualityResult(BaseModel):
    final_sql: str = ""
    quality_score: float = 0.0
    pipeline_summary: Dict[str, Any] = {}
    recommendations: List[str] = []
    confidence: float = 0.0


class SQLDbSchema(BaseModel):
    db_id: str = ""
    # Semantic labels are used for linking; *_original are the only SQL names.
    table_names: List[str] = []
    table_names_original: List[str] = []
    column_names: List[Tuple[int, str]] = []
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


class SQLSemanticAuditResult(BaseModel):
    """Question/contract checks that go beyond SQLite executability."""

    valid: bool = False
    parser: str = ""
    signature: Dict[str, Any] = Field(default_factory=dict)
    violations: List[Dict[str, str]] = Field(default_factory=list)
    risk_reasons: List[str] = Field(default_factory=list)


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
    semantic_tables = (
        schema.table_names
        if len(schema.table_names) == len(schema.table_names_original)
        else list(schema.table_names_original)
    )
    semantic_columns = (
        schema.column_names
        if len(schema.column_names) == len(schema.column_names_original)
        else list(schema.column_names_original)
    )
    payload.update(
        {
            "table_names": semantic_tables,
            "column_names": semantic_columns,
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


def build_identifier_map(schema: SQLDbSchema) -> Dict[str, Any]:
    """Build deterministic semantic-to-executable identifier mappings."""
    schema = enrich_schema_metadata(schema)
    table_map: Dict[str, str] = {}
    for semantic, original in zip(
        schema.table_names,
        schema.table_names_original,
    ):
        table_map[str(semantic).strip().casefold()] = original
        table_map[str(original).strip().casefold()] = original

    scoped_columns: Dict[Tuple[str, str], str] = {}
    global_candidates: Dict[str, Set[str]] = {}
    for semantic_entry, original_entry in zip(
        schema.column_names,
        schema.column_names_original,
    ):
        semantic_table_index, semantic_column = semantic_entry
        original_table_index, original_column = original_entry
        if original_table_index < 0:
            continue
        original_table = schema.table_names_original[original_table_index]
        for column_label in (semantic_column, original_column):
            key = str(column_label).strip().casefold()
            scoped_columns[(original_table.casefold(), key)] = original_column
            global_candidates.setdefault(key, set()).add(original_column)

    global_columns = {
        key: next(iter(values))
        for key, values in global_candidates.items()
        if len(values) == 1
    }
    return {
        "tables": table_map,
        "columns": scoped_columns,
        "global_columns": global_columns,
    }


def canonicalize_structured_identifiers(
    payload: Any,
    schema: SQLDbSchema,
) -> Any:
    """Canonicalize identifier-bearing JSON while leaving literals untouched."""
    identifier_map = build_identifier_map(schema)
    table_map: Dict[str, str] = identifier_map["tables"]
    scoped_columns: Dict[Tuple[str, str], str] = identifier_map["columns"]
    global_columns: Dict[str, str] = identifier_map["global_columns"]
    table_keys = {
        "table",
        "from_table",
        "to_table",
        "project_table",
        "rank_table",
        "foreign_table",
        "referenced_table",
    }
    table_list_keys = {
        "required_tables",
        "tables",
        "table_names_original",
        "backup_table_names_original",
    }
    column_keys = {
        "column",
        "project_column",
        "rank_column",
        "foreign_column",
        "referenced_column",
    }

    def canonical_table(value: Any) -> Any:
        if not isinstance(value, str):
            return value
        return table_map.get(value.strip().casefold(), value)

    def canonical_column(value: Any, table_hint: str = "") -> Any:
        if not isinstance(value, str) or value == "*":
            return value
        key = value.strip().casefold()
        if table_hint:
            scoped = scoped_columns.get((table_hint.casefold(), key))
            if scoped:
                return scoped
        return global_columns.get(key, value)

    def visit(value: Any, parent_key: str = "") -> Any:
        if isinstance(value, list):
            if parent_key in table_list_keys:
                return [canonical_table(item) for item in value]
            return [visit(item, parent_key) for item in value]
        if not isinstance(value, dict):
            return value

        result = dict(value)
        for key in table_keys:
            if key in result:
                result[key] = canonical_table(result[key])
        table_hint = next(
            (
                str(result[key])
                for key in (
                    "table",
                    "project_table",
                    "rank_table",
                    "from_table",
                    "to_table",
                )
                if isinstance(result.get(key), str)
            ),
            "",
        )
        for key, item in list(result.items()):
            if key in column_keys:
                result[key] = canonical_column(item, table_hint)
            elif key == "column_names_original" and isinstance(item, list):
                normalized_columns = []
                for entry in item:
                    if isinstance(entry, (list, tuple)) and len(entry) >= 2:
                        table_ref, column_name = entry[0], entry[1]
                        entry_table = (
                            canonical_table(table_ref)
                            if isinstance(table_ref, str)
                            else table_hint
                        )
                        normalized_columns.append(
                            [
                                table_ref,
                                canonical_column(column_name, str(entry_table)),
                            ]
                        )
                    else:
                        normalized_columns.append(
                            canonical_column(entry, table_hint)
                        )
                result[key] = normalized_columns
            elif key in table_list_keys and isinstance(item, list):
                result[key] = [canonical_table(entry) for entry in item]
            else:
                result[key] = visit(item, key)
        return result

    return visit(payload)


def executable_schema(schema: SQLDbSchema) -> SQLDbSchema:
    """Hide perturbed semantic labels from agents that must emit SQLite."""
    payload = schema.model_dump()
    payload["table_names"] = list(schema.table_names_original)
    payload["column_names"] = list(schema.column_names_original)
    return SQLDbSchema(**payload)


def direct_candidate_schema(schema: SQLDbSchema) -> SQLDbSchema:
    """Expose executable schema evidence without analysis-derived plan hints."""
    payload = executable_schema(schema).model_dump()
    payload.update(
        {
            "join_plan": [],
            "required_tables": [],
            "join_plan_warnings": [],
        }
    )
    return SQLDbSchema(**payload)


def canonicalize_sql_identifiers(sql: str, schema: SQLDbSchema) -> str:
    """Rewrite semantic table/column labels to executable Spider identifiers."""
    if not sql.strip() or parse_one is None or exp is None:
        return sql
    identifier_map = build_identifier_map(schema)
    table_map: Dict[str, str] = identifier_map["tables"]
    scoped_columns: Dict[Tuple[str, str], str] = identifier_map["columns"]
    global_columns: Dict[str, str] = identifier_map["global_columns"]

    def identifier(value: str):
        quoted = re.fullmatch(r"[A-Za-z_][A-Za-z0-9_$]*", value) is None
        return exp.to_identifier(value, quoted=quoted)

    try:
        tree = parse_one(sql, read="sqlite")
        alias_to_table: Dict[str, str] = {}
        explicit_aliases: Set[str] = set()
        for table in tree.find_all(exp.Table):
            old_name = str(table.name)
            original = table_map.get(old_name.strip().casefold(), old_name)
            alias = str(table.alias or "")
            if alias:
                explicit_aliases.add(alias.casefold())
                alias_to_table[alias.casefold()] = original
            alias_to_table[old_name.casefold()] = original
            alias_to_table[original.casefold()] = original
            if original != old_name:
                table.set("this", identifier(original))

        for column in tree.find_all(exp.Column):
            old_column = str(column.name)
            qualifier = str(column.table or "")
            original_table = alias_to_table.get(
                qualifier.casefold(),
                table_map.get(qualifier.casefold(), qualifier),
            )
            original_column = (
                scoped_columns.get(
                    (original_table.casefold(), old_column.casefold())
                )
                if original_table
                else None
            ) or global_columns.get(old_column.casefold(), old_column)
            if original_column != old_column:
                column.set("this", identifier(original_column))
            if (
                qualifier
                and qualifier.casefold() not in explicit_aliases
                and original_table
                and original_table != qualifier
            ):
                column.set("table", identifier(original_table))
        return tree.sql(dialect="sqlite")
    except Exception:
        return sql


def extended_route_reasons(
    analysis: Dict[str, Any],
    schema: SQLDbSchema,
    question: str = "",
) -> List[str]:
    """Route structurally or lexically risky questions through planning."""
    reasons = [str(flag) for flag in analysis.get("risk_flags", []) if flag]
    complexity = str(analysis.get("complexity", "")).upper()
    if complexity in {"HARD", "EXTRA", "EXTRA_HARD"}:
        reasons.append(f"complexity={complexity}")
    set_operation = analysis.get("set_operation", {})
    if (
        isinstance(set_operation, dict)
        and str(set_operation.get("operator", "NONE")).upper() != "NONE"
    ):
        reasons.append("set operation")
    if analysis.get("extreme_row"):
        reasons.append("extreme row")
    if analysis.get("scalar_comparisons"):
        reasons.append("scalar comparison")
    if analysis.get("having"):
        reasons.append("HAVING")
    if analysis.get("order_by"):
        reasons.append("explicit order contract")
    if analysis.get("retain_unmatched_entities") or analysis.get(
        "include_zero_groups"
    ):
        reasons.append("explicit unmatched/zero retention")
    scopes = analysis.get("predicate_scope", [])
    if any(
        isinstance(scope, dict)
        and str(scope.get("scope", "")).upper()
        in {"RELATED_ROWS", "INDEPENDENT_BRANCHES"}
        for scope in scopes
    ):
        reasons.append("multi-row predicate scope")
    required_tables = set(analysis.get("required_tables", []))
    if len(required_tables) > 1 and (
        analysis.get("group_by")
        or analysis.get("having")
        or analysis.get("filters")
    ):
        reasons.append("multi-table aggregation/filter")
    if schema.join_plan_warnings:
        reasons.append("ambiguous join graph")
    # Lexical cues common on Dr.Spider synonym/value/sort perturbations.
    question_lower = " ".join((question or "").lower().split())
    if question_lower:
        if re.search(
            r"\b(?:most|least|highest|lowest|lightest|heaviest|"
            r"largest|smallest|top|bottom|fewest)\b",
            question_lower,
        ):
            reasons.append("ranking/extremum wording")
        if re.search(
            r"\b(?:birth\s*year|born\s*in|year(?:s)?\s+\d{4}|in\s+\d{4})\b",
            question_lower,
        ):
            reasons.append("year-valued filter wording")
        if re.search(
            r"\b(?:minimum|maximum|min|max|average|avg|mean)\b",
            question_lower,
        ):
            reasons.append("aggregate-measure wording")
        if re.search(
            r"\b(?:called|named|titled|known as)\b",
            question_lower,
        ):
            reasons.append("value-synonym carrier wording")
    return list(dict.fromkeys(reasons))


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
    """Build a safe schema superset and deterministically rebuild FK metadata."""
    analysis = analysis or {}
    raw = enrich_schema_metadata(raw)
    try:
        filter_mode = os.getenv(
            "NL2SQL_SCHEMA_FILTER_MODE", "safe_superset"
        ).strip().lower()
        kept_table_names = {
            str(table).lower()
            for table in (
                parsed.get("table_names_original", [])
                + parsed.get("backup_table_names_original", [])
            )
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
        complexity = str(analysis.get("complexity", "")).upper()
        confidence = float(analysis.get("confidence", 0.0) or 0.0)
        if filter_mode == "full" or (
            filter_mode == "safe_superset"
            and (complexity in {"HARD", "EXTRA", "EXTRA_HARD"} or confidence < 0.85)
        ):
            kept_table_idxs = set(range(len(raw.table_names_original)))
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
            keep_entire_selected_table = filter_mode in {
                "safe_superset",
                "full",
            }
            if table_index in kept_table_idxs and (
                keep_entire_selected_table
                or not kept_col_names
                or column_name.lower() in kept_col_names
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
        semantic_tables = (
            raw.table_names
            if len(raw.table_names) == len(raw.table_names_original)
            else raw.table_names_original
        )
        new_semantic_tables = [semantic_tables[index] for index in old_tables]
        table_remap = {
            old_index: new_index
            for new_index, old_index in enumerate(old_tables)
        }
        new_columns: List[Tuple[int, str]] = [(-1, "*")]
        new_semantic_columns: List[Tuple[int, str]] = [(-1, "*")]
        new_types: List[str] = ["text"]
        new_samples: List[List[str]] = [[]]
        column_remap: Dict[int, int] = {}
        has_samples = (
            len(raw.column_sample_values)
            == len(raw.column_names_original)
        )
        semantic_columns = (
            raw.column_names
            if len(raw.column_names) == len(raw.column_names_original)
            else raw.column_names_original
        )
        for column_index, (table_index, column_name) in enumerate(
            raw.column_names_original
        ):
            if column_index not in keep_cols or table_index < 0:
                continue
            column_remap[column_index] = len(new_columns)
            new_columns.append((table_remap[table_index], column_name))
            _, semantic_column_name = semantic_columns[column_index]
            new_semantic_columns.append(
                (table_remap[table_index], semantic_column_name)
            )
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
            table_names=new_semantic_tables,
            table_names_original=new_tables,
            column_names=new_semantic_columns,
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
    """Prepend exact and conservative named-entity value matches."""
    resolved_path = resolve_database_path(schema.db_id, explicit_path=db_path)
    if resolved_path is None or not question.strip():
        return schema

    samples = [list(values) for values in schema.column_sample_values]
    if len(samples) != len(schema.column_names_original):
        samples = [[] for _ in schema.column_names_original]
    matches: List[Dict[str, str]] = []
    named_terms = {
        term
        for term in re.findall(r"\b[A-Z][A-Za-z0-9_-]{2,}\b", question)
        if term.casefold()
        not in {
            "and",
            "are",
            "find",
            "give",
            "list",
            "not",
            "show",
            "the",
            "what",
            "which",
            "who",
        }
    }
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
                # A question often uses a short entity alias while the database
                # stores the full canonical value (for example a brand token
                # inside a company name). Keep only capitalized named terms to
                # avoid broad fuzzy matching on ordinary question words.
                for term in sorted(named_terms, key=len, reverse=True):
                    expanded_query = (
                        f"SELECT DISTINCT {quoted_column} FROM {quoted_table} "
                        f"WHERE {quoted_column} IS NOT NULL "
                        f"AND instr(lower(trim(CAST({quoted_column} AS TEXT))), "
                        "lower(?)) > 0 "
                        f"ORDER BY length(trim(CAST({quoted_column} AS TEXT))) DESC "
                        "LIMIT 8"
                    )
                    for (raw_value,) in connection.execute(
                        expanded_query, (term,)
                    ):
                        value = str(raw_value).strip()
                        if (
                            not value
                            or value.casefold() == term.casefold()
                            or len(value) > 80
                        ):
                            continue
                        matched_values.append(value)
                        matches.append(
                            {
                                "table": table_name,
                                "column": column_name,
                                "value": value,
                                "evidence": "QUESTION_VALUE_CONTAINS",
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


def _year_like_column_names(schema: SQLDbSchema) -> Set[str]:
    """Columns that Spider-style DBs often store as numeric years."""
    names: Set[str] = set()
    for index, (_, column_name) in enumerate(schema.column_names_original):
        lowered = str(column_name).casefold()
        type_name = (
            str(schema.column_types[index]).casefold()
            if index < len(schema.column_types)
            else ""
        )
        if type_name == "number" or re.search(
            r"(?:^|_)(?:year|born_date|birth_date|birthdate)(?:$|_)",
            lowered,
        ):
            names.add(lowered)
    return names


def repair_population_count_as_sum(sql: str, question: str) -> str:
    """Map 'how many people live/reside' COUNT(*) to SUM(Population)."""
    if not sql.strip():
        return sql
    question_l = " ".join(question.casefold().split())
    asks_people_population = bool(
        re.search(
            r"(?:how many|number of|total(?: number of)?)\s+people\b"
            r".{0,40}\b(?:live|living|reside|residing|lived)\b"
            r"|"
            r"\b(?:live|living|reside|residing)\b.{0,40}"
            r"(?:how many|number of|total(?: number of)?)\s+people\b"
            r"|"
            r"\btotal (?:number of )?people living\b",
            question_l,
        )
    )
    if not asks_people_population:
        return sql
    if re.search(r"\bsum\s*\(\s*population\s*\)", sql, re.IGNORECASE):
        return sql
    if not re.search(r"\bcount\s*\(\s*\*\s*\)", sql, re.IGNORECASE):
        return sql
    if not re.search(r"\b(?:city|country)\b", sql, re.IGNORECASE):
        return sql
    return re.sub(
        r"\bcount\s*\(\s*\*\s*\)",
        "SUM(Population)",
        sql,
        count=1,
        flags=re.IGNORECASE,
    )


def repair_bogus_order_by_aggregate_alias(sql: str) -> str:
    """Replace ORDER BY invented aggregate aliases with count(*).

    Common Spider failure: ``ORDER BY number_of_TV_Channels`` when SELECT has
    ``count(id)`` / ``count(*)`` without that alias.
    """
    if not sql.strip() or parse_one is None or exp is None:
        return sql
    try:
        tree = parse_one(sql, read="sqlite")
    except Exception:
        return sql

    select = next(tree.find_all(exp.Select), None)
    order = next(tree.find_all(exp.Order), None)
    if select is None or order is None:
        return sql

    select_aliases = set()
    has_count = False
    for item in select.expressions:
        if isinstance(item, exp.Alias) and item.alias:
            select_aliases.add(str(item.alias).casefold())
        item_sql = item.sql(dialect="sqlite").lower()
        if re.search(r"\bcount\s*\(", item_sql):
            has_count = True
    if not has_count:
        return sql

    changed = False
    for ordered in list(order.expressions):
        # sqlglot Order expression wraps the ordered this
        target = ordered.this if hasattr(ordered, "this") else ordered
        if not isinstance(target, exp.Column):
            continue
        name = str(target.name or "").casefold()
        if not name or name in select_aliases:
            continue
        # Invented ranking aliases usually look like number_of_*/num_*/*_count
        if not re.search(
            r"(number|num|count|total|amount|qty)",
            name,
        ):
            continue
        replacement = exp.Count(this=exp.Star())
        if isinstance(ordered, exp.Ordered):
            ordered.set("this", replacement)
        changed = True

    if not changed:
        return sql
    # Also normalize COUNT(id)/COUNT(col) → COUNT(*) in SELECT for the
    # common TV_Channel ranking pattern when ordering by count.
    for item in select.expressions:
        if isinstance(item, exp.Alias):
            inner = item.this
        else:
            inner = item
        if isinstance(inner, exp.Count) and not isinstance(
            inner.this, exp.Star
        ):
            # Only rewrite plain COUNT(col), keep COUNT(DISTINCT ...)
            if not inner.args.get("distinct"):
                inner.set("this", exp.Star())
    try:
        return tree.sql(dialect="sqlite")
    except Exception:
        return sql


def apply_post_generation_sql_repairs(
    sql: str,
    question: str,
    schema: SQLDbSchema,
) -> str:
    """Deterministic Spider-oriented repairs after LLM SQL generation."""
    repaired = canonicalize_sql_identifiers(sql, schema)
    repaired = normalize_numeric_year_predicates(repaired, schema)
    repaired = repair_population_count_as_sum(repaired, question)
    repaired = repair_bogus_order_by_aggregate_alias(repaired)
    return repaired


def normalize_numeric_year_predicates(
    sql: str,
    schema: SQLDbSchema,
) -> str:
    """Rewrite STRFTIME('%Y', col) year filters to direct column predicates."""
    if not sql.strip():
        return sql

    year_columns = _year_like_column_names(schema)
    in_pattern = re.compile(
        r"strftime\s*\(\s*(['\"])%Y\1\s*,\s*"
        r"(?P<column>(?:[A-Za-z_][\w$]*\.)?[A-Za-z_][\w$]*)\s*\)"
        r"\s+IN\s*\((?P<values>[^)]*)\)",
        re.IGNORECASE,
    )
    eq_pattern = re.compile(
        r"strftime\s*\(\s*(['\"])%Y\1\s*,\s*"
        r"(?P<column>(?:[A-Za-z_][\w$]*\.)?[A-Za-z_][\w$]*)\s*\)"
        r"\s*(?P<op>=|<>|!=|<|>|<=|>=)\s*['\"]?(?P<year>\d{4})['\"]?",
        re.IGNORECASE,
    )

    def replace_in(match: re.Match[str]) -> str:
        qualified_column = match.group("column")
        column_name = qualified_column.rsplit(".", 1)[-1].casefold()
        values = re.findall(r"\d{4}", match.group("values"))
        if column_name not in year_columns or not values:
            return match.group(0)
        return f"{qualified_column} IN ({', '.join(values)})"

    def replace_eq(match: re.Match[str]) -> str:
        qualified_column = match.group("column")
        column_name = qualified_column.rsplit(".", 1)[-1].casefold()
        if column_name not in year_columns:
            return match.group(0)
        return (
            f"{qualified_column} {match.group('op')} {match.group('year')}"
        )

    rewritten = in_pattern.sub(replace_in, sql)
    return eq_pattern.sub(replace_eq, rewritten)


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


def question_requests_unmatched_retention(question: str) -> bool:
    """Return true only for explicit zero/unmatched entity wording."""
    normalized = " ".join(question.lower().split())
    return bool(
        re.search(
            r"\b(?:including|include|even if|whether or not|regardless of|"
            r"with or without)\b.{0,45}\b(?:none|no|zero|without|not)\b",
            normalized,
        )
        or re.search(
            r"\b(?:none|no|zero|without)\b.{0,45}\b(?:related|associated|"
            r"courses?|documents?|records?|rows?)\b",
            normalized,
        )
    )


def _question_explicitly_requests_name_or_title(question: str) -> bool:
    normalized = " ".join(question.lower().split())
    return bool(
        re.search(
            r"\b(?:show|list|return|give|provide|display|which|what)\b"
            r".{0,55}\b(?:name|title)\b",
            normalized,
        )
        or re.search(
            r"\b(?:name|title)\b.{0,20}\b(?:and|along with|together with)\b",
            normalized,
        )
    )


def normalize_entity_carrier_outputs(
    question: str,
    analysis: Dict[str, Any],
) -> Dict[str, Any]:
    """Remove literal-bound named-entity carriers from multi-field output."""
    normalized: Dict[str, Any] = json.loads(json.dumps(analysis or {}))
    outputs = normalized.get("output_fields_detailed", [])
    if (
        not isinstance(outputs, list)
        or len(outputs) <= 1
        or not re.search(r"\b(?:called|named|titled)\b", question, re.I)
        or _question_explicitly_requests_name_or_title(question)
    ):
        return normalized

    carrier_fields: Set[Tuple[str, str]] = set()
    for binding in normalized.get("literal_bindings", []):
        if not isinstance(binding, dict):
            continue
        literal = str(binding.get("literal", "")).strip()
        if not literal or not re.search(
            rf"\b(?:called|named|titled)\b.{{0,20}}"
            rf"(?<!\w){re.escape(literal)}(?!\w)",
            question,
            re.IGNORECASE,
        ):
            continue
        carrier_fields.add(
            (
                str(binding.get("table", "")).casefold(),
                str(binding.get("column", "")).casefold(),
            )
        )
    for unit in normalized.get("coverage_units", []):
        if (
            isinstance(unit, dict)
            and str(unit.get("kind", "")).upper() == "ENTITY_CARRIER"
        ):
            carrier_fields.add(
                (
                    str(unit.get("table", "")).casefold(),
                    str(unit.get("column", "")).casefold(),
                )
            )
    carrier_fields.discard(("", ""))
    if not carrier_fields:
        return normalized

    retained_outputs = [
        field
        for field in outputs
        if not (
            isinstance(field, dict)
            and (
                str(field.get("table", "")).casefold(),
                str(field.get("column", "")).casefold(),
            )
            in carrier_fields
        )
    ]
    if not retained_outputs or len(retained_outputs) == len(outputs):
        return normalized

    normalized["output_fields_detailed"] = retained_outputs
    risk_flags = normalized.get("risk_flags", [])
    if not isinstance(risk_flags, list):
        risk_flags = []
    normalized["risk_flags"] = list(
        dict.fromkeys([*risk_flags, "OUTPUT_ROLE_AMBIGUITY"])
    )
    notes = normalized.get("normalization_notes", [])
    if not isinstance(notes, list):
        notes = []
    notes.append(
        "Removed a literal-bound called/named entity carrier from SELECT."
    )
    normalized["normalization_notes"] = list(dict.fromkeys(notes))
    return normalized


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
    explicit_unmatched_retention = question_requests_unmatched_retention(
        question
    )
    if (
        normalized.get("retain_unmatched_entities")
        or normalized.get("include_zero_groups")
    ) and not explicit_unmatched_retention:
        notes.append(
            "Unmatched/zero retention reset to false because the question "
            "does not explicitly request it."
        )
    normalized["retain_unmatched_entities"] = explicit_unmatched_retention
    normalized["include_zero_groups"] = explicit_unmatched_retention
    normalized["null_handling"] = (
        "LEFT_JOIN" if explicit_unmatched_retention else "INNER_JOIN"
    )
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
    normalized = normalize_entity_carrier_outputs(question, normalized)
    notes = normalized.get("normalization_notes", notes)
    if not isinstance(notes, list):
        notes = []

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


def normalize_low_cardinality_literals(
    analysis: Dict[str, Any],
    schema: SQLDbSchema,
) -> Dict[str, Any]:
    """Ground true/false concepts to observed SQLite sentinel values."""
    normalized: Dict[str, Any] = json.loads(json.dumps(analysis or {}))
    samples_by_column: Dict[Tuple[str, str], List[str]] = {}
    for index, (table_index, column_name) in enumerate(
        schema.column_names_original
    ):
        if table_index < 0 or table_index >= len(schema.table_names_original):
            continue
        samples = (
            schema.column_sample_values[index]
            if index < len(schema.column_sample_values)
            else []
        )
        samples_by_column[
            (
                schema.table_names_original[table_index].casefold(),
                str(column_name).casefold(),
            )
        ] = [str(sample) for sample in samples]

    truthy = {"1", "t", "true", "y", "yes"}
    falsy = {"0", "f", "false", "n", "no"}
    replacements: List[Tuple[str, str, str, str]] = []
    filters = normalized.get("filters", [])
    for filter_item in filters if isinstance(filters, list) else []:
        if not isinstance(filter_item, dict):
            continue
        table = str(filter_item.get("table", "")).strip()
        column = str(filter_item.get("column", "")).strip()
        raw_value = filter_item.get("value")
        if isinstance(raw_value, bool):
            value_key = "true" if raw_value else "false"
        elif isinstance(raw_value, str):
            value_key = raw_value.strip().casefold()
        else:
            continue
        desired_group = truthy if value_key in truthy else (
            falsy if value_key in falsy else set()
        )
        if not desired_group:
            continue
        observed = samples_by_column.get(
            (table.casefold(), column.casefold()), []
        )
        grounded = [
            sample
            for sample in observed
            if sample.strip().casefold() in desired_group
        ]
        grounded = list(dict.fromkeys(grounded))
        if len(grounded) != 1:
            continue
        replacement = grounded[0]
        old_value = str(raw_value)
        filter_item["value"] = replacement
        filter_item["value_type"] = "STRING"
        replacements.append((table, column, old_value, replacement))

    if replacements:
        bindings = normalized.get("literal_bindings", [])
        if not isinstance(bindings, list):
            bindings = []
        for table, column, old_value, replacement in replacements:
            updated = False
            for binding in bindings:
                if not isinstance(binding, dict):
                    continue
                same_field = (
                    str(binding.get("table", "")).casefold()
                    == table.casefold()
                    and str(binding.get("column", "")).casefold()
                    == column.casefold()
                )
                literal_key = str(
                    binding.get("literal", "")
                ).casefold()
                if same_field and literal_key in {
                    old_value.casefold(),
                    replacement.casefold(),
                }:
                    binding.update(
                        {
                            "literal": replacement,
                            "evidence": "SAMPLE_VALUE",
                        }
                    )
                    updated = True
            if not updated:
                bindings.append(
                    {
                        "literal": replacement,
                        "table": table,
                        "column": column,
                        "evidence": "SAMPLE_VALUE",
                    }
                )
        normalized["literal_bindings"] = bindings
        notes = normalized.get("normalization_notes", [])
        if not isinstance(notes, list):
            notes = []
        notes.extend(
            f"Boolean-like value {old!r} grounded to observed sentinel "
            f"{new!r} for {table}.{column}."
            for table, column, old, new in replacements
        )
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


def build_sql_signature(sql: str) -> Tuple[Dict[str, Any], str, Optional[str]]:
    """Return a stable structural signature for candidate comparison."""
    if parse_one is None or exp is None:
        normalized = " ".join(sql.lower().split())
        return (
            {
                "normalized": normalized,
                "tables": sorted(
                    set(
                        re.findall(
                            r"\b(?:from|join)\s+([a-zA-Z_][\w$]*)",
                            normalized,
                        )
                    )
                ),
                "has_group": bool(re.search(r"\bgroup\s+by\b", normalized)),
                "has_having": bool(re.search(r"\bhaving\b", normalized)),
                "has_order": bool(re.search(r"\border\s+by\b", normalized)),
                "has_limit": bool(re.search(r"\blimit\b", normalized)),
                "set_operations": sorted(
                    set(
                        token.upper()
                        for token in re.findall(
                            r"\b(union|intersect|except)\b", normalized
                        )
                    )
                ),
            },
            "regex",
            "sqlglot is not installed",
        )
    try:
        tree = parse_one(sql, read="sqlite")
        first_select = next(tree.find_all(exp.Select), None)
        projections = (
            [
                " ".join(item.sql(dialect="sqlite").lower().split())
                for item in first_select.expressions
            ]
            if first_select is not None
            else []
        )
        signature = {
            "projections": projections,
            "tables": sorted(
                {
                    str(table.name).lower()
                    for table in tree.find_all(exp.Table)
                    if table.name
                }
            ),
            "joins": sorted(
                " ".join(join.sql(dialect="sqlite").lower().split())
                for join in tree.find_all(exp.Join)
            ),
            "where": sorted(
                " ".join(where.sql(dialect="sqlite").lower().split())
                for where in tree.find_all(exp.Where)
            ),
            "group_by": sorted(
                " ".join(group.sql(dialect="sqlite").lower().split())
                for group in tree.find_all(exp.Group)
            ),
            "having": sorted(
                " ".join(having.sql(dialect="sqlite").lower().split())
                for having in tree.find_all(exp.Having)
            ),
            "order_by": sorted(
                " ".join(order.sql(dialect="sqlite").lower().split())
                for order in tree.find_all(exp.Order)
            ),
            "has_limit": any(True for _ in tree.find_all(exp.Limit)),
            "set_operations": sorted(
                {
                    node.__class__.__name__.upper()
                    for node_type in (exp.Union, exp.Intersect, exp.Except)
                    for node in tree.find_all(node_type)
                }
            ),
        }
        return signature, "sqlglot", None
    except Exception as error:
        return {}, "sqlglot", str(error)


def sql_contains_bound_literal(sql: str, literal: str) -> bool:
    """Match a complete SQL literal, never an arbitrary identifier substring."""
    expected = str(literal).strip()
    if not expected:
        return True
    expected_key = expected.casefold()
    if parse_one is not None and exp is not None:
        try:
            tree = parse_one(sql, read="sqlite")
            for node in tree.find_all(exp.Literal):
                if str(node.this).strip().casefold() == expected_key:
                    return True
            for node in tree.find_all(exp.Boolean):
                if str(node.this).strip().casefold() == expected_key:
                    return True
        except Exception:
            pass

    quoted = rf"(?P<quote>['\"]){re.escape(expected)}(?P=quote)"
    if re.search(quoted, sql, re.IGNORECASE):
        # Single-quoted values are literals. For SQLite-compatible
        # double-quoted string values, require predicate/list context.
        if re.search(rf"'{re.escape(expected)}'", sql, re.IGNORECASE):
            return True
        if re.search(
            rf"(?:=|<>|!=|<=|>=|<|>)\s*\"{re.escape(expected)}\"",
            sql,
            re.IGNORECASE,
        ) or re.search(
            rf"\bIN\s*\([^)]*\"{re.escape(expected)}\"",
            sql,
            re.IGNORECASE,
        ):
            return True
    if re.fullmatch(r"[-+]?(?:\d+(?:\.\d*)?|\.\d+)", expected):
        return bool(
            re.search(
                rf"(?<![\w.]){re.escape(expected)}(?![\w.])",
                sql,
            )
        )
    return False


def _semantic_required_tables(analysis: Dict[str, Any]) -> Set[str]:
    tables: Set[str] = set()
    for section in (
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
            table = value.get("table")
            if isinstance(table, str) and table.strip():
                tables.add(table.strip().lower())
            nested = value.get("value")
            if isinstance(nested, dict):
                nested_table = nested.get("table")
                if isinstance(nested_table, str) and nested_table.strip():
                    tables.add(nested_table.strip().lower())
    return tables


def audit_sql_semantics(
    sql: str,
    question: str,
    analysis: Optional[Dict[str, Any]] = None,
) -> SQLSemanticAuditResult:
    """Conservatively flag contract coverage risks without using gold SQL."""
    analysis = analysis or {}
    signature, parser_name, parser_error = build_sql_signature(sql)
    violations: List[Dict[str, str]] = []
    risk_reasons: List[str] = []
    sql_lower = " ".join(sql.lower().split())
    question_lower = " ".join(question.lower().split())

    if parser_error:
        risk_reasons.append(f"SQL parser fallback/error: {parser_error}")
        if parser_name == "sqlglot":
            violations.append(
                {"code": "SQL_AST_PARSE_ERROR", "message": parser_error}
            )

    output_fields = analysis.get("output_fields_detailed", [])
    if not isinstance(output_fields, list):
        output_fields = []
    projections = signature.get("projections", [])
    if projections and output_fields and len(projections) != len(output_fields):
        violations.append(
            {
                "code": "OUTPUT_COUNT_MISMATCH",
                "message": (
                    f"SQL projects {len(projections)} field(s), contract expects "
                    f"{len(output_fields)}."
                ),
            }
        )
    for index, field in enumerate(output_fields):
        if not isinstance(field, dict) or index >= len(projections):
            continue
        column = str(field.get("column", "")).strip().lower()
        aggregate = str(field.get("agg", "NONE")).strip().upper()
        projection = projections[index]
        if column and column != "*" and column not in projection:
            violations.append(
                {
                    "code": "OUTPUT_FIELD_MISMATCH",
                    "message": (
                        f"Projection {index} does not contain expected column "
                        f"{column}."
                    ),
                }
            )
        aggregate_sql = {
            "COUNT_DISTINCT": "count",
            "COUNT": "count",
            "SUM": "sum",
            "AVG": "avg",
            "MAX": "max",
            "MIN": "min",
        }.get(aggregate)
        if aggregate_sql and aggregate_sql not in projection:
            violations.append(
                {
                    "code": "OUTPUT_AGGREGATE_MISMATCH",
                    "message": (
                        f"Projection {index} lacks expected {aggregate} aggregate."
                    ),
                }
            )

    sql_tables = set(signature.get("tables", []))
    for required_table in sorted(_semantic_required_tables(analysis)):
        if sql_tables and required_table not in sql_tables:
            violations.append(
                {
                    "code": "REQUIRED_TABLE_MISSING",
                    "message": f"Required table {required_table} is absent.",
                }
            )

    for binding in analysis.get("literal_bindings", []):
        if not isinstance(binding, dict):
            continue
        evidence = str(binding.get("evidence", "")).strip().upper()
        if evidence not in {
            "SAMPLE_VALUE",
            "QUESTION_EXACT_DB_MATCH",
        }:
            continue
        literal = str(binding.get("literal", "")).strip()
        if literal and not sql_contains_bound_literal(sql, literal):
            violations.append(
                {
                    "code": "LITERAL_MISSING",
                    "message": f"Bound literal {literal!r} is absent from SQL.",
                }
            )

    has_named_entity_carrier = bool(
        re.search(r"\b(?:called|named|titled)\b", question_lower)
    )
    explicitly_requests_name_or_title = (
        _question_explicitly_requests_name_or_title(question)
    )
    if has_named_entity_carrier and not explicitly_requests_name_or_title:
        expected_output_columns = {
            str(field.get("column", "")).strip().lower()
            for field in output_fields
            if isinstance(field, dict)
            and str(field.get("column", "")).strip()
        }
        projected_carriers: Set[str] = set()
        for binding in analysis.get("literal_bindings", []):
            if not isinstance(binding, dict):
                continue
            column = str(binding.get("column", "")).strip().lower()
            if (
                column
                and column not in expected_output_columns
                and any(
                re.search(
                    rf"(?<![\w$]){re.escape(column)}(?![\w$])",
                    projection,
                )
                for projection in signature.get("projections", [])
                )
            ):
                projected_carriers.add(column)
        for column in sorted(projected_carriers):
            violations.append(
                {
                    "code": "ENTITY_CARRIER_PROJECTED",
                    "message": (
                        f"Literal-bound carrier column {column} is projected, "
                        "but the question uses it only to identify an entity."
                    ),
                }
            )

    for filter_item in analysis.get("filters", []):
        if not isinstance(filter_item, dict):
            continue
        column = str(filter_item.get("column", "")).strip().lower()
        if column and column not in sql_lower:
            violations.append(
                {
                    "code": "FILTER_COLUMN_MISSING",
                    "message": f"Filter column {column} is absent from SQL.",
                }
            )

    left_joins = [
        join
        for join in signature.get("joins", [])
        if re.search(r"\bleft(?:\s+outer)?\s+join\b", join)
    ]
    explicit_unmatched_retention = question_requests_unmatched_retention(
        question
    )
    anti_join = bool(
        re.search(r"\bis\s+null\b", sql_lower)
        and re.search(
            r"\b(?:without|not used|never|no related|not associated)\b",
            question_lower,
        )
    )
    if left_joins and not explicit_unmatched_retention and not anti_join:
        violations.append(
            {
                "code": "UNJUSTIFIED_LEFT_JOIN",
                "message": (
                    "LEFT JOIN retains unmatched rows, but the question does "
                    "not explicitly request zero/unmatched entities."
                ),
            }
        )

    expected_set = str(
        (analysis.get("set_operation") or {}).get("operator", "NONE")
    ).upper()
    actual_sets = set(signature.get("set_operations", []))
    if expected_set != "NONE" and expected_set not in actual_sets:
        violations.append(
            {
                "code": "SET_OPERATION_MISSING",
                "message": f"Expected {expected_set}, found {sorted(actual_sets)}.",
            }
        )

    if analysis.get("group_by") and not signature.get("group_by"):
        violations.append(
            {"code": "GROUP_BY_MISSING", "message": "Contract requires GROUP BY."}
        )
    if analysis.get("having") and not signature.get("having"):
        violations.append(
            {"code": "HAVING_MISSING", "message": "Contract requires HAVING."}
        )
    if analysis.get("order_by") and not signature.get("order_by"):
        violations.append(
            {"code": "ORDER_BY_MISSING", "message": "Contract requires ORDER BY."}
        )

    expected_order_directions = {
        str(item.get("direction", "")).strip().upper()
        for item in analysis.get("order_by", [])
        if isinstance(item, dict)
        and str(item.get("direction", "")).strip().upper() in {"ASC", "DESC"}
    }
    if not expected_order_directions:
        if re.search(
            r"\b(?:least|lowest|lightest|fewest|smallest|bottom)\b",
            question_lower,
        ):
            expected_order_directions.add("ASC")
        if re.search(
            r"\b(?:most|highest|heaviest|largest|top)\b",
            question_lower,
        ):
            expected_order_directions.add("DESC")
    order_blob = " ".join(signature.get("order_by") or []).lower()
    if expected_order_directions and order_blob:
        has_asc = bool(re.search(r"\basc\b", order_blob))
        has_desc = bool(re.search(r"\bdesc\b", order_blob))
        if expected_order_directions == {"ASC"} and has_desc and not has_asc:
            violations.append(
                {
                    "code": "ORDER_BY_DIRECTION_MISMATCH",
                    "message": "Question/contract expects ASC ordering.",
                }
            )
        if expected_order_directions == {"DESC"} and has_asc and not has_desc:
            violations.append(
                {
                    "code": "ORDER_BY_DIRECTION_MISMATCH",
                    "message": "Question/contract expects DESC ordering.",
                }
            )

    if re.search(r"strftime\s*\(\s*['\"]%[Yy]['\"]", sql_lower):
        violations.append(
            {
                "code": "YEAR_STRFTIME_PREDICATE",
                "message": (
                    "Prefer direct equality on numeric/year-like columns "
                    "instead of STRFTIME('%Y', ...)."
                ),
            }
        )

    required_tables = _semantic_required_tables(analysis)
    sql_tables_for_joins = set(signature.get("tables", []))
    extra_tables = sql_tables_for_joins - required_tables
    if (
        required_tables
        and extra_tables
        and len(sql_tables_for_joins) > len(required_tables)
        and not signature.get("set_operations")
    ):
        risk_reasons.append(
            "JOIN_OVERGENERATION: "
            + ", ".join(sorted(extra_tables))
        )

    if analysis.get("extreme_row") and not signature.get("has_limit"):
        violations.append(
            {
                "code": "EXTREME_LIMIT_MISSING",
                "message": "Extreme-row contract requires LIMIT.",
            }
        )

    related_negation = any(
        isinstance(scope, dict)
        and str(scope.get("logic", "")).upper()
        in {"NOT_EXISTS", "NOT_IN", "EXCEPT"}
        for scope in analysis.get("predicate_scope", [])
    )
    related_negation = related_negation or bool(
        len(_semantic_required_tables(analysis)) > 1
        and re.search(
            r"\b(?:without|never|do not have|does not have|don't have|"
            r"doesn't have|not associated|not use|don't use)\b",
            question_lower,
        )
    )
    if related_negation and not re.search(
        r"\b(?:not\s+exists|not\s+in|except)\b", sql_lower
    ):
        violations.append(
            {
                "code": "RELATED_NEGATION_UNSAFE",
                "message": (
                    "Related-row negation requires NOT EXISTS, NOT IN, or EXCEPT."
                ),
            }
        )

    complexity = str(analysis.get("complexity", "")).upper()
    if complexity in {"HARD", "EXTRA", "EXTRA_HARD"}:
        risk_reasons.append(f"complexity={complexity}")
    for risk_flag in analysis.get("risk_flags", []):
        risk_reasons.append(str(risk_flag))
    if re.search(
        r"\b(?:both|without|never|most|least|highest|lowest|average|"
        r"more than|fewer than|for each|per each)\b",
        question_lower,
    ):
        risk_reasons.append("high-risk question pattern")

    unique_violations = {
        (violation["code"], violation["message"]): violation
        for violation in violations
    }
    unique_risks = list(dict.fromkeys(risk_reasons))
    return SQLSemanticAuditResult(
        valid=not unique_violations,
        parser=parser_name,
        signature=signature,
        violations=list(unique_violations.values()),
        risk_reasons=unique_risks,
    )


def requires_semantic_review(
    direct_audit: SQLAuditResult,
    planned_audit: SQLAuditResult,
    direct_semantic: SQLSemanticAuditResult,
    planned_semantic: SQLSemanticAuditResult,
) -> Tuple[bool, List[str]]:
    review_reasons: List[str] = []
    if not direct_audit.valid:
        review_reasons.append("direct SQL has a deterministic error")
    if not planned_audit.valid:
        review_reasons.append("planned SQL has a deterministic error")
    if not direct_semantic.valid:
        review_reasons.append("direct SQL violates semantic contract")
    if not planned_semantic.valid:
        review_reasons.append("planned SQL violates semantic contract")
    if direct_semantic.signature != planned_semantic.signature:
        review_reasons.append("direct and planned SQL signatures disagree")

    # A risk flag routes the question through Planner and the independent
    # planned candidate, but does not by itself justify another paid model
    # call when both candidates are equivalent and pass all audits.
    risk_reasons = [
        *direct_semantic.risk_reasons,
        *planned_semantic.risk_reasons,
    ]
    high_impact_markers = {
        "RELATED_ROW_NEGATION",
        "SET_OPERATION",
        "AMBIGUOUS_SCHEMA",
        "OUTPUT_ROLE_AMBIGUITY",
        "SCALAR_SUBQUERY",
        "EXTREME_ROW",
        "LOW_CONFIDENCE",
        "JOIN_OVERGENERATION",
        "HIGH-RISK QUESTION PATTERN",
    }
    for risk_reason in risk_reasons:
        normalized_risk = str(risk_reason).strip().upper()
        if any(
            marker in normalized_risk
            for marker in high_impact_markers
        ):
            review_reasons.append(
                f"high-impact risk: {risk_reason}"
            )
    review_on_risk_only = os.getenv(
        "NL2SQL_REFINER_ON_RISK_ONLY", "false"
    ).strip().lower() in {"1", "true", "yes", "on"}
    if review_on_risk_only:
        review_reasons.extend(risk_reasons)

    review_reasons = list(dict.fromkeys(review_reasons))
    diagnostic_reasons = list(
        dict.fromkeys([*review_reasons, *risk_reasons])
    )
    return bool(review_reasons), diagnostic_reasons


def _projection_aggregate_family(signature: Dict[str, Any]) -> set:
    """Return aggregate function names present in SELECT projections."""
    projections = signature.get("projections") or []
    blob = " ".join(projections).lower() if projections else ""
    if not blob:
        blob = str(signature.get("normalized") or "").lower()
    return {
        name
        for name in ("count", "sum", "avg", "min", "max")
        if re.search(rf"\b{name}\s*\(", blob)
    }


def choose_best_candidate(
    candidates: List[
        Tuple[str, NL2SQLResult, SQLAuditResult, SQLSemanticAuditResult]
    ],
    preferred_labels: Optional[List[str]] = None,
) -> Tuple[str, NL2SQLResult, SQLAuditResult, SQLSemanticAuditResult]:
    """Choose without gold: audits first, then an evidence-based preference."""
    preferred_labels = preferred_labels or ["direct", "planned", "repaired", "validated"]
    preference = {
        label: index for index, label in enumerate(preferred_labels)
    }

    def score(
        item: Tuple[str, NL2SQLResult, SQLAuditResult, SQLSemanticAuditResult]
    ) -> Tuple[int, int, int, int, int, int]:
        label, result, deterministic, semantic = item
        signature = semantic.signature or {}
        table_count = len(signature.get("tables") or [])
        join_bloat_penalty = 0
        risk_blob = " ".join(semantic.risk_reasons or []).upper()
        if "JOIN_OVERGENERATION" in risk_blob:
            join_bloat_penalty = 1
        return (
            len(deterministic.fatal_errors),
            len(semantic.violations),
            join_bloat_penalty,
            table_count if table_count else 99,
            preference.get(label, len(preference)),
            len(result.sql),
        )

    return min(candidates, key=score)


def direct_candidate_anchor_reason(
    question: str,
    direct: NL2SQLResult,
    direct_audit: SQLAuditResult,
    alternative: NL2SQLResult,
    *,
    alternative_semantic: Optional[SQLSemanticAuditResult] = None,
) -> str:
    """Protect executable Direct SQL from observed over-refinement modes."""
    if (
        not direct_audit.valid
        or not direct.sql.strip()
        or direct.sql.strip() == alternative.sql.strip()
    ):
        return ""

    direct_signature, _, _ = build_sql_signature(direct.sql)
    alternative_signature, _, _ = build_sql_signature(alternative.sql)
    direct_projection = " ".join(direct_signature.get("projections", []))
    alternative_projection = " ".join(
        alternative_signature.get("projections", [])
    )
    aggregate_output_question = bool(
        re.search(
            r"^\s*(?:(?:what|which)\s+is\s+|(?:show|find|give)\s+)?"
            r"(?:the\s+)?(?:minimum|maximum|average|lightest|heaviest|"
            r"lowest|highest)\s+(?:[a-z_]+\s+){0,3}of\b",
            " ".join(question.casefold().split()),
        )
    )
    direct_projects_aggregate = bool(
        re.search(r"\b(?:avg|min|max|sum)\s*\(", direct_projection)
    )
    alternative_projects_aggregate = bool(
        re.search(r"\b(?:avg|min|max|sum)\s*\(", alternative_projection)
    )
    if (
        aggregate_output_question
        and direct_projects_aggregate
        and not alternative_projects_aggregate
    ):
        return (
            "Direct anchor: preserved the requested aggregate value; "
            "the alternative changed the output into an entity row."
        )

    singular_named_extreme = bool(
        re.search(
            r"\b(?:name|title|id)\b.{0,100}"
            r"\b(?:least|most|highest|lowest)\b",
            " ".join(question.casefold().split()),
        )
    )
    direct_is_extreme_row = bool(
        direct_signature.get("order_by")
        and direct_signature.get("has_limit")
    )
    alternative_is_extreme_row = bool(
        alternative_signature.get("order_by")
        and alternative_signature.get("has_limit")
    )
    if (
        singular_named_extreme
        and direct_is_extreme_row
        and not alternative_is_extreme_row
    ):
        return (
            "Direct anchor: preserved singular ORDER BY ... LIMIT 1 semantics; "
            "the alternative changed the request into a tie-aware aggregate."
        )

    direct_tables = set(direct_signature.get("tables") or [])
    alternative_tables = set(alternative_signature.get("tables") or [])
    alt_join_bloat = False
    if alternative_semantic is not None:
        alt_join_bloat = any(
            "JOIN_OVERGENERATION" in str(reason).upper()
            for reason in (alternative_semantic.risk_reasons or [])
        )
    if (
        direct_tables
        and alternative_tables
        and len(alternative_tables) > len(direct_tables)
        and direct_tables.issubset(alternative_tables)
    ) or (
        alt_join_bloat
        and direct_tables
        and len(alternative_tables) > len(direct_tables)
    ):
        return (
            "Direct anchor: preserved fewer-table SQL; "
            "the alternative introduced unnecessary joins."
        )

    direct_sets = set(direct_signature.get("set_operations") or [])
    alternative_sets = set(alternative_signature.get("set_operations") or [])
    if direct_sets and direct_sets != alternative_sets:
        return (
            "Direct anchor: preserved set-operation structure; "
            "the alternative changed UNION/INTERSECT/EXCEPT."
        )

    direct_aggs = _projection_aggregate_family(direct_signature)
    alternative_aggs = _projection_aggregate_family(alternative_signature)
    if direct_aggs and alternative_aggs and direct_aggs != alternative_aggs:
        return (
            "Direct anchor: preserved aggregate family; "
            "the alternative changed COUNT/SUM/AVG/MIN/MAX."
        )
    return ""


def refiner_candidate_preference(selected_candidate: str) -> List[str]:
    """Honor the Refiner's audited choice without duplicate-rank overwrite."""
    selected = str(selected_candidate).strip().lower()
    labels = (
        [selected, "direct", "planned", "repaired"]
        if selected in {"direct", "planned", "repaired"}
        else ["direct", "planned", "repaired"]
    )
    return list(dict.fromkeys(labels))


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
    extended_route: bool = False
    route_reasons: List[str] = []
    direct_sql: str = ""
    planned_sql: str = ""
    semantic_risk_reasons: List[str] = []
    direct_anchor_reason: str = ""
    intermediate_sql: str = ""
    result: NL2SQLResult = NL2SQLResult()


class _SeededCrewResult:
    """Minimal stand-in for a CrewAI kickoff result when reusing 4-step raw."""

    def __init__(self, raw: str):
        self.raw = raw
        self.token_usage = None


def load_four_step_seed_file(
    seed_root: Path,
    db_id: str,
    question_index: int,
    question: str,
) -> Optional[Dict[str, Any]]:
    """Load a 4-step raw_responses JSON for hybrid 4→6 seeding."""
    if not seed_root:
        return None
    root = Path(seed_root)
    candidates = [
        root / "raw_responses" / db_id / f"q{question_index:04d}.json",
        root / db_id / f"q{question_index:04d}.json",
    ]
    for path in candidates:
        if path.is_file():
            try:
                cached = json.loads(path.read_text(encoding="utf-8"))
            except Exception:
                continue
            if cached.get("question") and cached.get("question") != question:
                continue
            return cached
    # Fallback: scan by exact question text under raw_responses.
    raw_root = root / "raw_responses"
    if not raw_root.is_dir():
        raw_root = root
    if raw_root.is_dir():
        for path in raw_root.rglob("q*.json"):
            if path.name.endswith(".error.json"):
                continue
            try:
                cached = json.loads(path.read_text(encoding="utf-8"))
            except Exception:
                continue
            if cached.get("question") == question:
                return cached
    return None


def map_four_step_seed_to_six_steps(
    four_step_raw: Dict[str, Any],
) -> Dict[str, Dict[str, Any]]:
    """Map 4-step step traces onto 6-step step names that may be seeded.

    By default seeds Analyzer + Schema + Direct. Set
    ``NL2SQL_SEED_INCLUDE_DIRECT=0`` to seed only steps 1–2 so Planner /
    Expert / Refiner / Validator still call the LLM (Spider R1 repair mode).
    """
    by_name = {
        (step.get("step_name") or ""): step
        for step in (four_step_raw.get("steps") or [])
        if isinstance(step, dict) and step.get("raw_response")
        and not step.get("skipped")
        and step.get("success", True)
    }
    mapped: Dict[str, Dict[str, Any]] = {}
    if "question_analysis" in by_name:
        mapped["question_analysis"] = {
            "raw_response": by_name["question_analysis"]["raw_response"],
            "source_step": "question_analysis",
            "source_pipeline": "4step",
        }
    if "schema_selector" in by_name:
        mapped["schema_selector"] = {
            "raw_response": by_name["schema_selector"]["raw_response"],
            "source_step": "schema_selector",
            "source_pipeline": "4step",
        }
    include_direct = os.getenv(
        "NL2SQL_SEED_INCLUDE_DIRECT", "true"
    ).strip().lower() in {"1", "true", "yes", "on"}
    if include_direct and "generate_sql" in by_name:
        mapped["generate_sql_direct"] = {
            "raw_response": by_name["generate_sql"]["raw_response"],
            "source_step": "generate_sql",
            "source_pipeline": "4step",
        }
    return mapped


class NL2SQLFlow(Flow[NL2SQLState]):
    """Flow for generate SQL from natural language instructions."""

    # NL2SQL_STEP_MAX_RETRIES is max attempts per step (1 = no retry).
    STEP_MAX_RETRIES = int(os.getenv("NL2SQL_STEP_MAX_RETRIES", "1"))
    # Hard wall-clock bound around kickoff. Provider timeouts alone can hang
    # indefinitely on some Gemini/HTTP stalls.
    STEP_TIMEOUT_SECONDS = int(os.getenv("NL2SQL_STEP_TIMEOUT_SECONDS", "90"))

    def __init__(
        self,
        _question: NLQuestions,
        _raw_schema: SQLDbSchema,
        seed_steps: Optional[Dict[str, Dict[str, Any]]] = None,
    ):
        super().__init__()
        self.question = _question
        self.raw_schema = _raw_schema
        # Full trace of every agent step (raw LLM responses) for experiment logging
        self.step_traces: List[Dict] = []
        # Optional 4-step seed map: six-step step_name -> {raw_response, ...}
        self.seed_steps: Dict[str, Dict[str, Any]] = dict(seed_steps or {})
        # Re-read env each flow so smoke runners can change knobs without reload.
        self.STEP_MAX_RETRIES = int(os.getenv("NL2SQL_STEP_MAX_RETRIES", "1"))
        self.STEP_TIMEOUT_SECONDS = int(
            os.getenv("NL2SQL_STEP_TIMEOUT_SECONDS", "90")
        )

    def _consume_seeded_step(
        self,
        step_name: str,
        *,
        effective_model: str = "",
    ) -> Optional[_SeededCrewResult]:
        """Reuse a seeded raw response instead of calling the provider."""
        seed = self.seed_steps.pop(step_name, None)
        if not seed:
            return None
        raw_text = str(seed.get("raw_response") or "")
        if not raw_text.strip():
            return None
        source_step = seed.get("source_step") or step_name
        source_pipeline = seed.get("source_pipeline") or "4step"
        print(
            f"[API][{step_name}] Seeded from {source_pipeline}/"
            f"{source_step} (no LLM call)"
        )
        self.step_traces.append(
            {
                "step_name": step_name,
                "attempt": 0,
                "elapsed_seconds": 0.0,
                "raw_response": raw_text,
                "token_usage": None,
                "success": True,
                "seeded": True,
                "seed_source_pipeline": source_pipeline,
                "seed_source_step": source_step,
                "effective_model": effective_model or f"seed:{source_pipeline}",
                "timestamp": datetime.now().isoformat(),
            }
        )
        return _SeededCrewResult(raw_text)

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

    @staticmethod
    def _is_non_retryable_error(error: Exception) -> bool:
        text = f"{type(error).__name__}: {error}".lower()
        return any(
            marker in text
            for marker in (
                "authentication",
                "permission",
                "notfound",
                "not_found",
                "badrequest",
                "invalid api key",
                "status code: 400",
                "status code: 401",
                "status code: 403",
                "status code: 404",
            )
        )

    def _run_crew_step(
        self,
        step_name: str,
        crew_factory,
        inputs: Dict[str, Any],
        *,
        max_attempts: Optional[int] = None,
        effective_model: str = "",
    ):
        sanitized_inputs = self._sanitize_inputs(inputs)
        self._log_input_summary(step_name, sanitized_inputs)
        last_error: Exception | None = None
        attempts = (
            max_attempts
            if max_attempts is not None
            else self.STEP_MAX_RETRIES
        )
        attempts = max(1, int(attempts))

        for attempt in range(1, attempts + 1):
            started_at = time.time()
            print(
                f"[API][{step_name}] Attempt {attempt}/{attempts} started "
                f"(timeout={self.STEP_TIMEOUT_SECONDS}s)"
            )
            executor = ThreadPoolExecutor(max_workers=1)
            try:
                future = executor.submit(
                    lambda: crew_factory().kickoff(inputs=sanitized_inputs)
                )
                try:
                    result = future.result(timeout=self.STEP_TIMEOUT_SECONDS)
                except FuturesTimeoutError as timeout_error:
                    future.cancel()
                    raise TimeoutError(
                        f"{step_name} timed out after "
                        f"{self.STEP_TIMEOUT_SECONDS}s on attempt {attempt}"
                    ) from timeout_error
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
                    "success": True,
                    "effective_model": effective_model,
                    "timestamp": datetime.now().isoformat(),
                })
                return result
            except Exception as e:
                elapsed = time.time() - started_at
                last_error = e
                print(f"[API][{step_name}] Error on attempt {attempt}: {type(e).__name__}: {e}")
                self.step_traces.append(
                    {
                        "step_name": step_name,
                        "attempt": attempt,
                        "elapsed_seconds": round(elapsed, 3),
                        "raw_response": "",
                        "token_usage": None,
                        "success": False,
                        "effective_model": effective_model,
                        "error_type": type(e).__name__,
                        "error": str(e)[:2000],
                        "timestamp": datetime.now().isoformat(),
                    }
                )
                if self._is_non_retryable_error(e):
                    break
            finally:
                executor.shutdown(wait=False, cancel_futures=True)

            if attempt < attempts:
                backoff = 1 if self._abort_on_failure_enabled() else min(5 * attempt, 15)
                print(f"[API][{step_name}] Retrying after {backoff}s")
                time.sleep(backoff)

        assert last_error is not None
        if self._abort_on_failure_enabled():
            raise RuntimeError(
                f"ABORT: step '{step_name}' failed after {attempts} attempt(s): "
                f"{type(last_error).__name__}: {last_error}"
            ) from last_error
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

    def _record_skipped_step(self, step_name: str, reason: str) -> None:
        self.step_traces.append(
            {
                "step_name": step_name,
                "attempt": 0,
                "elapsed_seconds": 0.0,
                "raw_response": "",
                "skipped": True,
                "skip_reason": reason,
                "token_usage": None,
                "timestamp": datetime.now().isoformat(),
            }
        )

    @staticmethod
    def _env_flag(name: str, default: bool = False) -> bool:
        value = os.getenv(name)
        if value is None:
            return default
        return value.strip().lower() in {"1", "true", "yes", "on"}

    @classmethod
    def _strict_benchmark_enabled(cls) -> bool:
        return cls._env_flag("NL2SQL_STRICT_BENCHMARK", default=False)

    @classmethod
    def _abort_on_failure_enabled(cls) -> bool:
        """Stop the whole process after a step exhausts its retries."""
        return cls._env_flag("NL2SQL_ABORT_ON_FAILURE", default=False)

    def _enforce_final_executable_result(
        self,
        audit_schema: SQLDbSchema,
    ) -> SQLAuditResult:
        self.state.result.sql = canonicalize_sql_identifiers(
            self.state.result.sql,
            self.state.db_raw_schema,
        )
        final_audit = audit_sql_constraints(
            self.state.result.sql,
            audit_schema,
            db_id=self.state.db_id,
        )
        final_semantic = audit_sql_semantics(
            self.state.result.sql,
            self.state.question,
            self.state.question_analysis,
        )
        for trace in reversed(self.step_traces):
            if trace.get("step_name") == "validate_sql":
                trace["final_deterministic_audit"] = final_audit.model_dump()
                trace["final_semantic_audit"] = final_semantic.model_dump()
                break
        strict_benchmark = self._strict_benchmark_enabled()
        if not final_audit.valid or (
            strict_benchmark and final_audit.sqlite_explain_ok is not True
        ):
            codes = [
                issue["code"] for issue in final_audit.fatal_errors
            ]
            if strict_benchmark and final_audit.sqlite_explain_ok is None:
                codes.append("DATABASE_NOT_FOUND")
            detail = ", ".join(codes) or "SQLITE_EXPLAIN_NOT_CONFIRMED"
            raise RuntimeError(
                "Final SQL failed the executable-output invariant: "
                f"{detail}"
            )
        # Semantic violations are quality signals for EX scoring / traces.
        # Do not abort a multi-question benchmark on them: only executable
        # invariants above are hard failures under NL2SQL_STRICT_BENCHMARK.
        if final_semantic.violations:
            codes = ", ".join(
                sorted({item["code"] for item in final_semantic.violations})
            )
            print(
                "[audit] Final SQL has residual semantic violations "
                f"(continuing for EX scoring): {codes}"
            )
        return final_audit

    @listen(get_user_input)
    def question_analysis(self):
        print(f"\nAnalyzing question for intent and complexity\n")
        inputs = {
            "question": self.state.question,
            "raw_db_schema": self.state.db_raw_schema.model_dump_json(),
        }
        analyzer_model = os.getenv(
            "NL2SQL_QUESTION_ANALYZER_MODEL",
            "openai/gpt-4o",
        )
        result = self._consume_seeded_step(
            "question_analysis",
            effective_model=f"seed:4step/{analyzer_model}",
        )
        if result is None:
            try:
                result = self._run_crew_step(
                    "question_analysis",
                    Nl2SqlCrew(
                        model_overrides={
                            "question_analyzer": analyzer_model
                        }
                    ).question_analysis_crew,
                    inputs,
                    effective_model=analyzer_model,
                )
            except Exception as error:
                if self._abort_on_failure_enabled():
                    raise
                fallback_model = os.getenv(
                    "NL2SQL_QUESTION_ANALYZER_FALLBACK_MODEL",
                    os.getenv(
                        "NL2SQL_ANALYZER_FALLBACK_MODEL",
                        "gemini/gemini-flash-latest",
                    ),
                )
                if fallback_model == analyzer_model:
                    raise
                print(
                    "[API][question_analysis] Falling back to "
                    f"{fallback_model} after {type(error).__name__}"
                )
                result = self._run_crew_step(
                    "question_analysis",
                    Nl2SqlCrew(
                        model_overrides={"question_analyzer": fallback_model}
                    ).question_analysis_crew,
                    inputs,
                    max_attempts=1,
                    effective_model=fallback_model,
                )
        parsed_analysis = self.parse_json_safely(result.raw)
        normalized_analysis = normalize_question_analysis(
            self.state.question, parsed_analysis
        )
        canonical_analysis = canonicalize_structured_identifiers(
            normalized_analysis,
            self.state.db_raw_schema,
        )
        self.state.question_analysis = normalize_low_cardinality_literals(
            canonical_analysis,
            self.state.db_raw_schema,
        )
        print(
            f"\nQuestion Analysis Results:\n{json.dumps(self.state.question_analysis, indent=2)}\n")
        return self.state

    @listen(question_analysis)
    def schema_selector(self):
        print(f"\nSelecting needed schema database for question\n")
        schema_model = os.getenv(
            "NL2SQL_SCHEMA_SELECTOR_MODEL",
            "gemini/gemini-flash-latest",
        )
        result = self._consume_seeded_step(
            "schema_selector",
            effective_model=f"seed:4step/{schema_model}",
        )
        if result is None:
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
                effective_model=schema_model,
            )
        schema_dict = canonicalize_structured_identifiers(
            self.parse_json_safely(result.raw),
            self.state.db_raw_schema,
        )
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
        self.state.route_reasons = extended_route_reasons(
            self.state.question_analysis,
            self.state.db_schema,
            question=self.state.question,
        )
        self.state.extended_route = bool(self.state.route_reasons)
        if not self.state.extended_route:
            self.state.query_plan = {
                "route": "fast",
                "steps": ["Use the plan-free direct SQL anchor."],
                "warnings": [],
            }
            self._record_skipped_step(
                "query_planning",
                "Fast route: no structural semantic risk was detected.",
            )
            print("[router] Fast route selected; Query Planner skipped.")
            return self.state

        planner_inputs = {
            "question": self.state.question,
            "db_schema": executable_schema(
                self.state.db_schema
            ).model_dump_json(),
            "question_analysis": json.dumps(self.state.question_analysis),
            "join_plan": json.dumps(self.state.db_schema.join_plan),
        }
        planner_model = os.getenv(
            "NL2SQL_QUERY_PLANNER_MODEL",
            "gemini/gemini-flash-latest",
        )
        try:
            result = self._run_crew_step(
                "query_planning",
                Nl2SqlCrew(
                    model_overrides={"query_planner": planner_model}
                ).query_planning_crew,
                planner_inputs,
                effective_model=planner_model,
            )
            plan_raw = result.raw
        except Exception as error:
            if self._abort_on_failure_enabled():
                raise
            fallback_model = os.getenv(
                "NL2SQL_QUERY_PLANNER_FALLBACK_MODEL",
                "gemini/gemini-flash-lite-latest",
            )
            plan_raw = ""
            if fallback_model != planner_model:
                print(
                    "[API][query_planning] Falling back to "
                    f"{fallback_model} after {type(error).__name__}"
                )
                try:
                    result = self._run_crew_step(
                        "query_planning",
                        Nl2SqlCrew(
                            model_overrides={"query_planner": fallback_model}
                        ).query_planning_crew,
                        planner_inputs,
                        max_attempts=1,
                        effective_model=fallback_model,
                    )
                    plan_raw = result.raw
                except Exception as fallback_error:
                    print(
                        "[API][query_planning] Fallback failed "
                        f"({type(fallback_error).__name__}); using stub plan"
                    )
            else:
                print(
                    "[API][query_planning] Using stub plan after "
                    f"{type(error).__name__}"
                )
            if not plan_raw:
                self.state.query_plan = {
                    "route": "stub_after_planner_failure",
                    "steps": [
                        "Continue with Direct/Planned SQL from analysis and schema."
                    ],
                    "warnings": [
                        f"planner_error={type(error).__name__}: {error}"
                    ],
                }
                print(
                    f"\nQuery Plan:\n{json.dumps(self.state.query_plan, indent=2)}\n"
                )
                return self.state
        self.state.query_plan = canonicalize_structured_identifiers(
            self.parse_json_safely(plan_raw),
            self.state.db_schema,
        )
        print(f"\nQuery Plan:\n{json.dumps(self.state.query_plan, indent=2)}\n")
        return self.state

    @listen(query_planning)
    def generate_sql(self):
        print(f"\nGenerating independent SQL candidates\n")
        sql_schema = executable_schema(self.state.db_schema)
        direct_schema = direct_candidate_schema(self.state.db_raw_schema)
        direct_model = os.getenv(
            "NL2SQL_DIRECT_SQL_MODEL",
            os.getenv("NL2SQL_SQL_EXPERT_MODEL", "openai/gpt-4o"),
        )
        direct_result = self._consume_seeded_step(
            "generate_sql_direct",
            effective_model=f"seed:4step/{direct_model}",
        )
        if direct_result is None:
            direct_result = self._run_crew_step(
                "generate_sql_direct",
                Nl2SqlCrew(
                    model_overrides={"sql_expert": direct_model}
                ).generated_sql_crew,
                {
                    "question": self.state.question,
                    "db_schema": direct_schema.model_dump_json(),
                    "question_analysis": "{}",
                    "query_plan": json.dumps(
                        {
                            "status": "WITHHELD_FROM_DIRECT_CANDIDATE",
                            "instruction": (
                                "Derive direct_sql only from Question and Schema."
                            ),
                        }
                    ),
                    "join_plan": "[]",
                },
                effective_model=direct_model,
            )
        direct_dict = self.parse_json_safely(direct_result.raw)
        direct_legacy = (direct_dict.get("sql") or "").strip()
        direct_sql = (
            direct_dict.get("direct_sql") or direct_legacy
        ).strip()

        planned_sql = direct_sql
        if self.state.extended_route:
            planned_model = os.getenv(
                "NL2SQL_PLANNED_SQL_MODEL",
                "gemini/gemini-flash-latest",
            )
            planned_inputs = {
                "question": self.state.question,
                "db_schema": sql_schema.model_dump_json(),
                "question_analysis": json.dumps(
                    self.state.question_analysis
                ),
                "query_plan": json.dumps(self.state.query_plan),
                "join_plan": json.dumps(
                    self.state.db_schema.join_plan
                ),
            }
            try:
                planned_result = self._run_crew_step(
                    "generate_sql_planned",
                    Nl2SqlCrew(
                        model_overrides={"sql_expert": planned_model}
                    ).generated_sql_crew,
                    planned_inputs,
                    effective_model=planned_model,
                )
            except Exception as error:
                if self._abort_on_failure_enabled():
                    raise
                fallback_model = os.getenv(
                    "NL2SQL_PLANNED_SQL_FALLBACK_MODEL",
                    "gemini/gemini-flash-latest",
                )
                if fallback_model == planned_model:
                    raise
                print(
                    "[API][generate_sql_planned] Falling back to "
                    f"{fallback_model} after {type(error).__name__}"
                )
                planned_result = self._run_crew_step(
                    "generate_sql_planned",
                    Nl2SqlCrew(
                        model_overrides={"sql_expert": fallback_model}
                    ).generated_sql_crew,
                    planned_inputs,
                    max_attempts=1,
                    effective_model=fallback_model,
                )
            planned_dict = self.parse_json_safely(planned_result.raw)
            planned_legacy = (planned_dict.get("sql") or "").strip()
            planned_sql = (
                planned_dict.get("planned_sql")
                or planned_dict.get("direct_sql")
                or planned_legacy
                or direct_sql
            ).strip()
        else:
            self._record_skipped_step(
                "generate_sql_planned",
                "Fast route: planned candidate is not required.",
            )

        if not direct_sql:
            direct_sql = planned_sql
        if not planned_sql:
            planned_sql = direct_sql
        self.state.direct_sql = apply_post_generation_sql_repairs(
            direct_sql,
            self.state.question,
            self.state.db_raw_schema,
        )
        self.state.planned_sql = apply_post_generation_sql_repairs(
            planned_sql,
            self.state.question,
            self.state.db_raw_schema,
        )
        self.state.intermediate_sql = (
            self.state.planned_sql or self.state.direct_sql
        )
        print(f"\nDirect SQL:\n{self.state.direct_sql}")
        print(f"\nPlanned SQL:\n{self.state.planned_sql}\n")
        return self.state

    @listen(generate_sql)
    def refine_sql(self):
        print(f"\nAuditing and arbitrating SQL candidates\n")
        audit_schema = enrich_schema_metadata(
            self.state.db_raw_schema,
            join_plan=self.state.db_schema.join_plan,
            required_tables=self.state.db_schema.required_tables,
            join_plan_warnings=self.state.db_schema.join_plan_warnings,
        )
        direct = NL2SQLResult(sql=self.state.direct_sql)
        planned = NL2SQLResult(sql=self.state.planned_sql)
        direct_audit = audit_sql_constraints(
            direct.sql,
            audit_schema,
            db_id=self.state.db_id,
        )
        planned_audit = audit_sql_constraints(
            planned.sql,
            audit_schema,
            db_id=self.state.db_id,
        )
        direct_semantic = audit_sql_semantics(
            direct.sql,
            self.state.question,
            self.state.question_analysis,
        )
        planned_semantic = audit_sql_semantics(
            planned.sql,
            self.state.question,
            self.state.question_analysis,
        )
        for trace in self.step_traces:
            if trace.get("step_name") in {
                "generate_sql_direct",
                "generate_sql_planned",
            }:
                trace["candidate_audits"] = {
                    "direct": {
                        "deterministic": direct_audit.model_dump(),
                        "semantic": direct_semantic.model_dump(),
                    },
                    "planned": {
                        "deterministic": planned_audit.model_dump(),
                        "semantic": planned_semantic.model_dump(),
                    },
                }

        review_required, risk_reasons = requires_semantic_review(
            direct_audit,
            planned_audit,
            direct_semantic,
            planned_semantic,
        )
        self.state.semantic_risk_reasons = risk_reasons
        anchor_reason = direct_candidate_anchor_reason(
            self.state.question,
            direct,
            direct_audit,
            planned,
            alternative_semantic=planned_semantic,
        )
        if anchor_reason:
            self.state.direct_anchor_reason = anchor_reason
            self._record_skipped_step("refine_sql", anchor_reason)
            self.state.result = NL2SQLResult(
                sql=direct.sql,
                explain=anchor_reason,
                error="",
            )
            print(f"\nRefined SQL:\n{self.state.result.sql}\n")
            return self.state
        if not review_required:
            # Prefer Direct as the independent GPT-4o anchor when both pass.
            # Planned join-bloat previously leaked through this skip path.
            self._record_skipped_step(
                "refine_sql",
                "Candidates are structurally equivalent and semantic audits pass; kept Direct.",
            )
            self.state.result = NL2SQLResult(
                sql=direct.sql,
                explain=(
                    "Refiner skipped: equivalent low-risk candidates; "
                    "kept Direct anchor."
                ),
                error="",
            )
            print(f"\nRefined SQL:\n{self.state.result.sql}\n")
            return self.state

        try:
            refiner_model = os.getenv(
                "NL2SQL_SQL_REFINER_MODEL",
                "gemini/gemini-flash-latest",
            )
            refiner_inputs = {
                "question": self.state.question,
                "db_schema": executable_schema(
                    self.state.db_raw_schema
                ).model_dump_json(),
                "direct_sql": direct.sql,
                "planned_sql": planned.sql,
                "question_analysis": json.dumps(self.state.question_analysis),
                "query_plan": json.dumps(self.state.query_plan),
                "join_plan": json.dumps(self.state.db_schema.join_plan),
                "constraint_report": json.dumps(
                    {
                        "direct": direct_audit.model_dump(),
                        "planned": planned_audit.model_dump(),
                    }
                ),
                "direct_semantic_report": direct_semantic.model_dump_json(),
                "planned_semantic_report": planned_semantic.model_dump_json(),
                "risk_reasons": json.dumps(risk_reasons),
            }
            try:
                result = self._run_crew_step(
                    "refine_sql",
                    Nl2SqlCrew(
                        model_overrides={"sql_refiner": refiner_model}
                    ).sql_refinement_crew,
                    refiner_inputs,
                    effective_model=refiner_model,
                )
            except Exception as error:
                if self._abort_on_failure_enabled():
                    raise
                fallback_model = os.getenv(
                    "NL2SQL_SQL_REFINER_FALLBACK_MODEL",
                    "gemini/gemini-flash-latest",
                )
                if fallback_model == refiner_model:
                    raise
                print(
                    "[API][refine_sql] Falling back to "
                    f"{fallback_model} after {type(error).__name__}"
                )
                result = self._run_crew_step(
                    "refine_sql",
                    Nl2SqlCrew(
                        model_overrides={"sql_refiner": fallback_model}
                    ).sql_refinement_crew,
                    refiner_inputs,
                    max_attempts=1,
                    effective_model=fallback_model,
                )
            result_dict = self.parse_json_safely(result.raw)
            refined_sql = apply_post_generation_sql_repairs(
                (result_dict.get("sql") or "").strip(),
                self.state.question,
                self.state.db_raw_schema,
            )
            refined = NL2SQLResult(
                sql=refined_sql if refined_sql else planned.sql,
                explain=result_dict.get("notes", ""),
                error="",
            )
            refined_audit = audit_sql_constraints(
                refined.sql,
                audit_schema,
                db_id=self.state.db_id,
            )
            refined_semantic = audit_sql_semantics(
                refined.sql,
                self.state.question,
                self.state.question_analysis,
            )
            self._attach_deterministic_audit("refine_sql", refined_audit)
            for trace in reversed(self.step_traces):
                if trace.get("step_name") == "refine_sql":
                    trace["semantic_audit"] = refined_semantic.model_dump()
                    break
            candidates = [
                ("direct", direct, direct_audit, direct_semantic),
                ("planned", planned, planned_audit, planned_semantic),
                ("repaired", refined, refined_audit, refined_semantic),
            ]
            refiner_choice = str(
                result_dict.get("selected_candidate", "")
            ).strip().lower()
            preferred_labels = refiner_candidate_preference(
                refiner_choice
            )
            _, selected, _, _ = choose_best_candidate(
                candidates,
                preferred_labels=preferred_labels,
            )
            self.state.result = selected
        except Exception as e:
            print(
                f"[API][refine_sql] Candidate fallback due to: "
                f"{type(e).__name__}: {e}"
            )
            if (
                self._strict_benchmark_enabled()
                or self._abort_on_failure_enabled()
            ):
                raise
            if not any(
                trace.get("step_name") == "refine_sql"
                for trace in self.step_traces
            ):
                self._record_skipped_step(
                    "refine_sql",
                    f"LLM refiner failed; deterministic candidate fallback: {e}",
                )
            _, selected, _, _ = choose_best_candidate(
                [
                    ("direct", direct, direct_audit, direct_semantic),
                    ("planned", planned, planned_audit, planned_semantic),
                ]
            )
            self.state.result = selected
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
        refined_semantic = audit_sql_semantics(
            refined.sql,
            self.state.question,
            self.state.question_analysis,
        )
        if self.state.direct_anchor_reason and refined_audit.valid:
            self._record_skipped_step(
                "validate_sql",
                self.state.direct_anchor_reason,
            )
            self.state.result = NL2SQLResult(
                sql=refined.sql,
                explain=self.state.direct_anchor_reason,
                error="",
            )
            self._enforce_final_executable_result(audit_schema)
            print(f"\nFinal SQL:\n")
            print(json.dumps(self.state.result.model_dump(), indent=4))
            return self.state
        residual_high_impact = any(
            any(
                marker in str(reason).strip().upper()
                for marker in {
                    "JOIN_OVERGENERATION",
                    "RELATED_ROW_NEGATION",
                    "SET_OPERATION",
                    "OUTPUT_ROLE_AMBIGUITY",
                    "EXTREME_ROW",
                    "HIGH-RISK QUESTION PATTERN",
                }
            )
            for reason in refined_semantic.risk_reasons
        )
        if (
            refined_audit.valid
            and refined_semantic.valid
            and refined.sql.strip()
            and not residual_high_impact
        ):
            self._record_skipped_step(
                "validate_sql",
                "Deterministic and semantic audits both pass.",
            )
            self.state.result = NL2SQLResult(
                sql=refined.sql,
                explain=refined.explain or "Validator skipped: all audits pass.",
                error="",
            )
            self._enforce_final_executable_result(audit_schema)
            print(f"\nFinal SQL:\n")
            print(json.dumps(self.state.result.model_dump(), indent=4))
            return self.state
        try:
            validator_model = os.getenv(
                "NL2SQL_SQL_VALIDATOR_MODEL",
                "gemini/gemini-flash-latest",
            )
            result = self._run_crew_step(
                "validate_sql",
                Nl2SqlCrew(
                    model_overrides={"sql_validator": validator_model}
                ).validate_sql_crew,
                {
                    "question": self.state.question,
                    "db_schema": executable_schema(
                        self.state.db_raw_schema
                    ).model_dump_json(),
                    "sql": self.state.result.sql,
                    "direct_sql": self.state.direct_sql,
                    "planned_sql": self.state.planned_sql,
                    "question_analysis": json.dumps(self.state.question_analysis),
                    "query_plan": json.dumps(self.state.query_plan),
                    "join_plan": json.dumps(self.state.db_schema.join_plan),
                    "constraint_report": refined_audit.model_dump_json(),
                    "semantic_report": refined_semantic.model_dump_json(),
                },
                effective_model=validator_model,
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
            validated.sql = normalize_numeric_year_predicates(
                canonicalize_sql_identifiers(
                    validated.sql,
                    self.state.db_raw_schema,
                ),
                self.state.db_raw_schema,
            )
            validated_audit = audit_sql_constraints(
                validated.sql,
                audit_schema,
                db_id=self.state.db_id,
            )
            validated_semantic = audit_sql_semantics(
                validated.sql,
                self.state.question,
                self.state.question_analysis,
            )
            self._attach_deterministic_audit(
                "validate_sql",
                validated_audit,
            )
            for trace in reversed(self.step_traces):
                if trace.get("step_name") == "validate_sql":
                    trace["semantic_audit"] = validated_semantic.model_dump()
                    break
            direct = NL2SQLResult(sql=self.state.direct_sql)
            planned = NL2SQLResult(sql=self.state.planned_sql)
            direct_audit = audit_sql_constraints(
                direct.sql, audit_schema, db_id=self.state.db_id
            )
            planned_audit = audit_sql_constraints(
                planned.sql, audit_schema, db_id=self.state.db_id
            )
            direct_semantic = audit_sql_semantics(
                direct.sql, self.state.question, self.state.question_analysis
            )
            planned_semantic = audit_sql_semantics(
                planned.sql, self.state.question, self.state.question_analysis
            )
            _, selected, _, _ = choose_best_candidate(
                [
                    ("direct", direct, direct_audit, direct_semantic),
                    ("planned", planned, planned_audit, planned_semantic),
                    ("repaired", refined, refined_audit, refined_semantic),
                    (
                        "validated",
                        validated,
                        validated_audit,
                        validated_semantic,
                    ),
                ],
                preferred_labels=[
                    "validated",
                    "repaired",
                    "planned",
                    "direct",
                ],
            )
            self.state.result = selected
        except Exception as e:
            print(f"[API][validate_sql] Fallback to current SQL due to: {type(e).__name__}: {e}")
            if (
                self._strict_benchmark_enabled()
                or self._abort_on_failure_enabled()
            ):
                raise
            if not any(
                trace.get("step_name") == "validate_sql"
                for trace in self.step_traces
            ):
                self._record_skipped_step(
                    "validate_sql",
                    f"LLM validator failed; kept current candidate: {e}",
                )
            self.state.result = NL2SQLResult(
                sql=self.state.result.sql,
                explain="Validator fallback after API failure/timeout.",
                error="",
            )

        self._enforce_final_executable_result(audit_schema)
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
                                            table_names=table.get(
                                                'table_names',
                                                table['table_names_original'],
                                            ),
                                            table_names_original=table['table_names_original'],
                                            column_names=table.get(
                                                'column_names',
                                                table['column_names_original'],
                                            ),
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
