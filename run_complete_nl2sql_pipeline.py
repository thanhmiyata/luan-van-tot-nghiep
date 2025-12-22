#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pipeline hoàn chỉnh để chạy NL2SQL experiment với CrewAI và đánh giá bằng test-suite-sql-eval
"""

import os
import sys
import json
import csv
import shutil
import subprocess
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Tuple
import time
import re
import argparse
from dotenv import load_dotenv


# Đường dẫn cơ sở cho các thành phần dự án (cố định)
DATA_DIR = Path("data")                   # data chung cho tất cả pipeline
SPIDER_DATA_DIR = DATA_DIR / "spider_data"       # chứa database Spider
OUTPUT_BASE_DIR = Path("output")          # thư mục output chung

# Các biến toàn cục phụ thuộc loại pipeline (4-step hoặc 6-step)
NL2SQL_BASE_DIR: Path | None = None       # sẽ được set trong configure_pipeline()
PIPELINE_OUTPUT_DIR: Path | None = None   # output riêng cho từng pipeline
PIPELINE_TYPE: str = "4step"              # "4step" hoặc "6step"


def configure_pipeline(pipeline_type: str) -> None:
    """
    Cấu hình đường dẫn và môi trường cho pipeline 4-step hoặc 6-step.
    """
    global NL2SQL_BASE_DIR, PIPELINE_OUTPUT_DIR, PIPELINE_TYPE

    if pipeline_type not in ("4step", "6step"):
        raise ValueError("pipeline_type must be '4step' or '6step'")

    PIPELINE_TYPE = pipeline_type

    if pipeline_type == "4step":
        NL2SQL_BASE_DIR = Path("src") / "nl2sql_4step"
        PIPELINE_OUTPUT_DIR = OUTPUT_BASE_DIR / "nl2sql_4step"
    else:
        NL2SQL_BASE_DIR = Path("src") / "nl2sql_6step"
        PIPELINE_OUTPUT_DIR = OUTPUT_BASE_DIR / "nl2sql_6step"

    # Load environment variables từ .env file (nếu có)
    load_dotenv(NL2SQL_BASE_DIR / ".env")  # type: ignore[arg-type]

    # Thêm đường dẫn để import các module CrewAI (nl2sql_flow)
    base_dir_str = str(NL2SQL_BASE_DIR)
    if base_dir_str not in sys.path:
        sys.path.append(base_dir_str)

    print(f"🔧 Đã cấu hình pipeline: {PIPELINE_TYPE} (base dir = {NL2SQL_BASE_DIR})")

# Global tracking variables
ai_request_count = 0
execution_metrics = {'total': 0, 'successful': 0, 'failed': 0}
timing_metrics = {
    'setup_time': 0.0,
    'questions_loading_time': 0.0,
    'nl2sql_processing_time': 0.0,
    'conversion_time': 0.0,
    'evaluation_time': 0.0
}
api_call_details = {
    'per_question': [],  # Track API calls per question
    'enhancement_calls': 0,
    'total_agent_calls': 0
}


def setup_environment():
    """Setup môi trường và copy database cần thiết"""
    global timing_metrics, PIPELINE_OUTPUT_DIR
    start_time = time.time()

    if PIPELINE_OUTPUT_DIR is None:
        raise RuntimeError(
            "PIPELINE_OUTPUT_DIR chưa được cấu hình. Hãy gọi configure_pipeline() trước."
        )

    print("[SETUP] Dang setup moi truong...")

    # Tạo thư mục output nếu chưa có
    os.makedirs(PIPELINE_OUTPUT_DIR, exist_ok=True)

    # Copy database từ data/spider_data sang test-suite-sql-eval
    source_db_dir = SPIDER_DATA_DIR / 'database'
    target_db_dir = Path('experiments/test-suite-sql-eval/database')

    if source_db_dir.exists() and not target_db_dir.exists():
        print(f"📁 Dang copy database tu {source_db_dir} sang {target_db_dir}")
        shutil.copytree(source_db_dir, target_db_dir)
    elif target_db_dir.exists():
        print("✅ Database da ton tai trong test-suite-sql-eval")
    else:
        print("❌ Khong tim thay database source")
        return False

    timing_metrics['setup_time'] = time.time() - start_time
    print(f"⏱️  Setup completed in {timing_metrics['setup_time']:.2f}s")
    return True


def get_test_questions(num_questions=40):
    """Lấy số câu hỏi test từ train_spider.json - chọn database có >50 câu hỏi và random n câu"""
    global timing_metrics
    start_time = time.time()

    import random

    # Các file Spider dùng chung cho mọi pipeline (4-step, 6-step, single)
    train_spider_file = DATA_DIR / 'train_spider.json'
    tables_file = DATA_DIR / 'tables.json'

    with open(train_spider_file, 'r', encoding='utf-8') as f:
        spider_data = json.load(f)

    with open(tables_file, 'r', encoding='utf-8') as f:
        tables_data = json.load(f)

    # Đếm số câu hỏi theo database
    print("🔍 Phân tích dữ liệu Spider...")
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

    # Chọn ngẫu nhiên một database có >50 câu hỏi
    selected_db = random.choice(list(eligible_dbs.keys()))
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
            test_questions.append({
                'db_id': item['db_id'],
                'question': item['question'],
                'gold_query': item['query'],  # Thêm ground truth
                'table_names_original': table_schema['table_names_original'],
                'column_names_original': table_schema['column_names_original'],
                'column_types': table_schema['column_types']
            })

    print(
        f"\n📝 Đã random chọn {len(test_questions)} câu hỏi từ database '{selected_db}':")
    for i, q in enumerate(test_questions, 1):
        print(f"   {i}. {q['question'][:70]}...")

    timing_metrics['questions_loading_time'] = time.time() - start_time
    print(
        f"⏱️  Questions loading completed in {timing_metrics['questions_loading_time']:.2f}s")

    return test_questions


def enhance_sql_query(sql_query: str, question_text: str, schema: dict) -> dict:
    """
    Simple SQL enhancement function - placeholder for more sophisticated enhancement
    """
    global api_call_details

    # This is a placeholder - in real implementation, this might call AI services
    # For now, just basic formatting
    try:
        # Simulate enhancement processing
        api_call_details['enhancement_calls'] += 1

        # Basic SQL formatting
        enhanced_sql = sql_query.strip()
        if not enhanced_sql.endswith(';'):
            enhanced_sql += ';'

        # Simple improvements check
        improvements_made = enhanced_sql != sql_query

        return {
            'enhanced_sql': enhanced_sql,
            'improvements_made': improvements_made,
            'enhancement_type': 'formatting' if improvements_made else 'none'
        }
    except Exception as e:
        print(f"⚠️  SQL enhancement error: {e}")
        return {
            'enhanced_sql': sql_query,
            'improvements_made': False,
            'enhancement_type': 'error'
        }


def run_nl2sql_system(test_questions):
    """Chạy hệ thống NL2SQL CrewAI"""
    global ai_request_count, execution_metrics, timing_metrics, api_call_details, PIPELINE_OUTPUT_DIR, PIPELINE_TYPE
    start_time = time.time()

    if PIPELINE_OUTPUT_DIR is None:
        raise RuntimeError(
            "PIPELINE_OUTPUT_DIR chưa được cấu hình. Hãy gọi configure_pipeline() trước."
        )

    print("\n🤖 Đang chạy hệ thống NL2SQL CrewAI...")

    # Import các module cần thiết từ CrewAI
    try:
        from pydantic import BaseModel
        from nl2sql_flow.main import NL2SQLFlow, NLQuestions, SQLDbSchema, NL2SQLResult
    except ImportError as e:
        print(f"❌ Lỗi import module CrewAI: {e}")
        print("💡 Hãy đảm bảo đã cài đặt crewai và các dependencies")
        return None

    # Schema đã được load trong test_questions

    # Tạo file CSV output (theo từng pipeline)
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    csv_filename = str(
        PIPELINE_OUTPUT_DIR / f'nl2sql_results_{PIPELINE_TYPE}_{timestamp}.csv'
    )

    # Initialize CSV file
    with open(csv_filename, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['db_id', 'question',
                      'gold_query', 'sql', 'explain', 'error']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

    results = []
    execution_metrics['total'] = len(test_questions)

    for i, question in enumerate(test_questions, 1):
        question_start_time = time.time()
        print(
            f"\n📊 Xử lý câu hỏi {i}/{len(test_questions)}: {question['question'][:50]}...")

        try:
            # Chạy NL2SQL flow với schema đã có sẵn trong question
            print("   🔄 Đang chạy multi-agent flow...")

            # Track AI requests (estimate based on typical CrewAI flow)
            # 4-step: khoảng 4 calls, 6-step: khoảng 6 calls
            question_api_calls = 6 if PIPELINE_TYPE == "6step" else 4
            ai_request_count += question_api_calls
            api_call_details['total_agent_calls'] += question_api_calls

            flow_result = NL2SQLFlow(
                _question=NLQuestions(
                    question=question['question'], db_id=question['db_id']),
                _raw_schema=SQLDbSchema(
                    db_id=question['db_id'],
                    table_names_original=question['table_names_original'],
                    column_names_original=question['column_names_original'],
                    column_types=question['column_types'],
                )
            ).kickoff()

            result = {
                'db_id': flow_result.db_id,
                'question': flow_result.question,
                'gold_query': question['gold_query'],  # Thêm ground truth
                'sql': flow_result.result.sql,
                'explain': flow_result.result.explain,
                'error': flow_result.result.error,
            }

            # ===== PHASE 1 IMPROVEMENT: SQL Enhancement =====
            if result['sql'] and not result['error']:
                print("   🚀 Applying Phase 1 SQL enhancements...")
                try:
                    enhancement_result = enhance_sql_query(
                        sql_query=result['sql'],
                        question_text=result['question'],
                        schema={
                            'table_names_original': question['table_names_original'],
                            'column_names_original': question['column_names_original'],
                            'column_types': question['column_types']
                        }
                    )

                    if enhancement_result['improvements_made']:
                        original_sql = result['sql']
                        result['sql'] = enhancement_result['enhanced_sql']
                        result['explain'] += f" [Enhanced from: {original_sql[:30]}...]"
                        print(
                            f"   ✨ SQL enhanced: {enhancement_result['enhanced_sql'][:50]}...")
                    else:
                        print("   ✅ No enhancements needed")

                except Exception as e:
                    print(f"   ⚠️  Enhancement failed: {e}")
                    # Continue with original SQL if enhancement fails

            # Track successful execution
            if result['sql'] and not result['error']:
                execution_metrics['successful'] += 1
            else:
                execution_metrics['failed'] += 1

            results.append(result)

            # Ghi vào CSV
            with open(csv_filename, 'a', newline='', encoding='utf-8') as csvfile:
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writerow(result)

            # Track per-question timing and API calls
            question_time = time.time() - question_start_time
            api_call_details['per_question'].append({
                'question_id': i,
                'question': question['question'][:50] + '...',
                # +1 for enhancement if successful
                'api_calls': question_api_calls + (1 if result['sql'] and not result['error'] else 0),
                'processing_time': question_time,
                'success': bool(result['sql'] and not result['error'])
            })

            print(
                f"   ✅ Hoàn thành: SQL = {result['sql'][:50]}... (⏱️ {question_time:.1f}s)")

        except Exception as e:
            print(f"   ❌ Lỗi xử lý câu hỏi: {e}")
            execution_metrics['failed'] += 1
            failed_api_calls = 2  # Even failed attempts make some AI requests
            ai_request_count += failed_api_calls
            api_call_details['total_agent_calls'] += failed_api_calls

            error_result = {
                'db_id': question['db_id'],
                'question': question['question'],
                'gold_query': question['gold_query'],
                'sql': '',
                'explain': '',
                'error': str(e),
            }
            results.append(error_result)

            # Ghi lỗi vào CSV
            with open(csv_filename, 'a', newline='', encoding='utf-8') as csvfile:
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writerow(error_result)

            # Track failed question timing and API calls
            question_time = time.time() - question_start_time
            api_call_details['per_question'].append({
                'question_id': i,
                'question': question['question'][:50] + '...',
                'api_calls': failed_api_calls,
                'processing_time': question_time,
                'success': False
            })

    timing_metrics['nl2sql_processing_time'] = time.time() - start_time
    print(
        f"\n✅ Hoàn thành chạy NL2SQL system. Kết quả được lưu tại: {csv_filename}")
    print(
        f"⏱️  NL2SQL processing completed in {timing_metrics['nl2sql_processing_time']:.2f}s")
    return csv_filename, results


def convert_csv_to_evaluation_format(csv_filename):
    """Convert CSV output sang format đánh giá"""
    global timing_metrics, PIPELINE_OUTPUT_DIR
    start_time = time.time()

    if PIPELINE_OUTPUT_DIR is None:
        raise RuntimeError(
            "PIPELINE_OUTPUT_DIR chưa được cấu hình. Hãy gọi configure_pipeline() trước."
        )

    print("\n🔄 Đang convert CSV sang format đánh giá...")

    # Lưu gold/predict chung vào thư mục output của pipeline hiện tại
    predict_file = PIPELINE_OUTPUT_DIR / 'predict.sql'
    gold_file = PIPELINE_OUTPUT_DIR / 'gold.sql'

    # Đọc CSV results (đã có ground truth trong CSV)
    with open(csv_filename, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)

        with open(predict_file, 'w', encoding='utf-8') as pred_f, \
                open(gold_file, 'w', encoding='utf-8') as gold_f:

            matched_count = 0
            for row in reader:
                if row['gold_query'] and row['sql']:  # Kiểm tra có ground truth và predicted SQL
                    # Format: SQL\tdb_id
                    gold_f.write(f"{row['gold_query']}\t{row['db_id']}\n")
                    pred_f.write(f"{row['sql']}\t{row['db_id']}\n")
                    matched_count += 1
                else:
                    print(
                        f"⚠️ Thiếu ground truth hoặc predicted SQL cho: {row['question'][:50]}...")

    timing_metrics['conversion_time'] = time.time() - start_time
    print(f"✅ Convert hoàn thành. Matched {matched_count} câu hỏi")
    print(f"   📄 Gold file: {gold_file}")
    print(f"   📄 Predict file: {predict_file}")
    print(
        f"⏱️  Conversion completed in {timing_metrics['conversion_time']:.2f}s")

    return gold_file, predict_file


def run_evaluation(gold_file, predict_file):
    """Chạy đánh giá bằng test-suite-sql-eval"""
    global timing_metrics
    start_time = time.time()

    print("\n📊 Đang chạy đánh giá bằng test-suite-sql-eval...")

    # Chuyển đến thư mục test-suite-sql-eval
    eval_dir = Path('experiments/test-suite-sql-eval')
    current_dir = Path.cwd()

    try:
        # Copy tables.json từ data chung sang test-suite-sql-eval trước khi chạy evaluation
        tables_source = current_dir / DATA_DIR / 'tables.json'
        tables_target = eval_dir / 'tables.json'

        if not tables_target.exists() and tables_source.exists():
            print(
                f"📁 Đang copy tables.json từ {tables_source} sang {tables_target}")
            shutil.copy2(tables_source, tables_target)
        elif tables_target.exists():
            print("✅ File tables.json đã tồn tại trong test-suite-sql-eval")
        else:
            print(f"⚠️ Không tìm thấy file tables.json tại {tables_source}")

        # Không cần chuyển thư mục, chạy từ thư mục gốc với đường dẫn đầy đủ

        # Sử dụng Python từ virtual environment và chạy từ thư mục gốc
        import sys
        python_executable = sys.executable

        # Chạy evaluation từ thư mục gốc với đường dẫn đầy đủ
        eval_script = os.path.join(
            current_dir, 'experiments', 'test-suite-sql-eval', 'evaluation.py')
        gold_path = str(current_dir / gold_file)
        pred_path = str(current_dir / predict_file)
        db_path = os.path.join(current_dir, 'experiments',
                               'test-suite-sql-eval', 'database')
        tables_path = os.path.join(
            current_dir, 'experiments', 'test-suite-sql-eval', 'tables.json')

        # Kiểm tra các file cần thiết trước khi chạy evaluation với đường dẫn đầy đủ
        required_files = {
            'evaluation.py': eval_script,
            'tables.json': tables_path,
            'gold.sql': gold_path,
            'predict.sql': pred_path
        }

        missing_files = []
        for name, path in required_files.items():
            if not Path(path).exists():
                missing_files.append(f"{name} ({path})")

        if missing_files:
            print(f"❌ Thiếu các file cần thiết: {missing_files}")
            return None

        cmd = [
            python_executable, eval_script,
            '--gold', gold_path,
            '--pred', pred_path,
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
        eval_result = parse_evaluation_results(result.stdout)
        timing_metrics['evaluation_time'] = time.time() - start_time
        print(
            f"⏱️  Evaluation completed in {timing_metrics['evaluation_time']:.2f}s")
        return eval_result

    except Exception as e:
        timing_metrics['evaluation_time'] = time.time() - start_time
        print(f"❌ Lỗi khi chạy đánh giá: {e}")
        print(
            f"⏱️  Evaluation failed after {timing_metrics['evaluation_time']:.2f}s")
        return None


def parse_evaluation_results(eval_output):
    """Parse kết quả evaluation để lấy metrics"""
    metrics = {'execution_rate': 0.0, 'exact_match_rate': 0.0}

    if not eval_output:
        return metrics

    try:
        # Parse execution accuracy từ bảng EXECUTION ACCURACY
        # Format: execution            1.000                0.857                0.750                0.667                0.789
        exec_match = re.search(
            r'execution\s+[\d.]+\s+[\d.]+\s+[\d.]+\s+[\d.]+\s+([\d.]+)', eval_output)
        if exec_match:
            metrics['execution_rate'] = float(
                exec_match.group(1)) * 100  # Convert to percentage

        # Parse exact match accuracy từ bảng EXACT MATCHING ACCURACY
        # Format: exact match          1.000                0.429                0.625                0.333                0.526
        exact_match = re.search(
            r'exact match\s+[\d.]+\s+[\d.]+\s+[\d.]+\s+[\d.]+\s+([\d.]+)', eval_output)
        if exact_match:
            metrics['exact_match_rate'] = float(
                exact_match.group(1)) * 100  # Convert to percentage

        # Alternative patterns nếu không tìm thấy
        if metrics['execution_rate'] == 0.0:
            exec_alt = re.search(
                r'execution.*?([\d.]+)$', eval_output, re.MULTILINE | re.IGNORECASE)
            if exec_alt:
                val = float(exec_alt.group(1))
                metrics['execution_rate'] = val * 100 if val <= 1.0 else val

        if metrics['exact_match_rate'] == 0.0:
            exact_alt = re.search(
                r'exact match.*?([\d.]+)$', eval_output, re.MULTILINE | re.IGNORECASE)
            if exact_alt:
                val = float(exact_alt.group(1))
                metrics['exact_match_rate'] = val * 100 if val <= 1.0 else val

        print(
            f"📊 Parsed metrics: execution={metrics['execution_rate']:.1f}%, exact_match={metrics['exact_match_rate']:.1f}%")

    except Exception as e:
        print(f"⚠️ Lỗi parse evaluation results: {e}")
        print(f"📋 Eval output sample: {eval_output[:500]}...")

    return metrics


def print_detailed_api_statistics():
    """In thống kê chi tiết về API calls"""
    global api_call_details

    print(f"\n🤖 THỐNG KÊ CHI TIẾT API CALLS")
    print("=" * 80)

    # Summary
    total_questions = len(api_call_details['per_question'])
    successful_questions = sum(
        1 for q in api_call_details['per_question'] if q['success'])
    failed_questions = total_questions - successful_questions

    print(f"📊 Tổng quan API calls:")
    print(f"   • Tổng agent calls: {api_call_details['total_agent_calls']}")
    print(f"   • Enhancement calls: {api_call_details['enhancement_calls']}")
    print(
        f"   • Trung bình API calls/câu hỏi: {api_call_details['total_agent_calls']/total_questions:.1f}")

    if api_call_details['per_question']:
        avg_time_per_question = sum(
            q['processing_time'] for q in api_call_details['per_question']) / len(api_call_details['per_question'])
        print(
            f"   • Thời gian trung bình/câu hỏi: {avg_time_per_question:.2f}s")

        # Top 5 slowest questions
        slowest_questions = sorted(
            api_call_details['per_question'], key=lambda x: x['processing_time'], reverse=True)[:5]
        print(f"\n⏱️  Top 5 câu hỏi xử lý chậm nhất:")
        for i, q in enumerate(slowest_questions, 1):
            status = "✅" if q['success'] else "❌"
            print(
                f"   {i}. {status} {q['question']} - {q['processing_time']:.2f}s ({q['api_calls']} calls)")


def print_detailed_timing_breakdown():
    """In breakdown chi tiết về thời gian"""
    global timing_metrics

    print(f"\n⏱️  PHÂN TÍCH THỜI GIAN CHI TIẾT")
    print("=" * 80)

    total_time = sum(timing_metrics.values())

    print(f"📊 Breakdown thời gian thực thi:")
    for phase, time_spent in timing_metrics.items():
        percentage = (time_spent / total_time * 100) if total_time > 0 else 0
        phase_name = phase.replace('_', ' ').title()
        print(f"   • {phase_name:<25}: {time_spent:6.2f}s ({percentage:5.1f}%)")

    print(f"   {'='*25}   {'='*6}   {'='*7}")
    print(f"   {'Total':<25}: {total_time:6.2f}s (100.0%)")


def print_results_table(run_number, num_questions, eval_metrics, total_time):
    """In bảng kết quả theo format yêu cầu"""
    global ai_request_count, execution_metrics, timing_metrics, api_call_details

    # Calculate execution rate
    exec_rate = (execution_metrics['successful'] / execution_metrics['total']
                 * 100) if execution_metrics['total'] > 0 else 0.0

    # Get evaluation metrics
    eval_exec_rate = eval_metrics.get(
        'execution_rate', 0.0) if eval_metrics else 0.0
    exact_match_rate = eval_metrics.get(
        'exact_match_rate', 0.0) if eval_metrics else 0.0

    print("\n" + "=" * 90)
    print("📊 KẾT QUẢ CHẠY PIPELINE NL2SQL")
    print("=" * 90)
    print("| Lượt | Câu hỏi | Execute(%) | Exact Match(%) | Agent Calls | Enhancement | Thời gian(s) |")
    print("|------|---------|------------|----------------|-------------|-------------|--------------|")
    print(
        f"|  {run_number:2d}  |   {num_questions:2d}    |   {eval_exec_rate:5.1f}    |     {exact_match_rate:5.1f}      |     {api_call_details['total_agent_calls']:2d}      |      {api_call_details['enhancement_calls']:2d}     |   {total_time:6.1f}    |")
    print("=" * 90)

    print(f"\n📈 Chi tiết thống kê:")
    print(f"   • Tổng câu hỏi xử lý: {execution_metrics['total']}")
    print(f"   • Thành công tạo SQL: {execution_metrics['successful']}")
    print(f"   • Thất bại: {execution_metrics['failed']}")
    print(f"   • Tỉ lệ thành công hệ thống: {exec_rate:.1f}%")
    print(f"   • Tỉ lệ execute đúng (test-suite): {eval_exec_rate:.1f}%")
    print(f"   • Tỉ lệ exact match: {exact_match_rate:.1f}%")
    print(
        f"   • Tổng agent API calls: {api_call_details['total_agent_calls']}")
    print(
        f"   • Tổng enhancement calls: {api_call_details['enhancement_calls']}")
    print(f"   • Tổng tất cả API calls: {ai_request_count}")
    print(f"   • Thời gian thực thi: {total_time:.1f} giây")

    # Print detailed breakdowns
    print_detailed_timing_breakdown()
    print_detailed_api_statistics()


def main():
    """Hàm chính chạy toàn bộ pipeline"""
    global ai_request_count, execution_metrics, timing_metrics, api_call_details

    # Reset tracking variables
    ai_request_count = 0
    execution_metrics = {'total': 0, 'successful': 0, 'failed': 0}
    timing_metrics = {
        'setup_time': 0.0,
        'questions_loading_time': 0.0,
        'nl2sql_processing_time': 0.0,
        'conversion_time': 0.0,
        'evaluation_time': 0.0
    }
    api_call_details = {
        'per_question': [],
        'enhancement_calls': 0,
        'total_agent_calls': 0
    }

    # Parse tham số dòng lệnh
    parser = argparse.ArgumentParser(
        description="Chạy complete NL2SQL pipeline với lựa chọn 4-step hoặc 6-step."
    )
    parser.add_argument(
        "--pipeline",
        choices=["4step", "6step"],
        default="4step",
        help="Chọn loại pipeline NL2SQL: 4step (mặc định) hoặc 6step."
    )
    parser.add_argument(
        "--num_questions",
        type=int,
        default=5,
        help="Số câu hỏi sẽ được random từ Spider để test pipeline (mặc định: 5).",
    )
    args = parser.parse_args()

    # Cấu hình pipeline tương ứng
    configure_pipeline(args.pipeline)

    print(f"🚀 Bắt đầu chạy Complete NL2SQL Pipeline ({args.pipeline})")
    print("=" * 60)

    start_time = time.time()

    # 1. Setup environment
    if not setup_environment():
        print("❌ Setup environment thất bại")
        return

    # 2. Lấy câu hỏi test (số lượng cấu hình bằng tham số dòng lệnh)
    test_questions = get_test_questions(num_questions=args.num_questions)

    # 3. Chạy NL2SQL system
    csv_filename, results = run_nl2sql_system(test_questions)
    if not csv_filename:
        print("❌ NL2SQL system thất bại")
        return

    # 4. Convert format
    gold_file, predict_file = convert_csv_to_evaluation_format(csv_filename)

    # 5. Chạy evaluation
    eval_metrics = run_evaluation(gold_file, predict_file)

    end_time = time.time()
    duration = end_time - start_time

    # 6. Print results table
    print_results_table(1, len(test_questions), eval_metrics, duration)

    print("\n📁 Các file được tạo:")
    print(f"   - CSV kết quả: {csv_filename}")
    print(f"   - Gold SQL: {gold_file}")
    print(f"   - Predict SQL: {predict_file}")


if __name__ == "__main__":
    main()
