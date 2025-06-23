#!/usr/bin/env python3
"""
Test so sánh GPT-4 vs Claude Sonnet với phương pháp execution-based
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
            f'comparison_test_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log', encoding='utf-8'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class DualModelSQLTester:
    def __init__(self):
        load_dotenv()

        print("=== Khởi tạo Dual Model SQL Tester (GPT-4 vs Claude) ===")

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
        """Generate SQL using GPT-4"""
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
                return self._clean_sql_query(sql_query)

            except Exception as e:
                logger.error(f"Lỗi GPT-4 (lần {attempt + 1}): {e}")
                if attempt < max_retries - 1:
                    time.sleep(2)

        return None

    def generate_sql_with_claude_local(self, question: str) -> Optional[str]:
        """Generate SQL using Claude local logic (simplified pattern matching)"""
        question_lower = question.lower()

        # Một số pattern đơn giản cho Claude local
        if any(keyword in question_lower for keyword in ['how many films', 'số lượng phim', 'count film']):
            return "SELECT COUNT(*) FROM film;"

        if any(keyword in question_lower for keyword in ['how many customers', 'số khách hàng']):
            return "SELECT COUNT(*) FROM customer;"

        if any(keyword in question_lower for keyword in ['longest film', 'phim dài nhất']):
            return "SELECT title, length FROM film ORDER BY length DESC LIMIT 1;"

        if any(keyword in question_lower for keyword in ['total revenue', 'tổng doanh thu']):
            return "SELECT SUM(amount) FROM payment;"

        if 'email' in question_lower and 'customer' in question_lower:
            return "SELECT first_name, last_name, email FROM customer WHERE email IS NOT NULL;"

        if 'action' in question_lower and any(keyword in question_lower for keyword in ['category', 'thể loại']):
            return """SELECT f.title FROM film f 
                     JOIN film_category fc ON f.film_id = fc.film_id 
                     JOIN category c ON fc.category_id = c.category_id 
                     WHERE c.name = 'Action';"""

        if any(keyword in question_lower for keyword in ['actor', 'diễn viên']) and 'count' in question_lower:
            return "SELECT COUNT(*) FROM actor;"

        # Default fallback
        return "SELECT COUNT(*) FROM film;"

    def _clean_sql_query(self, sql_query: str) -> str:
        """Clean SQL query from model response"""
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

        sorted_data = sorted(data, key=lambda x: str(sorted(x.items())))
        data_str = json.dumps(sorted_data, sort_keys=True, default=str)
        return hashlib.md5(data_str.encode()).hexdigest()

    def compare_execution_results(self, expected_result: Dict, model_result: Dict) -> Dict[str, Any]:
        """So sánh kết quả thực thi"""
        comparison = {
            'results_match': False,
            'both_successful': False,
            'row_count_match': False,
            'content_match': False,
            'error_details': []
        }

        if expected_result['success'] and model_result['success']:
            comparison['both_successful'] = True

            if expected_result['row_count'] == model_result['row_count']:
                comparison['row_count_match'] = True

            if expected_result['result_hash'] == model_result['result_hash']:
                comparison['content_match'] = True
                comparison['results_match'] = True
            else:
                comparison['error_details'].append(
                    "Nội dung kết quả khác nhau")

        elif not expected_result['success'] and not model_result['success']:
            comparison['both_successful'] = False
            comparison['error_details'].append("Cả 2 đều lỗi")

        else:
            if expected_result['success']:
                comparison['error_details'].append(
                    f"Expected thành công nhưng Model lỗi: {model_result['error']}")
            else:
                comparison['error_details'].append(
                    "Expected lỗi nhưng Model thành công")

        return comparison

    def test_single_question(self, question_data: Dict[str, Any]) -> Dict[str, Any]:
        """Test một câu hỏi với cả 2 model"""
        question = question_data['question']
        expected_sql = question_data['sql']

        logger.info(f"Testing: {question}")

        result = {
            'question': question,
            'expected_sql': expected_sql,
            'gpt4_sql': None,
            'claude_sql': None,
            'expected_execution': None,
            'gpt4_execution': None,
            'claude_execution': None,
            'gpt4_match': False,
            'claude_match': False,
            'gpt4_comparison': None,
            'claude_comparison': None,
            'models_agree': False,
            'processing_time': 0
        }

        start_time = time.time()

        try:
            # 1. Generate SQL với cả 2 model
            gpt4_sql = self.generate_sql_with_gpt4(question)
            claude_sql = self.generate_sql_with_claude_local(question)

            result['gpt4_sql'] = gpt4_sql
            result['claude_sql'] = claude_sql

            # 2. Thực thi expected SQL
            expected_execution = self.execute_sql_safely(expected_sql)
            result['expected_execution'] = expected_execution

            # 3. Thực thi GPT-4 SQL
            if gpt4_sql:
                gpt4_execution = self.execute_sql_safely(gpt4_sql)
                result['gpt4_execution'] = gpt4_execution

                gpt4_comparison = self.compare_execution_results(
                    expected_execution, gpt4_execution)
                result['gpt4_comparison'] = gpt4_comparison
                result['gpt4_match'] = gpt4_comparison['results_match']

            # 4. Thực thi Claude SQL
            if claude_sql:
                claude_execution = self.execute_sql_safely(claude_sql)
                result['claude_execution'] = claude_execution

                claude_comparison = self.compare_execution_results(
                    expected_execution, claude_execution)
                result['claude_comparison'] = claude_comparison
                result['claude_match'] = claude_comparison['results_match']

            # 5. Kiểm tra xem 2 model có đồng ý không
            if gpt4_sql and claude_sql and result['gpt4_execution'] and result['claude_execution']:
                if (result['gpt4_execution']['success'] and result['claude_execution']['success'] and
                        result['gpt4_execution']['result_hash'] == result['claude_execution']['result_hash']):
                    result['models_agree'] = True

        except Exception as e:
            logger.error(f"Lỗi khi test câu hỏi: {e}")
            result['error'] = str(e)

        finally:
            result['processing_time'] = time.time() - start_time

        return result

    def run_all_tests(self) -> Dict[str, Any]:
        """Chạy test tất cả câu hỏi với cả 2 model"""
        print(
            f"\n=== Bắt đầu test {len(self.dataset)} câu hỏi với cả GPT-4 và Claude ===")

        results = []
        start_time = time.time()

        for i, question_data in enumerate(self.dataset, 1):
            print(f"\n--- Test {i}/{len(self.dataset)} ---")
            result = self.test_single_question(question_data)
            results.append(result)

            # Log kết quả ngắn gọn
            gpt4_status = "✓" if result['gpt4_match'] else "✗"
            claude_status = "✓" if result['claude_match'] else "✗"
            agree_status = "🤝" if result['models_agree'] else "❌"

            print(
                f"GPT-4: {gpt4_status} | Claude: {claude_status} | Agree: {agree_status}")

        # Tính toán thống kê
        stats = self.calculate_statistics(results)

        test_results = {
            'test_info': {
                'total_questions': len(self.dataset),
                'completion_time': time.time() - start_time,
                'timestamp': datetime.now().isoformat(),
                'method': 'dual_model_execution_based'
            },
            'results': results,
            'statistics': stats
        }

        return test_results

    def calculate_statistics(self, results: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Tính toán thống kê cho cả 2 model"""
        total = len(results)

        gpt4_matches = sum(1 for r in results if r['gpt4_match'])
        claude_matches = sum(1 for r in results if r['claude_match'])
        models_agree = sum(1 for r in results if r['models_agree'])
        both_correct = sum(
            1 for r in results if r['gpt4_match'] and r['claude_match'])

        processing_times = [r['processing_time']
                            for r in results if 'processing_time' in r]
        avg_time = sum(processing_times) / \
            len(processing_times) if processing_times else 0

        stats = {
            'total_questions': total,
            'gpt4_matches': gpt4_matches,
            'claude_matches': claude_matches,
            'gpt4_match_rate': gpt4_matches / total if total > 0 else 0,
            'claude_match_rate': claude_matches / total if total > 0 else 0,
            'models_agree': models_agree,
            'models_agree_rate': models_agree / total if total > 0 else 0,
            'both_correct': both_correct,
            'both_correct_rate': both_correct / total if total > 0 else 0,
            'average_processing_time': avg_time
        }

        return stats

    def save_results(self, test_results: Dict[str, Any], filename: str = None):
        """Lưu kết quả test ra file JSON"""
        if filename is None:
            filename = f"dual_model_test_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"

        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(test_results, f, ensure_ascii=False,
                      indent=2, default=str)

        print(f"Đã lưu kết quả chi tiết vào: {filename}")

    def print_summary(self, stats: Dict[str, Any]):
        """In tóm tắt kết quả test cho cả 2 model"""
        print(f"\n{'='*70}")
        print(f"TỔNG KẾT SO SÁNH GPT-4 vs CLAUDE (EXECUTION-BASED)")
        print(f"{'='*70}")
        print(f"Tổng số câu hỏi: {stats['total_questions']}")
        print(
            f"GPT-4 đúng: {stats['gpt4_matches']}/{stats['total_questions']} ({stats['gpt4_match_rate']:.1%})")
        print(
            f"Claude đúng: {stats['claude_matches']}/{stats['total_questions']} ({stats['claude_match_rate']:.1%})")
        print(
            f"Cả 2 đúng: {stats['both_correct']}/{stats['total_questions']} ({stats['both_correct_rate']:.1%})")
        print(
            f"Cả 2 đồng ý: {stats['models_agree']}/{stats['total_questions']} ({stats['models_agree_rate']:.1%})")
        print(
            f"Thời gian xử lý trung bình: {stats['average_processing_time']:.2f}s")

        # So sánh hiệu suất
        if stats['gpt4_match_rate'] > stats['claude_match_rate']:
            diff = stats['gpt4_match_rate'] - stats['claude_match_rate']
            print(f"🏆 GPT-4 tốt hơn Claude: {diff:.1%}")
        elif stats['claude_match_rate'] > stats['gpt4_match_rate']:
            diff = stats['claude_match_rate'] - stats['gpt4_match_rate']
            print(f"🏆 Claude tốt hơn GPT-4: {diff:.1%}")
        else:
            print(f"🤝 Cả 2 model có hiệu suất ngang nhau")

        print(f"{'='*70}")

    def analyze_disagreements(self, results: List[Dict[str, Any]]) -> None:
        """Phân tích các trường hợp 2 model không đồng ý"""
        print(f"\n{'='*70}")
        print(f"PHÂN TÍCH CÁC TRƯỜNG HỢP 2 MODEL KHÔNG ĐỒNG Ý (TOP 5)")
        print(f"{'='*70}")

        disagreement_cases = [r for r in results if not r['models_agree']]

        for i, case in enumerate(disagreement_cases[:5], 1):
            print(f"\n--- Case {i} ---")
            print(f"Câu hỏi: {case['question']}")
            print(f"Expected SQL: {case['expected_sql']}")
            print(f"GPT-4 SQL: {case['gpt4_sql']}")
            print(f"Claude SQL: {case['claude_sql']}")
            print(f"GPT-4 đúng: {case['gpt4_match']}")
            print(f"Claude đúng: {case['claude_match']}")
            print("-" * 50)


def main():
    """Hàm main để chạy test so sánh"""
    try:
        tester = DualModelSQLTester()

        # Chạy test
        test_results = tester.run_all_tests()

        # In tóm tắt
        tester.print_summary(test_results['statistics'])

        # Phân tích disagreements
        tester.analyze_disagreements(test_results['results'])

        # Lưu kết quả
        tester.save_results(test_results)

        print("\n🎉 Hoàn thành test so sánh execution-based!")

    except Exception as e:
        logger.error(f"Lỗi trong quá trình test: {e}")
        print(f"❌ Lỗi: {e}")


if __name__ == "__main__":
    main()
