"""
Metrics calculation utilities for Multi-Agent SQL system
"""

import time
import subprocess
import sys
from typing import List, Dict, Any, Optional, Tuple
from pathlib import Path
from loguru import logger

from src.core.models import PipelineResult, ModelBenchmarkResult, QuestionMetrics, ModelType


class MetricsCalculator:
    """Utility class for calculating performance metrics"""

    @staticmethod
    def calculate_basic_metrics(results: List[PipelineResult]) -> Dict[str, Any]:
        """
        Calculate basic performance metrics from pipeline results

        Args:
            results: List of pipeline results

        Returns:
            Dictionary containing basic metrics
        """
        if not results:
            return {}

        total_questions = len(results)
        successful_results = [
            r for r in results if r.final_sql and not r.error]
        failed_results = [r for r in results if not r.final_sql or r.error]

        total_time = sum(r.execution_time for r in results)
        total_api_calls = sum(r.api_calls for r in results)

        metrics = {
            'total_questions': total_questions,
            'successful_questions': len(successful_results),
            'failed_questions': len(failed_results),
            'success_rate': len(successful_results) / total_questions if total_questions > 0 else 0.0,
            'total_time': total_time,
            'avg_time_per_question': total_time / total_questions if total_questions > 0 else 0.0,
            'total_api_calls': total_api_calls,
            'avg_api_calls_per_question': total_api_calls / total_questions if total_questions > 0 else 0.0,
            'min_time': min(r.execution_time for r in results) if results else 0.0,
            'max_time': max(r.execution_time for r in results) if results else 0.0,
            'model_type': results[0].model_type if results else None
        }

        return metrics

    @staticmethod
    def calculate_question_metrics(results: List[PipelineResult]) -> List[QuestionMetrics]:
        """
        Calculate per-question metrics

        Args:
            results: List of pipeline results

        Returns:
            List of QuestionMetrics
        """
        question_metrics = []

        for result in results:
            metrics = QuestionMetrics(
                question_id=result.question_id,
                execution_time=result.execution_time,
                api_calls=result.api_calls,
                success=bool(result.final_sql and not result.error),
                sql_generated=bool(result.final_sql),
                error=result.error
            )
            question_metrics.append(metrics)

        return question_metrics

    @staticmethod
    def run_test_suite_evaluation(gold_file: str, pred_file: str, db_path: str, tables_file: str) -> Dict[str, float]:
        """
        Run test-suite-sql-eval to get accuracy metrics

        Args:
            gold_file: Path to gold SQL file
            pred_file: Path to predicted SQL file  
            db_path: Path to database directory
            tables_file: Path to tables.json file

        Returns:
            Dictionary containing accuracy metrics
        """
        try:
            # Construct command for test-suite-sql-eval
            eval_script = Path("experiments/test-suite-sql-eval/evaluation.py")

            cmd = [
                sys.executable, str(eval_script),
                '--gold', gold_file,
                '--pred', pred_file,
                '--db', db_path,
                '--etype', 'all',
                '--table', tables_file,
                '--plug_value'
            ]

            logger.info(f"Running evaluation: {' '.join(cmd)}")

            # Run the evaluation
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=300  # 5 minute timeout
            )

            if result.returncode != 0:
                logger.error(f"Evaluation failed: {result.stderr}")
                return {'execution_accuracy': 0.0, 'exact_match_accuracy': 0.0}

            # Parse the output to extract metrics
            output = result.stdout
            metrics = MetricsCalculator._parse_evaluation_output(output)

            logger.info(f"Evaluation completed: {metrics}")
            return metrics

        except subprocess.TimeoutExpired:
            logger.error("Evaluation timed out")
            return {'execution_accuracy': 0.0, 'exact_match_accuracy': 0.0}
        except Exception as e:
            logger.error(f"Failed to run evaluation: {e}")
            return {'execution_accuracy': 0.0, 'exact_match_accuracy': 0.0}

    @staticmethod
    def _parse_evaluation_output(output: str) -> Dict[str, float]:
        """
        Parse test-suite-sql-eval output to extract metrics

        Args:
            output: Raw output from evaluation script

        Returns:
            Dictionary containing parsed metrics
        """
        metrics = {
            'execution_accuracy': 0.0,
            'exact_match_accuracy': 0.0
        }

        try:
            lines = output.strip().split('\n')

            for line in lines:
                line = line.strip()

                # Look for execution accuracy
                if 'execution accuracy' in line.lower():
                    # Extract percentage value
                    parts = line.split()
                    for part in parts:
                        if '%' in part:
                            metrics['execution_accuracy'] = float(
                                part.replace('%', '')) / 100.0
                            break

                # Look for exact match accuracy
                elif 'exact match' in line.lower() or 'exact-match' in line.lower():
                    parts = line.split()
                    for part in parts:
                        if '%' in part:
                            metrics['exact_match_accuracy'] = float(
                                part.replace('%', '')) / 100.0
                            break

        except Exception as e:
            logger.error(f"Failed to parse evaluation output: {e}")

        return metrics

    @staticmethod
    def create_benchmark_result(
        model_type: ModelType,
        results: List[PipelineResult],
        evaluation_metrics: Optional[Dict[str, float]] = None,
        estimated_cost: Optional[float] = None
    ) -> ModelBenchmarkResult:
        """
        Create a comprehensive benchmark result

        Args:
            model_type: Type of model tested
            results: List of pipeline results
            evaluation_metrics: Optional accuracy metrics from test-suite-sql-eval
            estimated_cost: Optional cost estimation

        Returns:
            ModelBenchmarkResult object
        """
        basic_metrics = MetricsCalculator.calculate_basic_metrics(results)
        question_metrics = MetricsCalculator.calculate_question_metrics(
            results)

        benchmark_result = ModelBenchmarkResult(
            model_type=model_type,
            total_questions=basic_metrics.get('total_questions', 0),
            successful_questions=basic_metrics.get('successful_questions', 0),
            failed_questions=basic_metrics.get('failed_questions', 0),
            success_rate=basic_metrics.get('success_rate', 0.0),
            total_time=basic_metrics.get('total_time', 0.0),
            avg_time_per_question=basic_metrics.get(
                'avg_time_per_question', 0.0),
            total_api_calls=basic_metrics.get('total_api_calls', 0),
            avg_api_calls_per_question=basic_metrics.get(
                'avg_api_calls_per_question', 0.0),
            execution_accuracy=evaluation_metrics.get(
                'execution_accuracy') if evaluation_metrics else None,
            exact_match_accuracy=evaluation_metrics.get(
                'exact_match_accuracy') if evaluation_metrics else None,
            estimated_cost=estimated_cost,
            question_metrics=question_metrics
        )

        return benchmark_result

    @staticmethod
    def estimate_cost(results: List[PipelineResult], cost_per_1k_tokens: float = 0.002) -> float:
        """
        Estimate cost based on API calls (rough approximation)

        Args:
            results: List of pipeline results
            cost_per_1k_tokens: Cost per 1000 tokens (default for Gemini)

        Returns:
            Estimated cost in USD
        """
        # Rough estimation: assume each API call uses ~500 tokens on average
        total_api_calls = sum(r.api_calls for r in results)
        estimated_tokens = total_api_calls * 500
        estimated_cost = (estimated_tokens / 1000) * cost_per_1k_tokens

        return estimated_cost

    @staticmethod
    def compare_models(results: Dict[ModelType, ModelBenchmarkResult]) -> Dict[str, Any]:
        """
        Compare multiple model benchmark results

        Args:
            results: Dictionary mapping model types to their benchmark results

        Returns:
            Comparison analysis
        """
        if not results:
            return {}

        comparison = {
            'model_count': len(results),
            'models_tested': list(results.keys()),
            'summary': {},
            'rankings': {},
            'trade_offs': {}
        }

        # Find best performing models
        best_accuracy = max(
            results.values(), key=lambda x: x.execution_accuracy or 0)
        fastest = min(results.values(), key=lambda x: x.avg_time_per_question)
        most_efficient = min(
            results.values(), key=lambda x: x.avg_api_calls_per_question)

        comparison['rankings'] = {
            'best_accuracy': best_accuracy.model_type,
            'fastest': fastest.model_type,
            'most_efficient': most_efficient.model_type
        }

        # Create summary table
        for model_type, result in results.items():
            comparison['summary'][model_type.value] = {
                'success_rate': f"{result.success_rate:.1%}",
                'execution_accuracy': f"{result.execution_accuracy:.1%}" if result.execution_accuracy else "N/A",
                'avg_time': f"{result.avg_time_per_question:.2f}s",
                'avg_api_calls': f"{result.avg_api_calls_per_question:.1f}",
                'estimated_cost': f"${result.estimated_cost:.3f}" if result.estimated_cost else "N/A"
            }

        return comparison


# Convenience functions
def calculate_accuracy_metrics(gold_file: str, pred_file: str, db_path: str, tables_file: str) -> Dict[str, float]:
    """Convenience function to calculate accuracy metrics"""
    return MetricsCalculator.run_test_suite_evaluation(gold_file, pred_file, db_path, tables_file)
