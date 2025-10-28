"""
Evaluation module for Multi-Agent SQL system
Handles benchmark evaluation, test-suite integration, and result parsing
"""

from .evaluator import Evaluator
from .test_suite_integration import TestSuiteIntegration
from .result_parser import ResultParser

__all__ = [
    'Evaluator',
    'TestSuiteIntegration',
    'ResultParser'
]
