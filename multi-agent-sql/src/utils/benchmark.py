"""
Benchmark utilities for Multi-Agent SQL system
"""

import time
import tempfile
from pathlib import Path
from typing import List, Dict, Any, Optional
from loguru import logger

from src.core.models import ModelType, NLQuestion, DatabaseSchema, PipelineResult
from src.models.model_3_step import Model3Step
from src.models.model_4_step import Model4Step
from src.models.model_6_step import Model6Step
from src.utils.data_loader import DataLoader
from src.utils.metrics import MetricsCalculator


class BenchmarkRunner:
    """Utility class for running model benchmarks"""

    def __init__(self, db_path: str = "experiments/test-suite-sql-eval/database",
                 tables_file: str = "experiments/test-suite-sql-eval/tables.json"):
        self.db_path = db_path
        self.tables_file = tables_file

        # Available models
        self.models = {
            ModelType.THREE_STEP: Model3Step,
            ModelType.FOUR_STEP: Model4Step,
            ModelType.SIX_STEP: Model6Step
        }

    def run_single_model_benchmark(
        self,
        model_type: ModelType,
        questions: List[NLQuestion],
        schema: DatabaseSchema,
        runs: int = 1
    ) -> Dict[str, Any]:
        """
        Run benchmark for a single model

        Args:
            model_type: Type of model to test
            questions: List of test questions
            schema: Database schema
            runs: Number of runs to average over

        Returns:
            Benchmark results dictionary
        """
        logger.info(
            f"Starting benchmark for {model_type.value} model ({runs} runs)")

        if model_type not in self.models:
            raise ValueError(f"Unknown model type: {model_type}")

        all_results = []
        all_times = []

        for run in range(runs):
            logger.info(f"Run {run + 1}/{runs} for {model_type.value}")

            # Initialize model
            model_class = self.models[model_type]
            model = model_class()

            # Reset metrics
            model.reset_metrics()

            # Run benchmark
            start_time = time.time()
            run_results = []

            for i, question in enumerate(questions):
                try:
                    logger.debug(
                        f"Processing question {i+1}/{len(questions)}: {question.question[:50]}...")
                    result = model.process(question, schema)
                    run_results.append(result)

                except Exception as e:
                    logger.error(f"Failed to process question {i+1}: {e}")
                    # Create error result
                    error_result = PipelineResult(
                        question_id=question.question_id or f"q_error_{i}",
                        db_id=question.db_id,
                        original_question=question.question,
                        final_sql="",
                        explanation="",
                        error=str(e),
                        execution_time=0.0,
                        api_calls=0,
                        model_type=model_type
                    )
                    run_results.append(error_result)

            run_time = time.time() - start_time
            all_results.extend(run_results)
            all_times.append(run_time)

            logger.info(f"Run {run + 1} completed in {run_time:.2f}s")

        # Calculate metrics
        basic_metrics = MetricsCalculator.calculate_basic_metrics(all_results)

        # Save results to temporary files for evaluation
        with tempfile.NamedTemporaryFile(mode='w', suffix='.sql', delete=False) as pred_file:
            DataLoader.save_results_to_sql_file(
                [r.__dict__ for r in all_results],
                pred_file.name
            )
            pred_file_path = pred_file.name

        # For now, skip test-suite-sql-eval integration (can be added later)
        evaluation_metrics = None

        # Estimate cost
        estimated_cost = MetricsCalculator.estimate_cost(all_results)

        # Create benchmark result
        benchmark_result = MetricsCalculator.create_benchmark_result(
            model_type=model_type,
            results=all_results,
            evaluation_metrics=evaluation_metrics,
            estimated_cost=estimated_cost
        )

        # Clean up temporary file
        Path(pred_file_path).unlink(missing_ok=True)

        logger.info(f"Benchmark completed for {model_type.value}: "
                    f"{benchmark_result.success_rate:.1%} success rate, "
                    f"{benchmark_result.avg_time_per_question:.2f}s avg time")

        return {
            'benchmark_result': benchmark_result,
            'basic_metrics': basic_metrics,
            'total_runs': runs,
            'avg_run_time': sum(all_times) / len(all_times)
        }

    def run_model_comparison(
        self,
        questions: List[NLQuestion],
        schema: DatabaseSchema,
        models: Optional[List[ModelType]] = None,
        runs: int = 1
    ) -> Dict[str, Any]:
        """
        Run comparison benchmark across multiple models

        Args:
            questions: List of test questions
            schema: Database schema
            models: List of model types to test (default: all)
            runs: Number of runs per model

        Returns:
            Comparison results dictionary
        """
        if models is None:
            models = [ModelType.THREE_STEP,
                      ModelType.FOUR_STEP, ModelType.SIX_STEP]

        logger.info(
            f"Starting model comparison with {len(models)} models, {len(questions)} questions, {runs} runs each")

        comparison_results = {}
        benchmark_results = {}

        for model_type in models:
            try:
                result = self.run_single_model_benchmark(
                    model_type=model_type,
                    questions=questions,
                    schema=schema,
                    runs=runs
                )

                comparison_results[model_type] = result
                benchmark_results[model_type] = result['benchmark_result']

            except Exception as e:
                logger.error(f"Failed to benchmark {model_type.value}: {e}")
                continue

        # Generate comparison analysis
        comparison_analysis = MetricsCalculator.compare_models(
            benchmark_results)

        final_results = {
            'comparison_analysis': comparison_analysis,
            'individual_results': comparison_results,
            'benchmark_results': benchmark_results,
            'test_info': {
                'total_questions': len(questions),
                'models_tested': [m.value for m in models],
                'runs_per_model': runs,
                'database_id': schema.db_id
            }
        }

        logger.info("Model comparison completed!")
        return final_results

    def generate_comparison_report(self, results: Dict[str, Any]) -> str:
        """
        Generate a human-readable comparison report

        Args:
            results: Results from run_model_comparison

        Returns:
            Formatted report string
        """
        analysis = results.get('comparison_analysis', {})
        test_info = results.get('test_info', {})

        report = []
        report.append("=" * 60)
        report.append("🧪 MULTI-AGENT SQL MODEL COMPARISON REPORT")
        report.append("=" * 60)
        report.append("")

        # Test info
        report.append(f"📋 Test Configuration:")
        report.append(f"   • Database: {test_info.get('database_id', 'N/A')}")
        report.append(f"   • Questions: {test_info.get('total_questions', 0)}")
        report.append(
            f"   • Models tested: {', '.join(test_info.get('models_tested', []))}")
        report.append(
            f"   • Runs per model: {test_info.get('runs_per_model', 1)}")
        report.append("")

        # Summary table
        if 'summary' in analysis:
            report.append("📊 PERFORMANCE SUMMARY:")
            report.append("-" * 60)
            report.append(
                "| Model    | Success | Exec Acc | Avg Time | Avg API | Est Cost |")
            report.append(
                "|----------|---------|----------|----------|---------|----------|")

            for model, metrics in analysis['summary'].items():
                report.append(
                    f"| {model:8} | {metrics.get('success_rate', 'N/A'):7} | "
                    f"{metrics.get('execution_accuracy', 'N/A'):8} | "
                    f"{metrics.get('avg_time', 'N/A'):8} | "
                    f"{metrics.get('avg_api_calls', 'N/A'):7} | "
                    f"{metrics.get('estimated_cost', 'N/A'):8} |"
                )
            report.append("")

        # Rankings
        if 'rankings' in analysis:
            rankings = analysis['rankings']
            report.append("🏆 MODEL RANKINGS:")
            report.append(
                f"   • Best Accuracy: {rankings.get('best_accuracy', 'N/A')}")
            report.append(f"   • Fastest: {rankings.get('fastest', 'N/A')}")
            report.append(
                f"   • Most Efficient: {rankings.get('most_efficient', 'N/A')}")
            report.append("")

        # Recommendations
        report.append("💡 RECOMMENDATIONS:")
        report.append(
            "   • For prototyping: 3-step model (fastest, lowest cost)")
        report.append(
            "   • For production: 4-step model (balanced performance)")
        report.append(
            "   • For high-precision: 6-step model (highest accuracy)")
        report.append("")

        report.append("=" * 60)
        return "\n".join(report)


# Convenience functions
def run_model_comparison(
    questions: List[NLQuestion],
    schema: DatabaseSchema,
    models: Optional[List[ModelType]] = None,
    runs: int = 1
) -> Dict[str, Any]:
    """Convenience function to run model comparison"""
    runner = BenchmarkRunner()
    return runner.run_model_comparison(questions, schema, models, runs)
