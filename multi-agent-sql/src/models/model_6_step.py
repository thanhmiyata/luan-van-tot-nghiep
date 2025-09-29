"""
6-Step Enhanced Model: Query Refinement → Entity Recognition → Question Analyzer → Schema Selector → SQL Expert → SQL Validator
"""

from typing import List
from loguru import logger

from src.core.models import ModelType, NLQuestion, DatabaseSchema, PipelineResult
from src.core.pipeline import Pipeline


class Model6Step:
    """Enhanced 6-step model for high-precision SQL generation"""

    def __init__(self):
        self.model_type = ModelType.SIX_STEP
        self.name = "Enhanced (6-step)"
        self.description = "Query Refinement → Entity Recognition → Question Analyzer → Schema Selector → SQL Expert → SQL Validator"
        self.pipeline = Pipeline(self.model_type)

        # Expected performance characteristics
        self.expected_accuracy = 0.92
        self.expected_time_per_question = 9.2  # seconds
        self.expected_api_calls = 6  # per question
        self.expected_cost_index = 2.1  # relative to 3-step

        logger.info(f"Initialized {self.name} model")

    def process(self, question: NLQuestion, schema: DatabaseSchema) -> PipelineResult:
        """
        Process a single question through the 6-step pipeline

        Args:
            question: Natural language question
            schema: Database schema

        Returns:
            PipelineResult with SQL and metrics
        """
        logger.debug(
            f"Processing question with {self.name}: {question.question[:50]}...")
        return self.pipeline.process(question, schema)

    def process_batch(self, questions: List[NLQuestion], schema: DatabaseSchema) -> List[PipelineResult]:
        """
        Process a batch of questions

        Args:
            questions: List of questions
            schema: Database schema

        Returns:
            List of PipelineResults
        """
        logger.info(
            f"Processing batch of {len(questions)} questions with {self.name}")
        return self.pipeline.process_batch(questions, schema)

    def get_info(self) -> dict:
        """Get model information and characteristics"""
        return {
            'model_type': self.model_type.value,
            'name': self.name,
            'description': self.description,
            'workflow': [
                'Query Refinement: Make question self-contained and clear',
                'Entity Recognition: Identify tables, columns, values, relationships',
                'Question Analyzer: Analyze intent, complexity with entity context',
                'Schema Selector: Filter schema using entity and analysis information',
                'SQL Expert: Generate SQL with complete context and entity mapping',
                'SQL Validator: Comprehensive validation and optimization'
            ],
            'characteristics': {
                'speed': 'Slower (2.1x)',
                'accuracy': 'Highest (~92%)',
                'cost': 'Highest (+100%)',
                'complexity': 'Complex queries, multi-table JOINs',
                'use_cases': ['High-precision requirements', 'Complex analytics', 'Mission-critical systems']
            },
            'expected_performance': {
                'accuracy': self.expected_accuracy,
                'time_per_question': self.expected_time_per_question,
                'api_calls_per_question': self.expected_api_calls,
                'cost_index': self.expected_cost_index
            },
            'agents': [
                'Query Refinement', 'Entity Recognition', 'Question Analyzer',
                'Schema Selector', 'SQL Expert', 'SQL Validator'
            ],
            'workflow_steps': 6
        }

    def get_metrics(self) -> dict:
        """Get current performance metrics"""
        return self.pipeline.get_metrics()

    def reset_metrics(self):
        """Reset performance metrics"""
        self.pipeline.reset_metrics()

    def __str__(self) -> str:
        return f"{self.name} ({self.model_type.value})"

    def __repr__(self) -> str:
        return f"Model6Step(name='{self.name}', type='{self.model_type.value}')"
