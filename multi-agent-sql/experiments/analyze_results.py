"""
Analyze benchmark results in detail
Provides statistics, visualizations, and detailed analysis
"""

from src.evaluation.result_parser import ResultParser
import sys
import json
from pathlib import Path
from typing import Dict, List, Any, Optional
from collections import defaultdict
import click
from loguru import logger

# Add parent directory to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))


@click.command()
@click.option(
    '--result-file',
    type=click.Path(exists=True),
    required=True,
    help='Result JSON file to analyze'
)
@click.option(
    '--output',
    type=click.Path(),
    default=None,
    help='Output file for analysis report'
)
@click.option(
    '--detailed',
    is_flag=True,
    help='Include detailed per-question analysis'
)
def main(result_file: str, output: str, detailed: bool):
    """
    Analyze benchmark results in detail

    Examples:

        # Analyze a specific result file
        python experiments/analyze_results.py --result-file output/results_3-Step_20240101.json

        # Generate detailed analysis with output
        python experiments/analyze_results.py --result-file results.json --detailed --output analysis.txt
    """
    logger.info("="*60)
    logger.info("Benchmark Results Analyzer")
    logger.info("="*60)

    result_file = Path(result_file)
    logger.info(f"Analyzing: {result_file.name}")

    # Load results
    try:
        results = ResultParser.load_results(result_file)
    except Exception as e:
        logger.error(f"Failed to load results: {e}")
        return 1

    # Perform analysis
    analysis = analyze_results(results, detailed=detailed)

    # Print analysis
    print_analysis(analysis, detailed=detailed)

    # Save to file if requested
    if output:
        output_path = Path(output)
        output_path.parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, 'w', encoding='utf-8') as f:
            # Write formatted analysis
            f.write(format_analysis_text(analysis, detailed=detailed))

        logger.info(f"\n✓ Analysis saved to: {output_path}")

    return 0


