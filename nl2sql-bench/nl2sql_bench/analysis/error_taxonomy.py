"""
Error taxonomy for NL2SQL-Bench.

This module provides error classification capabilities for analyzing
common failure patterns in NL2SQL systems.
"""

import re
from enum import Enum
from typing import Any, Dict, List, Optional, Set


class ErrorCategory(str, Enum):
    """
    Enumeration of common NL2SQL error categories.
    
    Based on analysis of failure patterns in Spider benchmark evaluations.
    """
    
    FIELD_SELECTION = "field_selection"
    """Incorrect column selection in SELECT clause"""
    
    JOIN_PATH = "join_path"
    """Missing, extra, or incorrect JOIN operations"""
    
    AGGREGATION = "aggregation"
    """Incorrect aggregation function (COUNT/SUM/AVG/MIN/MAX)"""
    
    GROUP_BY = "group_by"
    """Incorrect or missing GROUP BY clause"""
    
    NESTED_QUERY = "nested_query"
    """Incorrect subquery structure"""
    
    VALUE_GROUNDING = "value_grounding"
    """Incorrect filter values in WHERE clause"""
    
    SET_OPERATION = "set_operation"
    """Incorrect UNION/INTERSECT/EXCEPT usage"""
    
    ORDER_LIMIT = "order_limit"
    """Incorrect ORDER BY or LIMIT clause"""
    
    CONDITION_LOGIC = "condition_logic"
    """Incorrect WHERE condition logic (AND/OR/NOT)"""
    
    SYNTAX_ERROR = "syntax_error"
    """SQL syntax error"""
    
    EMPTY_RESULT = "empty_result"
    """No SQL generated (empty prediction)"""
    
    OTHER = "other"
    """Other errors not fitting above categories"""


def normalize_sql_for_analysis(sql: str) -> str:
    """Normalize SQL for analysis comparison."""
    if not sql:
        return ""
    sql = sql.upper()
    sql = ' '.join(sql.split())
    sql = sql.rstrip(';').strip()
    return sql


def extract_select_columns(sql: str) -> Set[str]:
    """Extract column names from SELECT clause."""
    columns = set()
    match = re.search(r'SELECT\s+(.*?)\s+FROM', sql, re.DOTALL)
    if match:
        select_part = match.group(1)
        # Remove aggregations for pure column comparison
        select_part = re.sub(r'(COUNT|SUM|AVG|MIN|MAX)\s*\([^)]+\)', 'AGG', select_part)
        parts = [p.strip() for p in select_part.split(',')]
        for part in parts:
            # Remove aliases
            if ' AS ' in part:
                part = part.split(' AS ')[0].strip()
            columns.add(part)
    return columns


def extract_tables(sql: str) -> Set[str]:
    """Extract table names from SQL."""
    tables = set()
    # FROM clause
    from_match = re.search(r'FROM\s+(\w+)', sql)
    if from_match:
        tables.add(from_match.group(1))
    # JOIN clauses
    join_matches = re.findall(r'JOIN\s+(\w+)', sql)
    tables.update(join_matches)
    return tables


def extract_aggregations(sql: str) -> List[str]:
    """Extract aggregation functions."""
    aggs = []
    for func in ['COUNT', 'SUM', 'AVG', 'MIN', 'MAX']:
        matches = re.findall(rf'{func}\s*\([^)]+\)', sql)
        aggs.extend(matches)
    return aggs


def extract_group_by(sql: str) -> Set[str]:
    """Extract GROUP BY columns."""
    columns = set()
    match = re.search(r'GROUP\s+BY\s+(.*?)(?:HAVING|ORDER|LIMIT|$)', sql)
    if match:
        group_part = match.group(1).strip()
        columns = {c.strip() for c in group_part.split(',')}
    return columns


def has_subquery(sql: str) -> bool:
    """Check if SQL contains a subquery."""
    return sql.count('SELECT') > 1


def has_set_operation(sql: str) -> bool:
    """Check if SQL uses set operations."""
    return any(op in sql for op in ['UNION', 'INTERSECT', 'EXCEPT'])


def extract_joins(sql: str) -> List[str]:
    """Extract JOIN clauses."""
    joins = re.findall(r'((?:LEFT|RIGHT|INNER|OUTER|CROSS)?\s*JOIN\s+\w+\s+ON\s+[^,]+)', sql)
    return joins


