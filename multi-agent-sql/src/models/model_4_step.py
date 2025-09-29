"""
4-Step Balanced Model: Question Analyzer → Schema Selector → SQL Expert → SQL Validator
"""

from typing import List
from loguru import logger

from src.core.models import ModelType, NLQuestion, DatabaseSchema, PipelineResult
from src.core.pipeline import Pipeline


class Model4Step:
    """Balanced 4-step model for production use"""

    def __init__(self):
        self.model_type = ModelType.FOUR_STEP
        self.name = "Balanced (4-step)"
        self.description = "Question Analyzer → Schema Selector → SQL Expert → SQL Validator"
        self.pipeline = Pipeline(self.model_type)

        # Expected performance characteristics
        self.expected_accuracy = 0.85
        self.expected_time_per_question = 6.8  # seconds
        self.expected_api_calls = 4  # per question
        self.expected_cost_index = 1.33  # relative to 3-step

        logger.info(f"Initialized {self.name} model")

    def process(self, question: NLQuestion, schema: DatabaseSchema) -> PipelineResult:
        """
        Process a single question through the 4-step pipeline

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
                'Question Analyzer: Analyze intent, complexity, and entities',
                'Schema Selector: Filter schema to relevant tables/columns',
                'SQL Expert: Generate SQL with analysis and filtered schema',
                'SQL Validator: Thorough validation with context awareness'
            ],
            'characteristics': {
                'speed': 'Moderate',
                'accuracy': 'Good (~85%)',
                'cost': 'Moderate (+33%)',
                'complexity': 'Medium queries with JOINs',
                'use_cases': ['Production systems', 'Business applications', 'Most common choice']
            },
            'expected_performance': {
                'accuracy': self.expected_accuracy,
                'time_per_question': self.expected_time_per_question,
                'api_calls_per_question': self.expected_api_calls,
                'cost_index': self.expected_cost_index
            },
            'agents': ['Question Analyzer', 'Schema Selector', 'SQL Expert', 'SQL Validator'],
            'workflow_steps': 4
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
        return f"Model4Step(name='{self.name}', type='{self.model_type.value}')"
