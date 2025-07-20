#!/usr/bin/env python3
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
from dotenv import load_dotenv

# Load environment variables từ .env file
load_dotenv('experiments/experiment3_multi_agent_crewai/.env')

# Thêm đường dẫn để import các module CrewAI
sys.path.append('experiments/experiment3_multi_agent_crewai/src')

def setup_environment():
    """Setup môi trường và copy database cần thiết"""
    print("🔧 Đang setup môi trường...")
    
    # Tạo thư mục output nếu chưa có
    os.makedirs('experiments/experiment3_multi_agent_crewai/output', exist_ok=True)
    
    # Copy database từ spider_data sang test-suite-sql-eval
    source_db_dir = Path('Data Set/spider_data/database')
    target_db_dir = Path('experiments/test-suite-sql-eval/database')
    
    if source_db_dir.exists() and not target_db_dir.exists():
        print(f"📁 Đang copy database từ {source_db_dir} sang {target_db_dir}")
        shutil.copytree(source_db_dir, target_db_dir)
    elif target_db_dir.exists():
        print("✅ Database đã tồn tại trong test-suite-sql-eval")
    else:
        print("❌ Không tìm thấy database source")
        return False
    
    return True

def get_test_questions(num_questions=50):
    """Lấy số câu hỏi test được chỉ định"""
    questions_file = 'experiments/experiment3_multi_agent_crewai/questions.json'
    
    with open(questions_file, 'r', encoding='utf-8') as f:
        all_questions = json.load(f)
    
    # Lấy số câu hỏi được chỉ định
    test_questions = all_questions[:num_questions]
    
    print(f"📝 Đã chọn {len(test_questions)} câu hỏi test:")
    for i, q in enumerate(test_questions, 1):
        print(f"   {i}. {q['question'][:60]}... (db: {q['db_id']})")
    
    return test_questions

