import csv
import json

if __name__ == "__main__":
    with open("output/nl2sql_results_20250718214534.csv", "r", encoding='utf-8') as f:
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
