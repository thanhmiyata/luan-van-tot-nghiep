import csv
import json
import os
from pathlib import Path

if __name__ == "__main__":
    # Tìm file CSV mới nhất trong thư mục output
    output_dir = Path("output")
    csv_files = list(output_dir.glob("nl2sql_single_agent_results_*.csv"))

    if not csv_files:
        print("❌ Không tìm thấy file CSV trong thư mục output")
        exit(1)

    # Lấy file mới nhất
    latest_csv = max(csv_files, key=lambda x: x.stat().st_mtime)
    print(f"📁 Sử dụng file: {latest_csv}")

    with open(latest_csv, "r", encoding='utf-8') as f:
        fieldnames = ['db_id', 'question', 'sql',
                      'explain', 'error', 'filtered_schema']
        result_reader = csv.DictReader(f, fieldnames=fieldnames)
        with open('vi_train_spider.json', 'r', encoding='utf-8') as fq:
            questions = json.load(fq)
            with open('predict.sql', 'w', encoding='utf-8') as output_predict_file:
                with open('gold.sql', 'w', encoding='utf-8') as output_gold_file:
                    matched_count = 0
                    for row_num, row in enumerate(result_reader, 1):
                        matched = False
                        for question in questions:
                            if question['question'] == row['question']:
                                output_gold_file.write(
                                    f"{question['query']}	{question['db_id']}\n")
                                output_predict_file.write(
                                    f"{row['sql']}	{row['db_id']}\n")
                                matched_count += 1
                                matched = True
                                break
                        if not matched:
                            print(
                                f"⚠️ Không tìm thấy câu hỏi: {row['question']}")

                    print(f"✅ Đã match {matched_count} câu hỏi")
                    print(f"📁 Đã tạo gold.sql và predict.sql")
