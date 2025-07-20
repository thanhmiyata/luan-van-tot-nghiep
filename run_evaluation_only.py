#!/usr/bin/env python3
"""
Script để chỉ chạy phần đánh giá cuối cùng với gold.sql và predict.sql đã có sẵn
"""

import os
import subprocess
import shutil
from pathlib import Path

def run_evaluation_only():
    """Chỉ chạy phần đánh giá với các file đã có sẵn"""
    print("📊 Đang chạy đánh giá bằng test-suite-sql-eval...")
    
    # Đường dẫn các file
    eval_dir = Path('experiments/test-suite-sql-eval')
    current_dir = Path.cwd()
    gold_file = 'experiments/experiment3_multi_agent_crewai/gold.sql'
    predict_file = 'experiments/experiment3_multi_agent_crewai/predict.sql'
    
    # Kiểm tra các file cần thiết
    if not Path(gold_file).exists():
        print(f"❌ Không tìm thấy file: {gold_file}")
        return False
        
    if not Path(predict_file).exists():
        print(f"❌ Không tìm thấy file: {predict_file}")
        return False
        
    if not eval_dir.exists():
        print(f"❌ Không tìm thấy thư mục: {eval_dir}")
        return False
    
    try:
        # Copy tables.json nếu chưa có
        tables_source = current_dir / 'experiments/experiment3_multi_agent_crewai/tables.json'
        tables_target = eval_dir / 'tables.json'
        
        if not tables_target.exists() and tables_source.exists():
            print(f"📁 Đang copy tables.json từ {tables_source} sang {tables_target}")
            shutil.copy2(tables_source, tables_target)
        elif tables_target.exists():
            print("✅ File tables.json đã tồn tại trong test-suite-sql-eval")
        
        # Chuyển đến thư mục evaluation
        os.chdir(eval_dir)
        
        # Kiểm tra các file cần thiết
        required_files = [
            'evaluation.py',
            'tables.json',
            '../experiment3_multi_agent_crewai/gold.sql',
            '../experiment3_multi_agent_crewai/predict.sql'
        ]
        
        missing_files = []
        for file in required_files:
            if not Path(file).exists():
                missing_files.append(file)
        
        if missing_files:
            print(f"❌ Thiếu các file cần thiết: {missing_files}")
            return False
        
        # Chạy lệnh evaluation
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
        
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
        
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
            print(f"❌ Evaluation script kết thúc với mã lỗi: {result.returncode}")
            return False
        
        print("\n✅ Đánh giá hoàn thành thành công!")
        return True
        
    except subprocess.TimeoutExpired:
        print("❌ Evaluation script bị timeout (quá 5 phút)")
        return False
    except Exception as e:
        print(f"❌ Lỗi khi chạy đánh giá: {e}")
        return False
    finally:
        os.chdir(current_dir)

if __name__ == "__main__":
    print("🎯 Chạy chỉ phần đánh giá SQL")
    print("=" * 40)
    success = run_evaluation_only()
    if success:
        print("🎉 Đánh giá hoàn thành thành công!")
    else:
        print("❌ Đánh giá thất bại!") 