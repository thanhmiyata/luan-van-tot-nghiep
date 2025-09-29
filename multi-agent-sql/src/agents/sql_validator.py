"""
SQL Validator Agent - Validates and corrects SQL queries
"""

import json
import re
from typing import Dict, Any
from loguru import logger

from src.core.base_agent import BaseAgent, AgentError
from src.core.models import AgentType, ModelType, PipelineContext


class SQLValidatorAgent(BaseAgent):
    """Agent responsible for validating and correcting SQL queries"""

    def __init__(self, model_type: ModelType):
        super().__init__(AgentType.SQL_VALIDATOR, model_type)
        self.description = f"SQL Validator for {model_type.value} pipeline"

    def execute(self, context: PipelineContext) -> Dict[str, Any]:
        """
        Validate and correct SQL query

        Args:
            context: Pipeline context with generated SQL

        Returns:
            Dictionary with validated SQL, explanation, and error info
        """
        try:
            logger.debug(
                f"SQL Validator executing for {self.model_type.value} pipeline")

            # Get SQL to validate
            sql_to_validate = context.generated_sql or ""

            if not sql_to_validate.strip():
                return {
                    'sql': '',
                    'explanation': 'No SQL to validate',
                    'error': 'No SQL was generated',
                    'is_valid': False,
                    'corrections_made': []
                }

            # Prepare input for validation
            prompt_input = self._prepare_input(context, sql_to_validate)

            # Format prompt
            prompt = self._format_prompt(
                self.prompts.get('system', ''), **prompt_input)

            # Call LLM
            response = self._call_llm(prompt)

            # Parse response
            result = self._parse_response(response)

            logger.debug(
                f"SQL Validator result: {result.get('is_valid', False)}")

            return {
                'sql': result.get('sql', sql_to_validate),
                'explanation': result.get('explanation', ''),
                'error': result.get('error'),
                'is_valid': result.get('is_valid', True),
                'corrections_made': result.get('corrections_made', []),
                'agent_type': self.agent_type.value
            }

        except Exception as e:
            logger.error(f"SQL Validator failed: {e}")
            # Return original SQL with error info
            return {
                'sql': context.generated_sql or '',
                'explanation': f'Validation failed: {str(e)}',
                'error': str(e),
                'is_valid': False,
                'corrections_made': [],
                'agent_type': self.agent_type.value
            }

    def _prepare_input(self, context: PipelineContext, sql: str) -> Dict[str, Any]:
        """Prepare input for validation based on model type"""

        base_input = {
            'sql': sql,
            'question': self._get_question(context),
            'schema': self._format_schema(context),
            'db_id': context.question.db_id
        }

        if self.model_type == ModelType.THREE_STEP:
            # Simple validation: just SQL + question + schema
            return base_input

        elif self.model_type == ModelType.FOUR_STEP:
            # Enhanced validation: + analysis context
            base_input['analysis'] = self._format_analysis(context.analysis)
            return base_input

        elif self.model_type == ModelType.SIX_STEP:
            # Comprehensive validation: + all context
            base_input.update({
                'original_question': context.question.question,
                'entities': self._format_entities(context.entities),
                'analysis': self._format_analysis(context.analysis)
            })
            return base_input

        return base_input

    def _get_question(self, context: PipelineContext) -> str:
        """Get the appropriate question based on model type"""
        if self.model_type == ModelType.SIX_STEP and context.refined_question:
            return context.refined_question
        return context.question.question

    def _format_schema(self, context: PipelineContext) -> str:
        """Format schema for validation"""
        schema = context.filtered_schema or context.schema
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
        """Format question analysis"""
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
        """Format recognized entities"""
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
        """Parse validation response"""
        try:
            # Try to parse as JSON
            if response.strip().startswith('{'):
                parsed = json.loads(response)
                return {
                    'sql': parsed.get('sql', ''),
                    'explanation': parsed.get('explanation', ''),
                    'error': parsed.get('error'),
                    'is_valid': parsed.get('is_valid', True),
                    'corrections_made': parsed.get('corrections_made', [])
                }

            # Parse structured text response
            lines = response.strip().split('\n')
            result = {
                'sql': '',
                'explanation': '',
                'error': None,
                'is_valid': True,
                'corrections_made': []
            }

            current_section = None

            for line in lines:
                line = line.strip()

                if line.lower().startswith('sql:'):
                    current_section = 'sql'
                    result['sql'] = line[4:].strip()
                elif line.lower().startswith('explanation:'):
                    current_section = 'explanation'
                    result['explanation'] = line[12:].strip()
                elif line.lower().startswith('error:'):
                    current_section = 'error'
                    error_text = line[6:].strip()
                    if error_text and error_text.lower() not in ['none', 'null', '']:
                        result['error'] = error_text
                        result['is_valid'] = False
                elif line.lower().startswith('valid:'):
                    is_valid_text = line[6:].strip().lower()
                    result['is_valid'] = is_valid_text in ['true', 'yes', '1']
                elif current_section and line:
                    # Continue previous section
                    if current_section == 'sql':
                        result['sql'] += ' ' + line
                    elif current_section == 'explanation':
                        result['explanation'] += ' ' + line

            # Clean up SQL
            result['sql'] = result['sql'].strip()

            # If no structured parsing worked, assume response is the corrected SQL
            if not result['sql']:
                # Try to extract SQL from response
                sql_match = re.search(
                    r'SELECT.*?(?=\n|$)', response, re.IGNORECASE | re.DOTALL)
                if sql_match:
                    result['sql'] = sql_match.group(0).strip()
                else:
                    result['sql'] = response.strip()

            return result

        except Exception as e:
            logger.error(f"Failed to parse validator response: {e}")
            return {
                'sql': response.strip(),
                'explanation': f"Parsing error: {str(e)}",
                'error': None,
                'is_valid': True,
                'corrections_made': []
            }
