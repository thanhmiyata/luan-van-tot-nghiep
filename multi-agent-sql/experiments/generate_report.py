"""
Generate comprehensive benchmark reports
Supports multiple formats: Markdown, HTML, PDF
"""

from src.evaluation.result_parser import ResultParser
import sys
import json
from pathlib import Path
from typing import Dict, List, Any, Optional
from datetime import datetime
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
    '--comparison-file',
    type=click.Path(exists=True),
    default=None,
    help='Comparison JSON file from compare_models.py'
)
@click.option(
    '--output',
    type=click.Path(),
    required=True,
    help='Output file path (extension determines format: .md, .html, .txt)'
)
@click.option(
    '--title',
    type=str,
    default='Multi-Agent SQL Benchmark Report',
    help='Report title'
)
@click.option(
    '--include-details',
    is_flag=True,
    help='Include detailed per-question results'
)
def main(
    results_dir: str,
    comparison_file: str,
    output: str,
    title: str,
    include_details: bool
):
    """
    Generate comprehensive benchmark reports

    Examples:

        # Generate Markdown report
        python experiments/generate_report.py --results-dir output/ --output report.md

        # Generate from comparison file
        python experiments/generate_report.py --comparison-file comparison.json --output report.md

        # Generate detailed HTML report
        python experiments/generate_report.py --results-dir output/ --output report.html --include-details
    """
    logger.info("="*60)
    logger.info("Benchmark Report Generator")
    logger.info("="*60)

    output_path = Path(output)
    output_format = output_path.suffix.lower()

    # Load data
    model_results = {}
    comparison = None

    if comparison_file:
        # Load comparison file
        comparison_path = Path(comparison_file)
        logger.info(f"Loading comparison: {comparison_path.name}")

        with open(comparison_path, 'r', encoding='utf-8') as f:
            comparison = json.load(f)

    if results_dir:
        # Load all result files
        results_dir = Path(results_dir)
        logger.info(f"Loading results from: {results_dir}")

        for json_file in results_dir.glob("results_*.json"):
            try:
                results = ResultParser.load_results(json_file)
                model_name = results.get('model_name', json_file.stem)
                model_results[model_name] = results
                logger.info(f"  ✓ {model_name}")
            except Exception as e:
                logger.error(f"  ✗ Failed to load {json_file}: {e}")

        # Generate comparison if not provided
        if not comparison and model_results:
            logger.info("Generating comparison...")
            comparison = ResultParser.compare_models(model_results)

    if not comparison and not model_results:
        logger.error("No data to generate report from")
        return 1

    # Generate report
    logger.info(f"Generating {output_format} report...")

    if output_format == '.md':
        report_content = generate_markdown_report(
            title=title,
            comparison=comparison,
            model_results=model_results,
            include_details=include_details
        )
    elif output_format == '.html':
        report_content = generate_html_report(
            title=title,
            comparison=comparison,
            model_results=model_results,
            include_details=include_details
        )
    else:  # .txt or default
        report_content = generate_text_report(
            title=title,
            comparison=comparison,
            model_results=model_results,
            include_details=include_details
        )

    # Save report
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(report_content)

    logger.info(f"\n✅ Report generated: {output_path}")
    logger.info(f"📄 Format: {output_format[1:].upper()}")
    logger.info(f"📊 Size: {output_path.stat().st_size / 1024:.1f} KB")

    return 0


