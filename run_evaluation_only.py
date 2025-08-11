#!/usr/bin/env python3
"""
Script để chỉ chạy phần đánh giá cuối cùng với gold.sql và predict.sql đã có sẵn
Cho dự án Single Agent NL2SQL
"""

import os
import subprocess
import shutil
from pathlib import Path


def run_evaluation_only():
    """Chỉ chạy phần đánh giá với các file đã có sẵn cho Single Agent"""
    print("📊 Đang chạy đánh giá bằng test-suite-sql-eval cho Single Agent...")

    # Đường dẫn các file cho Single Agent
    eval_dir = Path('experiments/test-suite-sql-eval')
    current_dir = Path.cwd()
    gold_file = 'experiments/experiments_single_agent/gold.sql'
    predict_file = 'experiments/experiments_single_agent/predict.sql'

    # Kiểm tra các file cần thiết
    if not Path(gold_file).exists():
        print(f"❌ Không tìm thấy file: {gold_file}")
        print("💡 Hãy chạy convert-output-format.py trong thư mục experiments_single_agent trước")
        return False

    if not Path(predict_file).exists():
        print(f"❌ Không tìm thấy file: {predict_file}")
        print("💡 Hãy chạy convert-output-format.py trong thư mục experiments_single_agent trước")
        return False

    if not eval_dir.exists():
        print(f"❌ Không tìm thấy thư mục: {eval_dir}")
        return False

    try:
        # Copy tables.json nếu chưa có
        tables_source = current_dir / 'experiments/experiments_single_agent/tables.json'
        tables_target = eval_dir / 'tables.json'

        if not tables_target.exists() and tables_source.exists():
            print(
                f"📁 Đang copy tables.json từ {tables_source} sang {tables_target}")
            shutil.copy2(tables_source, tables_target)
        elif tables_target.exists():
            print("✅ File tables.json đã tồn tại trong test-suite-sql-eval")

        # Chuyển đến thư mục evaluation
        os.chdir(eval_dir)

        # Kiểm tra các file cần thiết
        required_files = [
            'evaluation.py',
            'tables.json',
            '../experiments_single_agent/gold.sql',
            '../experiments_single_agent/predict.sql'
        ]

        missing_files = []
        for file in required_files:
            if not Path(file).exists():
                missing_files.append(file)

        if missing_files:
            print(f"❌ Thiếu các file cần thiết: {missing_files}")
            return False

        # Chạy lệnh evaluation cho Single Agent
        cmd = [
            'python', 'evaluation.py',
            '--gold', '../experiments_single_agent/gold.sql',
            '--pred', '../experiments_single_agent/predict.sql',
            '--db', 'database',
            '--etype', 'all',
            '--table', 'tables.json',
            '--plug_value'
        ]

        print(f"🚀 Chạy lệnh đánh giá Single Agent: {' '.join(cmd)}")
        print("📈 Đang đánh giá hiệu suất Single Agent vs Multi-Agent...")

        result = subprocess.run(
            cmd, capture_output=True, text=True, timeout=300)

        print("\n📋 Kết quả đánh giá Single Agent:")
        print("=" * 60)
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
            return False

        print("\n✅ Đánh giá Single Agent hoàn thành thành công!")
        print("📊 Kết quả này sẽ được so sánh với Multi-Agent approach")
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
    print("🎯 Chạy chỉ phần đánh giá SQL cho Single Agent")
    print("=" * 50)
    success = run_evaluation_only()
    if success:
        print("🎉 Đánh giá Single Agent hoàn thành thành công!")
        print("💡 So sánh kết quả với Multi-Agent để đánh giá hiệu suất")
    else:
        print("❌ Đánh giá Single Agent thất bại!")
