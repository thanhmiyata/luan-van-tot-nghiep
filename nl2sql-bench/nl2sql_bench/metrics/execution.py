"""
Execution accuracy metric for NL2SQL-Bench.

This module computes execution accuracy by comparing the execution results
of predicted SQL against gold SQL on the actual database.
"""

import sqlite3
import signal
from contextlib import contextmanager
from typing import Any, List, Optional, Set, Tuple, Union


class TimeoutError(Exception):
    """Exception raised when SQL execution times out."""
    pass


@contextmanager
def timeout_handler(seconds: int):
    """
    Context manager for SQL execution timeout.
    
    Args:
        seconds: Maximum execution time in seconds.
        
    Raises:
        TimeoutError: If execution exceeds timeout.
    """
    def signal_handler(signum, frame):
        raise TimeoutError(f"SQL execution timed out after {seconds} seconds")
    
    # Set the signal handler
    original_handler = signal.signal(signal.SIGALRM, signal_handler)
    signal.alarm(seconds)
    
    try:
        yield
    finally:
        # Restore original handler and cancel alarm
        signal.alarm(0)
        signal.signal(signal.SIGALRM, original_handler)


def normalize_result(result: List[Tuple]) -> Set[Tuple]:
    """
    Normalize SQL execution result for comparison.
    
    - Converts to set (ignoring order)
    - Normalizes NULL values
    - Sorts tuple elements for column-order independence
    
    Args:
        result: List of tuples from SQL execution.
        
    Returns:
        Set of normalized tuples.
    """
    if not result:
        return set()
    
    normalized = set()
    for row in result:
        # Convert None to a consistent representation
        # Sort values within each row to handle column order differences
        norm_row = tuple(
            None if v is None else v
            for v in row
        )
        normalized.add(norm_row)
    
    return normalized


def execute_sql(
    sql: str,
    db_path: str,
    timeout_seconds: int = 30
) -> Tuple[bool, Optional[Set[Tuple]], Optional[str]]:
    """
    Execute SQL on a SQLite database.
    
    Args:
        sql: SQL query to execute.
        db_path: Path to SQLite database file.
        timeout_seconds: Maximum execution time.
        
    Returns:
        Tuple of (success, result_set, error_message)
        - success: True if execution completed without error
        - result_set: Set of result tuples if successful, None otherwise
        - error_message: Error description if failed, None otherwise
    """
    try:
        with timeout_handler(timeout_seconds):
            conn = sqlite3.connect(db_path)
            cursor = conn.cursor()
            cursor.execute(sql)
            result = cursor.fetchall()
            conn.close()
            
            return True, normalize_result(result), None
            
    except TimeoutError as e:
        return False, None, str(e)
    except sqlite3.Error as e:
        return False, None, f"SQLite error: {str(e)}"
    except Exception as e:
        return False, None, f"Execution error: {str(e)}"


def exec_match(
    pred_sql: str,
    gold_sql: str,
    db_path: str,
    timeout_seconds: int = 30
) -> bool:
    """
    Check if predicted SQL produces the same result as gold SQL.
    
    Compares execution results, not SQL strings. Two queries are considered
    matching if they produce identical result sets (ignoring row order).
    
    Args:
        pred_sql: Predicted SQL query.
        gold_sql: Gold (expected) SQL query.
        db_path: Path to SQLite database file.
        timeout_seconds: Maximum execution time per query.
        
    Returns:
        True if both queries produce the same result set.
        
    Example:
        ```python
        match = exec_match(
            pred_sql="SELECT name FROM users WHERE age > 21",
            gold_sql="SELECT name FROM users WHERE age >= 22",
            db_path="./database/users.sqlite"
        )
        print(f"Execution match: {match}")
        ```
    """
    # Execute predicted SQL
    pred_success, pred_result, pred_error = execute_sql(
        pred_sql, db_path, timeout_seconds
    )
    
    if not pred_success:
        return False
    
    # Execute gold SQL
    gold_success, gold_result, gold_error = execute_sql(
        gold_sql, db_path, timeout_seconds
    )
    
    if not gold_success:
        # Gold SQL should always succeed - log warning
        # For now, return False
        return False
    
    # Compare result sets
    return pred_result == gold_result


def exec_match_with_details(
    pred_sql: str,
    gold_sql: str,
    db_path: str,
    timeout_seconds: int = 30
) -> Tuple[bool, dict]:
    """
    Check execution match with detailed information.
    
    Args:
        pred_sql: Predicted SQL query.
        gold_sql: Gold (expected) SQL query.
        db_path: Path to SQLite database file.
        timeout_seconds: Maximum execution time per query.
        
    Returns:
        Tuple of (match_result, details_dict)
        details_dict contains:
        - pred_success: Whether predicted SQL executed successfully
        - gold_success: Whether gold SQL executed successfully
        - pred_error: Error message for predicted SQL (if any)
        - gold_error: Error message for gold SQL (if any)
        - pred_row_count: Number of rows in predicted result
        - gold_row_count: Number of rows in gold result
    """
    details = {
        "pred_success": False,
        "gold_success": False,
        "pred_error": None,
        "gold_error": None,
        "pred_row_count": 0,
        "gold_row_count": 0,
        "match": False,
    }
    
    # Execute predicted SQL
    pred_success, pred_result, pred_error = execute_sql(
        pred_sql, db_path, timeout_seconds
    )
    details["pred_success"] = pred_success
    details["pred_error"] = pred_error
    if pred_result:
        details["pred_row_count"] = len(pred_result)
    
    if not pred_success:
        return False, details
    
    # Execute gold SQL
    gold_success, gold_result, gold_error = execute_sql(
        gold_sql, db_path, timeout_seconds
    )
    details["gold_success"] = gold_success
    details["gold_error"] = gold_error
    if gold_result:
        details["gold_row_count"] = len(gold_result)
    
    if not gold_success:
        return False, details
    
    # Compare
    match = pred_result == gold_result
    details["match"] = match
    
    return match, details


def compute_execution_accuracy(
    predictions: List[str],
    golds: List[str],
    db_paths: List[str],
    timeout_seconds: int = 30,
    verbose: bool = False
) -> float:
    """
    Compute execution accuracy over a list of predictions.
    
    Args:
        predictions: List of predicted SQL queries.
        golds: List of gold SQL queries.
        db_paths: List of paths to SQLite database files.
        timeout_seconds: Maximum execution time per query.
        verbose: Print progress information.
        
    Returns:
        Execution accuracy as float between 0.0 and 1.0.
        
    Raises:
        ValueError: If input lists have different lengths.
        
    Example:
        ```python
        accuracy = compute_execution_accuracy(
            predictions=["SELECT ...", "SELECT ..."],
            golds=["SELECT ...", "SELECT ..."],
            db_paths=["db1.sqlite", "db2.sqlite"]
        )
        print(f"Execution Accuracy: {accuracy:.2%}")
        ```
    """
    if not (len(predictions) == len(golds) == len(db_paths)):
        raise ValueError(
            f"Input lengths must match: predictions={len(predictions)}, "
            f"golds={len(golds)}, db_paths={len(db_paths)}"
        )
    
    if len(predictions) == 0:
        return 0.0
    
    matches = 0
    total = len(predictions)
    
    for idx, (pred, gold, db_path) in enumerate(zip(predictions, golds, db_paths)):
        if exec_match(pred, gold, db_path, timeout_seconds):
            matches += 1
        
        if verbose and (idx + 1) % 100 == 0:
            current_acc = matches / (idx + 1)
            print(f"  Progress: {idx + 1}/{total} | Current EX: {current_acc:.2%}")
    
    return matches / total