def extract_where_conditions(sql: str) -> List[str]:
    """Extract WHERE conditions."""
    conditions = []
    match = re.search(r'WHERE\s+(.*?)(?:GROUP|ORDER|LIMIT|UNION|INTERSECT|EXCEPT|$)', sql)
    if match:
        where_part = match.group(1).strip()
        # Simple split - not handling nested conditions
        parts = re.split(r'\s+AND\s+|\s+OR\s+', where_part)
        conditions = [p.strip() for p in parts if p.strip()]
    return conditions


def classify_error(
    pred_sql: str,
    gold_sql: str,
    schema: Optional[Dict[str, Any]] = None
) -> List[ErrorCategory]:
    """
    Classify errors between predicted and gold SQL.
    
    Analyzes structural differences to identify error categories.
    
    Args:
        pred_sql: Predicted SQL query.
        gold_sql: Gold (expected) SQL query.
        schema: Optional database schema for context.
        
    Returns:
        List of ErrorCategory values identifying the error types.
        
    Example:
        ```python
        errors = classify_error(
            pred_sql="SELECT name FROM users",
            gold_sql="SELECT name, age FROM users"
        )
        # Returns [ErrorCategory.FIELD_SELECTION]
        ```
    """
    categories: List[ErrorCategory] = []
    
    # Handle empty prediction
    if not pred_sql or not pred_sql.strip():
        return [ErrorCategory.EMPTY_RESULT]
    
    # Normalize SQL
    pred_norm = normalize_sql_for_analysis(pred_sql)
    gold_norm = normalize_sql_for_analysis(gold_sql)
    
    # Check for syntax issues (very basic)
    if not pred_norm.startswith('SELECT'):
        categories.append(ErrorCategory.SYNTAX_ERROR)
        return categories
    
    # 1. Check SELECT columns
    pred_cols = extract_select_columns(pred_norm)
    gold_cols = extract_select_columns(gold_norm)
    if pred_cols != gold_cols:
        categories.append(ErrorCategory.FIELD_SELECTION)
    
    # 2. Check tables (JOIN path)
    pred_tables = extract_tables(pred_norm)
    gold_tables = extract_tables(gold_norm)
    if pred_tables != gold_tables:
        categories.append(ErrorCategory.JOIN_PATH)
    
    # Also check JOIN count
    pred_joins = len(extract_joins(pred_norm))
    gold_joins = len(extract_joins(gold_norm))
    if pred_joins != gold_joins and ErrorCategory.JOIN_PATH not in categories:
        categories.append(ErrorCategory.JOIN_PATH)
    
    # 3. Check aggregations
    pred_aggs = set(extract_aggregations(pred_norm))
    gold_aggs = set(extract_aggregations(gold_norm))
    if pred_aggs != gold_aggs:
        categories.append(ErrorCategory.AGGREGATION)
    
    # 4. Check GROUP BY
    pred_group = extract_group_by(pred_norm)
    gold_group = extract_group_by(gold_norm)
    if pred_group != gold_group:
        categories.append(ErrorCategory.GROUP_BY)
    
    # 5. Check subqueries
    pred_has_subquery = has_subquery(pred_norm)
    gold_has_subquery = has_subquery(gold_norm)
    if pred_has_subquery != gold_has_subquery:
        categories.append(ErrorCategory.NESTED_QUERY)
    
    # 6. Check set operations
    pred_has_set = has_set_operation(pred_norm)
    gold_has_set = has_set_operation(gold_norm)
    if pred_has_set != gold_has_set:
        categories.append(ErrorCategory.SET_OPERATION)
    
    # 7. Check WHERE conditions (simplified)
    pred_conds = extract_where_conditions(pred_norm)
    gold_conds = extract_where_conditions(gold_norm)
    if len(pred_conds) != len(gold_conds):
        categories.append(ErrorCategory.CONDITION_LOGIC)
    
    # 8. Check ORDER BY / LIMIT
    pred_has_order = 'ORDER BY' in pred_norm
    gold_has_order = 'ORDER BY' in gold_norm
    pred_has_limit = 'LIMIT' in pred_norm
    gold_has_limit = 'LIMIT' in gold_norm
    if pred_has_order != gold_has_order or pred_has_limit != gold_has_limit:
        categories.append(ErrorCategory.ORDER_LIMIT)
    
    # If no specific category found, mark as OTHER
    if not categories:
        categories.append(ErrorCategory.OTHER)
    
    return categories


