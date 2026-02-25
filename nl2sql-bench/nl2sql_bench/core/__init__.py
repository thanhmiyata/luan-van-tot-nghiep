"""Core components for NL2SQL-Bench."""

from nl2sql_bench.core.base import NL2SQLInput, NL2SQLOutput, NL2SQLSystem
from nl2sql_bench.core.evaluator import Evaluator, EvaluationResult

__all__ = [
    "NL2SQLInput",
    "NL2SQLOutput",
    "NL2SQLSystem",
    "Evaluator",
    "EvaluationResult",
]
