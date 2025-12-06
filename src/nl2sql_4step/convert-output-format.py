import csv
import json
import os
import glob

def get_latest_csv_file():
    """Tìm file CSV kết quả mới nhất trong thư mục output"""
    csv_files = glob.glob("output/nl2sql_results_*.csv")
    if not csv_files:
        raise FileNotFoundError("Không tìm thấy file kết quả CSV nào trong thư mục output/")
    # Sắp xếp theo thời gian tạo file (mới nhất trước)
    latest_file = max(csv_files, key=os.path.getctime)
    return latest_file

if __name__ == "__main__":
    latest_csv = get_latest_csv_file()
    print(f"Sử dụng file kết quả: {latest_csv}")
    
    with open(latest_csv, "r", encoding='utf-8') as f:
        fieldnames = ['db_id', 'question', 'sql', 'explain', 'error']
        result_reader = csv.DictReader(f, fieldnames=fieldnames)
        with open('train_spider.json', 'r', encoding='utf-8') as fq:
            questions = json.load(fq)
            with open('predict.sql', 'w', encoding='utf-8') as output_predict_file:
                with open('gold.sql', 'w', encoding='utf-8') as output_gold_file:
                    for row_num, row in enumerate(result_reader, 1):
                        for question in questions:
                            if question['question'] == row['question']:
                                output_gold_file.write(f"{question['query']}	{question['db_id']}\n")
                                output_predict_file.write(f"{row['sql']}	{row['db_id']}\n")
                                break
