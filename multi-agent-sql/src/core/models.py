"""
Pydantic models for Multi-Agent SQL system
"""

from typing import Optional, Dict, List, Any, Union
from datetime import datetime
from pydantic import BaseModel, Field
from enum import Enum


class ModelType(str, Enum):
    """Available model types"""
    THREE_STEP = "3_step"
    FOUR_STEP = "4_step" 
    SIX_STEP = "6_step"


class QuestionComplexity(str, Enum):
    """Question complexity levels"""
    EASY = "EASY"
    MEDIUM = "MEDIUM"
    HARD = "HARD"


class QueryIntent(str, Enum):
    """Query intent types"""
    COUNT = "COUNT"
    LIST = "LIST"
    MAX_MIN = "MAX_MIN"
    AGGREGATION = "AGGREGATION"
    COMPARISON = "COMPARISON"
    JOIN = "JOIN"


class AgentType(str, Enum):
    """Available agent types"""
    QUERY_REFINEMENT = "query_refinement"
    ENTITY_RECOGNITION = "entity_recognition" 
    QUESTION_ANALYZER = "question_analyzer"
    SCHEMA_SELECTOR = "schema_selector"
    SQL_EXPERT = "sql_expert"
    SQL_VALIDATOR = "sql_validator"


# Input/Output Models
class NLQuestion(BaseModel):
    """Natural language question input"""
    question: str = Field(..., description="Natural language question")
    db_id: str = Field(..., description="Database identifier")
    question_id: Optional[str] = Field(None, description="Unique question identifier")


class DatabaseSchema(BaseModel):
    """Database schema information"""
    db_id: str = Field(..., description="Database identifier")
    table_names_original: List[str] = Field(..., description="Original table names")
    column_names_original: List[List[Union[int, str]]] = Field(..., description="Column names with table indices")
    column_types: List[str] = Field(..., description="Column data types")
    primary_keys: Optional[List[List[int]]] = Field(None, description="Primary key information")
    foreign_keys: Optional[List[List[int]]] = Field(None, description="Foreign key information")


# Agent Output Models
class QueryRefinementResult(BaseModel):
    """Result from query refinement agent"""
    refined_question: str = Field(..., description="Refined, self-contained question")
    changes_made: List[str] = Field(default_factory=list, description="List of changes made")
    confidence: float = Field(0.0, ge=0.0, le=1.0, description="Confidence score")


class EntityRecognitionResult(BaseModel):
    """Result from entity recognition agent"""
    tables: List[Dict[str, Any]] = Field(default_factory=list, description="Recognized table entities")
    columns: List[Dict[str, Any]] = Field(default_factory=list, description="Recognized column entities")
    values: List[Dict[str, Any]] = Field(default_factory=list, description="Recognized value entities")
    relationships: List[str] = Field(default_factory=list, description="Identified relationships")


class QuestionAnalysisResult(BaseModel):
    """Result from question analysis agent"""
    intent: QueryIntent = Field(..., description="Query intent")
    complexity: QuestionComplexity = Field(..., description="Question complexity")
    entities: Dict[str, List[str]] = Field(default_factory=dict, description="Required entities")
    confidence: float = Field(0.0, ge=0.0, le=1.0, description="Analysis confidence")


class SchemaFilterResult(BaseModel):
    """Result from schema selector agent"""
    filtered_schema: DatabaseSchema = Field(..., description="Filtered database schema")
    removed_tables: List[str] = Field(default_factory=list, description="Tables that were removed")
    removed_columns: List[str] = Field(default_factory=list, description="Columns that were removed")


class SQLGenerationResult(BaseModel):
    """Result from SQL expert agent"""
    sql: str = Field(..., description="Generated SQL query")
    reasoning: Optional[str] = Field(None, description="Reasoning behind the SQL")


class SQLValidationResult(BaseModel):
    """Result from SQL validator agent"""
    sql: str = Field(..., description="Validated/corrected SQL query")
    explanation: str = Field(..., description="Explanation of what the SQL does")
    error: Optional[str] = Field(None, description="Error message if validation failed")
    is_valid: bool = Field(True, description="Whether the SQL is valid")
    corrections_made: List[str] = Field(default_factory=list, description="Corrections that were made")


# Pipeline Models
class PipelineContext(BaseModel):
    """Context passed between pipeline stages"""
    question: NLQuestion = Field(..., description="Original question")
    db_schema: DatabaseSchema = Field(..., description="Database schema")
    
    # Stage results
    refined_question: Optional[str] = Field(None, description="Refined question")
    entities: Optional[EntityRecognitionResult] = Field(None, description="Recognized entities")
    analysis: Optional[QuestionAnalysisResult] = Field(None, description="Question analysis")
    filtered_schema: Optional[DatabaseSchema] = Field(None, description="Filtered schema")
    generated_sql: Optional[str] = Field(None, description="Generated SQL")
    final_sql: Optional[str] = Field(None, description="Final validated SQL")
    explanation: Optional[str] = Field(None, description="SQL explanation")
    error: Optional[str] = Field(None, description="Any error that occurred")


