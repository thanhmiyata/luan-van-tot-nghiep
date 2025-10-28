"""
Main benchmark runner for Multi-Agent SQL System
Run comprehensive benchmarks comparing all 3 models
"""

from src.core.models import ModelType
from src.utils.data_loader import DataLoader
from src.evaluation.evaluator import Evaluator
from src.models.model_6_step import Model6Step
from src.models.model_4_step import Model4Step
from src.models.model_3_step import Model3Step
import sys
from pathlib import Path
from datetime import datetime
from typing import Optional
import click
from loguru import logger

# Add parent directory to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))


def setup_logging(verbose: bool = False):
    """Setup logging configuration"""
    log_level = "DEBUG" if verbose else "INFO"
    log_file = project_root / "logs" / \
        f"benchmark_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
    log_file.parent.mkdir(exist_ok=True)

    logger.remove()  # Remove default handler
    logger.add(sys.stderr, level=log_level)
    logger.add(log_file, level="DEBUG", rotation="10 MB")

    logger.info(f"Logging to: {log_file}")


@click.command()
@click.option(
    '--model',
    type=click.Choice(['3_step', '4_step', '6_step', 'all'],
                      case_sensitive=False),
    default='all',
    help='Model to benchmark (default: all)'
)
@click.option(
    '--questions',
    type=int,
    default=50,
    help='Number of questions to test (default: 50)'
)
@click.option(
    '--db-id',
    type=str,
    default=None,
    help='Specific database to test (default: most common in dataset)'
)
@click.option(
    '--runs',
    type=int,
    default=1,
    help='Number of runs for averaging (default: 1)'
)
@click.option(
    '--questions-file',
    type=click.Path(exists=True),
    default=None,
    help='Custom questions file path'
)
@click.option(
    '--tables-file',
    type=click.Path(exists=True),
    default=None,
    help='Custom tables.json file path'
)
@click.option(
    '--output-dir',
    type=click.Path(),
    default=None,
    help='Output directory for results'
)
@click.option(
    '--no-eval',
    is_flag=True,
    help='Skip test-suite-sql-eval evaluation'
)
@click.option(
    '--verbose',
    is_flag=True,
    help='Enable verbose output'
)
def main(
    model: str,
    questions: int,
    db_id: Optional[str],
    runs: int,
    questions_file: Optional[str],
    tables_file: Optional[str],
    output_dir: Optional[str],
    no_eval: bool,
    verbose: bool
):
    """
    Run comprehensive benchmark for Multi-Agent SQL models

    Examples:

        # Run all models with 50 questions
        python experiments/run_benchmark.py --all

        # Run specific model
        python experiments/run_benchmark.py --model 4_step --questions 100

        # Run with custom dataset
        python experiments/run_benchmark.py --questions-file data.json --tables-file tables.json
    """
    setup_logging(verbose)

    logger.info("="*60)
    logger.info("Multi-Agent SQL Benchmark Runner")
    logger.info("="*60)

    # Load data
    logger.info("\n📊 Loading test data...")

    if questions_file is None:
        questions_file = project_root / "train_spider.json"
    else:
        questions_file = Path(questions_file)

    if tables_file is None:
        # Try to find tables.json in test-suite-sql-eval
        tables_file = project_root.parent / "experiments" / \
            "test-suite-sql-eval" / "tables.json"
        if not tables_file.exists():
            tables_file = project_root / "tables.json"
    else:
        tables_file = Path(tables_file)

    try:
        # Load questions and schema
        test_questions, schema, gold_queries = DataLoader.load_test_dataset(
            questions_file=questions_file,
            tables_file=tables_file,
            num_questions=questions,
            db_id=db_id
        )

        logger.info(f"✓ Loaded {len(test_questions)} questions")
        logger.info(f"✓ Database: {schema.db_id}")
        logger.info(f"✓ Tables: {len(schema.table_names_original)}")

    except Exception as e:
        logger.error(f"Failed to load data: {e}")
        logger.info("Using sample dataset instead...")

        test_questions, schema = DataLoader.create_sample_dataset(
            min(questions, 10))
        gold_queries = None

        logger.info(f"✓ Created {len(test_questions)} sample questions")

    # Setup output directory
    if output_dir is None:
        output_dir = project_root / "output"
    else:
        output_dir = Path(output_dir)

    # Initialize evaluator
    evaluator = Evaluator(output_dir=output_dir)

    # Initialize models
    logger.info("\n🤖 Initializing models...")
    models = {}

    if model == 'all' or model == '3_step':
        models['3-Step_Lightweight'] = Model3Step()
        logger.info("✓ Model 3-Step (Lightweight) ready")

    if model == 'all' or model == '4_step':
        models['4-Step_Balanced'] = Model4Step()
        logger.info("✓ Model 4-Step (Balanced) ready")

    if model == 'all' or model == '6_step':
        models['6-Step_Enhanced'] = Model6Step()
        logger.info("✓ Model 6-Step (Enhanced) ready")

    logger.info(f"\n📝 Benchmark configuration:")
    logger.info(f"  Models: {', '.join(models.keys())}")
    logger.info(f"  Questions: {len(test_questions)}")
    logger.info(f"  Runs: {runs}")
    logger.info(f"  Evaluation: {'Disabled' if no_eval else 'Enabled'}")
    logger.info(f"  Output: {output_dir}")

    # Run benchmark
    logger.info("\n🚀 Starting benchmark...\n")

    try:
        results = evaluator.benchmark_multiple_models(
            models=models,
            questions=test_questions,
            schema=schema,
            gold_queries=gold_queries if not no_eval else None,
            runs=runs
        )

        # Print summary
        print_summary(results)

        logger.info("\n✅ Benchmark completed successfully!")
        logger.info(f"📁 Results saved to: {output_dir}")

        return 0

    except Exception as e:
        logger.error(f"Benchmark failed: {e}")
        import traceback
        traceback.print_exc()
        return 1


