"""
Correct benchmark following the exact flow from run_complete_nl2sql_pipeline.py
"""

from loguru import logger
from src.core.models import ModelType, NLQuestion, DatabaseSchema
from src.utils.benchmark import BenchmarkRunner
import sys
import json
import csv
import subprocess
import shutil
import time
import re
import random
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Tuple

# Add current directory to Python path
current_dir = Path(__file__).parent
sys.path.insert(0, str(current_dir))


# Global tracking variables
ai_request_count = 0
execution_metrics = {'total': 0, 'successful': 0, 'failed': 0}


def setup_environment():
    """Setup môi trường và copy database cần thiết - theo run_complete_nl2sql_pipeline.py"""
    print("[SETUP] Đang setup môi trường...")

    # Tạo thư mục output nếu chưa có
    output_dir = Path('output')
    output_dir.mkdir(exist_ok=True)

    # Copy database từ spider_data sang test-suite-sql-eval
    source_db_dir = Path('../Data Set/spider_data/database')
    target_db_dir = Path('../experiments/test-suite-sql-eval/database')

    if source_db_dir.exists() and not target_db_dir.exists():
        print(f"📁 Đang copy database từ {source_db_dir} sang {target_db_dir}")
        shutil.copytree(source_db_dir, target_db_dir)
    elif target_db_dir.exists():
        print("✅ Database đã tồn tại trong test-suite-sql-eval")
    else:
        print("❌ Không tìm thấy database source")
        return False

    return True


def get_test_questions(num_questions=10):
    """
    Lấy câu hỏi test CHÍNH XÁC theo flow run_complete_nl2sql_pipeline.py
    """
    print(f"🔍 Phân tích dữ liệu Spider để chọn {num_questions} câu hỏi...")

    # Load train_spider.json (có cả question và ground truth SQL)
    train_spider_file = 'train_spider.json'
    tables_file = '../experiments/test-suite-sql-eval/tables.json'

    with open(train_spider_file, 'r', encoding='utf-8') as f:
        spider_data = json.load(f)

    with open(tables_file, 'r', encoding='utf-8') as f:
        tables_data = json.load(f)

    # Đếm số câu hỏi theo database - GIỐNG HỆT run_complete_nl2sql_pipeline.py
    db_counts = {}
    db_questions = {}

    for item in spider_data:
        db_id = item['db_id']
        if db_id not in db_counts:
            db_counts[db_id] = 0
            db_questions[db_id] = []
        db_counts[db_id] += 1
        db_questions[db_id].append(item)

    # Lọc databases có >50 câu hỏi
    eligible_dbs = {db: count for db, count in db_counts.items() if count > 50}
    print(f"📊 Tìm thấy {len(eligible_dbs)} databases có >50 câu hỏi:")

    # Sắp xếp và hiển thị top databases
    sorted_dbs = sorted(eligible_dbs.items(), key=lambda x: x[1], reverse=True)
    for i, (db, count) in enumerate(sorted_dbs[:10], 1):
        print(f"   {i}. {db}: {count} câu hỏi")

    # Chọn database có nhiều câu hỏi nhất
    selected_db = sorted_dbs[0][0]
    available_questions = db_questions[selected_db]

    print(
        f"\n🎯 Đã chọn database: '{selected_db}' với {len(available_questions)} câu hỏi")

    # Random chọn num_questions câu hỏi từ database đã chọn
    if num_questions > len(available_questions):
        print(
            f"⚠️  Yêu cầu {num_questions} câu hỏi nhưng chỉ có {len(available_questions)} câu. Lấy tất cả.")
        selected_items = available_questions
    else:
        selected_items = random.sample(available_questions, num_questions)

    # Tìm schema tương ứng và tạo test_questions
    test_questions = []
    table_schema = None
    for table in tables_data:
        if table['db_id'] == selected_db:
            table_schema = table
            break

    if table_schema:
        for item in selected_items:
            # Tạo NLQuestion object
            question = NLQuestion(
                question=item['question'],
                db_id=item['db_id'],
                question_id=f"q_{len(test_questions)+1}"
            )
            test_questions.append({
                'question_obj': question,
                'gold_query': item['query'],  # Ground truth SQL
                'schema': table_schema
            })

    print(
        f"\n📝 Đã random chọn {len(test_questions)} câu hỏi từ database '{selected_db}':")
    for i, q in enumerate(test_questions, 1):
        print(f"   {i}. {q['question_obj'].question[:70]}...")

    # Tạo DatabaseSchema object - Fix primary_keys và foreign_keys format
    primary_keys = table_schema.get('primary_keys', [])
    foreign_keys = table_schema.get('foreign_keys', [])

    # Convert primary_keys từ List[int] thành List[List[int]] nếu cần
    if primary_keys and isinstance(primary_keys[0], int):
        primary_keys = [[pk] for pk in primary_keys]

    # Convert foreign_keys từ List[List[int]] format nếu cần
    if foreign_keys and len(foreign_keys) > 0:
        # Spider format: [[foreign_key_col, primary_key_col], ...]
        # Keep as is if already in correct format
        if not isinstance(foreign_keys[0], list):
            foreign_keys = [[fk] for fk in foreign_keys]

    schema = DatabaseSchema(
        db_id=table_schema['db_id'],
        table_names_original=table_schema['table_names_original'],
        column_names_original=table_schema['column_names_original'],
        column_types=table_schema['column_types'],
        primary_keys=primary_keys,
        foreign_keys=foreign_keys
    )

    return test_questions, schema