class PipelineResult(BaseModel):
    """Final result from pipeline execution"""
    question_id: str = Field(..., description="Question identifier")
    db_id: str = Field(..., description="Database identifier")
    original_question: str = Field(..., description="Original question")
    final_sql: str = Field(..., description="Final SQL query")
    explanation: str = Field(..., description="Explanation of the SQL")
    error: Optional[str] = Field(None, description="Error message if failed")
    
    # Metrics
    execution_time: float = Field(0.0, description="Total execution time in seconds")
    api_calls: int = Field(0, description="Number of API calls made")
    model_type: ModelType = Field(..., description="Model type used")
    
    # Intermediate results (for debugging)
    context: Optional[PipelineContext] = Field(None, description="Full pipeline context")


# Benchmark Models
class QuestionMetrics(BaseModel):
    """Metrics for a single question"""
    question_id: str = Field(..., description="Question identifier")
    execution_time: float = Field(..., description="Execution time in seconds")
    api_calls: int = Field(..., description="Number of API calls")
    success: bool = Field(..., description="Whether processing succeeded")
    sql_generated: bool = Field(..., description="Whether SQL was generated")
    error: Optional[str] = Field(None, description="Error message if failed")


class ModelBenchmarkResult(BaseModel):
    """Benchmark results for a single model"""
    model_type: ModelType = Field(..., description="Model type")
    timestamp: datetime = Field(default_factory=datetime.now, description="Benchmark timestamp")
    
    # Question metrics
    total_questions: int = Field(..., description="Total questions processed")
    successful_questions: int = Field(..., description="Successfully processed questions")
    failed_questions: int = Field(..., description="Failed questions")
    success_rate: float = Field(..., description="Success rate (0-1)")
    
    # Performance metrics
    total_time: float = Field(..., description="Total execution time")
    avg_time_per_question: float = Field(..., description="Average time per question")
    total_api_calls: int = Field(..., description="Total API calls")
    avg_api_calls_per_question: float = Field(..., description="Average API calls per question")
    
    # Accuracy metrics (from test-suite-sql-eval)
    execution_accuracy: Optional[float] = Field(None, description="Execution accuracy from evaluation")
    exact_match_accuracy: Optional[float] = Field(None, description="Exact match accuracy from evaluation")
    
    # Cost estimation
    estimated_cost: Optional[float] = Field(None, description="Estimated cost in USD")
    
    # Individual question results
    question_metrics: List[QuestionMetrics] = Field(default_factory=list, description="Per-question metrics")


class BenchmarkComparison(BaseModel):
    """Comparison of multiple model benchmarks"""
    timestamp: datetime = Field(default_factory=datetime.now, description="Comparison timestamp")
    dataset_info: Dict[str, Any] = Field(..., description="Information about the test dataset")
    model_results: Dict[ModelType, ModelBenchmarkResult] = Field(..., description="Results for each model")
    
    # Summary statistics
    best_accuracy_model: Optional[ModelType] = Field(None, description="Model with best accuracy")
    fastest_model: Optional[ModelType] = Field(None, description="Fastest model")
    most_cost_effective_model: Optional[ModelType] = Field(None, description="Most cost-effective model")
    
    # Trade-off analysis
    accuracy_improvements: Dict[str, float] = Field(default_factory=dict, description="Accuracy improvements between models")
    cost_increases: Dict[str, float] = Field(default_factory=dict, description="Cost increases between models")
    speed_changes: Dict[str, float] = Field(default_factory=dict, description="Speed changes between models")


# Configuration Models
class AgentConfig(BaseModel):
    """Configuration for a single agent"""
    agent_type: AgentType = Field(..., description="Type of agent")
    model: str = Field(..., description="AI model to use")
    temperature: float = Field(0.0, description="Model temperature")
    max_tokens: int = Field(1024, description="Maximum tokens")
    timeout: int = Field(30, description="Timeout in seconds")
    prompt_template: Optional[str] = Field(None, description="Prompt template")


class PipelineConfig(BaseModel):
    """Configuration for a pipeline"""
    model_type: ModelType = Field(..., description="Model type")
    agents: List[AgentConfig] = Field(..., description="Agent configurations")
    workflow: List[tuple[AgentType, str]] = Field(..., description="Workflow steps")
