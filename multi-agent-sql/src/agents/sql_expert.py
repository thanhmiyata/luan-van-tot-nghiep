"""
SQL Expert Agent - Generates SQL queries from natural language questions
"""

import json
from typing import Dict, Any
from loguru import logger

from src.core.base_agent import BaseAgent, AgentError
from src.core.models import AgentType, ModelType, PipelineContext, SQLGenerationResult


class SQLExpertAgent(BaseAgent):
    """Agent responsible for generating SQL queries"""

    def __init__(self, model_type: ModelType):
        super().__init__(AgentType.SQL_EXPERT, model_type)
        self.description = f"SQL Expert for {model_type.value} pipeline"

    def execute(self, context: PipelineContext) -> Dict[str, Any]:
        """
        Generate SQL query based on the pipeline context

        Args:
            context: Pipeline context with question and schema information

        Returns:
            Dictionary with generated SQL and reasoning
        """
        try:
            logger.debug(
                f"SQL Expert executing for {self.model_type.value} pipeline")

            # Prepare input based on model type
            prompt_input = self._prepare_input(context)

            # Format prompt
            prompt = self._format_prompt(
                self.prompts.get('system', ''), **prompt_input)

            # Call LLM
            response = self._call_llm(prompt)

            # Parse response
            result = self._parse_response(response)

            logger.debug(
                f"SQL Expert generated: {result.get('sql', '')[:50]}...")

            return {
                'sql': result.get('sql', ''),
                'reasoning': result.get('reasoning', ''),
                'agent_type': self.agent_type.value
            }

        except Exception as e:
            logger.error(f"SQL Expert failed: {e}")
            raise AgentError(
                self.agent_type, f"Failed to generate SQL: {str(e)}", e)

    def _prepare_input(self, context: PipelineContext) -> Dict[str, Any]:
        """Prepare input for prompt based on model type"""

        if self.model_type == ModelType.THREE_STEP:
            # Simple input: just question + full schema
            return {
                'question': context.question.question,
                'schema': self._format_schema(context.db_schema),
                'db_id': context.question.db_id
            }

        elif self.model_type == ModelType.FOUR_STEP:
            # Medium input: + analysis + filtered schema
            return {
                'question': context.question.question,
                'analysis': self._format_analysis(context.analysis),
                'schema': self._format_schema(context.filtered_schema or context.db_schema),
                'db_id': context.question.db_id
            }

        elif self.model_type == ModelType.SIX_STEP:
            # Complex input: + refined question + entities
            return {
                'question': context.refined_question or context.question.question,
                'original_question': context.question.question,
                'entities': self._format_entities(context.entities),
                'analysis': self._format_analysis(context.analysis),
                'schema': self._format_schema(context.filtered_schema or context.db_schema),
                'db_id': context.question.db_id
            }
        else:
            raise ValueError(f"Unsupported model type: {self.model_type}")

    def _format_schema(self, schema) -> str:
        """Format database schema for prompt"""
        if not schema:
            return "No schema available"

        try:
            schema_dict = {
                'db_id': schema.db_id,
                'tables': schema.table_names_original,
                'columns': schema.column_names_original,
                'column_types': schema.column_types
            }
            return json.dumps(schema_dict, indent=2)
        except Exception as e:
            logger.error(f"Failed to format schema: {e}")
            return "Schema formatting error"

    def _format_analysis(self, analysis) -> str:
        """Format question analysis for prompt"""
        if not analysis:
            return "No analysis available"

        try:
            analysis_dict = {
                'intent': analysis.intent.value if hasattr(analysis, 'intent') else 'UNKNOWN',
                'complexity': analysis.complexity.value if hasattr(analysis, 'complexity') else 'UNKNOWN',
                'entities': analysis.entities if hasattr(analysis, 'entities') else {},
                'confidence': analysis.confidence if hasattr(analysis, 'confidence') else 0.0
            }
            return json.dumps(analysis_dict, indent=2)
        except Exception as e:
            logger.error(f"Failed to format analysis: {e}")
            return "Analysis formatting error"

    def _format_entities(self, entities) -> str:
        """Format recognized entities for prompt"""
        if not entities:
            return "No entities available"

        try:
            entities_dict = {
                'tables': entities.tables if hasattr(entities, 'tables') else [],
                'columns': entities.columns if hasattr(entities, 'columns') else [],
                'values': entities.values if hasattr(entities, 'values') else [],
                'relationships': entities.relationships if hasattr(entities, 'relationships') else []
            }
            return json.dumps(entities_dict, indent=2)
        except Exception as e:
            logger.error(f"Failed to format entities: {e}")
            return "Entities formatting error"

    def _parse_response(self, response: str) -> Dict[str, Any]:
        """Parse LLM response to extract SQL and reasoning"""
        try:
            # Try to parse as JSON first
            if response.strip().startswith('{'):
                parsed = json.loads(response)
                return {
                    'sql': parsed.get('sql', ''),
                    'reasoning': parsed.get('reasoning', '')
                }

            # If not JSON, try to extract SQL from text
            lines = response.strip().split('\n')
            sql_lines = []
            reasoning_lines = []

            in_sql_block = False
            in_reasoning = False

            for line in lines:
                line = line.strip()

                # Detect SQL blocks
                if line.lower().startswith('select') or line.lower().startswith('with'):
                    in_sql_block = True
                    sql_lines.append(line)
                elif in_sql_block and line:
                    sql_lines.append(line)
                elif in_sql_block and not line:
                    in_sql_block = False

                # Collect reasoning
                if 'reasoning' in line.lower() or 'explanation' in line.lower():
                    in_reasoning = True
                elif in_reasoning:
                    reasoning_lines.append(line)

            sql = ' '.join(sql_lines).strip()
            reasoning = ' '.join(reasoning_lines).strip()

            # Fallback: if no structured parsing worked, assume the whole response is SQL
            if not sql:
                sql = response.strip()

            return {
                'sql': sql,
                'reasoning': reasoning
            }

        except Exception as e:
            logger.error(f"Failed to parse SQL Expert response: {e}")
            return {
                'sql': response.strip(),  # Fallback to raw response
                'reasoning': f"Parsing error: {str(e)}"
            }
