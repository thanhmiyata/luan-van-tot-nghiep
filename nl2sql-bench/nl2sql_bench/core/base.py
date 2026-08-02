"""
Core base classes and interfaces for NL2SQL-Bench.

This module defines the abstract base class that all NL2SQL systems must implement,
as well as the standardized input/output data models.
"""

from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field


class NL2SQLInput(BaseModel):
    """
    Standardized input for NL2SQL systems.
    
    This model encapsulates all information needed to generate SQL from
    a natural language question, following the Spider dataset format.
    
    Attributes:
        question: The natural language question to convert to SQL.
        db_id: Database identifier matching the schema key.
        schema: Database schema in Spider format containing tables, columns,
                foreign keys, and primary keys.
        evidence: Optional additional context or hints (useful for BIRD dataset).
    """
    
    question: str = Field(
        ..., 
        description="Natural language question to convert to SQL"
    )
    db_id: str = Field(
        ..., 
        description="Database identifier matching schema key"
    )
    schema: Dict[str, Any] = Field(
        ..., 
        description="Database schema in Spider format"
    )
    evidence: Optional[str] = Field(
        None, 
        description="Additional context or hint for the question"
    )
    
    model_config = {
        "json_schema_extra": {
            "examples": [
                {
                    "question": "How many singers are there?",
                    "db_id": "concert_singer",
                    "schema": {
                        "db_id": "concert_singer",
                        "table_names_original": ["singer", "concert"],
                        "column_names_original": [
                            [-1, "*"],
                            [0, "singer_id"],
                            [0, "name"],
                            [1, "concert_id"]
                        ],
                        "column_types": ["number", "text", "number"],
                        "primary_keys": [1, 4],
                        "foreign_keys": []
                    }
                }
            ]
        }
    }


class NL2SQLOutput(BaseModel):
    """
    Standardized output from NL2SQL systems.
    
    This model captures the generated SQL along with optional metadata
    useful for debugging and analysis.
    
    Attributes:
        sql: The generated SQL query.
        confidence: Confidence score between 0 and 1 (default: 1.0).
        intermediate_steps: Optional list of pipeline steps for debugging.
        error: Error message if generation failed.
    """
    
    sql: str = Field(
        ..., 
        description="Generated SQL query"
    )
    confidence: float = Field(
        default=1.0, 
        ge=0.0, 
        le=1.0, 
        description="Confidence score for the generated SQL"
    )
    intermediate_steps: Optional[List[Dict[str, Any]]] = Field(
        None, 
        description="Pipeline steps for debugging/analysis"
    )
    error: Optional[str] = Field(
        None, 
        description="Error message if SQL generation failed"
    )
    
    model_config = {
        "json_schema_extra": {
            "examples": [
                {
                    "sql": "SELECT COUNT(*) FROM singer",
                    "confidence": 0.95,
                    "intermediate_steps": [
                        {"step": "question_analysis", "output": {"intent": "count"}},
                        {"step": "schema_selection", "output": {"tables": ["singer"]}}
                    ],
                    "error": None
                }
            ]
        }
    }


class NL2SQLSystem(ABC):
    """
    Abstract base class for NL2SQL systems.
    
    All NL2SQL systems to be evaluated must inherit from this class
    and implement the `predict` method.
    
    Example:
        ```python
        class MyNL2SQLSystem(NL2SQLSystem):
            def __init__(self, model_name: str = "gpt-4"):
                self.model_name = model_name
                self._version = "1.0.0"
            
            @property
            def version(self) -> str:
                return self._version
            
            def predict(self, input: NL2SQLInput) -> NL2SQLOutput:
                # Your implementation here
                sql = generate_sql(input.question, input.schema)
                return NL2SQLOutput(sql=sql)
        ```
    """
    
    @property
    def name(self) -> str:
        """
        System name for reporting.
        
        Override this property to provide a custom name.
        Default: class name.
        """
        return self.__class__.__name__
    
    @property
    def version(self) -> str:
        """
        System version string.
        
        Override this property to track different versions.
        Default: "1.0.0"
        """
        return "1.0.0"
    
    @abstractmethod
    def predict(self, input: NL2SQLInput) -> NL2SQLOutput:
        """
        Generate SQL from a natural language question.
        
        This is the main method that must be implemented by all NL2SQL systems.
        
        Args:
            input: NL2SQLInput containing question, db_id, and schema.
            
        Returns:
            NL2SQLOutput containing the generated SQL and optional metadata.
            
        Raises:
            Any exceptions should be caught and returned as NL2SQLOutput.error
        """
        pass
    
    def predict_batch(self, inputs: List[NL2SQLInput]) -> List[NL2SQLOutput]:
        """
        Generate SQL for multiple questions.
        
        Default implementation processes sequentially.
        Override for parallel or batched processing.
        
        Args:
            inputs: List of NL2SQLInput objects.
            
        Returns:
            List of NL2SQLOutput objects in the same order.
        """
        return [self.predict(inp) for inp in inputs]
    
    def __repr__(self) -> str:
        return f"{self.name}(version={self.version})"
