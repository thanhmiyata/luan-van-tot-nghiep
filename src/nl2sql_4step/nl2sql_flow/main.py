#!/usr/bin/env python
import csv
import json
import os
from datetime import datetime
from pprint import pprint
from typing import List, Dict, Tuple
from pydantic import BaseModel, Field
from crewai import LLM, Crew
from crewai.flow.flow import Flow, listen, start
from nl2sql_flow.crews.nl2sql_crew.nl2sql_crew import Nl2SqlCrew


class NL2SQLOnlyResult(BaseModel):
    sql: str = ""


class NLQuestions(BaseModel):
    db_id: str = ""
    question: str = ""


class QuestionAnalysisResult(BaseModel):
    intent: str = ""
    complexity: str = ""
    entities: str = "{}"
    requirements: str = "{}"
    patterns: str = "[]"
    linguistic_notes: str = ""
    confidence: float = 0.0


class NL2SQLResult(BaseModel):
    sql: str = ""
    explain: str = ""
    error: str = ""


class NL2SQLQualityResult(BaseModel):
    final_sql: str = ""
    quality_score: float = 0.0
    pipeline_summary: Dict = {}
    recommendations: List[str] = []
    confidence: float = 0.0


class SQLDbSchema(BaseModel):
    db_id: str = ""
    table_names_original: List[str] = []
    column_names_original: List[Tuple[int, str]] = []
    column_types: List[str] = []
    foreign_keys: List[List[int]] = []
    primary_keys: List[int] = []


class NL2SQLState(BaseModel):
    db_id: str = ""
    question: str = ""
    question_analysis: Dict = {}
    db_raw_schema: SQLDbSchema = SQLDbSchema()
    db_schema: SQLDbSchema = SQLDbSchema()
    result: NL2SQLResult = NL2SQLResult()


class NL2SQLFlow(Flow[NL2SQLState]):
    """Flow for generate SQL from natural language instructions."""

    def __init__(self, _question: NLQuestions, _raw_schema: SQLDbSchema):
        super().__init__()
        self.question = _question
        self.raw_schema = _raw_schema

    @start()
    def get_user_input(self):
        print(
            f"\nStarting create SQL for question '{self.question.question}' database {self.raw_schema.db_id}\n")
        self.state.db_id = self.raw_schema.db_id
        self.state.db_raw_schema = self.raw_schema
        self.state.question = self.question.question
        return self.state

    @listen(get_user_input)
    def question_analysis(self):
        print(f"\nAnalyzing question for intent and complexity\n")
        result = Nl2SqlCrew().question_analysis_crew().kickoff(
            inputs={
                "question": self.state.question,
                "raw_db_schema": self.state.db_raw_schema.model_dump_json(),
            }
        )
        self.state.question_analysis = result.to_dict()
        print(
            f"\nQuestion Analysis Results:\n{json.dumps(self.state.question_analysis, indent=2)}\n")
        return self.state

    @listen(question_analysis)
    def schema_selector(self):
        print(f"\nSelecting needed schema database for question\n")
        result = Nl2SqlCrew().select_needed_schema_crew().kickoff(
            inputs={
                "question": self.state.question,
                "raw_db_schema": self.state.db_raw_schema.model_dump_json(),
                "question_analysis": json.dumps(self.state.question_analysis),
            }
        )
        self.state.db_schema = SQLDbSchema(**result.to_dict())
        return self.state

    @listen(schema_selector)
    def generate_sql(self):
        print(f"\nGenerating SQL for question\n")
        result = Nl2SqlCrew().generated_sql_crew().kickoff(
            inputs={
                "question": self.state.question,
                "db_schema": self.state.db_schema.model_dump_json(),
                "question_analysis": json.dumps(self.state.question_analysis),
            }
        )
        self.state.result.sql = result.to_dict()["sql"]
        print(f"\nGenerated SQL:\n{self.state.result.sql}\n")
        return self.state

    @listen(generate_sql)
    def validate_sql(self):
        print(f"\nValidate generated SQL\n")
        result = Nl2SqlCrew().validate_sql_crew().kickoff(
            inputs={
                "question": self.state.question,
                "db_schema": self.state.db_schema.model_dump_json(),
                "sql": self.state.result.sql,
                "question_analysis": json.dumps(self.state.question_analysis),
            }
        ).to_dict()
        self.state.result = NL2SQLResult(**result)
        print(f"\nFinal SQL:\n")
        print(json.dumps(self.state.result.model_dump(), indent=4))

        return self.state


def run_optimized_nl2sql_pipeline(question: str, db_schema: Dict, db_id: str) -> Dict:
    """
    Run the optimized NL2SQL pipeline using the enhanced CrewAI workflow.
    
    Args:
        question: Natural language question
        db_schema: Database schema dictionary
        db_id: Database identifier
        
    Returns:
        Dictionary containing the complete pipeline results
    """
    try:
        # Initialize the optimized crew
        nl2sql_crew = Nl2SqlCrew()
        crew = nl2sql_crew.nl2sql_pipeline_crew()
        
        # Prepare inputs for the pipeline
        inputs = {
            'question': question,
            'raw_db_schema': json.dumps(db_schema, indent=2),
            'db_id': db_id
        }
        
        print(f"🚀 Starting optimized NL2SQL pipeline for question: {question[:50]}...")
        
        # Execute the complete pipeline
        result = crew.kickoff(inputs=inputs)
        
        print("✅ Pipeline completed successfully!")
        
        return {
            'success': True,
            'result': result,
            'pipeline_type': 'optimized_sequential',
            'timestamp': datetime.now().isoformat()
        }
        
    except Exception as e:
        print(f"❌ Pipeline failed: {str(e)}")
        return {
            'success': False,
            'error': str(e),
            'pipeline_type': 'optimized_sequential',
            'timestamp': datetime.now().isoformat()
        }


def generate_filename():
    """Tạo tên file với timestamp theo định dạng yyyymmddhhmmss"""
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    return f"output/nl2sql_results_{timestamp}.csv"


def init_csv_file(filename):
    with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['db_id', 'question', 'sql', 'explain', 'error']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
    print(f"Init result csv: {filename}")


def append_to_csv(result, filename):
    """Thêm một kết quả vào file CSV"""
    with open(filename, 'a', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['db_id', 'question', 'sql', 'explain', 'error']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writerow(result)
    print(
        f"Appended result to CSV: {result['db_id']} - {result['question'][:50]}...")


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
                }
                append_to_csv(result, filename)
                break
    except Exception as e:
        print(
            f"Error processing question: {question['question'][:50]}... due to {e}")


def kickoff():
    filename = generate_filename()
    init_csv_file(filename)
    cnt = 0
    with open('tables.json') as f:
        tables = json.load(f)
        with open('questions.json') as fq:
            questions = json.load(fq)
            for question in questions:
                cnt += 1
                if cnt > 50:
                    exit(0)
                process_single_question(question, tables, filename)
