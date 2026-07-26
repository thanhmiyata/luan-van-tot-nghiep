#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pipeline hoàn chỉnh để chạy NL2SQL experiment với CrewAI và đánh giá bằng test-suite-sql-eval
"""

import os
import sys

# Tắt CrewAI telemetry để tránh timeout (gửi dữ liệu đến telemetry.crewai.com)
os.environ["CREWAI_DISABLE_TELEMETRY"] = "true"

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
DEV_QUESTIONS_FILE = OUTPUT_BASE_DIR / "questions_dev.json"

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


def load_spider_dev_data():
    """Load Spider dev questions (with global index) and table schemas."""
    dev_questions_file = DEV_QUESTIONS_FILE if DEV_QUESTIONS_FILE.exists() else DATA_DIR / 'dev.json'
    tables_file = DATA_DIR / 'tables.json'

    with open(dev_questions_file, 'r', encoding='utf-8') as f:
        spider_data = json.load(f)

    with open(tables_file, 'r', encoding='utf-8') as f:
        tables_data = json.load(f)

    # Attach a stable global index (position in the dev file) to every question
    for idx, item in enumerate(spider_data):
        item['question_index'] = idx

    return spider_data, tables_data


def group_questions_by_db(spider_data):
    """Group dev questions by db_id, preserving original order."""
    db_questions: Dict[str, list] = {}
    for item in spider_data:
        db_questions.setdefault(item['db_id'], []).append(item)
    return db_questions


def collect_column_sample_values(db_id, table_schema, max_values=4, max_len=30):
    """Collect a few distinct sample values per TEXT column for value grounding.

    Returns a list aligned with column_names_original ([] for '*', non-text
    columns, or on any error). This lets agents see real literal casing/spelling
    (e.g. 'Republic' vs 'republic') instead of guessing values.
    """
    import sqlite3

    columns = table_schema['column_names_original']
    types = table_schema['column_types']
    samples = [[] for _ in columns]

    db_file = SPIDER_DATA_DIR / 'database' / db_id / f'{db_id}.sqlite'
    if not db_file.exists():
        print(f"⚠️  Không tìm thấy {db_file}, bỏ qua value grounding cho db '{db_id}'")
        return samples

    try:
        con = sqlite3.connect(f"file:{db_file}?mode=ro", uri=True)
        con.text_factory = lambda b: b.decode(errors='replace')
        tables = table_schema['table_names_original']
        for idx, (t_idx, col_name) in enumerate(columns):
            if t_idx < 0 or idx >= len(types) or types[idx] != 'text':
                continue
            try:
                rows = con.execute(
                    f'SELECT DISTINCT "{col_name}" FROM "{tables[t_idx]}" '
                    f'WHERE "{col_name}" IS NOT NULL LIMIT {max_values}'
                ).fetchall()
                samples[idx] = [str(r[0])[:max_len] for r in rows]
            except Exception:
                pass  # per-column failure is non-fatal
        con.close()
        n_grounded = sum(1 for s in samples if s)
        print(f"🔎 Value grounding: lấy giá trị mẫu cho {n_grounded} cột text của '{db_id}'")
    except Exception as e:
        print(f"⚠️  Value grounding lỗi ({e}), tiếp tục không có sample values")
    return samples


def get_test_questions(num_questions=40, db_id=None, seed=None):
    """Lấy câu hỏi test từ Spider dev set với tùy chọn cố định database và seed.

    num_questions <= 0 nghĩa là lấy TOÀN BỘ câu hỏi của database (giữ nguyên thứ tự).
    """
    global timing_metrics
    start_time = time.time()

    import random
    rng = random.Random(seed)

    spider_data, tables_data = load_spider_dev_data()

    # Đếm số câu hỏi theo database
    print("🔍 Phân tích dữ liệu Spider dev set...")
    db_questions = group_questions_by_db(spider_data)
    db_counts = {db: len(qs) for db, qs in db_questions.items()}

    requested_db_id = db_id

    # Lọc databases có >50 câu hỏi để hỗ trợ random benchmark nhanh
    eligible_dbs = {db: count for db, count in db_counts.items() if count > 50}
    print(f"📊 Tìm thấy {len(eligible_dbs)} databases có >50 câu hỏi:")

    # Sắp xếp và hiển thị top databases
    sorted_dbs = sorted(eligible_dbs.items(), key=lambda x: x[1], reverse=True)
    for i, (db, count) in enumerate(sorted_dbs[:10], 1):
        print(f"   {i}. {db}: {count} câu hỏi")

    if requested_db_id is not None:
        if requested_db_id not in db_questions:
            available_db_preview = ", ".join(sorted(db_questions.keys())[:15])
            raise ValueError(
                f"db_id '{requested_db_id}' không tồn tại trong Spider dev set. Ví dụ db_id hợp lệ: {available_db_preview}"
            )
        selected_db = requested_db_id
        available_questions = db_questions[selected_db]
        print(f"\n🎯 Sử dụng database do người dùng chỉ định: '{selected_db}' với {len(available_questions)} câu hỏi")
    else:
        # Chọn ngẫu nhiên một database có >50 câu hỏi để benchmark nhanh
        selected_db = rng.choice(list(eligible_dbs.keys()))
        available_questions = db_questions[selected_db]
        print(
            f"\n🎯 Đã chọn database ngẫu nhiên: '{selected_db}' với {len(available_questions)} câu hỏi"
        )

    if seed is not None:
        print(f"🎲 Seed lấy mẫu: {seed}")

    # num_questions <= 0: lấy TOÀN BỘ câu hỏi của db theo thứ tự gốc (chế độ benchmark full)
    if num_questions <= 0:
        print(f"📋 Chế độ full-db: lấy toàn bộ {len(available_questions)} câu hỏi (không sample)")
        selected_items = available_questions
    elif num_questions > len(available_questions):
        print(
            f"⚠️  Yêu cầu {num_questions} câu hỏi nhưng chỉ có {len(available_questions)} câu. Lấy tất cả.")
        selected_items = available_questions
    else:
        selected_items = rng.sample(available_questions, num_questions)

    # Tìm schema tương ứng và tạo test_questions
    test_questions = []
    table_schema = None
    for table in tables_data:
        if table['db_id'] == selected_db:
            table_schema = table
            break

    if table_schema:
        # Value grounding: collect sample values per text column once per database
        sample_values = collect_column_sample_values(selected_db, table_schema)
        for item in selected_items:
            test_questions.append({
                'question_index': item.get('question_index', -1),
                'db_id': item['db_id'],
                'question': item['question'],
                'gold_query': item['query'],  # Thêm ground truth
                'table_names_original': table_schema['table_names_original'],
                'column_names_original': table_schema['column_names_original'],
                'column_types': table_schema['column_types'],
                'foreign_keys': table_schema.get('foreign_keys', []),
                'primary_keys': table_schema.get('primary_keys', []),
                'column_sample_values': sample_values,
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

    # Thư mục lưu raw responses của từng agent theo từng câu hỏi
    raw_responses_dir = PIPELINE_OUTPUT_DIR / 'raw_responses'

    for i, question in enumerate(test_questions, 1):
        question_start_time = time.time()
        print(
            f"\n📊 Xử lý câu hỏi {i}/{len(test_questions)}: {question['question'][:50]}...")

        q_index = question.get('question_index', i)
        raw_db_dir = raw_responses_dir / question['db_id']
        raw_file = raw_db_dir / f"q{q_index:04d}.json"

        # Resume: nếu câu này đã có kết quả từ lần chạy trước thì dùng lại, không gọi API
        if raw_file.exists():
            try:
                with open(raw_file, 'r', encoding='utf-8') as f:
                    cached = json.load(f)
                result = {
                    'db_id': cached['db_id'],
                    'question': cached['question'],
                    'gold_query': cached['gold_query'],
                    'sql': cached.get('final_sql', ''),
                    'explain': cached.get('explain', ''),
                    'error': cached.get('error', ''),
                }
                results.append(result)
                if result['sql'] and not result['error']:
                    execution_metrics['successful'] += 1
                else:
                    execution_metrics['failed'] += 1
                with open(csv_filename, 'a', newline='', encoding='utf-8') as csvfile:
                    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                    writer.writerow(result)
                print(f"   ⏩ Đã có kết quả từ lần chạy trước ({raw_file.name}), bỏ qua.")
                continue
            except Exception as e:
                print(f"   ⚠️  Không đọc được cache {raw_file.name} ({e}), chạy lại câu này.")

        try:
            # Chạy NL2SQL flow với schema đã có sẵn trong question
            print("   🔄 Đang chạy multi-agent flow...")

            # Track AI requests (estimate based on typical CrewAI flow)
            # 4-step: khoảng 4 calls, 6-step: khoảng 6 calls
            question_api_calls = 6 if PIPELINE_TYPE == "6step" else 4
            ai_request_count += question_api_calls
            api_call_details['total_agent_calls'] += question_api_calls

            flow = NL2SQLFlow(
                _question=NLQuestions(
                    question=question['question'], db_id=question['db_id']),
                _raw_schema=SQLDbSchema(
                    db_id=question['db_id'],
                    table_names_original=question['table_names_original'],
                    column_names_original=question['column_names_original'],
                    column_types=question['column_types'],
                    foreign_keys=question.get('foreign_keys', []),
                    primary_keys=question.get('primary_keys', []),
                    column_sample_values=question.get('column_sample_values', []),
                )
            )
            flow_result = flow.kickoff()

            result = {
                'db_id': flow_result.db_id,
                'question': flow_result.question,
                'gold_query': question['gold_query'],  # Thêm ground truth
                'sql': flow_result.result.sql,
                'explain': flow_result.result.explain,
                'error': flow_result.result.error,
            }

            # Lưu raw response của TẤT CẢ agent steps cho câu hỏi này
            os.makedirs(raw_db_dir, exist_ok=True)
            with open(raw_file, 'w', encoding='utf-8') as f:
                json.dump({
                    'question_index': q_index,
                    'pipeline': PIPELINE_TYPE,
                    'db_id': question['db_id'],
                    'question': question['question'],
                    'gold_query': question['gold_query'],
                    'steps': getattr(flow, 'step_traces', []),
                    'final_sql': result['sql'],
                    'explain': result['explain'],
                    'error': result['error'],
                    'timestamp': datetime.now().isoformat(),
                }, f, ensure_ascii=False, indent=2)

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

            # Placeholder always-wrong SQL keeps one eval line per question (never drop failures)
            error_result = {
                'db_id': question['db_id'],
                'question': question['question'],
                'gold_query': question['gold_query'],
                'sql': 'SELECT 1',
                'explain': '',
                'error': str(e),
            }
            results.append(error_result)

            # Lưu trace lỗi vào file riêng (.error.json) để resume vẫn chạy lại câu này
            try:
                os.makedirs(raw_db_dir, exist_ok=True)
                error_trace_file = raw_db_dir / f"q{q_index:04d}.error.json"
                partial_steps = getattr(locals().get('flow'), 'step_traces', []) if 'flow' in locals() else []
                with open(error_trace_file, 'w', encoding='utf-8') as f:
                    json.dump({
                        'question_index': q_index,
                        'pipeline': PIPELINE_TYPE,
                        'db_id': question['db_id'],
                        'question': question['question'],
                        'gold_query': question['gold_query'],
                        'steps': partial_steps,
                        'error': str(e),
                        'timestamp': datetime.now().isoformat(),
                    }, f, ensure_ascii=False, indent=2)
            except Exception as log_err:
                print(f"   ⚠️  Không lưu được error trace: {log_err}")

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


# SQL keywords to lowercase for Spider-style normalization (order: longer first to avoid partial match)
_SQL_KEYWORDS = (
    'INTERSECT', 'EXCEPT', 'DISTINCT', 'BETWEEN', 'INNER', 'OUTER', 'ASCENDING', 'DESCENDING',
    'SELECT', 'FROM', 'WHERE', 'GROUP', 'ORDER', 'HAVING', 'LIMIT', 'JOIN', 'LEFT', 'RIGHT',
    'COUNT', 'SUM', 'AVG', 'MIN', 'MAX', 'AND', 'OR', 'NOT', 'IN', 'AS', 'ON', 'BY', 'ASC', 'DESC',
    'IS', 'NULL', 'LIKE', 'UNION', 'TRUE', 'FALSE',
)


def _alias_is_referenced_elsewhere(sql: str, alias: str, span: tuple[int, int]) -> bool:
    """True if `alias` appears as an identifier outside its AS-definition span."""
    elsewhere = sql[: span[0]] + sql[span[1] :]
    return re.search(r"\b" + re.escape(alias) + r"\b", elsewhere, flags=re.IGNORECASE) is not None


def _strip_unreferenced_as_aliases(sql: str) -> str:
    """Remove AS aliases only when they are not referenced later (e.g. in outer MAX(alias))."""

    def strip_paren_alias(match: re.Match) -> str:
        alias = match.group(1)
        if _alias_is_referenced_elsewhere(sql, alias, match.span()):
            return match.group(0)
        return ")"

    def strip_plain_alias(match: re.Match) -> str:
        alias = match.group(1)
        if _alias_is_referenced_elsewhere(sql, alias, match.span()):
            return match.group(0)
        return " "

    # ) AS alias  →  )   (keep when outer query uses the alias)
    sql = re.sub(
        r"\)\s+AS\s+([\w_]+)\b",
        strip_paren_alias,
        sql,
        flags=re.IGNORECASE,
    )
    # identifier AS alias before comma / FROM
    sql = re.sub(
        r"\bAS\s+([\w_]+)\s*(?=,)",
        strip_plain_alias,
        sql,
        flags=re.IGNORECASE,
    )
    sql = re.sub(
        r"\bAS\s+([\w_]+)\s*(?=FROM)",
        strip_plain_alias,
        sql,
        flags=re.IGNORECASE,
    )
    return sql


def normalize_sql_for_spider(sql: str) -> str:
    """
    Normalize predicted SQL toward Spider gold format to improve exact match.
    - Strip trailing semicolon and extra whitespace
    - Lowercase SQL keywords
    - Normalize string literals: single quotes -> double quotes (Spider style)
    - Remove redundant AS aliases only when the alias is not referenced elsewhere
      (keeps subquery aliases used by outer MAX(alias) / subquery.alias)
    """
    if not sql or not sql.strip():
        return sql
    s = sql.strip().rstrip(';').strip()
    # Lowercase keywords (word boundary aware)
    for kw in _SQL_KEYWORDS:
        s = re.sub(r'\b' + re.escape(kw) + r'\b', kw.lower(), s, flags=re.IGNORECASE)
    # Single-quoted string -> double-quoted (Spider style)
    def replace_quotes(m):
        return '"' + m.group(1).replace('"', '""') + '"'
    s = re.sub(r"'([^']*)'", replace_quotes, s)
    s = _strip_unreferenced_as_aliases(s)
    # Collapse multiple spaces
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def convert_csv_to_evaluation_format(csv_filename, output_dir=None):
    """Convert CSV output sang format đánh giá.

    output_dir: nếu được truyền (ví dụ thư mục per-db), gold/predict sẽ lưu vào đó
    thay vì thư mục output chung của pipeline.
    """
    global timing_metrics, PIPELINE_OUTPUT_DIR
    start_time = time.time()

    if PIPELINE_OUTPUT_DIR is None:
        raise RuntimeError(
            "PIPELINE_OUTPUT_DIR chưa được cấu hình. Hãy gọi configure_pipeline() trước."
        )

    print("\n🔄 Đang convert CSV sang format đánh giá...")

    # Lưu gold/predict vào thư mục output của pipeline (hoặc thư mục per-db nếu chỉ định)
    target_dir = Path(output_dir) if output_dir else PIPELINE_OUTPUT_DIR
    os.makedirs(target_dir, exist_ok=True)
    predict_file = target_dir / 'predict.sql'
    gold_file = target_dir / 'gold.sql'

    # Đọc CSV results (đã có ground truth trong CSV)
    with open(csv_filename, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)

        with open(predict_file, 'w', encoding='utf-8') as pred_f, \
                open(gold_file, 'w', encoding='utf-8') as gold_f:

            matched_count = 0
            for row in reader:
                if not row.get('gold_query'):
                    print(
                        f"⚠️ Thiếu ground truth cho: {row['question'][:50]}...")
                    continue
                # Always emit one gold/pred line per question; empty/failed SQL → always-wrong placeholder
                pred_raw = (row.get('sql') or '').strip() or 'SELECT 1'
                gold_f.write(f"{row['gold_query']}\t{row['db_id']}\n")
                pred_sql = normalize_sql_for_spider(pred_raw)
                pred_f.write(f"{pred_sql}\t{row['db_id']}\n")
                matched_count += 1

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


# ===== Benchmark full dev set theo từng database (round 2) =====

def get_progress_file() -> Path:
    """Progress file riêng cho từng pipeline."""
    if PIPELINE_OUTPUT_DIR is None:
        raise RuntimeError("Hãy gọi configure_pipeline() trước.")
    return PIPELINE_OUTPUT_DIR / 'benchmark_progress.json'


def init_or_load_progress() -> dict:
    """Load progress file; nếu chưa có thì khởi tạo danh sách db theo số câu giảm dần."""
    progress_file = get_progress_file()
    if progress_file.exists():
        with open(progress_file, 'r', encoding='utf-8') as f:
            return json.load(f)

    spider_data, _ = load_spider_dev_data()
    db_questions = group_questions_by_db(spider_data)
    # Chạy db nhiều câu trước, db ít câu sau; tie-break theo tên cho ổn định
    db_order = sorted(db_questions.keys(), key=lambda db: (-len(db_questions[db]), db))

    progress = {
        'pipeline': PIPELINE_TYPE,
        'created_at': datetime.now().isoformat(),
        'db_order': db_order,
        'databases': {
            db: {
                'status': 'pending',
                'num_questions': len(db_questions[db]),
                'successful': 0,
                'failed': 0,
                'execution_rate': None,
                'exact_match_rate': None,
                'finished_at': None,
            }
            for db in db_order
        },
    }
    save_progress(progress)
    print(f"🆕 Đã khởi tạo progress file: {progress_file} ({len(db_order)} databases)")
    return progress


def save_progress(progress: dict) -> None:
    progress_file = get_progress_file()
    os.makedirs(progress_file.parent, exist_ok=True)
    with open(progress_file, 'w', encoding='utf-8') as f:
        json.dump(progress, f, ensure_ascii=False, indent=2)


def get_next_pending_db(progress: dict) -> str | None:
    for db in progress['db_order']:
        if progress['databases'][db]['status'] != 'done':
            return db
    return None


def print_benchmark_status(progress: dict) -> None:
    print(f"\n📋 TIẾN ĐỘ BENCHMARK ({progress['pipeline']}) — thứ tự chạy: nhiều câu trước")
    print("=" * 78)
    print(f"{'#':>3}  {'Database':<28} {'Câu hỏi':>8} {'Trạng thái':<10} {'EX%':>6} {'EM%':>6}")
    print("-" * 78)
    total_q = done_q = 0
    for i, db in enumerate(progress['db_order'], 1):
        info = progress['databases'][db]
        total_q += info['num_questions']
        if info['status'] == 'done':
            done_q += info['num_questions']
        ex = f"{info['execution_rate']:.1f}" if info['execution_rate'] is not None else '-'
        em = f"{info['exact_match_rate']:.1f}" if info['exact_match_rate'] is not None else '-'
        print(f"{i:>3}  {db:<28} {info['num_questions']:>8} {info['status']:<10} {ex:>6} {em:>6}")
    print("-" * 78)
    print(f"Tổng: {done_q}/{total_q} câu hỏi đã hoàn thành")
    next_db = get_next_pending_db(progress)
    if next_db:
        print(f"➡️  Database kế tiếp: '{next_db}' — chạy bằng: python run_complete_nl2sql_pipeline.py --pipeline {progress['pipeline']} --next")
    else:
        print(f"🎉 Đã chạy xong toàn bộ! Tổng hợp kết quả: python run_complete_nl2sql_pipeline.py --pipeline {progress['pipeline']} --aggregate")


def run_single_db_benchmark(db_id: str) -> None:
    """Chạy TOÀN BỘ câu hỏi của một database, lưu raw responses, đánh giá và cập nhật tiến độ."""
    progress = init_or_load_progress()
    if db_id not in progress['databases']:
        raise ValueError(f"db_id '{db_id}' không có trong danh sách benchmark.")

    info = progress['databases'][db_id]
    print(f"\n🚀 Bắt đầu benchmark database '{db_id}' ({info['num_questions']} câu hỏi, pipeline {PIPELINE_TYPE})")

    progress['databases'][db_id]['status'] = 'running'
    save_progress(progress)

    start_time = time.time()
    try:
        if not setup_environment():
            raise RuntimeError("Setup environment thất bại")

        # num_questions=0 -> lấy toàn bộ câu hỏi của db (resume tự động qua raw_responses)
        test_questions = get_test_questions(num_questions=0, db_id=db_id)

        csv_filename, results = run_nl2sql_system(test_questions)
        if not csv_filename:
            raise RuntimeError("NL2SQL system thất bại")

        per_db_dir = PIPELINE_OUTPUT_DIR / 'per_db' / db_id
        gold_file, predict_file = convert_csv_to_evaluation_format(csv_filename, output_dir=per_db_dir)
        eval_metrics = run_evaluation(gold_file, predict_file)

        duration = time.time() - start_time
        print_results_table(1, len(test_questions), eval_metrics, duration)

        progress = init_or_load_progress()
        progress['databases'][db_id].update({
            'status': 'done',
            'successful': execution_metrics['successful'],
            'failed': execution_metrics['failed'],
            'execution_rate': eval_metrics.get('execution_rate') if eval_metrics else None,
            'exact_match_rate': eval_metrics.get('exact_match_rate') if eval_metrics else None,
            'finished_at': datetime.now().isoformat(),
        })
        save_progress(progress)

        print(f"\n✅ Database '{db_id}' hoàn thành trong {duration:.1f}s")
        print_benchmark_status(progress)
    except Exception as e:
        progress = init_or_load_progress()
        progress['databases'][db_id]['status'] = 'failed'
        save_progress(progress)
        print(f"\n❌ Database '{db_id}' thất bại: {e}")
        print(f"💡 Chạy lại (tự resume câu đã xong): python run_complete_nl2sql_pipeline.py --pipeline {PIPELINE_TYPE} --run-db {db_id}")
        raise


def aggregate_all_dbs() -> None:
    """Gộp gold/predict của tất cả db đã xong và chạy đánh giá trên toàn bộ dev set."""
    progress = init_or_load_progress()
    per_db_root = PIPELINE_OUTPUT_DIR / 'per_db'
    agg_dir = PIPELINE_OUTPUT_DIR / 'full_dev'
    os.makedirs(agg_dir, exist_ok=True)

    gold_lines, pred_lines, missing = [], [], []
    for db in progress['db_order']:
        db_dir = per_db_root / db
        gold_f, pred_f = db_dir / 'gold.sql', db_dir / 'predict.sql'
        if gold_f.exists() and pred_f.exists():
            with open(gold_f, 'r', encoding='utf-8') as f:
                gold_lines.extend(f.readlines())
            with open(pred_f, 'r', encoding='utf-8') as f:
                pred_lines.extend(f.readlines())
        else:
            missing.append(db)

    if missing:
        print(f"⚠️  Các database chưa có kết quả: {missing}")

    agg_gold = agg_dir / 'gold.sql'
    agg_pred = agg_dir / 'predict.sql'
    with open(agg_gold, 'w', encoding='utf-8') as f:
        f.writelines(gold_lines)
    with open(agg_pred, 'w', encoding='utf-8') as f:
        f.writelines(pred_lines)

    print(f"📦 Đã gộp {len(gold_lines)} cặp gold/predict vào {agg_dir}")
    if not setup_environment():
        print("❌ Setup environment thất bại")
        return
    eval_metrics = run_evaluation(agg_gold, agg_pred)
    if eval_metrics:
        print(f"\n🏁 KẾT QUẢ FULL DEV SET ({PIPELINE_TYPE}): EX={eval_metrics['execution_rate']:.1f}%  EM={eval_metrics['exact_match_rate']:.1f}%")


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
        default=50,
        help="Số câu hỏi sẽ được lấy từ Spider để test pipeline (mặc định: 50; 0 = toàn bộ câu hỏi của db).",
    )
    parser.add_argument(
        "--db_id",
        type=str,
        default=None,
        help="Cố định một database Spider cụ thể để so sánh công bằng giữa các lần chạy.",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=42,
        help="Seed cố định cho việc chọn mẫu câu hỏi trong database (mặc định: 42).",
    )
    # Chế độ benchmark full dev set theo từng database
    parser.add_argument(
        "--next",
        action="store_true",
        help="Chạy TOÀN BỘ câu hỏi của database kế tiếp chưa hoàn thành rồi dừng (benchmark mode).",
    )
    parser.add_argument(
        "--run-db",
        type=str,
        default=None,
        dest="run_db",
        help="Chạy TOÀN BỘ câu hỏi của một database cụ thể trong benchmark mode (tự resume).",
    )
    parser.add_argument(
        "--status",
        action="store_true",
        help="In tiến độ benchmark theo từng database rồi thoát.",
    )
    parser.add_argument(
        "--aggregate",
        action="store_true",
        help="Gộp kết quả tất cả database đã chạy và đánh giá trên toàn bộ dev set.",
    )
    args = parser.parse_args()

    # Cấu hình pipeline tương ứng
    configure_pipeline(args.pipeline)

    # ==== Benchmark mode: chạy theo từng database ====
    if args.status:
        print_benchmark_status(init_or_load_progress())
        return

    if args.aggregate:
        aggregate_all_dbs()
        return

    if args.next or args.run_db:
        if args.run_db:
            target_db = args.run_db
        else:
            target_db = get_next_pending_db(init_or_load_progress())
            if target_db is None:
                print("🎉 Tất cả database đã hoàn thành. Dùng --aggregate để lấy kết quả full dev set.")
                return
        run_single_db_benchmark(target_db)
        return

    print(f"🚀 Bắt đầu chạy Complete NL2SQL Pipeline ({args.pipeline})")
    print("=" * 60)

    start_time = time.time()

    # 1. Setup environment
    if not setup_environment():
        print("❌ Setup environment thất bại")
        return

    # 2. Lấy câu hỏi test (số lượng cấu hình bằng tham số dòng lệnh)
    test_questions = get_test_questions(
        num_questions=args.num_questions,
        db_id=args.db_id,
        seed=args.seed,
    )

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
