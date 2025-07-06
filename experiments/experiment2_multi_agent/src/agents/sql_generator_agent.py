"""
Agent 4: SQL Generator Agent
Chức năng: Generate SQL code từ execution plan
Input: Query plan + Schema context
Output: PostgreSQL query
Tech: GPT-4/Claude specialized for SQL generation
"""
import asyncio
import json
from datetime import datetime
from typing import Dict, Any, List, Optional

from .base_agent import BaseAgent, AgentResponse
from ..config import config


class SqlGeneratorAgent(BaseAgent):
    """
    Agent thứ 4 trong pipeline - sinh SQL code từ execution plan
    Specialized cho PostgreSQL syntax
    """

    def __init__(self):
        super().__init__(config.agents["sql_generator"])
        self.sql_templates = {
            "count": "SELECT COUNT(*) FROM {table} {where_clause}",
            "list": "SELECT {columns} FROM {table} {where_clause} {order_clause}",
            "join": "SELECT {columns} FROM {table1} {join_type} {table2} ON {join_condition} {where_clause}",
            "aggregate": "SELECT {agg_func}({column}) FROM {table} {where_clause} {group_clause}"
        }

    def get_system_prompt(self) -> str:
        return """Bạn là SQL Generator Agent - chuyên gia sinh PostgreSQL queries.

NHIỆM VỤ:
1. Chuyển đổi execution plan thành SQL code
2. Đảm bảo syntax chính xác cho PostgreSQL
3. Tối ưu hóa performance
4. Xử lý edge cases và error handling

POSTGRESQL SYNTAX:
- Sử dụng double quotes cho identifiers nếu cần
- LIMIT thay vì TOP
- ILIKE cho case-insensitive search
- Proper JOIN syntax
- Aggregate functions: COUNT, SUM, AVG, MAX, MIN

OUTPUT FORMAT:
{
    "sql_query": "SELECT * FROM table_name;",
    "query_type": "count/list/join/aggregate",
    "complexity": "LOW/MEDIUM/HIGH",
    "performance_notes": ["note1", "note2"],
    "parameters": {},
    "estimated_execution_time": "< 1s"
}

EXAMPLES:
Plan: Count films
SQL: {
    "sql_query": "SELECT COUNT(*) FROM film;",
    "query_type": "count",
    "complexity": "LOW"
}

Plan: List customers with payments
SQL: {
    "sql_query": "SELECT c.first_name, c.last_name, SUM(p.amount) FROM customer c JOIN payment p ON c.customer_id = p.customer_id GROUP BY c.customer_id;",
    "query_type": "join",
    "complexity": "MEDIUM"
}
"""

    async def process(self, input_data: Dict[str, Any]) -> AgentResponse:
        """Main processing method for SQL generation"""
        start_time = datetime.now()

        try:
            self.is_busy = True

            # Extract input data
            refined_query = input_data.get("refined_query", "")
            query_plan = input_data.get("query_plan", {})
            schema_data = input_data.get("schema_recognition", {})

            self.logger.info(f"Generating SQL for: {refined_query[:50]}...")

            # Generate SQL using LLM
            sql_result = await self._generate_sql_with_llm(refined_query, query_plan, schema_data)

            # Validate and optimize generated SQL
            validated_sql = await self._validate_and_optimize_sql(sql_result)

            # Add metadata
            final_result = {
                **validated_sql,
                "generation_method": "llm",
                "original_query": refined_query,
                "execution_plan_used": query_plan,
                "generation_confidence": self._calculate_confidence(validated_sql)
            }

            processing_time = (datetime.now() - start_time).total_seconds()

            return AgentResponse(
                agent_name=self.name,
                success=True,
                data=final_result,
                processing_time=processing_time,
                timestamp=datetime.now()
            )

        except Exception as e:
            processing_time = (datetime.now() - start_time).total_seconds()
            self.logger.error(f"SQL generation failed: {str(e)}")

            return AgentResponse(
                agent_name=self.name,
                success=False,
                data={},
                error_message=str(e),
                processing_time=processing_time,
                timestamp=datetime.now()
            )

        finally:
            self.is_busy = False

    async def _generate_sql_with_llm(self, query: str, plan: Dict[str, Any], schema: Dict[str, Any]) -> Dict[str, Any]:
        """Generate SQL using LLM"""

        messages = [
            {"role": "system", "content": self.get_system_prompt()},
            {"role": "user", "content": f"""
Generate PostgreSQL query for:

ORIGINAL QUERY: {query}
EXECUTION PLAN: {json.dumps(plan, indent=2)}
SCHEMA INFO: {json.dumps(schema, indent=2)}

Requirements:
1. Valid PostgreSQL syntax
2. Optimized for performance
3. Handle edge cases
4. Include proper JOINs if needed
5. Use appropriate data types

Return result in JSON format as specified.
"""}
        ]

        response = await self.call_llm(messages, temperature=0.0)

        try:
            sql_result = json.loads(response)
            return sql_result
        except json.JSONDecodeError:
            return self._fallback_sql_generation(query, plan, schema)

    def _fallback_sql_generation(self, query: str, plan: Dict[str, Any], schema: Dict[str, Any]) -> Dict[str, Any]:
        """Fallback SQL generation when LLM fails"""

        # Simple pattern-based SQL generation
        query_lower = query.lower()

        if "count" in query_lower or "bao nhiêu" in query_lower:
            return self._generate_count_sql(query, plan, schema)
        elif "list" in query_lower or "liệt kê" in query_lower:
            return self._generate_list_sql(query, plan, schema)
        else:
            return self._generate_generic_sql(query, plan, schema)

    def _generate_count_sql(self, query: str, plan: Dict[str, Any], schema: Dict[str, Any]) -> Dict[str, Any]:
        """Generate COUNT SQL"""

        # Determine table from schema or default to 'film'
        tables = schema.get("required_tables", ["film"])
        main_table = tables[0] if tables else "film"

        sql = f"SELECT COUNT(*) FROM {main_table};"

        return {
            "sql_query": sql,
            "query_type": "count",
            "complexity": "LOW",
            "performance_notes": ["Simple COUNT query - very fast"],
            "parameters": {},
            "estimated_execution_time": "< 1s"
        }

    def _generate_list_sql(self, query: str, plan: Dict[str, Any], schema: Dict[str, Any]) -> Dict[str, Any]:
        """Generate LIST SQL"""

        tables = schema.get("required_tables", ["film"])
        main_table = tables[0] if tables else "film"

        # Simple column selection
        if "name" in query.lower() or "tên" in query.lower():
            if main_table == "film":
                columns = "title"
            elif main_table == "customer":
                columns = "first_name, last_name"
            elif main_table == "category":
                columns = "name"
            else:
                columns = "*"
        else:
            columns = "*"

        sql = f"SELECT {columns} FROM {main_table};"

        return {
            "sql_query": sql,
            "query_type": "list",
            "complexity": "LOW",
            "performance_notes": ["Simple SELECT query"],
            "parameters": {},
            "estimated_execution_time": "< 2s"
        }

    def _generate_generic_sql(self, query: str, plan: Dict[str, Any], schema: Dict[str, Any]) -> Dict[str, Any]:
        """Generate generic SQL"""

        sql = "SELECT * FROM film LIMIT 10;"

        return {
            "sql_query": sql,
            "query_type": "generic",
            "complexity": "LOW",
            "performance_notes": ["Fallback generic query"],
            "parameters": {},
            "estimated_execution_time": "< 1s"
        }

    async def _validate_and_optimize_sql(self, sql_result: Dict[str, Any]) -> Dict[str, Any]:
        """Validate and optimize the generated SQL"""

        sql_query = sql_result.get("sql_query", "")

        # Basic SQL validation
        if not sql_query.strip():
            raise ValueError("Empty SQL query generated")

        # Check for basic SQL structure
        if not sql_query.upper().startswith("SELECT"):
            raise ValueError("Invalid SQL query - must start with SELECT")

        # Add optimizations
        optimizations = []

        # Add LIMIT if missing for large tables
        if "LIMIT" not in sql_query.upper() and sql_result.get("query_type") == "list":
            optimizations.append(
                "Consider adding LIMIT clause for large result sets")

        # Add index recommendations
        if "JOIN" in sql_query.upper():
            optimizations.append("Ensure proper indexes on JOIN columns")

        sql_result["optimizations"] = optimizations
        sql_result["validated"] = True

        return sql_result

    def _calculate_confidence(self, sql_result: Dict[str, Any]) -> float:
        """Calculate confidence score for generated SQL"""

        confidence = 0.5  # Base confidence

        # Add confidence based on query complexity
        if sql_result.get("query_type") == "count":
            confidence += 0.3
        elif sql_result.get("query_type") == "list":
            confidence += 0.2
        elif sql_result.get("query_type") == "join":
            confidence += 0.1

        # Add confidence if SQL is validated
        if sql_result.get("validated"):
            confidence += 0.2

        return min(confidence, 1.0)

    def get_sql_templates(self) -> Dict[str, str]:
        """Get available SQL templates"""
        return self.sql_templates.copy()
