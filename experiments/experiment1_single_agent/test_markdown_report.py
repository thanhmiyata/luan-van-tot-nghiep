#!/usr/bin/env python3
"""
Test script để tạo demo báo cáo Markdown 
"""

import json
from datetime import datetime
from comprehensive_sql_benchmark import ComprehensiveSQLBenchmark


def create_mock_metrics(sql_query, success=True):
    """Tạo mock metrics để demo"""
    return {
        'query_name': 'Mock',
        'sql_query': sql_query,
        'success': success,
        'execution_time_ms': 15.5,
        'memory_usage_mb': 2.1,
        'cpu_usage_percent': 5.2,
        'query_cost': 10.5,
        'rows_examined': 100,
        'rows_returned': 10,
        'io_operations': 5,
        'index_usage': True,
        'result_data': [{'count': 10}],
        'result_hash': 'abc123',
        'execution_plan': {},
        'error': None if success else 'Demo error'
    }


def create_demo_benchmark_results():
    """Tạo kết quả demo cho báo cáo"""

    # Load file sample
    with open('gpt4_test_results_sample.json', 'r', encoding='utf-8') as f:
        gpt4_results = json.load(f)

    results = []

    for question_data in gpt4_results['results']:
        expected_sql = question_data['expected_sql']
        generated_sql = question_data['generated_sql']

        # Mock metrics
        expected_metrics = create_mock_metrics(expected_sql, True)
        generated_metrics = create_mock_metrics(generated_sql, True)

        # Mock quality scores
        quality_scores = {
            'complexity_expected': 3,
            'complexity_generated': 3,
            'best_practices_expected': 9,
            'best_practices_generated': 8,
            'readability_expected': 8,
            'readability_generated': 7,
            'security_expected': 10,
            'security_generated': 9
        }

        # Mock correctness
        correctness = {
            'result_match': question_data['results_match'],
            'row_count_match': True,
            'data_type_consistency': True,
            'null_handling': True,
            'correctness_score': 40 if question_data['results_match'] else 0
        }

        # Mock scores với variation
        base_score = 40 if question_data['results_match'] else 0
        level = question_data['level']
        similarity = question_data['sql_similarity']

        # Điều chỉnh score theo level và similarity
        performance_score = max(15, 25 - (level * 2))
        cost_score = max(10, 20 - (level * 1.5))
        quality_score = min(15, 8 + similarity * 7)
        total = base_score + performance_score + cost_score + quality_score

        scores = {
            'correctness_score': base_score,
            'performance_score': performance_score,
            'cost_score': cost_score,
            'quality_score': quality_score,
            'total_score': total
        }

        result = {
            'question': question_data['question'],
            'question_id': question_data['question_id'],
            'level': question_data['level'],
            'expected_metrics': expected_metrics,
            'generated_metrics': generated_metrics,
            'quality_scores': quality_scores,
            'correctness': correctness,
            'scores': scores
        }

        results.append(result)

    # Mock stats
    stats = {
        'total_questions': len(results),
        'overall_accuracy': 1.0,  # 100%
        'average_total_score': 87.0,
        'average_correctness_score': 40.0,
        'average_performance_score': 20.0,
        'average_cost_score': 15.0,
        'average_quality_score': 12.0,
        'level_breakdown': {
            1: {
                'total': 3,
                'correct': 3,
                'avg_score': 87.0,
                'accuracy_rate': 1.0
            }
        },
        'score_distribution': {
            'excellent_90_100': 0,
            'good_70_89': 3,
            'fair_50_69': 0,
            'poor_below_50': 0
        }
    }

    benchmark_results = {
        'benchmark_info': {
            'total_questions': len(results),
            'completion_time': 45.2,
            'timestamp': datetime.now().isoformat(),
            'method': 'demo_comprehensive_benchmark'
        },
        'results': results,
        'statistics': stats
    }

    return benchmark_results, stats


def main():
    """Tạo demo báo cáo Markdown"""
    print("=== Tạo Demo Báo Cáo Markdown ===")

    # Tạo mock benchmark class
    class MockBenchmark:
        def generate_markdown_report(self, results, stats):
            # Import từ class gốc
            benchmark = ComprehensiveSQLBenchmark.__new__(
                ComprehensiveSQLBenchmark)
            return benchmark.generate_markdown_report(results, stats)

        def save_markdown_report(self, results, stats, filename=None):
            if filename is None:
                filename = f"demo_benchmark_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"

            report = self.generate_markdown_report(results, stats)

            with open(filename, 'w', encoding='utf-8') as f:
                f.write(report)

            print(f"\n📄 Đã tạo demo báo cáo Markdown: {filename}")

    # Tạo kết quả demo
    results, stats = create_demo_benchmark_results()

    # Tạo báo cáo
    mock_benchmark = MockBenchmark()
    mock_benchmark.save_markdown_report(results, stats)

    print("\n🎉 Hoàn thành tạo demo báo cáo!")


if __name__ == "__main__":
    main()