def print_summary(results: dict):
    """Print benchmark summary"""
    print("\n" + "="*80)
    print("📊 BENCHMARK SUMMARY")
    print("="*80)

    if 'comparison' not in results:
        print("No comparison data available")
        return

    comparison = results['comparison']
    summary = comparison.get('summary', {})

    if not summary:
        print("No summary data available")
        return

    # Print table header
    print(f"\n{'Model':<25} {'Success':<10} {'Exec Acc':<10} {'Match Acc':<10} {'Avg Time':<12} {'Avg API':<10}")
    print("-" * 80)

    # Print each model
    for model_name, metrics in summary.items():
        success_rate = metrics.get('success_rate', 0)
        exec_acc = metrics.get('execution_accuracy', 0)
        match_acc = metrics.get('exact_match_accuracy', 0)
        avg_time = metrics.get('avg_time', 0)
        avg_api = metrics.get('avg_api_calls', 0)

        print(
            f"{model_name:<25} "
            f"{success_rate:>7.1%}   "
            f"{exec_acc:>7.1%}   "
            f"{match_acc:>7.1%}   "
            f"{avg_time:>8.2f}s    "
            f"{avg_api:>6.1f}"
        )

    # Print rankings
    rankings = comparison.get('rankings', {})

    if rankings.get('by_accuracy'):
        print(f"\n🏆 Best Accuracy: {rankings['by_accuracy'][0]['model']} "
              f"({rankings['by_accuracy'][0]['value']:.1%})")

    if rankings.get('by_speed'):
        print(f"⚡ Fastest: {rankings['by_speed'][0]['model']} "
              f"({rankings['by_speed'][0]['value']:.2f}s)")

    if rankings.get('by_efficiency'):
        print(f"💰 Most Efficient: {rankings['by_efficiency'][0]['model']} "
              f"({rankings['by_efficiency'][0]['value']:.1f} API calls)")

    # Print trade-offs if available
    trade_offs = comparison.get('trade_offs', {})
    if trade_offs:
        print(f"\n📈 Trade-offs vs Baseline:")
        for model_name, data in trade_offs.items():
            print(f"  {model_name}:")
            print(f"    Accuracy: {data['accuracy_improvement']}")
            print(f"    Time: {data['time_increase']}")
            print(f"    Cost: {data['cost_increase']}")
            print(f"    ROI: {data['roi']:.2f}")

    print("\n" + "="*80)


if __name__ == "__main__":
    sys.exit(main())
