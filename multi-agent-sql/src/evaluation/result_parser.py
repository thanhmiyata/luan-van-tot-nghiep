"""
Result parsing utilities for benchmark results
"""

from typing import Dict, List, Any, Optional
from pathlib import Path
import json
from datetime import datetime
from loguru import logger


class ResultParser:
    """
    Parse and format benchmark results
    """

    @staticmethod
    def parse_benchmark_results(
        results: List[Dict],
        model_name: str,
        evaluation_metrics: Optional[Dict] = None
    ) -> Dict[str, Any]:
        """
        Parse raw benchmark results into structured format

        Args:
            results: List of result dictionaries from model.process()
            model_name: Name of the model
            evaluation_metrics: Optional metrics from test-suite-sql-eval

        Returns:
            Structured benchmark results dictionary
        """
        if not results:
            return {
                'model_name': model_name,
                'error': 'No results to parse'
            }

        # Calculate basic metrics
        total_questions = len(results)
        successful_queries = len(
            [r for r in results if r.get('final_sql') and not r.get('error')])
        failed_queries = total_questions - successful_queries

        total_time = sum(r.get('execution_time', 0) for r in results)
        total_api_calls = sum(r.get('api_calls', 0) for r in results)

        avg_time = total_time / total_questions if total_questions > 0 else 0
        avg_api_calls = total_api_calls / total_questions if total_questions > 0 else 0

        # Build result structure
        parsed = {
            'model_name': model_name,
            'timestamp': datetime.now().isoformat(),
            'total_questions': total_questions,
            'successful_queries': successful_queries,
            'failed_queries': failed_queries,
            'success_rate': successful_queries / total_questions if total_questions > 0 else 0,
            'performance': {
                'total_time': total_time,
                'avg_time_per_question': avg_time,
                'total_api_calls': total_api_calls,
                'avg_api_calls': avg_api_calls
            }
        }

        # Add evaluation metrics if available
        if evaluation_metrics:
            parsed['evaluation'] = {
                'execution_accuracy': evaluation_metrics.get('execution_accuracy', 0),
                'exact_match_accuracy': evaluation_metrics.get('exact_match_accuracy', 0),
                'successful_executions': evaluation_metrics.get('successful_executions', 0),
                'exact_matches': evaluation_metrics.get('exact_matches', 0)
            }

        # Add detailed results
        parsed['detailed_results'] = [
            {
                'question_id': r.get('question_id', i),
                # Truncate for storage
                'question': r.get('original_question', '')[:100],
                'sql': r.get('final_sql', ''),
                'success': bool(r.get('final_sql') and not r.get('error')),
                'execution_time': r.get('execution_time', 0),
                'api_calls': r.get('api_calls', 0),
                'error': r.get('error', None)
            }
            for i, r in enumerate(results)
        ]

        return parsed

    @staticmethod
    def compare_models(
        model_results: Dict[str, Dict]
    ) -> Dict[str, Any]:
        """
        Compare results from multiple models

        Args:
            model_results: Dictionary mapping model names to their results

        Returns:
            Comparison data structure
        """
        if not model_results:
            return {'error': 'No results to compare'}

        comparison = {
            'timestamp': datetime.now().isoformat(),
            'models': list(model_results.keys()),
            'summary': {},
            'rankings': {}
        }

        # Extract metrics for each model
        for model_name, results in model_results.items():
            comparison['summary'][model_name] = {
                'success_rate': results.get('success_rate', 0),
                'avg_time': results.get('performance', {}).get('avg_time_per_question', 0),
                'avg_api_calls': results.get('performance', {}).get('avg_api_calls', 0),
                'execution_accuracy': results.get('evaluation', {}).get('execution_accuracy', 0),
                'exact_match_accuracy': results.get('evaluation', {}).get('exact_match_accuracy', 0)
            }

        # Rank models by different metrics
        comparison['rankings'] = {
            'by_accuracy': ResultParser._rank_by_metric(
                comparison['summary'], 'exact_match_accuracy', reverse=True
            ),
            'by_speed': ResultParser._rank_by_metric(
                comparison['summary'], 'avg_time', reverse=False
            ),
            'by_efficiency': ResultParser._rank_by_metric(
                comparison['summary'], 'avg_api_calls', reverse=False
            )
        }

        # Calculate improvement/trade-offs
        if len(model_results) > 1:
            comparison['trade_offs'] = ResultParser._calculate_trade_offs(
                comparison['summary']
            )

        return comparison

    @staticmethod
    def _rank_by_metric(
        summary: Dict[str, Dict],
        metric: str,
        reverse: bool = True
    ) -> List[Dict]:
        """
        Rank models by a specific metric

        Args:
            summary: Summary dictionary
            metric: Metric to rank by
            reverse: If True, higher is better

        Returns:
            Ranked list of models
        """
        ranked = sorted(
            summary.items(),
            key=lambda x: x[1].get(metric, 0),
            reverse=reverse
        )

        return [
            {
                'rank': i + 1,
                'model': model,
                'value': data.get(metric, 0)
            }
            for i, (model, data) in enumerate(ranked)
        ]

    @staticmethod
    def _calculate_trade_offs(summary: Dict[str, Dict]) -> Dict[str, Any]:
        """
        Calculate trade-offs between models

        Args:
            summary: Summary dictionary

        Returns:
            Trade-off analysis
        """
        trade_offs = {}

        # Find baseline (typically the fastest/cheapest model)
        baseline_model = min(
            summary.items(),
            key=lambda x: x[1].get('avg_api_calls', float('inf'))
        )[0]

        baseline = summary[baseline_model]

        # Calculate relative improvements for each model
        for model_name, data in summary.items():
            if model_name == baseline_model:
                continue

            accuracy_improvement = (
                data.get('exact_match_accuracy', 0) -
                baseline.get('exact_match_accuracy', 0)
            ) * 100

            time_increase = (
                (data.get('avg_time', 0) / baseline.get('avg_time', 1) - 1) * 100
                if baseline.get('avg_time', 0) > 0 else 0
            )

            cost_increase = (
                (data.get('avg_api_calls', 0) /
                 baseline.get('avg_api_calls', 1) - 1) * 100
                if baseline.get('avg_api_calls', 0) > 0 else 0
            )

            trade_offs[model_name] = {
                'vs_baseline': baseline_model,
                'accuracy_improvement': f"{accuracy_improvement:+.1f}%",
                'time_increase': f"{time_increase:+.1f}%",
                'cost_increase': f"{cost_increase:+.1f}%",
                'roi': (
                    accuracy_improvement / cost_increase
                    if cost_increase > 0 else 0
                )
            }

        return trade_offs

    @staticmethod
    def save_results(
        results: Dict,
        output_file: Path
    ):
        """
        Save results to JSON file

        Args:
            results: Results dictionary
            output_file: Output file path
        """
        output_file.parent.mkdir(parents=True, exist_ok=True)

        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)

        logger.info(f"Results saved to: {output_file}")

    @staticmethod
    def load_results(input_file: Path) -> Dict:
        """
        Load results from JSON file

        Args:
            input_file: Input file path

        Returns:
            Results dictionary
        """
        with open(input_file, 'r', encoding='utf-8') as f:
            results = json.load(f)

        logger.info(f"Results loaded from: {input_file}")
        return results
