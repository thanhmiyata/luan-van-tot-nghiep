"""
Compare benchmark results from multiple models
"""

from src.evaluation.result_parser import ResultParser
import sys
import json
from pathlib import Path
from typing import List, Dict, Any
import click
from loguru import logger

# Add parent directory to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))


@click.command()
@click.option(
    '--results-dir',
    type=click.Path(exists=True),
    default=None,
    help='Directory containing result JSON files'
)
@click.option(
    '--result-files',
    multiple=True,
    type=click.Path(exists=True),
    help='Specific result files to compare (can specify multiple)'
)
@click.option(
    '--output',
    type=click.Path(),
    default=None,
    help='Output file for comparison results'
)
@click.option(
    '--format',
    type=click.Choice(['table', 'json', 'markdown'], case_sensitive=False),
    default='table',
    help='Output format (default: table)'
)
def main(
    results_dir: str,
    result_files: tuple,
    output: str,
    format: str
):
    """
    Compare benchmark results from multiple models

    Examples:

        # Compare all results in output directory
        python experiments/compare_models.py --results-dir output/

        # Compare specific result files
        python experiments/compare_models.py --result-files results1.json --result-files results2.json

        # Export comparison to JSON
        python experiments/compare_models.py --results-dir output/ --format json --output comparison.json
    """
    logger.info("="*60)
    logger.info("Model Comparison Tool")
    logger.info("="*60)

    # Load results
    model_results = {}

    if result_files:
        # Load specified files
        for file_path in result_files:
            file_path = Path(file_path)
            logger.info(f"Loading: {file_path.name}")

            try:
                results = ResultParser.load_results(file_path)
                model_name = results.get('model_name', file_path.stem)
                model_results[model_name] = results
            except Exception as e:
                logger.error(f"Failed to load {file_path}: {e}")

    elif results_dir:
        # Load all JSON files in directory
        results_dir = Path(results_dir)
        logger.info(f"Scanning directory: {results_dir}")

        for json_file in results_dir.glob("results_*.json"):
            logger.info(f"Loading: {json_file.name}")

            try:
                results = ResultParser.load_results(json_file)
                model_name = results.get('model_name', json_file.stem)
                model_results[model_name] = results
            except Exception as e:
                logger.error(f"Failed to load {json_file}: {e}")

    else:
        # Default: load from output directory
        output_dir = project_root / "output"
        logger.info(f"Using default directory: {output_dir}")

        for json_file in output_dir.glob("results_*.json"):
            logger.info(f"Loading: {json_file.name}")

            try:
                results = ResultParser.load_results(json_file)
                model_name = results.get('model_name', json_file.stem)
                model_results[model_name] = results
            except Exception as e:
                logger.error(f"Failed to load {json_file}: {e}")

    if not model_results:
        logger.error("No results found to compare")
        return 1

    logger.info(f"\nLoaded {len(model_results)} result sets")

    # Compare results
    logger.info("\nGenerating comparison...")
    comparison = ResultParser.compare_models(model_results)

    # Output results
    if format == 'table':
        print_comparison_table(comparison)
    elif format == 'json':
        print(json.dumps(comparison, indent=2, ensure_ascii=False))
    elif format == 'markdown':
        print_comparison_markdown(comparison)

    # Save to file if requested
    if output:
        output_path = Path(output)
        output_path.parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, 'w', encoding='utf-8') as f:
            if format == 'json':
                json.dump(comparison, f, indent=2, ensure_ascii=False)
            elif format == 'markdown':
                f.write(generate_markdown_report(comparison))
            else:
                # Save as JSON for table format too
                json.dump(comparison, f, indent=2, ensure_ascii=False)

        logger.info(f"\n✓ Comparison saved to: {output_path}")

    return 0


