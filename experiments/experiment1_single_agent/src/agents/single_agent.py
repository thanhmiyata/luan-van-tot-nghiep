"""
Single-Agent Implementation for Experiment 1
Multi-LLM Text-to-SQL Baseline System
"""

import os
import json
import time
from typing import Dict, List, Optional, Tuple, Any
from dataclasses import dataclass
from abc import ABC, abstractmethod

import openai
import anthropic
import google.generativeai as genai
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

from ..core.config import get_config
from ..core.logging import get_logger

logger = get_logger(__name__)

@dataclass
class QueryResult:
    """Result of a single query execution"""
    sql_query: str
    explanation: str
    execution_success: bool
    result_data: Optional[List[Dict]] = None
    error_message: Optional[str] = None
    response_time: float = 0.0
    input_tokens: int = 0
    output_tokens: int = 0


class LLMProvider(ABC):
    """Abstract base class for LLM providers"""
    
    @abstractmethod
    def generate_sql(self, prompt: str, schema_context: str) -> Tuple[str, str, int, int]:
        """Generate SQL query and explanation from natural language"""
        pass


class OpenAIProvider(LLMProvider):
    """OpenAI GPT-4 provider"""
    
    def __init__(self, api_key: str, model: str = "gpt-4-1106-preview"):
        self.client = openai.OpenAI(api_key=api_key)
        self.model = model
    
    def generate_sql(self, prompt: str, schema_context: str) -> Tuple[str, str, int, int]:
        """Generate SQL using GPT-4"""
        try:
            system_prompt = f"""You are an expert SQL developer. Convert natural language questions to PostgreSQL queries.

Database Schema Context:
{schema_context}

Instructions:
1. Generate ONLY valid PostgreSQL syntax
2. Use proper table and column names from the schema
3. Include appropriate JOINs when needed
4. Handle Vietnamese and English input
5. Return response in JSON format:
{{
    "sql_query": "your SQL query here",
    "explanation": "explanation in Vietnamese or English based on input language"
}}

Be precise and accurate."""

            response = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.1,
                max_tokens=1000
            )
            
            content = response.choices[0].message.content
            usage = response.usage
            
            # Parse JSON response
            result = json.loads(content)
            sql_query = result.get("sql_query", "").strip()
            explanation = result.get("explanation", "")
            
            return sql_query, explanation, usage.prompt_tokens, usage.completion_tokens
            
        except Exception as e:
            logger.error(f"OpenAI API error: {e}")
            return "", f"Error: {e}", 0, 0


class AnthropicProvider(LLMProvider):
    """Anthropic Claude provider"""
    
    def __init__(self, api_key: str, model: str = "claude-3-sonnet-20240229"):
        self.client = anthropic.Anthropic(api_key=api_key)
        self.model = model
    
    def generate_sql(self, prompt: str, schema_context: str) -> Tuple[str, str, int, int]:
        """Generate SQL using Claude"""
        try:
            system_prompt = f"""You are an expert SQL developer. Convert natural language questions to PostgreSQL queries.

Database Schema Context:
{schema_context}

Instructions:
1. Generate ONLY valid PostgreSQL syntax
2. Use proper table and column names from the schema
3. Include appropriate JOINs when needed
4. Handle Vietnamese and English input
5. Return response in JSON format:
{{
    "sql_query": "your SQL query here",
    "explanation": "explanation in Vietnamese or English based on input language"
}}

Be precise and accurate."""

            response = self.client.messages.create(
                model=self.model,
                max_tokens=1000,
                temperature=0.1,
                system=system_prompt,
                messages=[
                    {"role": "user", "content": prompt}
                ]
            )
            
            content = response.content[0].text
            
            # Parse JSON response
            result = json.loads(content)
            sql_query = result.get("sql_query", "").strip()
            explanation = result.get("explanation", "")
            
            # Anthropic doesn't provide token counts in the same way
            input_tokens = response.usage.input_tokens if hasattr(response, 'usage') else 0
            output_tokens = response.usage.output_tokens if hasattr(response, 'usage') else 0
            
            return sql_query, explanation, input_tokens, output_tokens
            
        except Exception as e:
            logger.error(f"Anthropic API error: {e}")
            return "", f"Error: {e}", 0, 0


class GoogleProvider(LLMProvider):
    """Google Gemini provider"""
    
    def __init__(self, api_key: str, model: str = "gemini-pro"):
        genai.configure(api_key=api_key)
        self.model = genai.GenerativeModel(model)
    
    def generate_sql(self, prompt: str, schema_context: str) -> Tuple[str, str, int, int]:
        """Generate SQL using Gemini"""
        try:
            full_prompt = f"""You are an expert SQL developer. Convert natural language questions to PostgreSQL queries.

Database Schema Context:
{schema_context}

User Question: {prompt}

Instructions:
1. Generate ONLY valid PostgreSQL syntax
2. Use proper table and column names from the schema
3. Include appropriate JOINs when needed
4. Handle Vietnamese and English input
5. Return response in JSON format:
{{
    "sql_query": "your SQL query here",
    "explanation": "explanation in Vietnamese or English based on input language"
}}

Be precise and accurate."""

            response = self.model.generate_content(
                full_prompt,
                generation_config=genai.types.GenerationConfig(
                    temperature=0.1,
                    max_output_tokens=1000
                )
            )
            
            content = response.text
            
            # Parse JSON response
            result = json.loads(content)
            sql_query = result.get("sql_query", "").strip()
            explanation = result.get("explanation", "")
            
            # Google doesn't provide detailed token counts
            return sql_query, explanation, 0, 0
            
        except Exception as e:
            logger.error(f"Google API error: {e}")
            return "", f"Error: {e}", 0, 0


