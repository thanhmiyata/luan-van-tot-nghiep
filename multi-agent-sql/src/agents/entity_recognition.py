"""
Entity Recognition Agent - Recognizes entities in natural language questions
"""

import json
from typing import Dict, Any
from loguru import logger

from src.core.base_agent import BaseAgent, AgentError
from src.core.models import AgentType, ModelType, PipelineContext


class EntityRecognitionAgent(BaseAgent):
    """Agent responsible for recognizing entities in questions"""

    def __init__(self, model_type: ModelType):
        super().__init__(AgentType.ENTITY_RECOGNITION, model_type)
        self.description = f"Entity Recognition for {model_type.value} pipeline"

    def execute(self, context: PipelineContext) -> Dict[str, Any]:
        """
        Recognize entities in the question

        Args:
            context: Pipeline context with question and schema

        Returns:
            Dictionary with recognized entities
        """
        try:
            logger.debug(
                f"Entity Recognition executing for {self.model_type.value} pipeline")

            # For now, return empty entities (placeholder implementation)
            # In a full implementation, this would use NER and schema matching
            entities = {
                'tables': [],
                'columns': [],
                'values': [],
                'relationships': []
            }

            logger.debug(
                f"Entity Recognition found {len(entities['tables'])} table entities")

            return {
                'entities': entities,
                'agent_type': self.agent_type.value
            }

        except Exception as e:
            logger.error(f"Entity Recognition failed: {e}")
            return {
                'entities': {'tables': [], 'columns': [], 'values': [], 'relationships': []},
                'agent_type': self.agent_type.value
            }