def analyze_results(results: Dict[str, Any], detailed: bool = False) -> Dict[str, Any]:
    """
    Analyze benchmark results

    Args:
        results: Results dictionary
        detailed: Whether to include detailed per-question analysis

    Returns:
        Analysis dictionary
    """
    analysis = {
        'model_name': results.get('model_name', 'Unknown'),
        'timestamp': results.get('timestamp', 'N/A'),
        'overview': {},
        'performance_stats': {},
        'success_analysis': {},
        'error_analysis': {}
    }

    # Overview
    analysis['overview'] = {
        'total_questions': results.get('total_questions', 0),
        'successful_queries': results.get('successful_queries', 0),
        'failed_queries': results.get('failed_queries', 0),
        'success_rate': results.get('success_rate', 0)
    }

    # Performance statistics
    performance = results.get('performance', {})
    analysis['performance_stats'] = {
        'total_time': performance.get('total_time', 0),
        'avg_time_per_question': performance.get('avg_time_per_question', 0),
        'total_api_calls': performance.get('total_api_calls', 0),
        'avg_api_calls': performance.get('avg_api_calls', 0)
    }

    # Evaluation metrics
    evaluation = results.get('evaluation', {})
    if evaluation:
        analysis['evaluation_metrics'] = {
            'execution_accuracy': evaluation.get('execution_accuracy', 0),
            'exact_match_accuracy': evaluation.get('exact_match_accuracy', 0),
            'successful_executions': evaluation.get('successful_executions', 0),
            'exact_matches': evaluation.get('exact_matches', 0)
        }

    # Detailed results analysis
    detailed_results = results.get('detailed_results', [])

    if detailed_results:
        # Time distribution
        execution_times = [r.get('execution_time', 0)
                           for r in detailed_results]
        if execution_times:
            analysis['time_distribution'] = {
                'min': min(execution_times),
                'max': max(execution_times),
                'median': sorted(execution_times)[len(execution_times) // 2],
                'mean': sum(execution_times) / len(execution_times)
            }

        # API calls distribution
        api_calls = [r.get('api_calls', 0) for r in detailed_results]
        if api_calls:
            analysis['api_distribution'] = {
                'min': min(api_calls),
                'max': max(api_calls),
                'median': sorted(api_calls)[len(api_calls) // 2],
                'mean': sum(api_calls) / len(api_calls)
            }

        # Error analysis
        errors = [r.get('error') for r in detailed_results if r.get('error')]
        if errors:
            error_types = defaultdict(int)
            for error in errors:
                # Categorize errors
                error_str = str(error).lower()
                if 'timeout' in error_str:
                    error_types['timeout'] += 1
                elif 'api' in error_str or 'rate limit' in error_str:
                    error_types['api_error'] += 1
                elif 'syntax' in error_str or 'invalid' in error_str:
                    error_types['syntax_error'] += 1
                elif 'connection' in error_str or 'network' in error_str:
                    error_types['network_error'] += 1
                else:
                    error_types['other'] += 1

            analysis['error_analysis'] = dict(error_types)

        # Success/failure patterns
        successes = [r for r in detailed_results if r.get('success')]
        failures = [r for r in detailed_results if not r.get('success')]

        if successes:
            success_times = [r.get('execution_time', 0) for r in successes]
            analysis['success_analysis'] = {
                'count': len(successes),
                'avg_time': sum(success_times) / len(success_times),
                'avg_api_calls': sum(r.get('api_calls', 0) for r in successes) / len(successes)
            }

        if failures:
            failure_times = [r.get('execution_time', 0) for r in failures]
            analysis['failure_analysis'] = {
                'count': len(failures),
                'avg_time': sum(failure_times) / len(failure_times) if failure_times else 0,
                'common_errors': list(analysis.get('error_analysis', {}).keys())[:3]
            }

        # Detailed per-question analysis
        if detailed:
            analysis['detailed_questions'] = []

            for r in detailed_results:
                analysis['detailed_questions'].append({
                    'question_id': r.get('question_id'),
                    'question': r.get('question', '')[:100],
                    'success': r.get('success'),
                    'execution_time': r.get('execution_time', 0),
                    'api_calls': r.get('api_calls', 0),
                    'sql_length': len(r.get('sql', '')),
                    'error': r.get('error')
                })

    return analysis


def print_analysis(analysis: Dict[str, Any], detailed: bool = False):
    """Print analysis to console"""
    print("\n" + "="*80)
    print(f"ANALYSIS: {analysis['model_name']}")
    print("="*80)

    # Overview
    print("\n📊 OVERVIEW")
    print("-"*80)
    overview = analysis['overview']
    print(f"Total Questions:    {overview['total_questions']}")
    print(f"Successful Queries: {overview['successful_queries']}")
    print(f"Failed Queries:     {overview['failed_queries']}")
    print(f"Success Rate:       {overview['success_rate']:.1%}")

    # Performance
    print("\n⚡ PERFORMANCE")
    print("-"*80)
    perf = analysis['performance_stats']
    print(f"Total Time:         {perf['total_time']:.2f}s")
    print(f"Avg Time/Question:  {perf['avg_time_per_question']:.2f}s")
    print(f"Total API Calls:    {perf['total_api_calls']}")
    print(f"Avg API Calls:      {perf['avg_api_calls']:.1f}")

    # Evaluation metrics
    if 'evaluation_metrics' in analysis:
        print("\n🎯 EVALUATION METRICS")
        print("-"*80)
        eval_metrics = analysis['evaluation_metrics']
        print(f"Execution Accuracy: {eval_metrics['execution_accuracy']:.1%}")
        print(
            f"Exact Match Acc:    {eval_metrics['exact_match_accuracy']:.1%}")
        print(f"Successful Execs:   {eval_metrics['successful_executions']}")
        print(f"Exact Matches:      {eval_metrics['exact_matches']}")

    # Time distribution
    if 'time_distribution' in analysis:
        print("\n⏱️  TIME DISTRIBUTION")
        print("-"*80)
        time_dist = analysis['time_distribution']
        print(f"Min:    {time_dist['min']:.2f}s")
        print(f"Median: {time_dist['median']:.2f}s")
        print(f"Mean:   {time_dist['mean']:.2f}s")
        print(f"Max:    {time_dist['max']:.2f}s")

    # API distribution
    if 'api_distribution' in analysis:
        print("\n🔌 API CALLS DISTRIBUTION")
        print("-"*80)
        api_dist = analysis['api_distribution']
        print(f"Min:    {api_dist['min']}")
        print(f"Median: {api_dist['median']}")
        print(f"Mean:   {api_dist['mean']:.1f}")
        print(f"Max:    {api_dist['max']}")

    # Success analysis
    if 'success_analysis' in analysis:
        print("\n✅ SUCCESS ANALYSIS")
        print("-"*80)
        success = analysis['success_analysis']
        print(f"Successful Queries: {success['count']}")
        print(f"Avg Time:           {success['avg_time']:.2f}s")
        print(f"Avg API Calls:      {success['avg_api_calls']:.1f}")

    # Failure analysis
    if 'failure_analysis' in analysis:
        print("\n❌ FAILURE ANALYSIS")
        print("-"*80)
        failure = analysis['failure_analysis']
        print(f"Failed Queries:     {failure['count']}")
        print(f"Avg Time:           {failure['avg_time']:.2f}s")
        if failure.get('common_errors'):
            print(f"Common Errors:      {', '.join(failure['common_errors'])}")

    # Error analysis
    if 'error_analysis' in analysis:
        print("\n⚠️  ERROR BREAKDOWN")
        print("-"*80)
        for error_type, count in analysis['error_analysis'].items():
            print(f"{error_type:.<20} {count:>5}")

    # Detailed questions
    if detailed and 'detailed_questions' in analysis:
        print("\n📝 DETAILED QUESTION ANALYSIS")
        print("-"*80)

        for q in analysis['detailed_questions'][:20]:  # Show first 20
            status = "✓" if q['success'] else "✗"
            print(f"\n{status} Q{q['question_id']}: {q['question'][:70]}...")
            print(
                f"   Time: {q['execution_time']:.2f}s | API: {q['api_calls']} | SQL: {q['sql_length']} chars")
            if q.get('error'):
                print(f"   Error: {q['error'][:60]}...")

        if len(analysis['detailed_questions']) > 20:
            print(
                f"\n... and {len(analysis['detailed_questions']) - 20} more questions")

    print("\n" + "="*80)


def format_analysis_text(analysis: Dict[str, Any], detailed: bool = False) -> str:
    """Format analysis as text for file output"""
    lines = []

    lines.append("="*80)
    lines.append(f"BENCHMARK ANALYSIS: {analysis['model_name']}")
    lines.append(f"Timestamp: {analysis['timestamp']}")
    lines.append("="*80)

    # Overview
    lines.append("\nOVERVIEW")
    lines.append("-"*80)
    overview = analysis['overview']
    lines.append(f"Total Questions:    {overview['total_questions']}")
    lines.append(f"Successful Queries: {overview['successful_queries']}")
    lines.append(f"Failed Queries:     {overview['failed_queries']}")
    lines.append(f"Success Rate:       {overview['success_rate']:.1%}")

    # Performance
    lines.append("\nPERFORMANCE")
    lines.append("-"*80)
    perf = analysis['performance_stats']
    lines.append(f"Total Time:         {perf['total_time']:.2f}s")
    lines.append(f"Avg Time/Question:  {perf['avg_time_per_question']:.2f}s")
    lines.append(f"Total API Calls:    {perf['total_api_calls']}")
    lines.append(f"Avg API Calls:      {perf['avg_api_calls']:.1f}")

    # Add other sections similar to print_analysis...

    lines.append("\n" + "="*80)

    return '\n'.join(lines)


if __name__ == "__main__":
    sys.exit(main())