def print_comparison_table(comparison: Dict[str, Any]):
    """Print comparison in table format"""
    print("\n" + "="*100)
    print("MODEL COMPARISON")
    print("="*100)

    summary = comparison.get('summary', {})

    if not summary:
        print("No comparison data available")
        return

    # Header
    print(f"\n{'Model':<25} {'Success':<10} {'Exec Acc':<12} {'Match Acc':<12} {'Avg Time':<12} {'API Calls':<10}")
    print("-" * 100)

    # Data rows
    for model_name, metrics in summary.items():
        print(
            f"{model_name:<25} "
            f"{metrics.get('success_rate', 0):>7.1%}   "
            f"{metrics.get('execution_accuracy', 0):>9.1%}   "
            f"{metrics.get('exact_match_accuracy', 0):>9.1%}   "
            f"{metrics.get('avg_time', 0):>8.2f}s    "
            f"{metrics.get('avg_api_calls', 0):>6.1f}"
        )

    # Rankings
    rankings = comparison.get('rankings', {})

    print("\n" + "-"*100)
    print("RANKINGS")
    print("-"*100)

    if rankings.get('by_accuracy'):
        print("\n🏆 By Accuracy:")
        for rank_data in rankings['by_accuracy']:
            print(
                f"  {rank_data['rank']}. {rank_data['model']}: {rank_data['value']:.1%}")

    if rankings.get('by_speed'):
        print("\n⚡ By Speed:")
        for rank_data in rankings['by_speed']:
            print(
                f"  {rank_data['rank']}. {rank_data['model']}: {rank_data['value']:.2f}s")

    if rankings.get('by_efficiency'):
        print("\n💰 By Efficiency:")
        for rank_data in rankings['by_efficiency']:
            print(
                f"  {rank_data['rank']}. {rank_data['model']}: {rank_data['value']:.1f} API calls")

    # Trade-offs
    trade_offs = comparison.get('trade_offs', {})

    if trade_offs:
        print("\n" + "-"*100)
        print("TRADE-OFF ANALYSIS")
        print("-"*100)

        for model_name, data in trade_offs.items():
            print(f"\n{model_name} vs {data['vs_baseline']}:")
            print(f"  Accuracy improvement: {data['accuracy_improvement']}")
            print(f"  Time increase: {data['time_increase']}")
            print(f"  Cost increase: {data['cost_increase']}")
            print(f"  ROI: {data['roi']:.2f}")

    print("\n" + "="*100)


def print_comparison_markdown(comparison: Dict[str, Any]):
    """Print comparison in markdown format"""
    print(generate_markdown_report(comparison))


def generate_markdown_report(comparison: Dict[str, Any]) -> str:
    """Generate markdown report"""
    md = []

    md.append("# Multi-Agent SQL Model Comparison\n")
    md.append(f"**Generated:** {comparison.get('timestamp', 'N/A')}\n")
    md.append(f"**Models:** {', '.join(comparison.get('models', []))}\n")

    summary = comparison.get('summary', {})

    if summary:
        md.append("\n## Summary\n")
        md.append(
            "| Model | Success Rate | Exec Accuracy | Match Accuracy | Avg Time | API Calls |")
        md.append(
            "|-------|--------------|---------------|----------------|----------|-----------|")

        for model_name, metrics in summary.items():
            md.append(
                f"| {model_name} | "
                f"{metrics.get('success_rate', 0):.1%} | "
                f"{metrics.get('execution_accuracy', 0):.1%} | "
                f"{metrics.get('exact_match_accuracy', 0):.1%} | "
                f"{metrics.get('avg_time', 0):.2f}s | "
                f"{metrics.get('avg_api_calls', 0):.1f} |"
            )

    rankings = comparison.get('rankings', {})

    if rankings:
        md.append("\n## Rankings\n")

        if rankings.get('by_accuracy'):
            md.append("\n### By Accuracy\n")
            for rank_data in rankings['by_accuracy']:
                md.append(
                    f"{rank_data['rank']}. **{rank_data['model']}**: {rank_data['value']:.1%}")

        if rankings.get('by_speed'):
            md.append("\n### By Speed\n")
            for rank_data in rankings['by_speed']:
                md.append(
                    f"{rank_data['rank']}. **{rank_data['model']}**: {rank_data['value']:.2f}s")

        if rankings.get('by_efficiency'):
            md.append("\n### By Efficiency\n")
            for rank_data in rankings['by_efficiency']:
                md.append(
                    f"{rank_data['rank']}. **{rank_data['model']}**: {rank_data['value']:.1f} API calls")

    trade_offs = comparison.get('trade_offs', {})

    if trade_offs:
        md.append("\n## Trade-off Analysis\n")

        for model_name, data in trade_offs.items():
            md.append(f"\n### {model_name} vs {data['vs_baseline']}\n")
            md.append(
                f"- **Accuracy improvement**: {data['accuracy_improvement']}")
            md.append(f"- **Time increase**: {data['time_increase']}")
            md.append(f"- **Cost increase**: {data['cost_increase']}")
            md.append(f"- **ROI**: {data['roi']:.2f}")

    return '\n'.join(md)


if __name__ == "__main__":
    sys.exit(main())
