"""
Exact match metric for NL2SQL-Bench.

This module computes exact match accuracy by comparing the structure
of predicted SQL against gold SQL, following Spider evaluation methodology.
"""

import re
from typing import Any, Dict, List, Optional, Set, Tuple


# SQL keywords for parsing
SQL_KEYWORDS = {
    "SELECT", "FROM", "WHERE", "GROUP", "BY", "HAVING", "ORDER",
    "LIMIT", "UNION", "INTERSECT", "EXCEPT", "JOIN", "ON", "AS",
    "AND", "OR", "NOT", "IN", "EXISTS", "BETWEEN", "LIKE", "IS",
    "NULL", "TRUE", "FALSE", "DISTINCT", "ALL", "ASC", "DESC",
    "INNER", "LEFT", "RIGHT", "OUTER", "CROSS", "NATURAL",
    "COUNT", "SUM", "AVG", "MIN", "MAX", "CASE", "WHEN", "THEN",
    "ELSE", "END"
}

# Aggregation functions
AGG_OPS = ["COUNT", "SUM", "AVG", "MIN", "MAX"]


def normalize_sql(sql: str) -> str:
    """
    Normalize SQL query for comparison.
    
    - Convert to uppercase
    - Remove extra whitespace
    - Standardize quotes
    
    Args:
        sql: SQL query string.
        
    Returns:
        Normalized SQL string.
    """
    # Remove comments
    sql = re.sub(r'--.*$', '', sql, flags=re.MULTILINE)
    sql = re.sub(r'/\*.*?\*/', '', sql, flags=re.DOTALL)
    
    # Convert to uppercase (but preserve string values)
    # Simple approach: uppercase everything, then handle values separately
    sql = sql.upper()
    
    # Standardize whitespace
    sql = ' '.join(sql.split())
    
    # Remove trailing semicolon
    sql = sql.rstrip(';').strip()
    
    return sql


def extract_tables(sql: str) -> Set[str]:
    """
    Extract table names from SQL query.
    
    Args:
        sql: Normalized SQL query.
        
    Returns:
        Set of table names (uppercase).
    """
    tables = set()
    
    # FROM clause
    from_match = re.search(r'FROM\s+(\w+)', sql)
    if from_match:
        tables.add(from_match.group(1))
    
    # JOIN clauses
    join_matches = re.findall(r'JOIN\s+(\w+)', sql)
    tables.update(join_matches)
    
    return tables


def extract_columns(sql: str) -> Set[str]:
    """
    Extract column references from SELECT clause.
    
    Args:
        sql: Normalized SQL query.
        
    Returns:
        Set of column references.
    """
    columns = set()
    
    # Extract SELECT clause
    select_match = re.search(r'SELECT\s+(.*?)\s+FROM', sql, re.DOTALL)
    if select_match:
        select_clause = select_match.group(1)
        
        # Handle SELECT *
        if select_clause.strip() == '*':
            columns.add('*')
            return columns
        
        # Split by comma (simple approach)
        parts = select_clause.split(',')
        for part in parts:
            part = part.strip()
            # Remove aliases
            if ' AS ' in part:
                part = part.split(' AS ')[0].strip()
            columns.add(part)
    
    return columns


def extract_conditions(sql: str) -> List[str]:
    """
    Extract WHERE conditions from SQL query.
    
    Args:
        sql: Normalized SQL query.
        
    Returns:
        List of condition strings.
    """
    conditions = []
    
    where_match = re.search(r'WHERE\s+(.*?)(?:GROUP|ORDER|LIMIT|UNION|INTERSECT|EXCEPT|$)', sql)
    if where_match:
        where_clause = where_match.group(1).strip()
        # Simple split by AND/OR (not handling nested conditions well)
        parts = re.split(r'\s+AND\s+|\s+OR\s+', where_clause)
        conditions.extend(p.strip() for p in parts if p.strip())
    
    return conditions


def extract_aggregations(sql: str) -> Set[str]:
    """
    Extract aggregation functions from SQL.
    
    Args:
        sql: Normalized SQL query.
        
    Returns:
        Set of aggregation expressions (e.g., "COUNT(*)", "SUM(amount)").
    """
    aggs = set()
    
    for agg in AGG_OPS:
        pattern = rf'{agg}\s*\([^)]+\)'
        matches = re.findall(pattern, sql)
        aggs.update(matches)
    
    return aggs


def extract_group_by(sql: str) -> Set[str]:
    """
    Extract GROUP BY columns.
    
    Args:
        sql: Normalized SQL query.
        
    Returns:
        Set of GROUP BY column names.
    """
    columns = set()
    
    group_match = re.search(r'GROUP\s+BY\s+(.*?)(?:HAVING|ORDER|LIMIT|$)', sql)
    if group_match:
        group_clause = group_match.group(1).strip()
        parts = group_clause.split(',')
        columns.update(p.strip() for p in parts if p.strip())
    
    return columns


def extract_order_by(sql: str) -> List[str]:
    """
    Extract ORDER BY columns with direction.
    
    Args:
        sql: Normalized SQL query.
        
    Returns:
        List of (column, direction) strings.
    """
    order_items = []
    
    order_match = re.search(r'ORDER\s+BY\s+(.*?)(?:LIMIT|$)', sql)
    if order_match:
        order_clause = order_match.group(1).strip()
        parts = order_clause.split(',')
        for part in parts:
            part = part.strip()
            if part:
                order_items.append(part)
    
    return order_items


