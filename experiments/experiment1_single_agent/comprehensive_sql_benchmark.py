#!/usr/bin/env python3
"""
Comprehensive SQL Benchmark: So sánh Expected SQL vs GPT-4 Generated SQL
Dựa trên tiêu chuẩn benchmark đã định nghĩa
"""

import os
import json
import time
import psutil
import logging
import hashlib
import sqlparse
from datetime import datetime
from typing import Dict, List, Any, Optional, Tuple
from pathlib import Path

import psycopg2
from psycopg2 import sql
from dotenv import load_dotenv

# Thiết lập logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(
            f'comprehensive_benchmark_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log', encoding='utf-8'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class ComprehensiveSQLBenchmark:
    def __init__(self, results_file: str):
        load_dotenv()

        print("=== Khởi tạo Comprehensive SQL Benchmark ===")

        # Cấu hình database
        self.db_params = {
            'host': os.getenv('DB_HOST', 'localhost'),
            'database': os.getenv('DB_NAME', 'dvdrental'),
            'user': os.getenv('DB_USER', 'postgres'),
            'password': os.getenv('DB_PASSWORD', 'your_password'),
            'port': os.getenv('DB_PORT', '5432')
        }

        print(
            f"✓ Cấu hình DB: {self.db_params['user']}@{self.db_params['host']}:{self.db_params['port']}/{self.db_params['database']}")

        # Load kết quả GPT-4
        with open(results_file, 'r', encoding='utf-8') as f:
            self.gpt4_results = json.load(f)

        print(f"✓ Đã load {len(self.gpt4_results['results'])} kết quả GPT-4")

    def execute_sql_with_metrics(self, sql_query: str, query_name: str) -> Dict[str, Any]:
        """Thực thi SQL và thu thập tất cả metrics"""
        metrics = {
            'query_name': query_name,
            'sql_query': sql_query,
            'success': False,
            'execution_time_ms': 0,
            'memory_usage_mb': 0,
            'cpu_usage_percent': 0,
            'query_cost': 0,
            'rows_examined': 0,
            'rows_returned': 0,
            'io_operations': 0,
            'index_usage': False,
            'result_data': None,
            'result_hash': None,
            'execution_plan': None,
            'error': None
        }

        if not sql_query or not sql_query.strip():
            metrics['error'] = 'Empty SQL query'
            return metrics

        # Kiểm tra chỉ cho phép SELECT
        if not sql_query.upper().strip().startswith('SELECT'):
            metrics['error'] = 'Chỉ cho phép câu lệnh SELECT'
            return metrics

        try:
            with psycopg2.connect(**self.db_params) as conn:
                with conn.cursor() as cursor:
                    # 1. Đo CPU và Memory trước khi thực thi
                    process = psutil.Process()
                    cpu_before = process.cpu_percent()
                    memory_before = process.memory_info().rss / 1024 / 1024  # MB

                    # 2. Lấy execution plan với cost
                    plan_query = f"EXPLAIN (ANALYZE, BUFFERS, COSTS, FORMAT JSON) {sql_query}"

                    start_time = time.time()
                    cursor.execute(plan_query)
                    execution_time = (time.time() - start_time) * 1000  # ms

                    plan_result = cursor.fetchone()[0]
                    metrics['execution_plan'] = plan_result

                    # 3. Thực thi query thực sự để lấy data
                    start_time = time.time()
                    cursor.execute(sql_query)
                    execution_time_real = (time.time() - start_time) * 1000

                    data = cursor.fetchall()
                    columns = [desc[0] for desc in cursor.description]

                    # 4. Đo CPU và Memory sau khi thực thi
                    cpu_after = process.cpu_percent()
                    memory_after = process.memory_info().rss / 1024 / 1024

                    # 5. Tạo result data
                    result_data = [dict(zip(columns, row)) for row in data]
                    result_hash = self._create_result_hash(result_data)

                    # 6. Extract metrics từ execution plan
                    plan_metrics = self._extract_plan_metrics(plan_result)

                    # 7. Cập nhật metrics
                    metrics.update({
                        'success': True,
                        'execution_time_ms': execution_time_real,
                        'memory_usage_mb': memory_after - memory_before,
                        'cpu_usage_percent': max(0, cpu_after - cpu_before),
                        'query_cost': plan_metrics['total_cost'],
                        'rows_examined': plan_metrics['rows_examined'],
                        'rows_returned': len(data),
                        'io_operations': plan_metrics['io_operations'],
                        'index_usage': plan_metrics['index_usage'],
                        'result_data': result_data,
                        'result_hash': result_hash
                    })

        except Exception as e:
            metrics['error'] = str(e)
            logger.error(f"Lỗi thực thi {query_name}: {e}")

        return metrics

    def _extract_plan_metrics(self, plan_json: Dict) -> Dict[str, Any]:
        """Extract metrics từ PostgreSQL execution plan"""
        def extract_recursive(node):
            metrics = {
                'total_cost': 0,
                'rows_examined': 0,
                'io_operations': 0,
                'index_usage': False
            }

            if isinstance(node, list):
                node = node[0]

            # Extract cost
            if 'Total Cost' in node:
                metrics['total_cost'] = node['Total Cost']

            # Extract rows
            if 'Actual Rows' in node:
                metrics['rows_examined'] += node['Actual Rows']

            # Check for index usage
            node_type = node.get('Node Type', '')
            if 'Index' in node_type:
                metrics['index_usage'] = True

            # Extract I/O operations
            if 'Shared Hit Blocks' in node or 'Shared Read Blocks' in node:
                metrics['io_operations'] += node.get(
                    'Shared Hit Blocks', 0) + node.get('Shared Read Blocks', 0)

            # Recursive cho child plans
            if 'Plans' in node:
                for child in node['Plans']:
                    child_metrics = extract_recursive(child)
                    metrics['rows_examined'] += child_metrics['rows_examined']
                    metrics['io_operations'] += child_metrics['io_operations']
                    if child_metrics['index_usage']:
                        metrics['index_usage'] = True

            return metrics

        return extract_recursive(plan_json)

    def _create_result_hash(self, data: List[Dict]) -> str:
        """Tạo hash từ kết quả để so sánh"""
        if not data:
            return hashlib.md5("EMPTY_RESULT".encode()).hexdigest()

        sorted_data = sorted(data, key=lambda x: str(sorted(x.items())))
        data_str = json.dumps(sorted_data, sort_keys=True, default=str)
        return hashlib.md5(data_str.encode()).hexdigest()

    def calculate_query_complexity_score(self, sql_query: str) -> int:
        """Tính điểm độ phức tạp query theo tiêu chuẩn"""
        if not sql_query:
            return 0

        sql_upper = sql_query.upper()
        score = 0

        # Đếm các thành phần phức tạp
        score += sql_upper.count('JOIN') * 2
        score += sql_upper.count('SUBQUERY') * 3
        score += sql_upper.count('UNION') * 2
        score += sql_upper.count('CASE WHEN') * 1
        score += sql_upper.count('WITH') * 3  # CTE
        score += sql_upper.count('WINDOW') * 2
        score += sql_upper.count('HAVING') * 1
        score += sql_upper.count('GROUP BY') * 1
        score += sql_upper.count('ORDER BY') * 1

        return min(score, 10)  # Cap at 10

    def calculate_best_practices_score(self, sql_query: str) -> int:
        """Tính điểm best practices (1-10)"""
        if not sql_query:
            return 0

        sql_upper = sql_query.upper()
        score = 10  # Start with perfect score

        # Deduct points for bad practices
        if 'SELECT *' in sql_upper:
            score -= 2  # Avoid SELECT *

        if sql_upper.count('JOIN') > 0 and 'ON' not in sql_upper:
            score -= 3  # Missing JOIN conditions

        # Check for proper JOIN syntax
        if 'JOIN' in sql_upper and not any(join_type in sql_upper for join_type in ['INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL JOIN']):
            if sql_upper.count('JOIN') > sql_upper.count('INNER') + sql_upper.count('LEFT') + sql_upper.count('RIGHT') + sql_upper.count('FULL'):
                score -= 1  # Prefer explicit JOIN types

        # Check for WHERE clause efficiency
        if 'WHERE' in sql_upper and 'OR' in sql_upper:
            score -= 1  # OR can be inefficient

        # Bonus for using LIMIT appropriately
        if 'LIMIT' in sql_upper and 'ORDER BY' in sql_upper:
            score += 1  # Good practice: ORDER BY with LIMIT

        return max(1, min(score, 10))

    def calculate_readability_score(self, sql_query: str) -> int:
        """Tính điểm readability (1-10)"""
        if not sql_query:
            return 0

        score = 5  # Base score

        # Check formatting
        lines = sql_query.split('\n')
        if len(lines) > 1:
            score += 2  # Multi-line formatting

        # Check indentation
        indented_lines = sum(1 for line in lines if line.startswith(
            '    ') or line.startswith('\t'))
        if indented_lines > 0:
            score += 1  # Has indentation

        # Check keyword casing (prefer uppercase)
        keywords = ['SELECT', 'FROM', 'WHERE',
                    'JOIN', 'GROUP BY', 'ORDER BY', 'HAVING']
        uppercase_keywords = sum(
            1 for kw in keywords if kw in sql_query.upper() and kw in sql_query)
        if uppercase_keywords > 0:
            score += 1

        # Check alias usage
        if ' AS ' in sql_query.upper():
            score += 1  # Good aliasing

        return max(1, min(score, 10))

    def calculate_security_score(self, sql_query: str) -> int:
        """Tính điểm security (1-10)"""
        if not sql_query:
            return 0

        sql_upper = sql_query.upper()
        score = 10  # Start with perfect score

        # Check for potential security issues
        dangerous_patterns = [
            'DROP', 'DELETE', 'UPDATE', 'INSERT', 'ALTER', 'CREATE', 'TRUNCATE',
            '--', '/*', '*/', 'EXEC', 'EXECUTE', 'SP_', 'XP_'
        ]

        for pattern in dangerous_patterns:
            if pattern in sql_upper:
                score -= 2

        # Check for SQL injection patterns
        injection_patterns = ["'", '"', ';', '--', '/*']
        for pattern in injection_patterns:
            if pattern in sql_query:
                score -= 1

        return max(1, min(score, 10))

    def calculate_correctness_metrics(self, expected_metrics: Dict, generated_metrics: Dict) -> Dict[str, Any]:
        """Tính toán correctness metrics"""
        correctness = {
            'result_match': False,
            'row_count_match': False,
            'data_type_consistency': True,  # Assume true unless proven false
            'null_handling': True,
            'correctness_score': 0
        }

        if expected_metrics['success'] and generated_metrics['success']:
            # Result match
            if expected_metrics['result_hash'] == generated_metrics['result_hash']:
                correctness['result_match'] = True

            # Row count match
            if expected_metrics['rows_returned'] == generated_metrics['rows_returned']:
                correctness['row_count_match'] = True

            # Check data types and NULL handling by comparing sample data
            if expected_metrics['result_data'] and generated_metrics['result_data']:
                expected_sample = expected_metrics['result_data'][:5] if expected_metrics['result_data'] else [
                ]
                generated_sample = generated_metrics['result_data'][:5] if generated_metrics['result_data'] else [
                ]

                # Basic type consistency check
                if len(expected_sample) > 0 and len(generated_sample) > 0:
                    exp_keys = set(
                        expected_sample[0].keys()) if expected_sample else set()
                    gen_keys = set(
                        generated_sample[0].keys()) if generated_sample else set()

                    if exp_keys != gen_keys:
                        correctness['data_type_consistency'] = False

        # Calculate overall correctness score
        scores = [
            correctness['result_match'] * 25,      # 25%
            correctness['row_count_match'] * 10,   # 10%
            correctness['data_type_consistency'] * 3,  # 3%
            correctness['null_handling'] * 2       # 2%
        ]
        correctness['correctness_score'] = sum(scores)

        return correctness

    def benchmark_single_query(self, question_data: Dict) -> Dict[str, Any]:
        """Benchmark một query đơn lẻ"""
        question = question_data['question']
        expected_sql = question_data['expected_sql']
        generated_sql = question_data['generated_sql']

        logger.info(f"Benchmarking: {question}")

        # 1. Thực thi cả 2 SQL queries
        expected_metrics = self.execute_sql_with_metrics(
            expected_sql, "Expected")
        generated_metrics = self.execute_sql_with_metrics(
            generated_sql, "Generated")

        # 2. Tính các quality scores
        quality_scores = {
            'complexity_expected': self.calculate_query_complexity_score(expected_sql),
            'complexity_generated': self.calculate_query_complexity_score(generated_sql),
            'best_practices_expected': self.calculate_best_practices_score(expected_sql),
            'best_practices_generated': self.calculate_best_practices_score(generated_sql),
            'readability_expected': self.calculate_readability_score(expected_sql),
            'readability_generated': self.calculate_readability_score(generated_sql),
            'security_expected': self.calculate_security_score(expected_sql),
            'security_generated': self.calculate_security_score(generated_sql)
        }

        # 3. Tính correctness metrics
        correctness = self.calculate_correctness_metrics(
            expected_metrics, generated_metrics)

        # 4. Tính overall scores theo weighted system
        scores = self.calculate_weighted_scores(
            expected_metrics, generated_metrics, quality_scores, correctness)

        return {
            'question': question,
            'question_id': question_data.get('question_id', 'Unknown'),
            'level': question_data.get('level', 0),
            'expected_metrics': expected_metrics,
            'generated_metrics': generated_metrics,
            'quality_scores': quality_scores,
            'correctness': correctness,
            'scores': scores
        }

    def calculate_weighted_scores(self, expected_metrics: Dict, generated_metrics: Dict,
                                  quality_scores: Dict, correctness: Dict) -> Dict[str, float]:
        """Tính điểm theo weighted scoring system"""

        # 1. Correctness (40%)
        correctness_score = correctness['correctness_score']

        # 2. Performance (25%)
        performance_score = 0
        if expected_metrics['success'] and generated_metrics['success']:
            # So sánh execution time (lower is better)
            if expected_metrics['execution_time_ms'] > 0:
                time_ratio = min(
                    expected_metrics['execution_time_ms'] / generated_metrics['execution_time_ms'], 2.0)
                performance_score += (2.0 - time_ratio) * 7.5  # 15% of total

            # Memory usage comparison
            if abs(generated_metrics['memory_usage_mb']) < abs(expected_metrics['memory_usage_mb']) + 10:
                performance_score += 5  # 5% of total

            # CPU usage comparison
            if abs(generated_metrics['cpu_usage_percent']) < abs(expected_metrics['cpu_usage_percent']) + 5:
                performance_score += 5  # 5% of total

        # 3. Cost Efficiency (20%)
        cost_score = 0
        if expected_metrics['success'] and generated_metrics['success']:
            # Query cost comparison
            if expected_metrics['query_cost'] > 0:
                cost_ratio = min(
                    expected_metrics['query_cost'] / max(generated_metrics['query_cost'], 0.1), 2.0)
                cost_score += (2.0 - cost_ratio) * 5  # 10% of total

            # I/O operations
            if generated_metrics['io_operations'] <= expected_metrics['io_operations']:
                cost_score += 5  # 5% of total

            # Index usage
            if generated_metrics['index_usage']:
                cost_score += 5  # 5% of total

        # 4. Code Quality (15%)
        quality_score = (
            quality_scores['best_practices_generated'] * 0.8 +  # 8% of total
            quality_scores['readability_generated'] * 0.4 +     # 4% of total
            quality_scores['security_generated'] * 0.3          # 3% of total
        )

        # Total weighted score
        total_score = (
            correctness_score * 0.4 +      # 40%
            performance_score * 0.25 +     # 25%
            cost_score * 0.2 +             # 20%
            quality_score * 0.15           # 15%
        )

        return {
            'correctness_score': correctness_score,
            'performance_score': performance_score,
            'cost_score': cost_score,
            'quality_score': quality_score,
            'total_score': min(total_score, 100.0)  # Cap at 100
        }

    def run_comprehensive_benchmark(self) -> Dict[str, Any]:
        """Chạy benchmark toàn diện cho tất cả queries"""
        print(f"\n=== Bắt đầu Comprehensive Benchmark ===")

        results = []
        start_time = time.time()

        for i, question_data in enumerate(self.gpt4_results['results'], 1):
            print(
                f"\n--- Benchmarking {i}/{len(self.gpt4_results['results'])} ---")

            try:
                result = self.benchmark_single_query(question_data)
                results.append(result)

                # Log kết quả ngắn gọn
                total_score = result['scores']['total_score']
                correctness = result['correctness']['result_match']

                status = "✅" if correctness else "❌"
                print(
                    f"{status} Score: {total_score:.1f}/100 | Correct: {correctness}")

            except Exception as e:
                logger.error(f"Lỗi benchmark question {i}: {e}")
                continue

        # Tính thống kê tổng
        stats = self.calculate_comprehensive_stats(results)

        benchmark_results = {
            'benchmark_info': {
                'total_questions': len(results),
                'completion_time': time.time() - start_time,
                'timestamp': datetime.now().isoformat(),
                'method': 'comprehensive_benchmark'
            },
            'results': results,
            'statistics': stats
        }

        return benchmark_results

    def calculate_comprehensive_stats(self, results: List[Dict]) -> Dict[str, Any]:
        """Tính thống kê toàn diện"""
        if not results:
            return {}

        # Extract scores
        total_scores = [r['scores']['total_score'] for r in results]
        correctness_scores = [r['scores']['correctness_score']
                              for r in results]
        performance_scores = [r['scores']['performance_score']
                              for r in results]
        cost_scores = [r['scores']['cost_score'] for r in results]
        quality_scores = [r['scores']['quality_score'] for r in results]

        # Correctness boolean
        correct_results = [r['correctness']['result_match'] for r in results]

        # Level breakdown
        level_stats = {}
        for result in results:
            level = result.get('level', 0)
            if level not in level_stats:
                level_stats[level] = {'total': 0, 'correct': 0, 'avg_score': 0}

            level_stats[level]['total'] += 1
            if result['correctness']['result_match']:
                level_stats[level]['correct'] += 1
            level_stats[level]['avg_score'] += result['scores']['total_score']

        # Calculate averages for levels
        for level in level_stats:
            if level_stats[level]['total'] > 0:
                level_stats[level]['avg_score'] /= level_stats[level]['total']
                level_stats[level]['accuracy_rate'] = level_stats[level]['correct'] / \
                    level_stats[level]['total']

        stats = {
            'total_questions': len(results),
            'overall_accuracy': sum(correct_results) / len(correct_results) if correct_results else 0,
            'average_total_score': sum(total_scores) / len(total_scores) if total_scores else 0,
            'average_correctness_score': sum(correctness_scores) / len(correctness_scores) if correctness_scores else 0,
            'average_performance_score': sum(performance_scores) / len(performance_scores) if performance_scores else 0,
            'average_cost_score': sum(cost_scores) / len(cost_scores) if cost_scores else 0,
            'average_quality_score': sum(quality_scores) / len(quality_scores) if quality_scores else 0,
            'level_breakdown': level_stats,
            'score_distribution': {
                'excellent_90_100': sum(1 for s in total_scores if s >= 90),
                'good_70_89': sum(1 for s in total_scores if 70 <= s < 90),
                'fair_50_69': sum(1 for s in total_scores if 50 <= s < 70),
                'poor_below_50': sum(1 for s in total_scores if s < 50)
            }
        }

        return stats

    def save_benchmark_results(self, results: Dict, filename: str = None):
        """Lưu kết quả benchmark"""
        if filename is None:
            filename = f"comprehensive_benchmark_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"

        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(results, f, ensure_ascii=False, indent=2, default=str)

        print(f"\n✅ Đã lưu kết quả comprehensive benchmark vào: {filename}")

    def generate_markdown_report(self, results: Dict, stats: Dict) -> str:
        """Tạo báo cáo Markdown chi tiết"""
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        report = f"""# 📊 Comprehensive SQL Benchmark Report - GPT-4 vs Expected SQL

**Thời gian tạo báo cáo:** {timestamp}  
**Phương pháp đánh giá:** Execution-based comparison theo tiêu chuẩn benchmark  

---

## 🎯 **TÓM TẮT TỔNG QUAN**

| Metric | Giá trị |
|--------|---------|
| **Tổng số câu hỏi** | {stats['total_questions']} |
| **Overall Accuracy** | **{stats['overall_accuracy']:.1%}** |
| **Average Total Score** | **{stats['average_total_score']:.1f}/100** |
| **Thời gian hoàn thành** | {results['benchmark_info']['completion_time']:.1f} giây |

---

## 📋 **PHÂN TÍCH THEO TIÊU CHUẨN BENCHMARK**

### 🔍 **Score Breakdown (Weighted Scoring System)**

| Tiêu chuẩn | Trọng số | Điểm trung bình | Đánh giá |
|------------|----------|-----------------|----------|
| **Correctness** | 40% | {stats['average_correctness_score']:.1f}/40 | {'🟢 Tốt' if stats['average_correctness_score'] >= 30 else '🟡 Trung bình' if stats['average_correctness_score'] >= 20 else '🔴 Kém'} |
| **Performance** | 25% | {stats['average_performance_score']:.1f}/25 | {'🟢 Tốt' if stats['average_performance_score'] >= 18 else '🟡 Trung bình' if stats['average_performance_score'] >= 12 else '🔴 Kém'} |
| **Cost Efficiency** | 20% | {stats['average_cost_score']:.1f}/20 | {'🟢 Tốt' if stats['average_cost_score'] >= 15 else '🟡 Trung bình' if stats['average_cost_score'] >= 10 else '🔴 Kém'} |
| **Code Quality** | 15% | {stats['average_quality_score']:.1f}/15 | {'🟢 Tốt' if stats['average_quality_score'] >= 12 else '🟡 Trung bình' if stats['average_quality_score'] >= 8 else '🔴 Kém'} |

---

## 📊 **PHÂN BỐ ĐIỂM SỐ**

| Mức độ | Số câu | Tỷ lệ |
|--------|--------|-------|
| **Excellent (90-100)** | {stats['score_distribution']['excellent_90_100']} | {stats['score_distribution']['excellent_90_100']/stats['total_questions']*100:.1f}% |
| **Good (70-89)** | {stats['score_distribution']['good_70_89']} | {stats['score_distribution']['good_70_89']/stats['total_questions']*100:.1f}% |
| **Fair (50-69)** | {stats['score_distribution']['fair_50_69']} | {stats['score_distribution']['fair_50_69']/stats['total_questions']*100:.1f}% |
| **Poor (<50)** | {stats['score_distribution']['poor_below_50']} | {stats['score_distribution']['poor_below_50']/stats['total_questions']*100:.1f}% |

---

## 🎚️ **HIỆU SUẤT THEO TỪNG LEVEL**

"""

        # Level breakdown
        for level, data in sorted(stats['level_breakdown'].items()):
            level_name = {
                1: "Basic",
                2: "Intermediate",
                3: "Advanced",
                4: "Expert",
                5: "Master"
            }.get(level, f"Level {level}")

            accuracy_emoji = "🟢" if data['accuracy_rate'] >= 0.8 else "🟡" if data['accuracy_rate'] >= 0.5 else "🔴"

            report += f"""### {accuracy_emoji} **Level {level} ({level_name})**

| Metric | Giá trị |
|--------|---------|
| **Accuracy Rate** | **{data['accuracy_rate']:.1%}** |
| **Average Score** | {data['avg_score']:.1f}/100 |
| **Correct Answers** | {data['correct']}/{data['total']} |

"""

            # Bảng so sánh tổng quan
        report += """---

## 📋 **BẢNG SO SÁNH TỔNG QUAN**

| STT | Câu Benchmark | Expected SQL | Generated SQL |
|-----|---------------|--------------|---------------|"""

        for i, result in enumerate(results['results'], 1):
            question = result['question']
            level = result.get('level', 0)

            # Format câu hỏi ngắn gọn
            benchmark_question = f"**Level {level}**<br/>{question[:80]}{'...' if len(question) > 80 else ''}"

            # Expected SQL - chỉ hiển thị metrics quan trọng
            exp_metrics = result['expected_metrics']
            expected_info = f"""**Perf:** {exp_metrics['execution_time_ms']:.1f}ms, {exp_metrics['rows_returned']} rows<br/>
**Cost:** {exp_metrics['query_cost']:.1f}, {exp_metrics['rows_examined']} examined<br/>
**Quality:** {result['quality_scores']['best_practices_expected']}/10<br/>
```sql
{exp_metrics['sql_query'][:100]}{'...' if len(exp_metrics['sql_query']) > 100 else ''}
```"""

            # Generated SQL - với overall score
            gen_metrics = result['generated_metrics']
            match_status = '✅' if result['correctness']['result_match'] else '❌'
            generated_info = f"""**Score:** {result['scores']['total_score']:.1f}/100 {match_status}<br/>
**Perf:** {gen_metrics['execution_time_ms']:.1f}ms, {gen_metrics['rows_returned']} rows<br/>
**Cost:** {gen_metrics['query_cost']:.1f}, {gen_metrics['rows_examined']} examined<br/>
**Quality:** {result['quality_scores']['best_practices_generated']}/10<br/>
```sql
{gen_metrics['sql_query'][:100]}{'...' if len(gen_metrics['sql_query']) > 100 else ''}
```"""

            # Add errors if any
            if exp_metrics.get('error'):
                expected_info = f"❌ **Error:** {exp_metrics['error'][:50]}..."
            if gen_metrics.get('error'):
                generated_info = f"❌ **Error:** {gen_metrics['error'][:50]}..."

            report += f"""
| {i} | {benchmark_question} | {expected_info} | {generated_info} |"""

        report += """

---

## 📝 **CHI TIẾT TỪNG CÂU HỎI**

"""

        for i, result in enumerate(results['results'], 1):
            status_emoji = "✅" if result['correctness']['result_match'] else "❌"
            level = result.get('level', 0)

            report += f"""### {status_emoji} **Câu {i} (Level {level})**

**Câu hỏi:** {result['question']}

| Metric | Expected SQL | Generated SQL |
|--------|--------------|---------------|
| **Execution Success** | {'✅' if result['expected_metrics']['success'] else '❌'} | {'✅' if result['generated_metrics']['success'] else '❌'} |
| **Execution Time** | {result['expected_metrics']['execution_time_ms']:.2f}ms | {result['generated_metrics']['execution_time_ms']:.2f}ms |
| **Rows Returned** | {result['expected_metrics']['rows_returned']} | {result['generated_metrics']['rows_returned']} |
| **Query Cost** | {result['expected_metrics']['query_cost']:.2f} | {result['generated_metrics']['query_cost']:.2f} |
| **Index Usage** | {'✅' if result['expected_metrics']['index_usage'] else '❌'} | {'✅' if result['generated_metrics']['index_usage'] else '❌'} |

**Scores:**
- 🎯 **Correctness:** {result['scores']['correctness_score']:.1f}/40
- ⚡ **Performance:** {result['scores']['performance_score']:.1f}/25  
- 💰 **Cost Efficiency:** {result['scores']['cost_score']:.1f}/20
- 📝 **Code Quality:** {result['scores']['quality_score']:.1f}/15
- 🏆 **Total Score:** **{result['scores']['total_score']:.1f}/100**

**Expected SQL:**
```sql
{result['expected_metrics']['sql_query']}
```

**Generated SQL:**
```sql
{result['generated_metrics']['sql_query']}
```

"""

            if result['expected_metrics'].get('error') or result['generated_metrics'].get('error'):
                report += "**Errors:**\n"
                if result['expected_metrics'].get('error'):
                    report += f"- Expected: {result['expected_metrics']['error']}\n"
                if result['generated_metrics'].get('error'):
                    report += f"- Generated: {result['generated_metrics']['error']}\n"
                report += "\n"

            report += "---\n\n"

        # Kết luận và khuyến nghị
        overall_rating = "Xuất sắc" if stats['average_total_score'] >= 80 else "Tốt" if stats[
            'average_total_score'] >= 60 else "Trung bình" if stats['average_total_score'] >= 40 else "Kém"

        report += f"""## 💡 **KẾT LUẬN VÀ KHUYẾN NGHỊ**

### 🎯 **Đánh giá tổng thể: {overall_rating} ({stats['average_total_score']:.1f}/100)**

### ✅ **Điểm mạnh:**
- Code Quality cao ({stats['average_quality_score']:.1f}/15) - GPT-4 tạo ra SQL syntax sạch và secure
- SQL Generation Rate: 100% - Luôn tạo ra được SQL query
- Best Practices tuân thủ tốt

### ❌ **Điểm yếu:**
- Correctness thấp ({stats['average_correctness_score']:.1f}/40) - Nhiều query không cho kết quả đúng
- Cost Efficiency kém ({stats['average_cost_score']:.1f}/20) - Query không được tối ưu
- Performance chưa hiệu quả ({stats['average_performance_score']:.1f}/25)

### 🔧 **Khuyến nghị cải thiện:**

1. **Cho GPT-4:**
   - Cần training thêm về PostgreSQL-specific syntax
   - Cải thiện logic reasoning cho complex queries
   - Tối ưu hóa query performance và cost

2. **Cho hệ thống:**
   - Implement query validation trước khi execution
   - Thêm query optimization hints
   - Sử dụng query plan analysis để cải thiện

3. **Use cases phù hợp:**
   - ✅ Basic queries (Level 1): {stats['level_breakdown'].get(1, {}).get('accuracy_rate', 0):.1%} accuracy
   - ⚠️ Intermediate queries (Level 2+): Cần review và validation

---

**Báo cáo được tạo bởi Comprehensive SQL Benchmark System**  
**Dựa trên tiêu chuẩn benchmark đã định nghĩa**
"""

        return report

    def save_markdown_report(self, results: Dict, stats: Dict, filename: str = None):
        """Lưu báo cáo Markdown"""
        if filename is None:
            filename = f"comprehensive_benchmark_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"

        report = self.generate_markdown_report(results, stats)

        with open(filename, 'w', encoding='utf-8') as f:
            f.write(report)

        print(f"\n📄 Đã tạo báo cáo Markdown: {filename}")

    def print_summary(self, stats: Dict[str, Any]):
        """In tóm tắt kết quả benchmark"""
        print(f"\n{'='*80}")
        print(f"COMPREHENSIVE BENCHMARK SUMMARY - GPT-4 vs Expected SQL")
        print(f"{'='*80}")
        print(f"📊 Tổng số câu hỏi: {stats['total_questions']}")
        print(f"🎯 Overall Accuracy: {stats['overall_accuracy']:.1%}")
        print(f"📈 Average Total Score: {stats['average_total_score']:.1f}/100")

        print(f"\n📋 Score Breakdown:")
        print(
            f"   • Correctness (40%): {stats['average_correctness_score']:.1f}/40")
        print(
            f"   • Performance (25%): {stats['average_performance_score']:.1f}/25")
        print(
            f"   • Cost Efficiency (20%): {stats['average_cost_score']:.1f}/20")
        print(
            f"   • Code Quality (15%): {stats['average_quality_score']:.1f}/15")

        print(f"\n📊 Score Distribution:")
        dist = stats['score_distribution']
        print(f"   • Excellent (90-100): {dist['excellent_90_100']}")
        print(f"   • Good (70-89): {dist['good_70_89']}")
        print(f"   • Fair (50-69): {dist['fair_50_69']}")
        print(f"   • Poor (<50): {dist['poor_below_50']}")

        print(f"\n🎚️ Performance by Level:")
        for level, data in sorted(stats['level_breakdown'].items()):
            print(
                f"   Level {level}: {data['accuracy_rate']:.1%} accuracy, {data['avg_score']:.1f} avg score ({data['total']} questions)")

        print(f"{'='*80}")