def analyze_errors(
    results: List[Dict[str, Any]],
    top_n_examples: int = 3
) -> Dict[str, Any]:
    """
    Analyze a batch of errors and generate statistics.
    
    Args:
        results: List of error dictionaries with keys:
            - pred_sql: Predicted SQL
            - gold_sql: Gold SQL
            - question: Natural language question
            - db_id: Database identifier
            - schema: Optional schema
        top_n_examples: Number of example errors to include per category.
        
    Returns:
        Dictionary containing:
        - total_errors: Total number of errors analyzed
        - by_category: Count per error category
        - by_category_percentage: Percentage per category
        - examples: Top examples per category
        
    Example:
        ```python
        errors = [
            {"pred_sql": "SELECT ...", "gold_sql": "SELECT ...", ...},
            ...
        ]
        analysis = analyze_errors(errors)
        print(f"Total errors: {analysis['total_errors']}")
        for cat, pct in analysis['by_category_percentage'].items():
            print(f"  {cat}: {pct:.1%}")
        ```
    """
    # Category counters and examples
    by_category: Dict[str, int] = {cat.value: 0 for cat in ErrorCategory}
    examples: Dict[str, List[Dict]] = {cat.value: [] for cat in ErrorCategory}
    
    total_errors = len(results)
    
    for error_data in results:
        pred_sql = error_data.get("pred_sql", "")
        gold_sql = error_data.get("gold_sql", "")
        schema = error_data.get("schema")
        
        # Classify this error
        categories = classify_error(pred_sql, gold_sql, schema)
        
        for cat in categories:
            by_category[cat.value] += 1
            
            # Store example if we haven't reached limit
            if len(examples[cat.value]) < top_n_examples:
                examples[cat.value].append({
                    "question": error_data.get("question", ""),
                    "db_id": error_data.get("db_id", ""),
                    "pred_sql": pred_sql[:200] + "..." if len(pred_sql) > 200 else pred_sql,
                    "gold_sql": gold_sql[:200] + "..." if len(gold_sql) > 200 else gold_sql,
                })
    
    # Calculate percentages
    by_category_percentage: Dict[str, float] = {}
    for cat, count in by_category.items():
        by_category_percentage[cat] = count / total_errors if total_errors > 0 else 0.0
    
    # Sort by frequency
    sorted_categories = sorted(
        by_category.items(),
        key=lambda x: x[1],
        reverse=True
    )
    
    return {
        "total_errors": total_errors,
        "by_category": dict(sorted_categories),
        "by_category_percentage": {
            k: by_category_percentage[k]
            for k, _ in sorted_categories
        },
        "examples": examples,
        "top_categories": [
            {"category": cat, "count": count, "percentage": by_category_percentage[cat]}
            for cat, count in sorted_categories[:5]
            if count > 0
        ],
    }


def get_category_description(category: ErrorCategory) -> str:
    """
    Get human-readable description of an error category.
    
    Args:
        category: ErrorCategory enum value.
        
    Returns:
        Description string.
    """
    descriptions = {
        ErrorCategory.FIELD_SELECTION: (
            "Incorrect column selection in SELECT clause. "
            "Missing columns, extra columns, or wrong column names."
        ),
        ErrorCategory.JOIN_PATH: (
            "Incorrect JOIN operations. Missing tables, extra tables, "
            "or wrong join conditions."
        ),
        ErrorCategory.AGGREGATION: (
            "Incorrect aggregation function. Wrong function type "
            "(COUNT vs SUM), missing aggregation, or wrong argument."
        ),
        ErrorCategory.GROUP_BY: (
            "Incorrect GROUP BY clause. Missing, extra, or wrong "
            "grouping columns."
        ),
        ErrorCategory.NESTED_QUERY: (
            "Incorrect subquery structure. Missing subquery, incorrect "
            "nesting, or wrong subquery logic."
        ),
        ErrorCategory.VALUE_GROUNDING: (
            "Incorrect filter values in WHERE clause. Wrong literal values "
            "or incorrectly mapped entity references."
        ),
        ErrorCategory.SET_OPERATION: (
            "Incorrect set operation. Wrong use of UNION/INTERSECT/EXCEPT "
            "or missing set operation."
        ),
        ErrorCategory.ORDER_LIMIT: (
            "Incorrect ORDER BY or LIMIT clause. Wrong sort order, "
            "missing sorting, or incorrect limit value."
        ),
        ErrorCategory.CONDITION_LOGIC: (
            "Incorrect WHERE condition logic. Wrong AND/OR combinations, "
            "missing conditions, or extra conditions."
        ),
        ErrorCategory.SYNTAX_ERROR: (
            "SQL syntax error. Invalid SQL that cannot be parsed "
            "or executed."
        ),
        ErrorCategory.EMPTY_RESULT: (
            "No SQL generated. The system failed to produce any output."
        ),
        ErrorCategory.OTHER: (
            "Other errors not fitting the defined categories."
        ),
    }
    return descriptions.get(category, "Unknown error category.")
