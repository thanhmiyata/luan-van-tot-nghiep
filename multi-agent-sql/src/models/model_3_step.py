"""
3-Step Lightweight Model: SQL Expert → SQL Validator
"""

from typing import List
from loguru import logger

from src.core.models import ModelType, NLQuestion, DatabaseSchema, PipelineResult
from src.core.pipeline import Pipeline


class Model3Step:
    """Lightweight 3-step model for fast SQL generation"""

    def __init__(self):
        self.model_type = ModelType.THREE_STEP
        self.name = "Lightweight (3-step)"
        self.description = "SQL Expert → SQL Validator"
        self.pipeline = Pipeline(self.model_type)

        # Expected performance characteristics
        self.expected_accuracy = 0.75
        self.expected_time_per_question = 4.5  # seconds
        self.expected_api_calls = 3  # per question
        self.expected_cost_index = 1.0  # baseline

        logger.info(f"Initialized {self.name} model")

    def process(self, question: NLQuestion, schema: DatabaseSchema) -> PipelineResult:
        """
        Process a single question through the 3-step pipeline

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
                'SQL Expert: Generate SQL directly from question and full schema',
                'SQL Validator: Quick validation and basic error correction'
            ],
            'characteristics': {
                'speed': 'Fastest',
                'accuracy': 'Basic (~75%)',
                'cost': 'Lowest',
                'complexity': 'Simple queries',
                'use_cases': ['Prototyping', 'Demos', 'Simple applications']
            },
            'expected_performance': {
                'accuracy': self.expected_accuracy,
                'time_per_question': self.expected_time_per_question,
                'api_calls_per_question': self.expected_api_calls,
                'cost_index': self.expected_cost_index
            },
            'agents': ['SQL Expert', 'SQL Validator'],
            'workflow_steps': 2
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
        return f"Model3Step(name='{self.name}', type='{self.model_type.value}')"
