#!/usr/bin/env python
import csv
import hashlib
import json
import os
import re
import time
from concurrent.futures import ThreadPoolExecutor, TimeoutError as FuturesTimeoutError
from datetime import datetime
from pprint import pprint
from typing import Any, List, Dict, Tuple
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
    expected_output_fields: List[str] = []
    field_order_critical: bool = True
    single_table_ok: bool = False
    output_fields_detailed: List[Dict] = []
    filters: List[Dict] = []
    group_by: List[Dict] = []
    order_by: List[Dict] = []
    join_hints: List[Dict] = []
    entities: Dict = {}
    self_join_hint: bool = False
    set_operation_type: str = "NONE"
    null_handling: str = "UNKNOWN"
    where_condition_type: str = "EQUALS"
    confidence: float = 0.0


class NL2SQLResult(BaseModel):
    sql: str = ""
    explain: str = ""
    error: str = ""


class QueryPlanResult(BaseModel):
    steps: List[Dict] = []


class RefinedSQLResult(BaseModel):
    sql: str = ""
    notes: str = ""


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
    query_plan: Dict = {}
    intermediate_sql: str = ""
    result: NL2SQLResult = NL2SQLResult()


class NL2SQLFlow(Flow[NL2SQLState]):
    """Flow for generate SQL from natural language instructions."""

    STEP_TIMEOUT_SECONDS = int(os.getenv("NL2SQL_STEP_TIMEOUT_SECONDS", "120"))
    STEP_MAX_RETRIES = int(os.getenv("NL2SQL_STEP_MAX_RETRIES", "2"))

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

    def parse_json_safely(self, text: str) -> Dict:
        """Extract and parse JSON from LLM output that might contain markdown backticks."""
        def iter_json_candidates(raw_text: str):
            stripped = raw_text.strip()
            if stripped:
                yield stripped

            # Many providers wrap valid JSON in fenced code blocks.
            for match in re.finditer(r'```(?:json)?\s*(.*?)\s*```', raw_text, re.DOTALL | re.IGNORECASE):
                candidate = match.group(1).strip()
                if candidate:
                    yield candidate

            # Some models prepend prose and then append a JSON object at the end.
            stack = 0
            start_idx = None
            objects = []
            for idx, ch in enumerate(raw_text):
                if ch == "{":
                    if stack == 0:
                        start_idx = idx
                    stack += 1
                elif ch == "}":
                    if stack > 0:
                        stack -= 1
                        if stack == 0 and start_idx is not None:
                            candidate = raw_text[start_idx:idx + 1].strip()
                            if candidate:
                                objects.append(candidate)
                            start_idx = None

            # Prefer later JSON objects because the actual answer is often appended last.
            for candidate in reversed(objects):
                yield candidate

        last_error = None
        for candidate in iter_json_candidates(text):
            try:
                return json.loads(candidate)
            except Exception as e:
                last_error = e

        if last_error is not None:
            print(f"Warning: Failed to parse JSON from text. Error: {last_error}")
        return {}

    def _sanitize_text(self, value: str) -> str:
        """Remove characters that frequently break JSON serialization or provider parsing."""
        if not value:
            return value
        sanitized = value.replace("\x00", "")
        sanitized = sanitized.encode("utf-8", "replace").decode("utf-8")
        sanitized = re.sub(r"[\x01-\x08\x0b\x0c\x0e-\x1f]", " ", sanitized)
        return sanitized

    def _sanitize_inputs(self, value: Any) -> Any:
        if isinstance(value, str):
            return self._sanitize_text(value)
        if isinstance(value, list):
            return [self._sanitize_inputs(item) for item in value]
        if isinstance(value, dict):
            return {key: self._sanitize_inputs(val) for key, val in value.items()}
        return value

    def _log_input_summary(self, step_name: str, inputs: Dict[str, Any]) -> None:
        summary_parts = []
        for key, value in inputs.items():
            serialized = value if isinstance(value, str) else json.dumps(value, ensure_ascii=False)
            digest = hashlib.md5(serialized.encode("utf-8", "ignore")).hexdigest()[:8]
            preview = serialized[:120].replace("\n", " ")
            summary_parts.append(
                f"{key}:len={len(serialized)} md5={digest} preview={preview!r}"
            )
        print(f"[API][{step_name}] Input summary")
        for part in summary_parts:
            print(f"  - {part}")

    def _run_crew_step(self, step_name: str, crew_factory, inputs: Dict[str, Any]):
        sanitized_inputs = self._sanitize_inputs(inputs)
        self._log_input_summary(step_name, sanitized_inputs)
        last_error: Exception | None = None

        for attempt in range(1, self.STEP_MAX_RETRIES + 1):
            executor = ThreadPoolExecutor(max_workers=1)
            started_at = time.time()
            print(
                f"[API][{step_name}] Attempt {attempt}/{self.STEP_MAX_RETRIES} started "
                f"(timeout={self.STEP_TIMEOUT_SECONDS}s)"
            )
            try:
                future = executor.submit(lambda: crew_factory().kickoff(inputs=sanitized_inputs))
                result = future.result(timeout=self.STEP_TIMEOUT_SECONDS)
                elapsed = time.time() - started_at
                raw_text = getattr(result, "raw", "")
                print(
                    f"[API][{step_name}] Attempt {attempt} completed in {elapsed:.1f}s "
                    f"(raw_len={len(raw_text)})"
                )
                executor.shutdown(wait=False, cancel_futures=True)
                return result
            except FuturesTimeoutError as e:
                last_error = TimeoutError(
                    f"{step_name} timed out after {self.STEP_TIMEOUT_SECONDS}s on attempt {attempt}"
                )
                print(f"[API][{step_name}] Timeout on attempt {attempt}")
                future.cancel()
                executor.shutdown(wait=False, cancel_futures=True)
            except Exception as e:
                last_error = e
                print(f"[API][{step_name}] Error on attempt {attempt}: {type(e).__name__}: {e}")
                executor.shutdown(wait=False, cancel_futures=True)

            if attempt < self.STEP_MAX_RETRIES:
                backoff = min(5 * attempt, 15)
                print(f"[API][{step_name}] Retrying after {backoff}s")
                time.sleep(backoff)

        assert last_error is not None
        raise last_error

    @listen(get_user_input)
    def question_analysis(self):
        print(f"\nAnalyzing question for intent and complexity\n")
        result = self._run_crew_step(
            "question_analysis",
            Nl2SqlCrew().question_analysis_crew,
            {
                "question": self.state.question,
                "raw_db_schema": self.state.db_raw_schema.model_dump_json(),
            },
        )
        self.state.question_analysis = self.parse_json_safely(result.raw)
        print(
            f"\nQuestion Analysis Results:\n{json.dumps(self.state.question_analysis, indent=2)}\n")
        return self.state

    @listen(question_analysis)
    def schema_selector(self):
        print(f"\nSelecting needed schema database for question\n")
        result = self._run_crew_step(
            "schema_selector",
            Nl2SqlCrew().select_needed_schema_crew,
            {
                "question": self.state.question,
                "raw_db_schema": self.state.db_raw_schema.model_dump_json(),
                "question_analysis": json.dumps(self.state.question_analysis),
            },
        )
        schema_dict = self.parse_json_safely(result.raw)
        self.state.db_schema = SQLDbSchema(**schema_dict)
        return self.state

    @listen(schema_selector)
    def query_planning(self):
        print(f"\nPlanning query strategy\n")
        result = self._run_crew_step(
            "query_planning",
            Nl2SqlCrew().query_planning_crew,
            {
                "question": self.state.question,
                "db_schema": self.state.db_schema.model_dump_json(),
                "question_analysis": json.dumps(self.state.question_analysis),
            },
        )
        self.state.query_plan = self.parse_json_safely(result.raw)
        print(f"\nQuery Plan:\n{json.dumps(self.state.query_plan, indent=2)}\n")
        return self.state

    @listen(query_planning)
    def generate_sql(self):
        print(f"\nGenerating SQL for question\n")
        result = self._run_crew_step(
            "generate_sql",
            Nl2SqlCrew().generated_sql_crew,
            {
                "question": self.state.question,
                "db_schema": self.state.db_schema.model_dump_json(),
                "question_analysis": json.dumps(self.state.question_analysis),
                "query_plan": json.dumps(self.state.query_plan),
            },
        )
        sql_dict = self.parse_json_safely(result.raw)
        self.state.intermediate_sql = sql_dict.get("sql", result.raw)
        print(f"\nGenerated initial SQL:\n{self.state.intermediate_sql}\n")
        return self.state

    @listen(generate_sql)
    def refine_sql(self):
        print(f"\nRefining generated SQL\n")
        try:
            result = self._run_crew_step(
                "refine_sql",
                Nl2SqlCrew().sql_refinement_crew,
                {
                    "question": self.state.question,
                    "db_schema": self.state.db_schema.model_dump_json(),
                    "sql": self.state.intermediate_sql,
                    "question_analysis": json.dumps(self.state.question_analysis),
                    "query_plan": json.dumps(self.state.query_plan),
                },
            )
            result_dict = self.parse_json_safely(result.raw)
            self.state.result.sql = result_dict.get("sql", self.state.intermediate_sql)
        except Exception as e:
            print(f"[API][refine_sql] Fallback to intermediate SQL due to: {type(e).__name__}: {e}")
            self.state.result.sql = self.state.intermediate_sql
        print(f"\nRefined SQL:\n{self.state.result.sql}\n")
        return self.state

    @listen(refine_sql)
    def validate_sql(self):
        print(f"\nValidate generated SQL\n")
        try:
            result = self._run_crew_step(
                "validate_sql",
                Nl2SqlCrew().validate_sql_crew,
                {
                    "question": self.state.question,
                    "db_schema": self.state.db_schema.model_dump_json(),
                    "sql": self.state.result.sql,
                    "question_analysis": json.dumps(self.state.question_analysis),
                },
            )
            result_dict = self.parse_json_safely(result.raw)
            self.state.result = NL2SQLResult(**result_dict)
        except Exception as e:
            print(f"[API][validate_sql] Fallback to current SQL due to: {type(e).__name__}: {e}")
            self.state.result = NL2SQLResult(
                sql=self.state.result.sql,
                explain="Validator fallback after API failure/timeout.",
                error="",
            )
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
