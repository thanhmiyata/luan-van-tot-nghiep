"""
Main evaluator for Multi-Agent SQL benchmarking
"""

import time
from typing import Dict, List, Optional, Any
from pathlib import Path
from datetime import datetime
from loguru import logger

from ..core.models import NLQuestion, DatabaseSchema, SQLResult
from .test_suite_integration import TestSuiteIntegration
from .result_parser import ResultParser


class Evaluator:
    """
    Main evaluator for benchmarking Multi-Agent SQL models
    """

    def __init__(
        self,
        test_suite_dir: Optional[Path] = None,
        output_dir: Optional[Path] = None
    ):
        """
        Initialize evaluator

        Args:
            test_suite_dir: Path to test-suite-sql-eval directory
            output_dir: Output directory for results
        """
        self.test_suite = TestSuiteIntegration(test_suite_dir)

        if output_dir is None:
            output_dir = Path(__file__).parent.parent.parent / "output"
        self.output_dir = output_dir
        self.output_dir.mkdir(parents=True, exist_ok=True)

        logger.info("Evaluator initialized")

    def benchmark_model(
        self,
        model,
        model_name: str,
        questions: List[NLQuestion],
        schema: DatabaseSchema,
        gold_queries: Optional[List[str]] = None,
        run_evaluation: bool = True
    ) -> Dict[str, Any]:
        """
        Run benchmark for a single model

        Args:
            model: Model instance to benchmark
            model_name: Name of the model
            questions: List of test questions
            schema: Database schema
            gold_queries: Optional list of gold SQL queries for evaluation
            run_evaluation: Whether to run test-suite-sql-eval

        Returns:
            Benchmark results dictionary
        """
        logger.info(f"Starting benchmark for {model_name}")
        logger.info(f"Questions: {len(questions)}")

        results = []
        start_time = time.time()

        # Process each question
        for i, question in enumerate(questions, 1):
            logger.info(
                f"[{i}/{len(questions)}] Processing: {question.question[:50]}...")

            try:
                result = model.process(question, schema)

                # Convert to dict for storage
                result_dict = {
                    'question_id': question.question_id or str(i),
                    'original_question': question.question,
                    'db_id': question.db_id,
                    'final_sql': result.final_sql,
                    'explanation': result.explanation,
                    'execution_time': result.execution_time,
                    'api_calls': result.api_calls,
                    'error': result.error,
                    'intermediate_results': result.intermediate_results
                }

                results.append(result_dict)

                if result.final_sql and not result.error:
                    logger.info(f"  ✓ Success ({result.execution_time:.2f}s)")
                else:
                    logger.warning(
                        f"  ✗ Failed: {result.error or 'No SQL generated'}")

            except Exception as e:
                logger.error(f"  ✗ Error: {e}")
                results.append({
                    'question_id': question.question_id or str(i),
                    'original_question': question.question,
                    'db_id': question.db_id,
                    'final_sql': None,
                    'error': str(e),
                    'execution_time': 0,
                    'api_calls': 0
                })

        total_time = time.time() - start_time

        logger.info(f"Benchmark completed in {total_time:.2f}s")

        # Parse basic results
        parsed_results = ResultParser.parse_benchmark_results(
            results,
            model_name
        )

        # Run evaluation with test-suite-sql-eval if requested
        if run_evaluation and gold_queries:
            logger.info("Running test-suite-sql-eval evaluation...")

            try:
                eval_results = self._run_test_suite_eval(
                    model_name,
                    results,
                    gold_queries
                )

                if eval_results.get('success'):
                    parsed_results['evaluation'] = eval_results
                    logger.info(
                        f"Evaluation complete - "
                        f"Execution: {eval_results.get('execution_accuracy', 0):.1%}, "
                        f"Exact Match: {eval_results.get('exact_match_accuracy', 0):.1%}"
                    )
                else:
                    logger.warning(
                        f"Evaluation failed: {eval_results.get('error')}")

            except Exception as e:
                logger.error(f"Evaluation error: {e}")

        # Save results
        self._save_benchmark_results(model_name, parsed_results, results)

        return parsed_results

    def benchmark_multiple_models(
        self,
        models: Dict[str, Any],
        questions: List[NLQuestion],
        schema: DatabaseSchema,
        gold_queries: Optional[List[str]] = None,
        runs: int = 1
    ) -> Dict[str, Any]:
        """
        Run benchmark for multiple models

        Args:
            models: Dictionary mapping model names to model instances
            questions: List of test questions
            schema: Database schema
            gold_queries: Optional list of gold SQL queries
            runs: Number of runs for averaging

        Returns:
            Combined results for all models
        """
        logger.info(
            f"Starting multi-model benchmark ({len(models)} models, {runs} runs)")

        all_results = {}

        for run in range(1, runs + 1):
            if runs > 1:
                logger.info(f"\n{'='*60}")
                logger.info(f"Run {run}/{runs}")
                logger.info(f"{'='*60}")

            for model_name, model in models.items():
                logger.info(f"\nBenchmarking: {model_name}")

                try:
                    results = self.benchmark_model(
                        model=model,
                        model_name=model_name,
                        questions=questions,
                        schema=schema,
                        gold_queries=gold_queries,
                        # Only evaluate on last run
                        run_evaluation=(run == runs)
                    )

                    # Store or average results
                    if model_name not in all_results:
                        all_results[model_name] = results
                    elif runs > 1:
                        # Average with previous runs
                        all_results[model_name] = self._average_results(
                            all_results[model_name],
                            results,
                            run
                        )

                except Exception as e:
                    logger.error(f"Model {model_name} failed: {e}")
                    all_results[model_name] = {
                        'model_name': model_name,
                        'error': str(e)
                    }

        # Compare models
        logger.info("\nGenerating comparison...")
        comparison = ResultParser.compare_models(all_results)

        # Save comparison
        comparison_file = self.output_dir / \
            f"comparison_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        ResultParser.save_results(comparison, comparison_file)

        return {
            'individual_results': all_results,
            'comparison': comparison
        }

    def _run_test_suite_eval(
        self,
        model_name: str,
        results: List[Dict],
        gold_queries: List[str]
    ) -> Dict[str, Any]:
        """
        Run test-suite-sql-eval evaluation

        Args:
            model_name: Name of the model
            results: List of result dictionaries
            gold_queries: List of gold SQL queries

        Returns:
            Evaluation results
        """
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')

        # Prepare files
        gold_file = self.output_dir / f"gold_{model_name}_{timestamp}.sql"
        pred_file = self.output_dir / f"predict_{model_name}_{timestamp}.sql"

        # Create gold file
        gold_file.parent.mkdir(parents=True, exist_ok=True)
        with open(gold_file, 'w', encoding='utf-8') as f:
            for query in gold_queries:
                if not query.endswith('\n'):
                    query += '\n'
                f.write(query)

        # Create prediction file
        self.test_suite.prepare_pred_file(results, pred_file)

        # Run evaluation
        eval_results = self.test_suite.run_evaluation(
            gold_file=gold_file,
            pred_file=pred_file
        )

        return eval_results

    def _save_benchmark_results(
        self,
        model_name: str,
        parsed_results: Dict,
        raw_results: List[Dict]
    ):
        """
        Save benchmark results to files

        Args:
            model_name: Name of the model
            parsed_results: Parsed results dictionary
            raw_results: Raw results list
        """
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        safe_model_name = model_name.replace(' ', '_')

        # Save parsed results (JSON)
        results_file = self.output_dir / \
            f"results_{safe_model_name}_{timestamp}.json"
        ResultParser.save_results(parsed_results, results_file)

        # Save SQL predictions
        pred_file = self.output_dir / \
            f"predict_{safe_model_name}_{timestamp}.sql"
        with open(pred_file, 'w', encoding='utf-8') as f:
            for result in raw_results:
                sql = result.get('final_sql', 'SELECT 1;')
                if not sql or sql.strip() == '':
                    sql = 'SELECT 1;'
                if not sql.endswith('\n'):
                    sql += '\n'
                f.write(sql)

        logger.info(f"Results saved: {results_file.name}")

    def _average_results(
        self,
        existing: Dict,
        new: Dict,
        run_number: int
    ) -> Dict:
        """
        Average results across multiple runs

        Args:
            existing: Existing averaged results
            new: New results to incorporate
            run_number: Current run number

        Returns:
            Updated averaged results
        """
        # Simple averaging for numeric fields
        for key in ['success_rate']:
            if key in existing and key in new:
                existing[key] = (
                    existing[key] * (run_number - 1) + new[key]
                ) / run_number

        # Average performance metrics
        if 'performance' in existing and 'performance' in new:
            for key in existing['performance']:
                if key in new['performance']:
                    existing['performance'][key] = (
                        existing['performance'][key] * (run_number - 1) +
                        new['performance'][key]
                    ) / run_number

        return existing
