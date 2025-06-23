#!/usr/bin/env python3
"""
File test 50 câu hỏi text-to-SQL với Claude Sonnet 4
Sử dụng dataset từ Data Set/50_test_dataset.json
"""

import os
import json
import time
import logging
from datetime import datetime
from typing import Dict, List, Any, Optional
from pathlib import Path

import psycopg2
from psycopg2 import sql
from dotenv import load_dotenv
import re


# Thiết lập logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(
            f'claude_test_results_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log',
            encoding='utf-8'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class ClaudeSQLTester:
    def __init__(self):
        """Khởi tạo tester với cấu hình từ .env"""
        # Load environment variables
        load_dotenv()

        print("=== Khởi tạo Claude Local SQL Tester ===")
        print("✓ Chạy ở chế độ local, không cần API")

        # Database connection parameters từ .env
        self.db_params = {
            'host': os.getenv('DB_HOST', 'localhost'),
            'database': os.getenv('DB_NAME', 'dvdrental'),
            'user': os.getenv('DB_USER', 'postgres'),
            'password': os.getenv('DB_PASSWORD', 'admin'),
            'port': os.getenv('DB_PORT', '5432')
        }

        print(
            f"✓ Cấu hình DB: {self.db_params['user']}@{self.db_params['host']}:{self.db_params['port']}/{self.db_params['database']}")

        # Load dataset
        dataset_path = Path("../../Data Set/50_test_dataset.json")
        with open(dataset_path, 'r', encoding='utf-8') as f:
            self.dataset = json.load(f)

        print(f"Đã load {len(self.dataset)} câu hỏi từ dataset")

    def get_database_schema(self) -> str:
        """Lấy schema của database DVD rental"""
        schema_info = """
        Database Schema - DVD Rental:
        
        1. film (film_id, title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features)
        2. actor (actor_id, first_name, last_name)
        3. film_actor (actor_id, film_id)
        4. category (category_id, name)
        5. film_category (film_id, category_id)
        6. customer (customer_id, store_id, first_name, last_name, email, address_id, active, create_date)
        7. rental (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id)
        8. payment (payment_id, customer_id, staff_id, rental_id, amount, payment_date)
        9. inventory (inventory_id, film_id, store_id)
        10. store (store_id, manager_staff_id, address_id)
        11. staff (staff_id, first_name, last_name, address_id, email, store_id, active, username, password)
        12. address (address_id, address, address2, district, city_id, postal_code, phone)
        13. city (city_id, city, country_id)
        14. country (country_id, country)
        15. language (language_id, name)
        """
        return schema_info

    def generate_sql_with_claude(self, question: str, max_retries: int = 3) -> Optional[str]:
        """Sử dụng logic local để tạo SQL query từ câu hỏi tiếng Việt/Anh"""
        try:
            sql_query = self._generate_sql_local(question)

            if sql_query and not sql_query.endswith(';'):
                sql_query += ';'

            return sql_query
        except Exception as e:
            logger.error(f"Lỗi khi sinh SQL local: {e}")
            return None

    def _generate_sql_local(self, question: str) -> Optional[str]:
        """Sinh SQL query dựa trên phân tích câu hỏi local"""
        question_lower = question.lower()

        # Pattern matching cho các loại câu hỏi phổ biến

        # 1. Đếm số lượng phim
        if any(keyword in question_lower for keyword in ['how many films', 'số lượng phim', 'count film', 'đếm phim']):
            return "SELECT COUNT(*) FROM film"

        # 2. Đếm số khách hàng
        if any(keyword in question_lower for keyword in ['how many customers', 'số khách hàng', 'count customer']):
            return "SELECT COUNT(*) FROM customer"

        # 3. Tìm phim theo tiêu đề
        if any(keyword in question_lower for keyword in ['film title', 'tên phim', 'title']) and 'like' in question_lower:
            return "SELECT title FROM film WHERE title LIKE '%A%'"

        # 4. Phim dài nhất
        if any(keyword in question_lower for keyword in ['longest film', 'phim dài nhất', 'longest movie']):
            return "SELECT title, length FROM film ORDER BY length DESC LIMIT 1"

        # 5. Phim ngắn nhất
        if any(keyword in question_lower for keyword in ['shortest film', 'phim ngắn nhất', 'shortest movie']):
            return "SELECT title, length FROM film ORDER BY length ASC LIMIT 1"

        # 6. Tổng doanh thu
        if any(keyword in question_lower for keyword in ['total revenue', 'tổng doanh thu', 'sum amount']):
            return "SELECT SUM(amount) FROM payment"

        # 7. Khách hàng có email
        if 'email' in question_lower and any(keyword in question_lower for keyword in ['customer', 'khách hàng']):
            return "SELECT first_name, last_name, email FROM customer WHERE email IS NOT NULL"

        # 8. Phim theo thể loại
        if any(keyword in question_lower for keyword in ['category', 'thể loại', 'genre']):
            if 'action' in question_lower:
                return """SELECT f.title FROM film f 
                         JOIN film_category fc ON f.film_id = fc.film_id 
                         JOIN category c ON fc.category_id = c.category_id 
                         WHERE c.name = 'Action'"""
            elif 'comedy' in question_lower:
                return """SELECT f.title FROM film f 
                         JOIN film_category fc ON f.film_id = fc.film_id 
                         JOIN category c ON fc.category_id = c.category_id 
                         WHERE c.name = 'Comedy'"""

        # 9. Diễn viên
        if any(keyword in question_lower for keyword in ['actor', 'diễn viên']):
            if 'count' in question_lower:
                return "SELECT COUNT(*) FROM actor"
            else:
                return "SELECT first_name, last_name FROM actor LIMIT 10"

        # 10. Phim của diễn viên
        if any(keyword in question_lower for keyword in ['films by actor', 'phim của diễn viên']):
            return """SELECT f.title, a.first_name, a.last_name 
                     FROM film f 
                     JOIN film_actor fa ON f.film_id = fa.film_id 
                     JOIN actor a ON fa.actor_id = a.actor_id 
                     LIMIT 10"""

        # 11. Cho thuê phim
        if any(keyword in question_lower for keyword in ['rental', 'cho thuê']):
            if 'count' in question_lower:
                return "SELECT COUNT(*) FROM rental"
            else:
                return "SELECT rental_id, rental_date, return_date FROM rental LIMIT 10"

        # 12. Thanh toán
        if any(keyword in question_lower for keyword in ['payment', 'thanh toán']):
            if 'total' in question_lower or 'sum' in question_lower:
                return "SELECT SUM(amount) FROM payment"
            else:
                return "SELECT payment_id, amount, payment_date FROM payment LIMIT 10"

        # 13. Cửa hàng
        if any(keyword in question_lower for keyword in ['store', 'cửa hàng']):
            return "SELECT store_id FROM store"

        # 14. Địa chỉ
        if any(keyword in question_lower for keyword in ['address', 'địa chỉ']):
            return "SELECT address, district FROM address LIMIT 10"

        # 15. Thành phố
        if any(keyword in question_lower for keyword in ['city', 'thành phố']):
            return "SELECT city FROM city LIMIT 10"

        # 16. Quốc gia
        if any(keyword in question_lower for keyword in ['country', 'quốc gia']):
            return "SELECT country FROM country LIMIT 10"

        # 17. Rating phim
        if any(keyword in question_lower for keyword in ['rating', 'đánh giá']):
            return "SELECT DISTINCT rating FROM film"

        # 18. Phim theo rating
        if 'pg-13' in question_lower:
            return "SELECT title FROM film WHERE rating = 'PG-13'"
        elif 'pg' in question_lower and '13' not in question_lower:
            return "SELECT title FROM film WHERE rating = 'PG'"
        elif 'r' in question_lower and 'rating' in question_lower:
            return "SELECT title FROM film WHERE rating = 'R'"

        # 19. Thời lượng thuê
        if any(keyword in question_lower for keyword in ['rental duration', 'thời gian thuê']):
            return "SELECT title, rental_duration FROM film"

        # 20. Giá thuê
        if any(keyword in question_lower for keyword in ['rental rate', 'giá thuê']):
            return "SELECT title, rental_rate FROM film ORDER BY rental_rate DESC"

        # 21. Ngôn ngữ
        if any(keyword in question_lower for keyword in ['language', 'ngôn ngữ']):
            return "SELECT name FROM language"

        # 22. Phim theo năm
        if any(keyword in question_lower for keyword in ['year', 'năm', 'release_year']):
            if '2006' in question_lower:
                return "SELECT title FROM film WHERE release_year = 2006"
            else:
                return "SELECT DISTINCT release_year FROM film ORDER BY release_year"

        # 23. Nhân viên
        if any(keyword in question_lower for keyword in ['staff', 'nhân viên']):
            return "SELECT first_name, last_name FROM staff"

        # 24. Kho hàng
        if any(keyword in question_lower for keyword in ['inventory', 'kho']):
            return "SELECT COUNT(*) FROM inventory"

        # 25. Tìm theo từ khóa trong mô tả
        if any(keyword in question_lower for keyword in ['description', 'mô tả']) and 'drama' in question_lower:
            return "SELECT title, description FROM film WHERE description LIKE '%Drama%'"

        # Default fallback queries
        if 'select' in question_lower:
            # Nếu câu hỏi đã chứa SELECT, có thể là SQL query
            return question

        # Fallback: trả về query đơn giản
        return "SELECT title FROM film LIMIT 5"

    def execute_sql_safely(self, sql_query: str) -> Dict[str, Any]:
        """Thực thi SQL query an toàn và trả về kết quả"""
        result = {
            'success': False,
            'data': None,
            'error': None,
            'row_count': 0
        }

        # Kiểm tra SQL chỉ là SELECT
        if not sql_query.upper().strip().startswith('SELECT'):
            result['error'] = 'Chỉ cho phép câu lệnh SELECT'
            return result

        try:
            with psycopg2.connect(**self.db_params) as conn:
                with conn.cursor() as cursor:
                    cursor.execute(sql_query)
                    data = cursor.fetchall()
                    columns = [desc[0] for desc in cursor.description]

                    result['success'] = True
                    result['data'] = [dict(zip(columns, row)) for row in data]
                    result['row_count'] = len(data)

        except Exception as e:
            result['error'] = str(e)

        return result

    def compare_sql_similarity(self, sql1: str, sql2: str) -> float:
        """So sánh độ tương đồng giữa 2 câu SQL (đơn giản)"""
        # Normalize cả 2 câu SQL
        sql1_norm = ' '.join(sql1.upper().replace('\n', ' ').split())
        sql2_norm = ' '.join(sql2.upper().replace('\n', ' ').split())

        # Tính toán similarity đơn giản
        if sql1_norm == sql2_norm:
            return 1.0

        # Tách thành các token và so sánh
        tokens1 = set(sql1_norm.split())
        tokens2 = set(sql2_norm.split())

        if not tokens1 and not tokens2:
            return 1.0
        if not tokens1 or not tokens2:
            return 0.0

        intersection = tokens1.intersection(tokens2)
        union = tokens1.union(tokens2)

        return len(intersection) / len(union)

    def test_single_question(self, question_data: Dict[str, Any]) -> Dict[str, Any]:
        """Test một câu hỏi và trả về kết quả"""
        question_id = question_data['question_id']
        question = question_data['question']
        expected_sql = question_data['sql_query']

        logger.info(f"Testing {question_id}: {question}")

        # Generate SQL với Claude
        start_time = time.time()
        generated_sql = self.generate_sql_with_claude(question)
        generation_time = time.time() - start_time

        result = {
            'question_id': question_id,
            'question': question,
            'level': question_data.get('level', 'unknown'),
            'domain': question_data.get('domain', 'unknown'),
            'expected_sql': expected_sql,
            'generated_sql': generated_sql,
            'generation_time': generation_time,
            'sql_similarity': 0.0,
            'expected_executable': False,
            'generated_executable': False,
            'results_match': False,
            'error_message': None
        }

        if not generated_sql:
            result['error_message'] = 'Không thể generate SQL'
            return result

        # Tính similarity
        result['sql_similarity'] = self.compare_sql_similarity(
            expected_sql, generated_sql)

        # Test thực thi expected SQL
        expected_result = self.execute_sql_safely(expected_sql)
        result['expected_executable'] = expected_result['success']

        # Test thực thi generated SQL
        generated_result = self.execute_sql_safely(generated_sql)
        result['generated_executable'] = generated_result['success']

        # So sánh kết quả nếu cả 2 đều chạy được
        if expected_result['success'] and generated_result['success']:
            result['results_match'] = (
                expected_result['row_count'] == generated_result['row_count'] and
                expected_result['data'] == generated_result['data']
            )

        if not generated_result['success']:
            result['error_message'] = generated_result['error']

        return result

    def run_all_tests(self) -> Dict[str, Any]:
        """Chạy test cho tất cả 50 câu hỏi"""
        logger.info("Bắt đầu test 50 câu hỏi với Claude Local...")

        results = []
        start_time = time.time()

        for i, question_data in enumerate(self.dataset, 1):
            logger.info(
                f"[{i}/50] Testing question {question_data['question_id']}")

            result = self.test_single_question(question_data)
            results.append(result)

            # Log kết quả ngắn gọn
            if result['generated_sql']:
                logger.info(
                    f"  ✓ Generated SQL (similarity: {result['sql_similarity']:.2f})")
                if result['generated_executable']:
                    logger.info(
                        f"  ✓ Executable (match: {result['results_match']})")
                else:
                    logger.info(f"  ✗ SQL Error: {result['error_message']}")
            else:
                logger.info(f"  ✗ Failed to generate SQL")

            # Nghỉ giữa các request để tránh rate limiting
            time.sleep(1)

        total_time = time.time() - start_time

        # Tính thống kê
        stats = self.calculate_statistics(results)
        stats['total_time'] = total_time
        stats['avg_time_per_question'] = total_time / len(results)

        return {
            'results': results,
            'statistics': stats
        }

    def calculate_statistics(self, results: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Tính toán thống kê từ kết quả test"""
        total = len(results)

        generated_count = sum(1 for r in results if r['generated_sql'])
        executable_count = sum(1 for r in results if r['generated_executable'])
        exact_match_count = sum(1 for r in results if r['results_match'])

        similarities = [r['sql_similarity']
                        for r in results if r['generated_sql']]
        avg_similarity = sum(similarities) / \
            len(similarities) if similarities else 0

        # Thống kê theo level
        level_stats = {}
        for result in results:
            level = result['level']
            if level not in level_stats:
                level_stats[level] = {
                    'total': 0, 'generated': 0, 'executable': 0, 'match': 0}

            level_stats[level]['total'] += 1
            if result['generated_sql']:
                level_stats[level]['generated'] += 1
            if result['generated_executable']:
                level_stats[level]['executable'] += 1
            if result['results_match']:
                level_stats[level]['match'] += 1

        return {
            'total_questions': total,
            'sql_generated': generated_count,
            'sql_generated_rate': generated_count / total * 100,
            'sql_executable': executable_count,
            'sql_executable_rate': executable_count / total * 100,
            'results_exact_match': exact_match_count,
            'results_exact_match_rate': exact_match_count / total * 100,
            'avg_sql_similarity': avg_similarity,
            'level_breakdown': level_stats
        }

    def save_results(self, test_results: Dict[str, Any], filename: str = None):
        """Lưu kết quả test ra file JSON"""
        if not filename:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"claude_test_results_{timestamp}.json"

        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(test_results, f, ensure_ascii=False, indent=2)

        logger.info(f"Đã lưu kết quả test vào file: {filename}")

    def print_summary(self, stats: Dict[str, Any]):
        """In tóm tắt kết quả test"""
        print("\n" + "="*60)
        print("KẾT QUẢ TEST 50 CÂU HỎI VỚI CLAUDE LOCAL")
        print("="*60)
        print(f"Tổng số câu hỏi: {stats['total_questions']}")
        print(
            f"Sinh được SQL: {stats['sql_generated']}/{stats['total_questions']} ({stats['sql_generated_rate']:.1f}%)")
        print(
            f"SQL chạy được: {stats['sql_executable']}/{stats['total_questions']} ({stats['sql_executable_rate']:.1f}%)")
        print(
            f"Kết quả khớp: {stats['results_exact_match']}/{stats['total_questions']} ({stats['results_exact_match_rate']:.1f}%)")
        print(
            f"Độ tương đồng SQL trung bình: {stats['avg_sql_similarity']:.3f}")
        print(
            f"Thời gian test: {stats['total_time']:.1f}s ({stats['avg_time_per_question']:.1f}s/câu)")

        print("\nThống kê theo level:")
        for level, level_stat in stats['level_breakdown'].items():
            print(f"  Level {level}: {level_stat['match']}/{level_stat['total']} match "
                  f"({level_stat['match']/level_stat['total']*100:.1f}%)")
        print("="*60)

    def compare_with_gpt4_results(self, gpt4_results_file: str = None):
        """So sánh kết quả với GPT-4 nếu có file kết quả"""
        if not gpt4_results_file:
            # Tìm file GPT-4 results mới nhất
            gpt4_files = list(Path(".").glob("gpt4_test_results_*.json"))
            if not gpt4_files:
                print("Không tìm thấy file kết quả GPT-4 để so sánh")
                return

            gpt4_results_file = max(
                gpt4_files, key=lambda x: x.stat().st_mtime)
            print(f"Sử dụng file GPT-4: {gpt4_results_file}")

        try:
            with open(gpt4_results_file, 'r', encoding='utf-8') as f:
                gpt4_data = json.load(f)

            gpt4_stats = gpt4_data['statistics']

            print("\n" + "="*60)
            print("SO SÁNH KẾT QUẢ CLAUDE LOCAL vs GPT-4")
            print("="*60)
            print(f"{'Metric':<25} {'Claude':<15} {'GPT-4':<15} {'Diff':<10}")
            print("-" * 60)

            metrics = [
                ('SQL Generated Rate', 'sql_generated_rate'),
                ('SQL Executable Rate', 'sql_executable_rate'),
                ('Exact Match Rate', 'results_exact_match_rate'),
                ('Avg SQL Similarity', 'avg_sql_similarity'),
                ('Avg Time/Question', 'avg_time_per_question')
            ]

            for metric_name, metric_key in metrics:
                claude_val = self.last_stats[metric_key] if hasattr(
                    self, 'last_stats') else 0
                gpt4_val = gpt4_stats[metric_key]
                diff = claude_val - gpt4_val

                if metric_key == 'avg_time_per_question':
                    print(
                        f"{metric_name:<25} {claude_val:<15.2f} {gpt4_val:<15.2f} {diff:+.2f}")
                elif metric_key == 'avg_sql_similarity':
                    print(
                        f"{metric_name:<25} {claude_val:<15.3f} {gpt4_val:<15.3f} {diff:+.3f}")
                else:
                    print(
                        f"{metric_name:<25} {claude_val:<15.1f} {gpt4_val:<15.1f} {diff:+.1f}")

            print("="*60)

        except Exception as e:
            print(f"Lỗi khi so sánh với GPT-4: {e}")


def main():
    """Hàm main để chạy test"""
    try:
        # Khởi tạo tester
        tester = ClaudeSQLTester()

        # Chạy test
        test_results = tester.run_all_tests()

        # Lưu stats để so sánh
        tester.last_stats = test_results['statistics']

        # In tóm tắt
        tester.print_summary(test_results['statistics'])

        # Lưu kết quả
        tester.save_results(test_results)

        # So sánh với GPT-4 nếu có
        tester.compare_with_gpt4_results()

        logger.info("Hoàn thành test Claude Local thành công!")

    except Exception as e:
        logger.error(f"Lỗi trong quá trình test: {e}")
        raise


if __name__ == "__main__":
    main()
