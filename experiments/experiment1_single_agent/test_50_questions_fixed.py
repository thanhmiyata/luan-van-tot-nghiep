#!/usr/bin/env python3
"""
File test 50 câu hỏi text-to-SQL với GPT-4
Sử dụng dataset từ Data Set/50_test_dataset.json
"""

import os
import json
import time
import logging
from datetime import datetime
from typing import Dict, List, Any, Optional
from pathlib import Path

import openai
import psycopg2
from psycopg2 import sql
from dotenv import load_dotenv


# Thiết lập logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(
            f'test_results_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log',
            encoding='utf-8'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class GPT4SQLTester:
    def __init__(self):
        """Khởi tạo tester với cấu hình từ .env"""
        # Load environment variables
        load_dotenv()

        print("=== Khởi tạo GPT-4 SQL Tester ===")

        # Lấy API key từ .env
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise ValueError("Không tìm thấy OPENAI_API_KEY trong file .env")

        # Thiết lập OpenAI API
        self.client = openai.OpenAI(api_key=api_key)
        print("✓ Đã kết nối OpenAI API")

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

    def generate_sql_with_gpt4(self, question: str, max_retries: int = 3) -> Optional[str]:
        """Sử dụng GPT-4 để tạo SQL query từ câu hỏi tiếng Việt/Anh"""
        schema = self.get_database_schema()

        prompt = f"""
        Bạn là một chuyên gia SQL. Dựa vào schema database DVD Rental dưới đây, hãy viết câu lệnh SQL chính xác cho câu hỏi được đưa ra.

        {schema}

        Câu hỏi: {question}

        Yêu cầu:
        - Chỉ trả về câu lệnh SQL, không giải thích
        - SQL phải chính xác và có thể chạy được
        - Sử dụng tên cột và bảng chính xác theo schema
        - Nếu cần JOIN, hãy sử dụng đúng khóa ngoại
        - Với câu hỏi tiếng Việt, hiểu đúng ý nghĩa và viết SQL tương ứng

        SQL:
        """

        for attempt in range(max_retries):
            try:
                response = self.client.chat.completions.create(
                    model="gpt-4",
                    messages=[
                        {"role": "system",
                            "content": "Bạn là chuyên gia SQL cho DVD rental database."},
                        {"role": "user", "content": prompt}
                    ],
                    max_tokens=500,
                    temperature=0.1
                )

                sql_query = response.choices[0].message.content.strip()

                # Làm sạch SQL query
                if sql_query.startswith("```sql"):
                    sql_query = sql_query[6:]
                if sql_query.startswith("```"):
                    sql_query = sql_query[3:]
                if sql_query.endswith("```"):
                    sql_query = sql_query[:-3]

                sql_query = sql_query.strip()
                if not sql_query.endswith(';'):
                    sql_query += ';'

                return sql_query

            except Exception as e:
                logger.error(f"Lỗi GPT-4 (lần {attempt + 1}): {e}")
                if attempt < max_retries - 1:
                    time.sleep(2)
                else:
                    return None

        return None

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

        # Generate SQL với GPT-4
        start_time = time.time()
        generated_sql = self.generate_sql_with_gpt4(question)
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
        logger.info("Bắt đầu test 50 câu hỏi với GPT-4...")

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
            filename = f"gpt4_test_results_{timestamp}.json"

        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(test_results, f, ensure_ascii=False, indent=2)

        logger.info(f"Đã lưu kết quả test vào file: {filename}")

    def print_summary(self, stats: Dict[str, Any]):
        """In tóm tắt kết quả test"""
        print("\n" + "="*60)
        print("KẾT QUẢ TEST 50 CÂU HỎI VỚI GPT-4")
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


def main():
    """Hàm main để chạy test"""
    try:
        # Khởi tạo tester
        tester = GPT4SQLTester()

        # Chạy test
        test_results = tester.run_all_tests()

        # In tóm tắt
        tester.print_summary(test_results['statistics'])

        # Lưu kết quả
        tester.save_results(test_results)

        logger.info("Hoàn thành test thành công!")

    except Exception as e:
        logger.error(f"Lỗi trong quá trình test: {e}")
        raise


if __name__ == "__main__":
    main()