def run_multi_agent_system(test_questions, schema, model_type: ModelType):
    """Chạy multi-agent system với model type cụ thể"""
    global ai_request_count, execution_metrics

    print(f"\n🤖 Đang chạy {model_type.value} model...")

    # Extract just the question objects
    questions = [item['question_obj'] for item in test_questions]

    # Initialize benchmark runner
    runner = BenchmarkRunner()

    try:
        result = runner.run_single_model_benchmark(
            model_type=model_type,
            questions=questions,
            schema=schema,
            runs=1
        )

        benchmark_result = result['benchmark_result']

        # Update global metrics
        execution_metrics['total'] += benchmark_result.total_questions
        execution_metrics['successful'] += benchmark_result.successful_questions
        execution_metrics['failed'] += benchmark_result.failed_questions
        ai_request_count += benchmark_result.total_api_calls

        return benchmark_result, result.get('results', [])

    except Exception as e:
        print(f"❌ Lỗi chạy {model_type.value} model: {e}")
        return None, []


def convert_to_evaluation_format(test_questions, pipeline_results, model_name):
    """Convert kết quả sang format đánh giá - GIỐNG HỆT run_complete_nl2sql_pipeline.py"""
    print(f"\n🔄 Đang convert {model_name} results sang format đánh giá...")

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    predict_file = f'output/predict_{model_name}_{timestamp}.sql'
    gold_file = f'output/gold_{model_name}_{timestamp}.sql'

    with open(predict_file, 'w', encoding='utf-8') as pred_f, \
            open(gold_file, 'w', encoding='utf-8') as gold_f:

        matched_count = 0
        for i, (test_q, pipeline_result) in enumerate(zip(test_questions, pipeline_results)):
            gold_query = test_q['gold_query']
            predicted_sql = pipeline_result.final_sql if pipeline_result else ""
            db_id = test_q['question_obj'].db_id

            if gold_query and predicted_sql:
                # Format: SQL\tdb_id - CHÍNH XÁC theo test-suite-sql-eval
                gold_f.write(f"{gold_query}\t{db_id}\n")
                pred_f.write(f"{predicted_sql}\t{db_id}\n")
                matched_count += 1
            else:
                print(
                    f"⚠️  Thiếu SQL cho câu hỏi {i+1}: {test_q['question_obj'].question[:50]}...")

    print(f"✅ Convert hoàn thành. Matched {matched_count} câu hỏi")
    print(f"   📄 Gold file: {gold_file}")
    print(f"   📄 Predict file: {predict_file}")

    return gold_file, predict_file


def run_evaluation(gold_file, predict_file):
    """Chạy đánh giá bằng test-suite-sql-eval - CHÍNH XÁC theo run_complete_nl2sql_pipeline.py"""
    print("\n📊 Đang chạy đánh giá bằng test-suite-sql-eval...")

    try:
        # Copy tables.json nếu cần
        current_dir = Path.cwd()
        tables_source = current_dir / 'experiments/test-suite-sql-eval/tables.json'
        tables_target = Path('../experiments/test-suite-sql-eval/tables.json')

        if not tables_target.exists() and tables_source.exists():
            print(
                f"📁 Đang copy tables.json từ {tables_source} sang {tables_target}")
            shutil.copy2(tables_source, tables_target)

        # Chạy evaluation với đường dẫn tuyệt đối
        python_executable = sys.executable

        eval_script = '../experiments/test-suite-sql-eval/evaluation.py'
        db_path = '../experiments/test-suite-sql-eval/database'
        tables_path = '../experiments/test-suite-sql-eval/tables.json'

        cmd = [
            python_executable, eval_script,
            '--gold', gold_file,
            '--pred', predict_file,
            '--db', db_path,
            '--etype', 'all',
            '--table', tables_path,
            '--plug_value'
        ]

        print(f"🚀 Chạy lệnh: {' '.join(cmd)}")

        result = subprocess.run(
            cmd, capture_output=True, text=True, timeout=300)

        print("\n📋 Kết quả đánh giá:")
        print("=" * 50)
        if result.stdout:
            print(result.stdout)
        else:
            print("Không có output từ evaluation script")

        if result.stderr:
            print("\n⚠️ Warnings/Errors:")
            print(result.stderr)

        if result.returncode != 0:
            print(
                f"❌ Evaluation script kết thúc với mã lỗi: {result.returncode}")
            return None

        # Parse evaluation results
        return parse_evaluation_results(result.stdout)

    except Exception as e:
        print(f"❌ Lỗi khi chạy đánh giá: {e}")
        return None


