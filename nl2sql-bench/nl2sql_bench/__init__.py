"""
NL2SQL-Bench: A standardized evaluation framework for NL2SQL systems.

This package provides tools for evaluating Natural Language to SQL systems
using standard benchmarks like Spider dataset.
"""

from nl2sql_bench.core.base import NL2SQLInput, NL2SQLOutput, NL2SQLSystem
from nl2sql_bench.core.evaluator import Evaluator, EvaluationResult
from nl2sql_bench.datasets.spider import SpiderDataset

__version__ = "0.1.0"
__all__ = [
    "NL2SQLInput",
    "NL2SQLOutput", 
    "NL2SQLSystem",
    "Evaluator",
    "EvaluationResult",
    "SpiderDataset",
]
