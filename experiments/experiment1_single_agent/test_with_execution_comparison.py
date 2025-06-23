#!/usr/bin/env python3
"""
Test SQL generation với phương pháp đánh giá dựa trên thực thi
So sánh kết quả thực thi thay vì so sánh chuỗi SQL
"""

import os
import json
import time
import logging
from datetime import datetime
from typing import Dict, List, Any, Optional
from pathlib import Path
import hashlib

import openai
import psycopg2
from dotenv import load_dotenv

# Thiết lập logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(
            f'execution_test_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log', encoding='utf-8'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class ExecutionBasedSQLTester:
    def __init__(self):
        load_dotenv()

        print("=== Khởi tạo Execution-Based SQL Tester ===")

        # Thiết lập OpenAI
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise ValueError("Không tìm thấy OPENAI_API_KEY trong file .env")

        self.client = openai.OpenAI(api_key=api_key)
        print("✓ Đã kết nối OpenAI API")

        # Cấu hình database
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
        return """
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

    def generate_sql_with_gpt4(self, question: str, max_retries: int = 3) -> Optional[str]:
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

        return None

    def execute_sql_safely(self, sql_query: str) -> Dict[str, Any]:
        """Thực thi SQL và trả về kết quả"""
        result = {
            'success': False,
            'data': None,
            'error': None,
            'row_count': 0,
            'result_hash': None
        }

        if not sql_query.upper().strip().startswith('SELECT'):
            result['error'] = 'Chỉ cho phép câu lệnh SELECT'
            return result

        try:
            with psycopg2.connect(**self.db_params) as conn:
                with conn.cursor() as cursor:
                    cursor.execute(sql_query)
                    data = cursor.fetchall()
                    columns = [desc[0] for desc in cursor.description]

                    result_data = [dict(zip(columns, row)) for row in data]
                    result_hash = self._create_result_hash(result_data)

                    result['success'] = True
                    result['data'] = result_data
                    result['row_count'] = len(data)
                    result['result_hash'] = result_hash

        except Exception as e:
            result['error'] = str(e)

        return result

    def _create_result_hash(self, data: List[Dict]) -> str:
        """Tạo hash từ kết quả để so sánh"""
        if not data:
            return hashlib.md5("EMPTY_RESULT".encode()).hexdigest()

        # Sắp xếp data theo thứ tự nhất quán
        sorted_data = sorted(data, key=lambda x: str(sorted(x.items())))

        # Chuyển thành string và hash
        data_str = json.dumps(sorted_data, sort_keys=True, default=str)
        return hashlib.md5(data_str.encode()).hexdigest()

    def compare_execution_results(self, expected_result: Dict, generated_result: Dict) -> Dict[str, Any]:
        """So sánh kết quả thực thi của 2 SQL queries"""
        comparison = {
            'results_match': False,
            'both_successful': False,
            'row_count_match': False,
            'content_match': False,
            'error_details': []
        }

        if expected_result['success'] and generated_result['success']:
            comparison['both_successful'] = True

            if expected_result['row_count'] == generated_result['row_count']:
                comparison['row_count_match'] = True

            if expected_result['result_hash'] == generated_result['result_hash']:
                comparison['content_match'] = True
                comparison['results_match'] = True
            else:
                comparison['error_details'].append(f"Nội dung khác nhau")

        elif not expected_result['success'] and not generated_result['success']:
            comparison['both_successful'] = False
            comparison['error_details'].append(f"Cả 2 đều lỗi")

        else:
            if expected_result['success']:
                comparison['error_details'].append(
                    f"Expected thành công nhưng Generated lỗi: {generated_result['error']}")
            else:
                comparison['error_details'].append(
                    f"Expected lỗi nhưng Generated thành công")

        return comparison

    def test_single_question(self, question_data: Dict[str, Any]) -> Dict[str, Any]:
        """Test một câu hỏi với phương pháp execution-based"""
        question = question_data['question']
        expected_sql = question_data['sql']

        logger.info(f"Testing: {question}")

        result = {
            'question': question,
            'expected_sql': expected_sql,
            'generated_sql': None,
            'execution_match': False,
            'expected_execution': None,
            'generated_execution': None,
            'comparison_details': None,
            'processing_time': 0,
            'status': 'failed'
        }

        start_time = time.time()

        try:
            # 1. Generate SQL với GPT-4
            generated_sql = self.generate_sql_with_gpt4(question)
            result['generated_sql'] = generated_sql

            if not generated_sql:
                result['status'] = 'generation_failed'
                return result

            # 2. Thực thi expected SQL
            logger.info(f"Thực thi Expected SQL: {expected_sql}")
            expected_execution = self.execute_sql_safely(expected_sql)
            result['expected_execution'] = expected_execution

            # 3. Thực thi generated SQL
            logger.info(f"Thực thi Generated SQL: {generated_sql}")
            generated_execution = self.execute_sql_safely(generated_sql)
            result['generated_execution'] = generated_execution

            # 4. So sánh kết quả thực thi
            comparison = self.compare_execution_results(
                expected_execution, generated_execution)
            result['comparison_details'] = comparison
            result['execution_match'] = comparison['results_match']

            # 5. Xác định status
            if result['execution_match']:
                result['status'] = 'execution_match'
            elif comparison['both_successful']:
                result['status'] = 'execution_different'
            else:
                result['status'] = 'execution_error'

        except Exception as e:
            logger.error(f"Lỗi khi test câu hỏi: {e}")
            result['status'] = 'test_error'
            result['error'] = str(e)

        finally:
            result['processing_time'] = time.time() - start_time

        return result

    def run_all_tests(self) -> Dict[str, Any]:
        """Chạy test tất cả câu hỏi trong dataset"""
        print(
            f"\n=== Bắt đầu test {len(self.dataset)} câu hỏi với Execution-Based Method ===")

        results = []
        start_time = time.time()

        for i, question_data in enumerate(self.dataset, 1):
            print(f"\n--- Test {i}/{len(self.dataset)} ---")
            result = self.test_single_question(question_data)
            results.append(result)

            # Log kết quả ngắn gọn
            status = result['status']
            if result['execution_match']:
                print(f"✓ PASS (Execution Match)")
            elif status == 'execution_different':
                print(f"~ PARTIAL (Different Results)")
            else:
                print(f"✗ FAIL ({status})")

        # Tính toán thống kê
        stats = self.calculate_statistics(results)

        test_results = {
            'test_info': {
                'total_questions': len(self.dataset),
                'completion_time': time.time() - start_time,
                'timestamp': datetime.now().isoformat(),
                'method': 'execution_based'
            },
            'results': results,
            'statistics': stats
        }

        return test_results

    def calculate_statistics(self, results: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Tính toán thống kê từ kết quả test"""
        total = len(results)

        execution_matches = sum(1 for r in results if r['execution_match'])
        generation_failures = sum(
            1 for r in results if r['status'] == 'generation_failed')
        execution_errors = sum(1 for r in results if r['status'] in [
                               'execution_error', 'test_error'])
        execution_different = sum(
            1 for r in results if r['status'] == 'execution_different')

        processing_times = [r['processing_time']
                            for r in results if 'processing_time' in r]
        avg_time = sum(processing_times) / \
            len(processing_times) if processing_times else 0

        stats = {
            'total_questions': total,
            'execution_matches': execution_matches,
            'execution_match_rate': execution_matches / total if total > 0 else 0,
            'generation_failures': generation_failures,
            'execution_errors': execution_errors,
            'execution_different': execution_different,
            'average_processing_time': avg_time,
            'status_breakdown': {
                'execution_match': execution_matches,
                'execution_different': execution_different,
                'generation_failed': generation_failures,
                'execution_error': execution_errors
            }
        }

        return stats

    def save_results(self, test_results: Dict[str, Any], filename: str = None):
        """Lưu kết quả test ra file JSON"""
        if filename is None:
            filename = f"execution_test_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"

        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(test_results, f, ensure_ascii=False,
                      indent=2, default=str)

        print(f"Đã lưu kết quả chi tiết vào: {filename}")

    def print_summary(self, stats: Dict[str, Any]):
        """In tóm tắt kết quả test"""
        print(f"\n{'='*60}")
        print(f"TỔNG KẾT KẾT QUẢ TEST (EXECUTION-BASED)")
        print(f"{'='*60}")
        print(f"Tổng số câu hỏi: {stats['total_questions']}")
        print(
            f"Kết quả thực thi khớp: {stats['execution_matches']}/{stats['total_questions']} ({stats['execution_match_rate']:.1%})")
        print(f"Kết quả khác nhau: {stats['execution_different']}")
        print(f"Lỗi generation: {stats['generation_failures']}")
        print(f"Lỗi execution: {stats['execution_errors']}")
        print(
            f"Thời gian xử lý trung bình: {stats['average_processing_time']:.2f}s")
        print(f"{'='*60}")

    def analyze_failed_cases(self, results: List[Dict[str, Any]]) -> None:
        """Phân tích các trường hợp fail để hiểu lý do"""
        print(f"\n{'='*60}")
        print(f"PHÂN TÍCH CÁC TRƯỜNG HỢP KHÔNG KHỚP (TOP 5)")
        print(f"{'='*60}")

        failed_cases = [r for r in results if not r['execution_match']]

        for i, case in enumerate(failed_cases[:5], 1):
            print(f"\n--- Case {i} ---")
            print(f"Câu hỏi: {case['question']}")
            print(f"Expected SQL: {case['expected_sql']}")
            print(f"Generated SQL: {case['generated_sql']}")
            print(f"Status: {case['status']}")

            if case.get('comparison_details'):
                details = case['comparison_details']
                print(f"Both successful: {details['both_successful']}")
                print(f"Row count match: {details['row_count_match']}")
                if details['error_details']:
                    print(
                        f"Error details: {'; '.join(details['error_details'])}")
            print("-" * 40)


def main():
    """Hàm main để chạy test"""
    try:
        tester = ExecutionBasedSQLTester()

        # Chạy test
        test_results = tester.run_all_tests()

        # In tóm tắt
        tester.print_summary(test_results['statistics'])

        # Phân tích failed cases
        tester.analyze_failed_cases(test_results['results'])

        # Lưu kết quả
        tester.save_results(test_results)

        print("\n🎉 Hoàn thành test execution-based!")

    except Exception as e:
        logger.error(f"Lỗi trong quá trình test: {e}")
        print(f"❌ Lỗi: {e}")


if __name__ == "__main__":
    main()
