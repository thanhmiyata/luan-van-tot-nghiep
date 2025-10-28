"""
Integration with test-suite-sql-eval for SQL evaluation
"""

import sys
import subprocess
from pathlib import Path
from typing import Dict, Optional, List
from loguru import logger


class TestSuiteIntegration:
    """
    Integration with test-suite-sql-eval tool for SQL accuracy evaluation
    """

    def __init__(self, test_suite_dir: Optional[Path] = None):
        """
        Initialize test suite integration

        Args:
            test_suite_dir: Path to test-suite-sql-eval directory
        """
        if test_suite_dir is None:
            # Try to find test-suite-sql-eval in parent directory
            current_dir = Path(__file__).parent.parent.parent
            test_suite_dir = current_dir.parent / "experiments" / "test-suite-sql-eval"

            if not test_suite_dir.exists():
                # Try alternative location
                test_suite_dir = current_dir / "test-suite-sql-eval"

        self.test_suite_dir = test_suite_dir
        self.evaluation_script = test_suite_dir / "evaluation.py"
        self.database_dir = test_suite_dir / "database"
        self.tables_file = test_suite_dir / "tables.json"

        # Validate paths
        self._validate_paths()

    def _validate_paths(self):
        """Validate that required test suite files exist"""
        if not self.test_suite_dir.exists():
            logger.warning(
                f"Test suite directory not found: {self.test_suite_dir}")

        if not self.evaluation_script.exists():
            logger.warning(
                f"Evaluation script not found: {self.evaluation_script}")

        if not self.database_dir.exists():
            logger.warning(
                f"Database directory not found: {self.database_dir}")

        if not self.tables_file.exists():
            logger.warning(f"Tables file not found: {self.tables_file}")

    def run_evaluation(
        self,
        gold_file: Path,
        pred_file: Path,
        etype: str = "all",
        plug_value: bool = True,
        timeout: int = 300
    ) -> Dict[str, any]:
        """
        Run test-suite-sql-eval evaluation

        Args:
            gold_file: Path to gold SQL file
            pred_file: Path to predicted SQL file
            etype: Evaluation type ('all', 'exec', 'match')
            plug_value: Whether to use value plugging
            timeout: Execution timeout in seconds

        Returns:
            Dictionary with evaluation results
        """
        logger.info(f"Running evaluation: {pred_file.name}")

        # Build command
        cmd = [
            sys.executable,
            str(self.evaluation_script),
            '--gold', str(gold_file),
            '--pred', str(pred_file),
            '--db', str(self.database_dir),
            '--etype', etype,
            '--table', str(self.tables_file)
        ]

        if plug_value:
            cmd.append('--plug_value')

        try:
            # Run evaluation
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=timeout,
                cwd=self.test_suite_dir
            )

            if result.returncode != 0:
                logger.error(f"Evaluation failed: {result.stderr}")
                return {
                    'success': False,
                    'error': result.stderr,
                    'stdout': result.stdout
                }

            # Parse output
            parsed_results = self._parse_output(result.stdout)
            parsed_results['success'] = True
            parsed_results['raw_output'] = result.stdout

            return parsed_results

        except subprocess.TimeoutExpired:
            logger.error(f"Evaluation timeout after {timeout}s")
            return {
                'success': False,
                'error': f'Timeout after {timeout}s'
            }

        except Exception as e:
            logger.error(f"Evaluation error: {e}")
            return {
                'success': False,
                'error': str(e)
            }

    def _parse_output(self, output: str) -> Dict[str, any]:
        """
        Parse test-suite-sql-eval output

        Args:
            output: Raw output from evaluation script

        Returns:
            Dictionary with parsed metrics
        """
        results = {
            'execution_accuracy': 0.0,
            'exact_match_accuracy': 0.0,
            'total_questions': 0,
            'successful_executions': 0,
            'exact_matches': 0
        }

        lines = output.split('\n')

        for line in lines:
            line = line.strip()

            # Parse execution accuracy
            if 'execution accuracy' in line.lower():
                try:
                    # Format: "execution accuracy: 0.75" or "75.0%"
                    parts = line.split(':')
                    if len(parts) == 2:
                        value_str = parts[1].strip().replace('%', '')
                        value = float(value_str)
                        results['execution_accuracy'] = value / \
                            100 if value > 1 else value
                except:
                    pass

            # Parse exact match accuracy
            if 'exact match' in line.lower() or 'exact matching' in line.lower():
                try:
                    parts = line.split(':')
                    if len(parts) == 2:
                        value_str = parts[1].strip().replace('%', '')
                        value = float(value_str)
                        results['exact_match_accuracy'] = value / \
                            100 if value > 1 else value
                except:
                    pass

            # Parse counts
            if 'total' in line.lower() and 'questions' in line.lower():
                try:
                    parts = line.split(':')
                    if len(parts) == 2:
                        results['total_questions'] = int(parts[1].strip())
                except:
                    pass

        # Calculate counts from accuracy if not found
        if results['total_questions'] > 0:
            if results['successful_executions'] == 0:
                results['successful_executions'] = int(
                    results['execution_accuracy'] * results['total_questions']
                )

            if results['exact_matches'] == 0:
                results['exact_matches'] = int(
                    results['exact_match_accuracy'] *
                    results['total_questions']
                )

        return results

    def prepare_gold_file(
        self,
        questions: List[Dict],
        output_file: Path
    ) -> Path:
        """
        Prepare gold SQL file from questions dataset

        Args:
            questions: List of question dictionaries with 'query' field
            output_file: Output file path

        Returns:
            Path to created gold file
        """
        output_file.parent.mkdir(parents=True, exist_ok=True)

        with open(output_file, 'w', encoding='utf-8') as f:
            for question in questions:
                sql = question.get('query', question.get('sql', ''))
                # Ensure SQL ends with newline
                if sql and not sql.endswith('\n'):
                    sql += '\n'
                f.write(sql)

        logger.info(f"Created gold file: {output_file}")
        return output_file

    def prepare_pred_file(
        self,
        results: List[Dict],
        output_file: Path
    ) -> Path:
        """
        Prepare predicted SQL file from results

        Args:
            results: List of result dictionaries with 'final_sql' field
            output_file: Output file path

        Returns:
            Path to created prediction file
        """
        output_file.parent.mkdir(parents=True, exist_ok=True)

        with open(output_file, 'w', encoding='utf-8') as f:
            for result in results:
                sql = result.get('final_sql', 'SELECT 1;')
                # Use placeholder for failed queries
                if not sql or sql.strip() == '':
                    sql = 'SELECT 1;'
                # Ensure SQL ends with newline
                if not sql.endswith('\n'):
                    sql += '\n'
                f.write(sql)

        logger.info(f"Created prediction file: {output_file}")
        return output_file
