"""Error analysis tools for NL2SQL-Bench."""

from nl2sql_bench.analysis.error_taxonomy import ErrorCategory, classify_error, analyze_errors
from nl2sql_bench.analysis.reporter import generate_json_report, generate_cli_summary

__all__ = [
    "ErrorCategory",
    "classify_error",
    "analyze_errors",
    "generate_json_report",
    "generate_cli_summary",
]
