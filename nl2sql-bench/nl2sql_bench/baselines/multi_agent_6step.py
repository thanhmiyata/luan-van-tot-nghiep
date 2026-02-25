"""
Multi-Agent 6-Step NL2SQL Baseline for NL2SQL-Bench.

This module wraps the 6-step Multi-Agent NL2SQL system as a baseline
for comparison in the benchmark framework.

The 6-step pipeline consists of:
1. Question Analyzer (Claude 3.7 Sonnet) - Extract intent and entities
2. Schema Selector (Gemini 2.0 Flash) - Filter relevant tables/columns
3. Query Planner (Claude 3.7 Sonnet) - Create execution plan
4. SQL Expert (GPT-4o) - Generate initial SQL
5. SQL Refiner (Claude 3.7 Sonnet) - Refine and improve SQL
6. SQL Validator (Gemini 2.0 Flash) - Validate final SQL

Requires additional dependencies:
    pip install crewai openai anthropic google-generativeai
"""

import json
import os
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

from nl2sql_bench.core.base import NL2SQLInput, NL2SQLOutput, NL2SQLSystem

# Type definitions for schema
try:
    from pydantic import BaseModel
except ImportError:
    BaseModel = object


class SQLDbSchema(BaseModel):
    """Database schema model matching the existing pipeline."""
    db_id: str = ""
    table_names_original: List[str] = []
    column_names_original: List[Tuple[int, str]] = []
    column_types: List[str] = []
    foreign_keys: List[List[int]] = []
    primary_keys: List[int] = []


def convert_spider_schema_to_internal(spider_schema: Dict[str, Any]) -> SQLDbSchema:
    """
    Convert Spider format schema to internal SQLDbSchema format.
    
    Args:
        spider_schema: Schema in Spider dataset format.
        
    Returns:
        SQLDbSchema object compatible with the pipeline.
    """
    return SQLDbSchema(
        db_id=spider_schema.get("db_id", ""),
        table_names_original=spider_schema.get("table_names_original", []),
        column_names_original=[
            tuple(col) if isinstance(col, list) else col
            for col in spider_schema.get("column_names_original", [])
        ],
        column_types=spider_schema.get("column_types", []),
        foreign_keys=spider_schema.get("foreign_keys", []),
        primary_keys=spider_schema.get("primary_keys", []),
    )


