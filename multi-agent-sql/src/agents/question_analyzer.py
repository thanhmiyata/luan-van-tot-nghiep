"""
Question Analyzer Agent - Analyzes questions for intent, complexity, and entities
"""

import json
from typing import Dict, Any
from loguru import logger

from src.core.base_agent import BaseAgent, AgentError
from src.core.models import (
    AgentType, ModelType, PipelineContext,
    QuestionAnalysisResult, QueryIntent, QuestionComplexity
)


class QuestionAnalyzerAgent(BaseAgent):
    """Agent responsible for analyzing natural language questions"""

    def __init__(self, model_type: ModelType):
        super().__init__(AgentType.QUESTION_ANALYZER, model_type)
        self.description = f"Question Analyzer for {model_type.value} pipeline"

    def execute(self, context: PipelineContext) -> Dict[str, Any]:
        """
        Analyze the question for intent, complexity, and required entities

        Args:
            context: Pipeline context with question and schema

        Returns:
            Dictionary with analysis results
        """
        try:
            logger.debug(
                f"Question Analyzer executing for {self.model_type.value} pipeline")

            # Prepare input
            prompt_input = self._prepare_input(context)

            # Format prompt
            system_prompt = self.prompts.get('system_prompt', '')
            user_prompt = self.prompts.get('user_prompt', '')

            if not system_prompt or not user_prompt:
                raise AgentError(self.agent_type, "Missing prompt templates")

            # Combine system and user prompts
            full_prompt = f"{system_prompt}\n\n{user_prompt}"
            prompt = self._format_prompt(full_prompt, **prompt_input)

            # Call LLM
            response = self._call_llm(prompt)

            # Parse response
            result = self._parse_response(response)

            logger.debug(
                f"Question Analyzer result: {result.get('intent', 'UNKNOWN')}")

            return {
                'analysis': result,
                'agent_type': self.agent_type.value
            }

        except Exception as e:
            logger.error(f"Question Analyzer failed: {e}")
            # Return default analysis
            return {
                'analysis': {
                    'intent': 'UNKNOWN',
                    'complexity': 'MEDIUM',
                    'entities': {'tables': [], 'columns': [], 'values': []},
                    'confidence': 0.0
                },
                'agent_type': self.agent_type.value
            }

    def _prepare_input(self, context: PipelineContext) -> Dict[str, Any]:
        """Prepare input for analysis"""
        question = context.refined_question if context.refined_question else context.question.question

        return {
            'question': question,
            'db_id': context.question.db_id,
            'schema': self._format_schema(context.db_schema)
        }

    def _format_schema(self, schema) -> str:
        """Format schema for analysis"""
        if not schema:
            return "No schema available"

        try:
            schema_dict = {
                'db_id': schema.db_id,
                'tables': schema.table_names_original,
                # Limit for analysis
                'columns': schema.column_names_original[:20]
            }
            return json.dumps(schema_dict, indent=2)
        except Exception as e:
            logger.error(f"Failed to format schema: {e}")
            return "Schema formatting error"

    def _parse_response(self, response: str) -> Dict[str, Any]:
        """Parse analysis response"""
        try:
            # Try JSON parsing first
            if response.strip().startswith('{'):
                parsed = json.loads(response)
                return {
                    'intent': parsed.get('intent', 'UNKNOWN'),
                    'complexity': parsed.get('complexity', 'MEDIUM'),
                    'entities': parsed.get('entities', {}),
                    'confidence': parsed.get('confidence', 0.0)
                }

            # Fallback parsing
            return {
                'intent': 'LIST',  # Most common
                'complexity': 'MEDIUM',
                'entities': {'tables': [], 'columns': [], 'values': []},
                'confidence': 0.5
            }

        except Exception as e:
            logger.error(f"Failed to parse analysis response: {e}")
            return {
                'intent': 'UNKNOWN',
                'complexity': 'MEDIUM',
                'entities': {},
                'confidence': 0.0
            }