class SingleAgent:
    """Single-Agent Text-to-SQL System for Experiment 1"""
    
    def __init__(self, database_url: str, default_llm: str = "openai"):
        self.database_url = database_url
        self.engine = create_engine(database_url)
        self.providers = {}
        self.default_llm = default_llm
        
        # Initialize LLM providers
        self._initialize_providers()
        
        logger.info(f"SingleAgent initialized with {len(self.providers)} LLM providers")
    
    def _initialize_providers(self):
        """Initialize available LLM providers based on API keys"""
        config = get_config()
        
        # OpenAI
        if config.get("OPENAI_API_KEY") and config.get("OPENAI_API_KEY") != "your_openai_api_key_here":
            self.providers["openai"] = OpenAIProvider(
                config["OPENAI_API_KEY"],
                config.get("OPENAI_MODEL", "gpt-4-1106-preview")
            )
            logger.info("OpenAI provider initialized")
        
        # Anthropic
        if config.get("ANTHROPIC_API_KEY") and config.get("ANTHROPIC_API_KEY") != "your_anthropic_api_key_here":
            self.providers["anthropic"] = AnthropicProvider(
                config["ANTHROPIC_API_KEY"],
                config.get("ANTHROPIC_MODEL", "claude-3-sonnet-20240229")
            )
            logger.info("Anthropic provider initialized")
        
        # Google
        if config.get("GOOGLE_API_KEY") and config.get("GOOGLE_API_KEY") != "your_google_api_key_here":
            self.providers["google"] = GoogleProvider(
                config["GOOGLE_API_KEY"],
                config.get("GOOGLE_MODEL", "gemini-pro")
            )
            logger.info("Google provider initialized")
    
    def get_schema_context(self, schema_name: str = "public") -> str:
        """Get database schema information"""
        try:
            with self.engine.connect() as conn:
                # Get table information
                tables_query = text("""
                    SELECT table_name, column_name, data_type, is_nullable
                    FROM information_schema.columns 
                    WHERE table_schema = :schema_name
                    ORDER BY table_name, ordinal_position
                """)
                
                result = conn.execute(tables_query, {"schema_name": schema_name})
                schema_info = {}
                
                for row in result:
                    table_name = row[0]
                    if table_name not in schema_info:
                        schema_info[table_name] = []
                    
                    schema_info[table_name].append({
                        "column": row[1],
                        "type": row[2],
                        "nullable": row[3]
                    })
                
                # Format schema for prompt
                schema_text = "Database Schema:\n"
                for table, columns in schema_info.items():
                    schema_text += f"\nTable: {table}\n"
                    for col in columns:
                        nullable = "NULL" if col["nullable"] == "YES" else "NOT NULL"
                        schema_text += f"  - {col['column']}: {col['type']} ({nullable})\n"
                
                return schema_text
                
        except Exception as e:
            logger.error(f"Error getting schema: {e}")
            return "Schema information unavailable"
    
    def execute_sql(self, sql_query: str) -> Tuple[bool, Optional[List[Dict]], Optional[str]]:
        """Execute SQL query and return results"""
        try:
            with self.engine.connect() as conn:
                result = conn.execute(text(sql_query))
                
                # Convert to list of dictionaries
                columns = result.keys()
                rows = result.fetchall()
                data = [dict(zip(columns, row)) for row in rows]
                
                return True, data, None
                
        except SQLAlchemyError as e:
            logger.error(f"SQL execution error: {e}")
            return False, None, str(e)
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return False, None, str(e)
    
    def process_query(self, user_query: str, llm_provider: Optional[str] = None) -> QueryResult:
        """Process natural language query and return SQL result"""
        start_time = time.time()
        
        # Use specified provider or default
        provider_name = llm_provider or self.default_llm
        
        if provider_name not in self.providers:
            return QueryResult(
                sql_query="",
                explanation=f"LLM provider '{provider_name}' not available",
                execution_success=False,
                error_message=f"Provider '{provider_name}' not configured",
                response_time=time.time() - start_time
            )
        
        provider = self.providers[provider_name]
        
        # Get schema context
        schema_context = self.get_schema_context()
        
        # Generate SQL using LLM
        sql_query, explanation, input_tokens, output_tokens = provider.generate_sql(
            user_query, schema_context
        )
        
        if not sql_query:
            return QueryResult(
                sql_query="",
                explanation=explanation,
                execution_success=False,
                error_message="Failed to generate SQL query",
                response_time=time.time() - start_time,
                input_tokens=input_tokens,
                output_tokens=output_tokens
            )
        
        # Execute SQL query
        success, data, error = self.execute_sql(sql_query)
        
        response_time = time.time() - start_time
        
        return QueryResult(
            sql_query=sql_query,
            explanation=explanation,
            execution_success=success,
            result_data=data,
            error_message=error,
            response_time=response_time,
            input_tokens=input_tokens,
            output_tokens=output_tokens
        )
    
    def get_available_providers(self) -> List[str]:
        """Get list of available LLM providers"""
        return list(self.providers.keys())
    
    def test_connection(self) -> Dict[str, bool]:
        """Test connections to all configured providers"""
        results = {}
        test_query = "What tables are available?"
        schema_context = self.get_schema_context()
        
        for name, provider in self.providers.items():
            try:
                sql, explanation, _, _ = provider.generate_sql(test_query, schema_context)
                results[name] = bool(sql)
            except Exception as e:
                logger.error(f"Connection test failed for {name}: {e}")
                results[name] = False
        
        return results 