class MultiAgent6StepSystem(NL2SQLSystem):
    """
    Multi-Agent 6-Step NL2SQL System.
    
    This system uses a pipeline of 6 specialized agents to convert
    natural language questions to SQL queries.
    
    Performance on Spider dev set:
    - Exact Match: 76.8%
    - Execution Accuracy: 84.0%
    
    Example:
        ```python
        from nl2sql_bench.baselines import MultiAgent6StepSystem
        
        system = MultiAgent6StepSystem(
            project_path="/path/to/nl2sql_6step"
        )
        
        result = system.predict(nl2sql_input)
        print(result.sql)
        ```
    
    Attributes:
        project_path: Path to the nl2sql_6step project directory.
        verbose: Whether to print progress information.
    """
    
    def __init__(
        self,
        project_path: Optional[str] = None,
        verbose: bool = False,
        config_overrides: Optional[Dict[str, Any]] = None,
    ):
        """
        Initialize the Multi-Agent 6-Step system.
        
        Args:
            project_path: Path to nl2sql_6step project directory.
                         If None, tries to detect from common locations.
            verbose: Print progress information during prediction.
            config_overrides: Optional configuration overrides.
        """
        self._version = "1.0.0"
        self.verbose = verbose
        self.config_overrides = config_overrides or {}
        
        # Find project path
        self.project_path = self._resolve_project_path(project_path)
        
        # Lazy loading flags
        self._pipeline_loaded = False
        self._NL2SQLFlow = None
        self._NLQuestions = None
        self._SQLDbSchema = None
    
    def _resolve_project_path(self, project_path: Optional[str]) -> Optional[Path]:
        """Resolve the project path."""
        if project_path:
            return Path(project_path)
        
        # Try common locations relative to this file
        possible_paths = [
            Path(__file__).parent.parent.parent.parent / "src" / "nl2sql_6step",
            Path.cwd() / "src" / "nl2sql_6step",
            Path.cwd().parent / "src" / "nl2sql_6step",
        ]
        
        for path in possible_paths:
            if path.exists():
                return path
        
        return None
    
    def _load_pipeline(self) -> bool:
        """
        Lazy load the pipeline components.
        
        Returns:
            True if pipeline loaded successfully.
        """
        if self._pipeline_loaded:
            return True
        
        if self.project_path is None:
            return False
        
        try:
            # Add project to path
            sys.path.insert(0, str(self.project_path))
            
            # Import pipeline components
            from nl2sql_flow.main import (
                NL2SQLFlow,
                NLQuestions,
                SQLDbSchema as InternalSQLDbSchema,
            )
            
            self._NL2SQLFlow = NL2SQLFlow
            self._NLQuestions = NLQuestions
            self._SQLDbSchema = InternalSQLDbSchema
            self._pipeline_loaded = True
            
            if self.verbose:
                print(f"Loaded 6-step pipeline from: {self.project_path}")
            
            return True
            
        except ImportError as e:
            if self.verbose:
                print(f"Failed to load pipeline: {e}")
            return False
    
    @property
    def name(self) -> str:
        """System name for reporting."""
        return "MultiAgent6Step"
    
    @property
    def version(self) -> str:
        """System version."""
        return self._version
    
    def predict(self, input: NL2SQLInput) -> NL2SQLOutput:
        """
        Generate SQL from natural language question.
        
        Uses the 6-step multi-agent pipeline:
        1. Question Analysis
        2. Schema Selection
        3. Query Planning
        4. SQL Generation
        5. SQL Refinement
        6. SQL Validation
        
        Args:
            input: NL2SQLInput containing question, db_id, and schema.
            
        Returns:
            NL2SQLOutput with generated SQL.
        """
        # Try to load pipeline
        if not self._load_pipeline():
            return NL2SQLOutput(
                sql="",
                confidence=0.0,
                error="Failed to load 6-step pipeline. Check project_path.",
            )
        
        try:
            # Convert schema to internal format
            internal_schema = self._SQLDbSchema(
                db_id=input.db_id,
                table_names_original=input.schema.get("table_names_original", []),
                column_names_original=input.schema.get("column_names_original", []),
                column_types=input.schema.get("column_types", []),
                foreign_keys=input.schema.get("foreign_keys", []),
                primary_keys=input.schema.get("primary_keys", []),
            )
            
            # Create question input
            question_input = self._NLQuestions(
                question=input.question,
                db_id=input.db_id,
            )
            
            # Run the flow
            if self.verbose:
                print(f"\nProcessing: {input.question[:50]}...")
            
            flow = self._NL2SQLFlow(
                _question=question_input,
                _raw_schema=internal_schema,
            )
            result_state = flow.kickoff()
            
            # Extract results
            sql = result_state.result.sql
            explain = result_state.result.explain
            error = result_state.result.error
            
            # Build intermediate steps for debugging
            intermediate_steps = [
                {
                    "step": "question_analysis",
                    "output": result_state.question_analysis,
                },
                {
                    "step": "schema_selection",
                    "output": {
                        "tables": result_state.db_schema.table_names_original,
                        "columns_count": len(result_state.db_schema.column_names_original),
                    },
                },
                {
                    "step": "query_planning",
                    "output": result_state.query_plan,
                },
                {
                    "step": "sql_generation",
                    "output": {"intermediate_sql": result_state.intermediate_sql},
                },
                {
                    "step": "sql_refinement",
                    "output": {"final_sql": sql},
                },
            ]
            
            return NL2SQLOutput(
                sql=sql,
                confidence=0.9 if not error else 0.5,
                intermediate_steps=intermediate_steps,
                error=error if error else None,
            )
            
        except Exception as e:
            return NL2SQLOutput(
                sql="",
                confidence=0.0,
                error=f"Pipeline execution failed: {str(e)}",
            )
    
    def predict_batch(self, inputs: List[NL2SQLInput]) -> List[NL2SQLOutput]:
        """
        Generate SQL for multiple questions.
        
        Currently processes sequentially. Future versions may support
        parallel execution.
        
        Args:
            inputs: List of NL2SQLInput objects.
            
        Returns:
            List of NL2SQLOutput objects.
        """
        results = []
        total = len(inputs)
        
        for idx, inp in enumerate(inputs):
            if self.verbose and (idx + 1) % 10 == 0:
                print(f"Progress: {idx + 1}/{total}")
            
            result = self.predict(inp)
            results.append(result)
        
        return results