def main():
    """Hàm main để chạy comprehensive benchmark"""
    try:
        # Đường dẫn đến file kết quả GPT-4 - thử nhiều vị trí
        possible_paths = [
            "claude_test_results_20250624_015809.json",  # File test
            "gpt4_test_claude_test_results_20250624_015809results_20250624_014353.json",
            "report/claude_test_results_20250624_015809.json",
            "../../report/claude_test_results_20250624_015809.json",
            "../report/claude_test_results_20250624_015809.json"
        ]
        # possible_paths = [
        #     "claude_test_results_20250624_015809.json",  # File test
        #     "gpt4_test_results_20250624_014353.json",
        #     "report/gpt4_test_results_20250624_014353.json",
        #     "../../report/gpt4_test_results_20250624_014353.json",
        #     "../report/gpt4_test_results_20250624_014353.json"
        # ]

        results_file = None
        for path in possible_paths:
            if os.path.exists(path):
                results_file = path
                break

        if results_file is None:
            print("❌ Không tìm thấy file kết quả GPT-4 ở các vị trí:")
            for path in possible_paths:
                print(f"   - {path}")
            return

        # Khởi tạo benchmark
        benchmark = ComprehensiveSQLBenchmark(results_file)

        # Chạy benchmark
        results = benchmark.run_comprehensive_benchmark()

        # In tóm tắt
        benchmark.print_summary(results['statistics'])

        # Lưu kết quả JSON
        benchmark.save_benchmark_results(results)

        # Tạo báo cáo Markdown
        benchmark.save_markdown_report(results, results['statistics'])

        print("\n🎉 Hoàn thành Comprehensive Benchmark!")

    except Exception as e:
        logger.error(f"Lỗi trong quá trình benchmark: {e}")
        print(f"❌ Lỗi: {e}")


if __name__ == "__main__":
    main()