def parse_evaluation_results(eval_output):
    """Parse kết quả evaluation - GIỐNG HỆT run_complete_nl2sql_pipeline.py"""
    metrics = {'execution_rate': 0.0, 'exact_match_rate': 0.0}

    if not eval_output:
        return metrics

    try:
        # Parse execution accuracy
        exec_match = re.search(r'Execution Accuracy: ([\d.]+)', eval_output)
        if exec_match:
            metrics['execution_rate'] = float(exec_match.group(1))

        # Parse exact match accuracy
        exact_match = re.search(r'Exact Match Accuracy: ([\d.]+)', eval_output)
        if exact_match:
            metrics['exact_match_rate'] = float(exact_match.group(1))

        # Alternative patterns
        if metrics['execution_rate'] == 0.0:
            exec_alt = re.search(
                r'execution.*?accuracy.*?([\d.]+)', eval_output, re.IGNORECASE)
            if exec_alt:
                metrics['execution_rate'] = float(exec_alt.group(1))

        if metrics['exact_match_rate'] == 0.0:
            exact_alt = re.search(
                r'exact.*?match.*?([\d.]+)', eval_output, re.IGNORECASE)
            if exact_alt:
                metrics['exact_match_rate'] = float(exact_alt.group(1))

    except Exception as e:
        print(f"⚠️  Lỗi parse evaluation results: {e}")

    return metrics


def print_results_table(model_name, num_questions, eval_metrics, total_time):
    """In bảng kết quả - GIỐNG HỆT run_complete_nl2sql_pipeline.py"""
    global ai_request_count, execution_metrics

    exec_rate = (execution_metrics['successful'] / execution_metrics['total']
                 * 100) if execution_metrics['total'] > 0 else 0.0

    eval_exec_rate = eval_metrics.get(
        'execution_rate', 0.0) if eval_metrics else 0.0
    exact_match_rate = eval_metrics.get(
        'exact_match_rate', 0.0) if eval_metrics else 0.0

    print("\n" + "=" * 80)
    print(f"📊 KẾT QUẢ {model_name.upper()} MODEL")
    print("=" * 80)
    print("| Mô hình | Số câu hỏi | Tỉ lệ execute (%) | Tỉ lệ exact match (%) | Số request AI | Thời gian (s) |")
    print("|---------|------------|-------------------|----------------------|---------------|---------------|")
    print(f"| {model_name:7} |     {num_questions:2d}     |       {eval_exec_rate:5.1f}       |        {exact_match_rate:5.1f}         |      {ai_request_count:2d}       |    {total_time:6.1f}     |")
    print("=" * 80)


def main():
    """Hàm chính - TUÂN THỦ CHÍNH XÁC flow run_complete_nl2sql_pipeline.py"""
    global ai_request_count, execution_metrics

    print("🚀 Multi-Agent SQL Benchmark - Correct Flow")
    print("=" * 60)

    start_time = time.time()

    # 1. Setup environment
    if not setup_environment():
        print("❌ Setup environment thất bại")
        return

    # 2. Lấy câu hỏi test - CHÍNH XÁC theo flow gốc
    test_questions, schema = get_test_questions(num_questions=10)

    # 3. Test từng model
    models_to_test = [
        (ModelType.THREE_STEP, "3-step"),
        (ModelType.FOUR_STEP, "4-step"),
        (ModelType.SIX_STEP, "6-step")
    ]

    for model_type, model_name in models_to_test:
        print(f"\n{'='*60}")
        print(f"🧪 Testing {model_name.upper()} MODEL")
        print(f"{'='*60}")

        # Reset metrics
        ai_request_count = 0
        execution_metrics = {'total': 0, 'successful': 0, 'failed': 0}
        model_start_time = time.time()

        # 4. Chạy multi-agent system
        benchmark_result, pipeline_results = run_multi_agent_system(
            test_questions, schema, model_type)

        if not benchmark_result:
            print(f"❌ {model_name} model thất bại")
            continue

        # 5. Convert format
        gold_file, predict_file = convert_to_evaluation_format(
            test_questions, pipeline_results, model_name)

        # 6. Chạy evaluation
        eval_metrics = run_evaluation(gold_file, predict_file)

        model_end_time = time.time()
        model_duration = model_end_time - model_start_time

        # 7. Print results
        print_results_table(model_name, len(test_questions),
                            eval_metrics, model_duration)

    end_time = time.time()
    total_duration = end_time - start_time

    print(f"\n⏱️  Tổng thời gian benchmark: {total_duration:.1f} giây")
    print(f"📁 Kết quả được lưu trong thư mục 'output/'")


if __name__ == "__main__":
    main()