class SimplifiedMultiAgent6Step(NL2SQLSystem):
    """
    Simplified wrapper that doesn't require the full pipeline installation.
    
    Uses the same prompting strategy but with a simpler implementation
    for environments where the full CrewAI setup isn't available.
    
    Note: This provides lower accuracy than the full pipeline but
    is useful for comparison and testing.
    """
    
    def __init__(
        self,
        llm_provider: str = "openai",
        model_name: str = "gpt-4o",
        api_key: Optional[str] = None,
    ):
        """
        Initialize simplified system.
        
        Args:
            llm_provider: LLM provider ("openai", "anthropic", "google").
            model_name: Model name for the provider.
            api_key: API key (uses environment variable if None).
        """
        self._version = "1.0.0-simplified"
        self.llm_provider = llm_provider
        self.model_name = model_name
        self.api_key = api_key
        self._client = None
    
    @property
    def name(self) -> str:
        return f"MultiAgent6Step-Simplified-{self.model_name}"
    
    @property
    def version(self) -> str:
        return self._version
    
    def _get_client(self):
        """Lazy initialize LLM client."""
        if self._client is not None:
            return self._client
        
        if self.llm_provider == "openai":
            try:
                from openai import OpenAI
                self._client = OpenAI(api_key=self.api_key)
            except ImportError:
                raise ImportError("openai package required. Install with: pip install openai")
        
        elif self.llm_provider == "anthropic":
            try:
                from anthropic import Anthropic
                self._client = Anthropic(api_key=self.api_key)
            except ImportError:
                raise ImportError("anthropic package required. Install with: pip install anthropic")
        
        else:
            raise ValueError(f"Unsupported provider: {self.llm_provider}")
        
        return self._client
    
    def _call_llm(self, prompt: str) -> str:
        """Call the LLM with a prompt."""
        client = self._get_client()
        
        if self.llm_provider == "openai":
            response = client.chat.completions.create(
                model=self.model_name,
                messages=[{"role": "user", "content": prompt}],
                temperature=0.0,
            )
            return response.choices[0].message.content
        
        elif self.llm_provider == "anthropic":
            response = client.messages.create(
                model=self.model_name,
                max_tokens=1024,
                messages=[{"role": "user", "content": prompt}],
            )
            return response.content[0].text
        
        return ""
    
    def predict(self, input: NL2SQLInput) -> NL2SQLOutput:
        """
        Generate SQL using simplified multi-step prompting.
        
        Args:
            input: NL2SQLInput with question and schema.
            
        Returns:
            NL2SQLOutput with generated SQL.
        """
        try:
            # Format schema
            schema_str = json.dumps(input.schema, indent=2)
            
            # Multi-step prompt combining the 6-step strategy
            prompt = f"""You are an expert SQL query generator. Follow these steps:

1. ANALYZE the question to understand intent and required information.
2. SELECT relevant tables and columns from the schema.
3. PLAN the query structure (JOINs, aggregations, filters).
4. GENERATE the SQL query.
5. REFINE the query for correctness and efficiency.
6. VALIDATE the final SQL.

Database Schema:
{schema_str}

Question: {input.question}

Provide ONLY the final SQL query, nothing else. Do not include explanations, markdown formatting, or code blocks."""

            sql = self._call_llm(prompt).strip()
            
            # Clean up response
            sql = sql.replace("```sql", "").replace("```", "").strip()
            
            return NL2SQLOutput(
                sql=sql,
                confidence=0.8,
            )
            
        except Exception as e:
            return NL2SQLOutput(
                sql="",
                confidence=0.0,
                error=str(e),
            )
