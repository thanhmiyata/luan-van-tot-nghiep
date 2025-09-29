"""
Query Refinement Agent - Refines questions to be self-contained and clear
"""

import json
from typing import Dict, Any
from loguru import logger

from src.core.base_agent import BaseAgent, AgentError
from src.core.models import AgentType, ModelType, PipelineContext


class QueryRefinementAgent(BaseAgent):
    """Agent responsible for refining natural language questions"""

    def __init__(self, model_type: ModelType):
        super().__init__(AgentType.QUERY_REFINEMENT, model_type)
        self.description = f"Query Refinement for {model_type.value} pipeline"

    def execute(self, context: PipelineContext) -> Dict[str, Any]:
        """
        Refine the question to be self-contained and clear

        Args:
            context: Pipeline context with question

        Returns:
            Dictionary with refined question
        """
        try:
            logger.debug(
                f"Query Refinement executing for {self.model_type.value} pipeline")

            # For now, return original question (placeholder implementation)
            # In a full implementation, this would use conversation history and context
            refined_question = context.question.question

            logger.debug(f"Query refined: {refined_question[:50]}...")

            return {
                'refined_question': refined_question,
                'changes_made': [],
                'confidence': 1.0,
                'agent_type': self.agent_type.value
            }

        except Exception as e:
            logger.error(f"Query Refinement failed: {e}")
            return {
                'refined_question': context.question.question,
                'changes_made': [],
                'confidence': 0.0,
                'agent_type': self.agent_type.value
            }