def generate_markdown_report(
    title: str,
    comparison: Optional[Dict],
    model_results: Dict[str, Any],
    include_details: bool = False
) -> str:
    """Generate Markdown report"""
    md = []

    # Header
    md.append(f"# {title}\n")
    md.append(
        f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")

    if comparison:
        md.append(
            f"**Models Compared:** {len(comparison.get('models', []))}\n")

    md.append("---\n")

    # Executive Summary
    md.append("## Executive Summary\n")

    if comparison and 'summary' in comparison:
        summary = comparison['summary']

        # Find best performers
        best_accuracy = max(summary.items(), key=lambda x: x[1].get(
            'exact_match_accuracy', 0))
        fastest = min(summary.items(), key=lambda x: x[1].get(
            'avg_time', float('inf')))
        most_efficient = min(summary.items(), key=lambda x: x[1].get(
            'avg_api_calls', float('inf')))

        md.append(
            f"- **Best Accuracy:** {best_accuracy[0]} ({best_accuracy[1].get('exact_match_accuracy', 0):.1%})")
        md.append(
            f"- **Fastest:** {fastest[0]} ({fastest[1].get('avg_time', 0):.2f}s per question)")
        md.append(
            f"- **Most Efficient:** {most_efficient[0]} ({most_efficient[1].get('avg_api_calls', 0):.1f} API calls)")
        md.append("")

    # Comparison Table
    if comparison and 'summary' in comparison:
        md.append("## Performance Comparison\n")
        md.append(
            "| Model | Success Rate | Exec Accuracy | Match Accuracy | Avg Time | API Calls |")
        md.append(
            "|-------|--------------|---------------|----------------|----------|-----------|")

        for model_name, metrics in comparison['summary'].items():
            md.append(
                f"| {model_name} | "
                f"{metrics.get('success_rate', 0):.1%} | "
                f"{metrics.get('execution_accuracy', 0):.1%} | "
                f"{metrics.get('exact_match_accuracy', 0):.1%} | "
                f"{metrics.get('avg_time', 0):.2f}s | "
                f"{metrics.get('avg_api_calls', 0):.1f} |"
            )

        md.append("")

    # Rankings
    if comparison and 'rankings' in comparison:
        md.append("## Rankings\n")

        rankings = comparison['rankings']

        if rankings.get('by_accuracy'):
            md.append("### By Accuracy\n")
            for rank_data in rankings['by_accuracy']:
                md.append(
                    f"{rank_data['rank']}. **{rank_data['model']}** - {rank_data['value']:.1%}")
            md.append("")

        if rankings.get('by_speed'):
            md.append("### By Speed\n")
            for rank_data in rankings['by_speed']:
                md.append(
                    f"{rank_data['rank']}. **{rank_data['model']}** - {rank_data['value']:.2f}s")
            md.append("")

        if rankings.get('by_efficiency'):
            md.append("### By Efficiency (API Calls)\n")
            for rank_data in rankings['by_efficiency']:
                md.append(
                    f"{rank_data['rank']}. **{rank_data['model']}** - {rank_data['value']:.1f} calls")
            md.append("")

    # Trade-off Analysis
    if comparison and 'trade_offs' in comparison:
        md.append("## Trade-off Analysis\n")

        for model_name, data in comparison['trade_offs'].items():
            md.append(f"### {model_name} vs {data['vs_baseline']}\n")
            md.append(
                f"- **Accuracy Improvement:** {data['accuracy_improvement']}")
            md.append(f"- **Time Increase:** {data['time_increase']}")
            md.append(f"- **Cost Increase:** {data['cost_increase']}")
            md.append(f"- **ROI:** {data['roi']:.2f}")
            md.append("")

    # Individual Model Details
    if model_results and include_details:
        md.append("## Detailed Model Results\n")

        for model_name, results in model_results.items():
            md.append(f"### {model_name}\n")
            md.append(
                f"- **Total Questions:** {results.get('total_questions', 0)}")
            md.append(
                f"- **Successful Queries:** {results.get('successful_queries', 0)}")
            md.append(
                f"- **Success Rate:** {results.get('success_rate', 0):.1%}")

            perf = results.get('performance', {})
            md.append(f"- **Total Time:** {perf.get('total_time', 0):.2f}s")
            md.append(
                f"- **Avg Time/Question:** {perf.get('avg_time_per_question', 0):.2f}s")
            md.append(
                f"- **Total API Calls:** {perf.get('total_api_calls', 0)}")

            eval_metrics = results.get('evaluation', {})
            if eval_metrics:
                md.append(
                    f"- **Execution Accuracy:** {eval_metrics.get('execution_accuracy', 0):.1%}")
                md.append(
                    f"- **Exact Match Accuracy:** {eval_metrics.get('exact_match_accuracy', 0):.1%}")

            md.append("")

    # Conclusion
    md.append("## Conclusion\n")
    md.append(
        "This benchmark provides a comprehensive comparison of Multi-Agent SQL models, ")
    md.append("evaluating the trade-offs between accuracy, speed, and cost. ")
    md.append("Choose the model that best fits your use case requirements.\n")

    return '\n'.join(md)


def generate_html_report(
    title: str,
    comparison: Optional[Dict],
    model_results: Dict[str, Any],
    include_details: bool = False
) -> str:
    """Generate HTML report"""
    # Simple HTML wrapper around markdown content
    markdown_content = generate_markdown_report(
        title, comparison, model_results, include_details)

    # Convert markdown to basic HTML (simple implementation)
    html_lines = ["<!DOCTYPE html>", "<html>", "<head>"]
    html_lines.append(f"<title>{title}</title>")
    html_lines.append("<style>")
    html_lines.append(
        "body { font-family: Arial, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; }")
    html_lines.append(
        "table { border-collapse: collapse; width: 100%; margin: 20px 0; }")
    html_lines.append(
        "th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }")
    html_lines.append("th { background-color: #4CAF50; color: white; }")
    html_lines.append("h1, h2, h3 { color: #333; }")
    html_lines.append("</style>")
    html_lines.append("</head>")
    html_lines.append("<body>")

    # Simple markdown to HTML conversion (basic implementation)
    for line in markdown_content.split('\n'):
        if line.startswith('# '):
            html_lines.append(f"<h1>{line[2:]}</h1>")
        elif line.startswith('## '):
            html_lines.append(f"<h2>{line[3:]}</h2>")
        elif line.startswith('### '):
            html_lines.append(f"<h3>{line[4:]}</h3>")
        elif line.startswith('- '):
            html_lines.append(f"<li>{line[2:]}</li>")
        elif line.startswith('|'):
            # Simple table handling
            html_lines.append(line)  # Keep as is for now
        else:
            html_lines.append(f"<p>{line}</p>")

    html_lines.append("</body>")
    html_lines.append("</html>")

    return '\n'.join(html_lines)


def generate_text_report(
    title: str,
    comparison: Optional[Dict],
    model_results: Dict[str, Any],
    include_details: bool = False
) -> str:
    """Generate plain text report"""
    lines = []

    lines.append("="*80)
    lines.append(title.center(80))
    lines.append(
        f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}".center(80))
    lines.append("="*80)
    lines.append("")

    # Summary
    if comparison and 'summary' in comparison:
        lines.append("PERFORMANCE COMPARISON")
        lines.append("-"*80)
        lines.append(
            f"{'Model':<25} {'Success':<10} {'Exec Acc':<12} {'Match Acc':<12} {'Time':<10} {'API':<8}")
        lines.append("-"*80)

        for model_name, metrics in comparison['summary'].items():
            lines.append(
                f"{model_name:<25} "
                f"{metrics.get('success_rate', 0):>7.1%}   "
                f"{metrics.get('execution_accuracy', 0):>9.1%}   "
                f"{metrics.get('exact_match_accuracy', 0):>9.1%}   "
                f"{metrics.get('avg_time', 0):>6.2f}s  "
                f"{metrics.get('avg_api_calls', 0):>5.1f}"
            )

        lines.append("")

    # Add more sections...

    lines.append("="*80)

    return '\n'.join(lines)


if __name__ == "__main__":
    sys.exit(main())