def run_nl2sql_system(test_questions):
    """Chạy hệ thống NL2SQL CrewAI"""
    print("\n🤖 Đang chạy hệ thống NL2SQL CrewAI...")
    
    # Import các module cần thiết từ CrewAI
    try:
        from pydantic import BaseModel
        from nl2sql_flow.main import NL2SQLFlow, NLQuestions, SQLDbSchema, NL2SQLResult
    except ImportError as e:
        print(f"❌ Lỗi import module CrewAI: {e}")
        print("💡 Hãy đảm bảo đã cài đặt crewai và các dependencies")
        return None
    
    # Load database schemas
    tables_file = 'experiments/experiment3_multi_agent_crewai/tables.json'
    with open(tables_file, 'r', encoding='utf-8') as f:
        tables = json.load(f)
    
    # Tạo file CSV output
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    csv_filename = f'experiments/experiment3_multi_agent_crewai/output/nl2sql_results_{timestamp}.csv'
    
    # Initialize CSV file
    with open(csv_filename, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['db_id', 'question', 'sql', 'explain', 'error']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
    
    results = []
    
    for i, question in enumerate(test_questions, 1):
        print(f"\n📊 Xử lý câu hỏi {i}/{len(test_questions)}: {question['question'][:50]}...")
        
        try:
            # Tìm schema tương ứng
            table_schema = None
            for table in tables:
                if table['db_id'] == question['db_id']:
                    table_schema = table
                    break
            
            if not table_schema:
                print(f"❌ Không tìm thấy schema cho database: {question['db_id']}")
                continue
            
            # Chạy NL2SQL flow
            print("   🔄 Đang chạy multi-agent flow...")
            flow_result = NL2SQLFlow(
                _question=NLQuestions(question=question['question'], db_id=question['db_id']),
                _raw_schema=SQLDbSchema(
                    db_id=table_schema['db_id'],
                    table_names_original=table_schema['table_names_original'],
                    column_names_original=table_schema['column_names_original'],
                    column_types=table_schema['column_types'],
                )
            ).kickoff()
            
            result = {
                'db_id': flow_result.db_id,
                'question': flow_result.question,
                'sql': flow_result.result.sql,
                'explain': flow_result.result.explain,
                'error': flow_result.result.error,
            }
            
            results.append(result)
            
            # Ghi vào CSV
            with open(csv_filename, 'a', newline='', encoding='utf-8') as csvfile:
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writerow(result)
            
            print(f"   ✅ Hoàn thành: SQL = {result['sql'][:50]}...")
            
        except Exception as e:
            print(f"   ❌ Lỗi xử lý câu hỏi: {e}")
            error_result = {
                'db_id': question['db_id'],
                'question': question['question'],
                'sql': '',
                'explain': '',
                'error': str(e),
            }
            results.append(error_result)
            
            # Ghi lỗi vào CSV
            with open(csv_filename, 'a', newline='', encoding='utf-8') as csvfile:
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writerow(error_result)
    
    print(f"\n✅ Hoàn thành chạy NL2SQL system. Kết quả được lưu tại: {csv_filename}")
    return csv_filename, results

def convert_csv_to_evaluation_format(csv_filename):
    """Convert CSV output sang format đánh giá"""
    print("\n🔄 Đang convert CSV sang format đánh giá...")
    
    train_spider_file = 'experiments/experiment3_multi_agent_crewai/train_spider.json'
    predict_file = 'experiments/experiment3_multi_agent_crewai/predict.sql'
    gold_file = 'experiments/experiment3_multi_agent_crewai/gold.sql'
    
    # Load train_spider.json để lấy ground truth
    with open(train_spider_file, 'r', encoding='utf-8') as f:
        train_questions = json.load(f)
    
    # Tạo dict để tra cứu nhanh ground truth
    ground_truth_dict = {}
    for item in train_questions:
        ground_truth_dict[item['question']] = {
            'query': item['query'],
            'db_id': item['db_id']
        }
    
    # Đọc CSV results
    with open(csv_filename, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        with open(predict_file, 'w', encoding='utf-8') as pred_f, \
             open(gold_file, 'w', encoding='utf-8') as gold_f:
            
            matched_count = 0
            for row in reader:
                question = row['question']
                if question in ground_truth_dict:
                    gt = ground_truth_dict[question]
                    # Format: SQL\tdb_id
                    gold_f.write(f"{gt['query']}\t{gt['db_id']}\n")
                    pred_f.write(f"{row['sql']}\t{row['db_id']}\n")
                    matched_count += 1
                else:
                    print(f"⚠️ Không tìm thấy ground truth cho câu hỏi: {question[:50]}...")
    
    print(f"✅ Convert hoàn thành. Matched {matched_count} câu hỏi")
    print(f"   📄 Gold file: {gold_file}")
    print(f"   📄 Predict file: {predict_file}")
    
    return gold_file, predict_file

def run_evaluation(gold_file, predict_file):
    """Chạy đánh giá bằng test-suite-sql-eval"""
    print("\n📊 Đang chạy đánh giá bằng test-suite-sql-eval...")
    
    # Chuyển đến thư mục test-suite-sql-eval
    eval_dir = Path('experiments/test-suite-sql-eval')
    current_dir = Path.cwd()
    
    try:
        os.chdir(eval_dir)
        
        # Copy tables.json từ experiment3 sang test-suite-sql-eval nếu chưa có
        tables_source = current_dir / 'experiments/experiment3_multi_agent_crewai/tables.json'
        tables_target = eval_dir / 'tables.json'
        
        if not tables_target.exists() and tables_source.exists():
            print(f"📁 Đang copy tables.json từ {tables_source} sang {tables_target}")
            shutil.copy2(tables_source, tables_target)
        
        # Sử dụng đường dẫn tương đối như user đã chỉ ra
        cmd = [
            'python', 'evaluation.py',
            '--gold', '../experiment3_multi_agent_crewai/gold.sql',
            '--pred', '../experiment3_multi_agent_crewai/predict.sql',
            '--db', 'database',
            '--etype', 'all',
            '--table', 'tables.json',
            '--plug_value'
        ]
        
        print(f"🚀 Chạy lệnh: {' '.join(cmd)}")
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        print("\n📋 Kết quả đánh giá:")
        print("=" * 50)
        print(result.stdout)
        
        if result.stderr:
            print("\n⚠️ Warnings/Errors:")
            print(result.stderr)
        
        return result.returncode == 0
        
    except Exception as e:
        print(f"❌ Lỗi khi chạy đánh giá: {e}")
        return False
    finally:
        os.chdir(current_dir)

def main():
    """Hàm chính chạy toàn bộ pipeline"""
    print("🚀 Bắt đầu chạy Complete NL2SQL Pipeline")
    print("=" * 60)
    
    start_time = time.time()
    
    # 1. Setup environment
    if not setup_environment():
        print("❌ Setup environment thất bại")
        return
    
    # 2. Lấy câu hỏi test
    test_questions = get_test_questions(50)
    
    # 3. Chạy NL2SQL system
    csv_filename, results = run_nl2sql_system(test_questions)
    if not csv_filename:
        print("❌ NL2SQL system thất bại")
        return
    
    # 4. Convert format
    gold_file, predict_file = convert_csv_to_evaluation_format(csv_filename)
    
    # 5. Chạy evaluation
    success = run_evaluation(gold_file, predict_file)
    
    end_time = time.time()
    duration = end_time - start_time
    
    print("\n" + "=" * 60)
    if success:
        print("🎉 Pipeline hoàn thành thành công!")
    else:
        print("⚠️ Pipeline hoàn thành nhưng có lỗi trong đánh giá")
    
    print(f"⏱️ Tổng thời gian: {duration:.2f} giây")
    print("\n📁 Các file được tạo:")
    print(f"   - CSV kết quả: {csv_filename}")
    print(f"   - Gold SQL: {gold_file}")
    print(f"   - Predict SQL: {predict_file}")

if __name__ == "__main__":
    main() 