#!/usr/bin/env python
import csv
import json
import os
import time
from datetime import datetime
from pprint import pprint
from typing import List, Dict, Tuple
from pydantic import BaseModel, Field
from crewai import LLM, Crew
from crewai.flow.flow import Flow, listen, start
from nl2sql_single_agent.crews.nl2sql_crew.nl2sql_crew import Nl2SqlCrew

class NLQuestions(BaseModel):
    db_id: str = ""
    question: str = ""

class NL2SQLResult(BaseModel):
    sql: str = ""
    explain: str = ""
    error: str = ""
    filtered_schema: str = ""

class SQLDbSchema(BaseModel):
    db_id: str = ""
    table_names_original: List[str] = []
    column_names_original: List[Tuple[int, str]] = []
    column_types: List[str] = []

class NL2SQLState(BaseModel):
    db_id: str = ""
    question: str = ""
    db_raw_schema: SQLDbSchema = SQLDbSchema()
    result: NL2SQLResult = NL2SQLResult()

class NL2SQLFlow(Flow[NL2SQLState]):
    """Single Agent Flow for generate SQL from natural language instructions."""

    def __init__(self, _question: NLQuestions, _raw_schema: SQLDbSchema):
        super().__init__()
        self.question = _question
        self.raw_schema = _raw_schema

    @start()
    def get_user_input(self):
        print(f"\nStarting create SQL for question '{self.question.question}' database {self.raw_schema.db_id}\n")
        self.state.db_id = self.raw_schema.db_id
        self.state.db_raw_schema = self.raw_schema
        self.state.question = self.question.question
        return self.state

    @listen(get_user_input)
    def process_nl2sql(self):
        print(f"\nProcessing NL2SQL with single agent\n")
        result = Nl2SqlCrew().nl2sql_crew().kickoff(
            inputs={
                "question": self.state.question,
                "raw_db_schema": self.state.db_raw_schema.model_dump_json(),
            }
        )
        self.state.result = NL2SQLResult(**result.to_dict())
        print(f"\nFinal SQL:\n")
        print(json.dumps(self.state.result.model_dump(), indent=4))
        return self.state

def generate_filename():
    """Tạo tên file với timestamp theo định dạng yyyymmddhhmmss"""
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    return f"output/nl2sql_single_agent_results_{timestamp}.csv"

def init_csv_file(filename):
    with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['db_id', 'question', 'sql', 'explain', 'error', 'filtered_schema']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
    print(f"Init result csv: {filename}")

def append_to_csv(result, filename):
    """Thêm một kết quả vào file CSV"""
    with open(filename, 'a', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['db_id', 'question', 'sql', 'explain', 'error', 'filtered_schema']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writerow(result)
    print(f"Appended result to CSV: {result['db_id']} - {result['question'][:50]}...")

def process_single_question(question, tables, filename):
    try:
        print(f"\nProcessing question: {question['question'][:50]}...\n")
        for table in tables:
            if table['db_id'] == question['db_id']:
                raw_result = NL2SQLFlow(_question=NLQuestions(question=question['question'], db_id=question['db_id']),
                                        _raw_schema=SQLDbSchema(
                                            db_id=table['db_id'],
                                            table_names_original=table['table_names_original'],
                                            column_names_original=table['column_names_original'],
                                            column_types=table['column_types'],
                                        )).kickoff()
                result = {
                    'db_id': raw_result.db_id,
                    'question': raw_result.question,
                    'sql': raw_result.result.sql,
                    'explain': raw_result.result.explain,
                    'error': raw_result.result.error,
                    'filtered_schema': raw_result.result.filtered_schema,
                }
                append_to_csv(result, filename)
                break
    except Exception as e:
        print(f"Error processing question: {question['question'][:50]}... due to {e}")

def kickoff():
    filename = generate_filename()
    init_csv_file(filename)
    cnt = 0
    with open('tables.json', encoding='utf-8') as f:
        tables = json.load(f)
        with open('questions.json', encoding='utf-8') as fq:
            questions = json.load(fq)
            for question in questions:
               cnt += 1
               if cnt > 50:
                   exit(0)
               process_single_question(question, tables, filename)
               # Thêm delay 3 giây giữa các lần call để tránh overload
               print(f"\nWaiting 3 seconds before next call...")
               time.sleep(3) 