def has_distinct(sql: str) -> bool:
    """Check if query uses DISTINCT."""
    return 'SELECT DISTINCT' in sql


def has_subquery(sql: str) -> bool:
    """Check if query contains a subquery."""
    # Count SELECT occurrences
    select_count = sql.count('SELECT')
    return select_count > 1


def compute_exact_match(
    pred_sql: str,
    gold_sql: str,
    db_id: Optional[str] = None,
    schema: Optional[Dict[str, Any]] = None,
    disable_value: bool = True,
    disable_distinct: bool = True
) -> bool:
    """
    Compute exact match between predicted and gold SQL.
    
    Compares structural components of SQL queries:
    - Tables (FROM, JOIN)
    - Columns (SELECT)
    - Conditions (WHERE)
    - Aggregations (COUNT, SUM, etc.)
    - GROUP BY
    - ORDER BY
    
    Args:
        pred_sql: Predicted SQL query.
        gold_sql: Gold (expected) SQL query.
        db_id: Database identifier (optional, for context).
        schema: Database schema (optional, for enhanced matching).
        disable_value: Ignore literal values in comparison.
        disable_distinct: Ignore DISTINCT differences.
        
    Returns:
        True if queries match structurally.
        
    Example:
        ```python
        match = compute_exact_match(
            pred_sql="SELECT COUNT(*) FROM users",
            gold_sql="SELECT COUNT(*) FROM users"
        )
        print(f"Exact match: {match}")
        ```
    """
    # Normalize both queries
    pred_norm = normalize_sql(pred_sql)
    gold_norm = normalize_sql(gold_sql)
    
    # Quick check: identical normalized SQL
    if pred_norm == gold_norm:
        return True
    
    # Compare structural components
    
    # 1. Tables
    pred_tables = extract_tables(pred_norm)
    gold_tables = extract_tables(gold_norm)
    if pred_tables != gold_tables:
        return False
    
    # 2. Columns (SELECT clause)
    pred_cols = extract_columns(pred_norm)
    gold_cols = extract_columns(gold_norm)
    if pred_cols != gold_cols:
        return False
    
    # 3. Aggregations
    pred_aggs = extract_aggregations(pred_norm)
    gold_aggs = extract_aggregations(gold_norm)
    if pred_aggs != gold_aggs:
        return False
    
    # 4. GROUP BY
    pred_group = extract_group_by(pred_norm)
    gold_group = extract_group_by(gold_norm)
    if pred_group != gold_group:
        return False
    
    # 5. ORDER BY (optional: may want to be lenient here)
    pred_order = extract_order_by(pred_norm)
    gold_order = extract_order_by(gold_norm)
    if pred_order != gold_order:
        return False
    
    # 6. WHERE conditions (simplified comparison)
    pred_conds = set(extract_conditions(pred_norm))
    gold_conds = set(extract_conditions(gold_norm))
    
    if not disable_value:
        # Compare with values
        if pred_conds != gold_conds:
            return False
    else:
        # Compare structure only (remove values)
        # This is a simplified approach
        if len(pred_conds) != len(gold_conds):
            return False
    
    # 7. DISTINCT check (if not disabled)
    if not disable_distinct:
        if has_distinct(pred_norm) != has_distinct(gold_norm):
            return False
    
    # 8. Subquery check
    if has_subquery(pred_norm) != has_subquery(gold_norm):
        return False
    
    return True


def compute_exact_match_batch(
    predictions: List[str],
    golds: List[str],
    db_ids: Optional[List[str]] = None,
    schemas: Optional[Dict[str, Dict]] = None,
    disable_value: bool = True,
    disable_distinct: bool = True,
    verbose: bool = False
) -> float:
    """
    Compute exact match accuracy over a batch of predictions.
    
    Args:
        predictions: List of predicted SQL queries.
        golds: List of gold SQL queries.
        db_ids: Optional list of database identifiers.
        schemas: Optional dict mapping db_id to schema.
        disable_value: Ignore literal values in comparison.
        disable_distinct: Ignore DISTINCT differences.
        verbose: Print progress information.
        
    Returns:
        Exact match accuracy as float between 0.0 and 1.0.
    """
    if len(predictions) != len(golds):
        raise ValueError(
            f"Length mismatch: predictions={len(predictions)}, golds={len(golds)}"
        )
    
    if len(predictions) == 0:
        return 0.0
    
    matches = 0
    total = len(predictions)
    
    for idx, (pred, gold) in enumerate(zip(predictions, golds)):
        db_id = db_ids[idx] if db_ids else None
        schema = schemas.get(db_id) if schemas and db_id else None
        
        if compute_exact_match(
            pred, gold, db_id, schema, 
            disable_value=disable_value,
            disable_distinct=disable_distinct
        ):
            matches += 1
        
        if verbose and (idx + 1) % 100 == 0:
            current_acc = matches / (idx + 1)
            print(f"  Progress: {idx + 1}/{total} | Current EM: {current_acc:.2%}")
    
    return matches / total
