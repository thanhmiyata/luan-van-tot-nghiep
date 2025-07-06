"""
Agent 5: Validation Agent
Chức năng: Kiểm tra syntax và semantic của SQL
Input: Generated SQL + Schema
Output: Validated SQL hoặc error feedback
Tech: Rule-based + LLM validation
"""
import asyncio
import json
import re
import psycopg2
from datetime import datetime
from typing import Dict, Any, List, Optional, Tuple

from .base_agent import BaseAgent, AgentResponse
from ..config import config


class ValidationAgent(BaseAgent):
    """
    Agent thứ 5 trong pipeline - kiểm tra và validate SQL
    Kết hợp rule-based validation và LLM validation
    """

    def __init__(self):
        super().__init__(config.agents["validation"])
        self.sql_keywords = {
            "SELECT", "FROM", "WHERE", "JOIN", "INNER", "LEFT", "RIGHT", "FULL",
            "GROUP", "ORDER", "HAVING", "LIMIT", "COUNT", "SUM", "AVG", "MAX", "MIN"
        }
        self.dvd_tables = {
            "film", "actor", "customer", "category", "rental", "payment",
            "inventory", "store", "staff", "address", "city", "country"
        }

    def get_system_prompt(self) -> str:
        return """Bạn là Validation Agent - chuyên gia kiểm tra SQL queries.

NHIỆM VỤ:
1. Kiểm tra syntax PostgreSQL
2. Validate semantic correctness
3. Detect potential errors và security issues
4. Suggest improvements nếu cần

VALIDATION CRITERIA:
- Syntax correctness
- Table và column existence
- JOIN conditions validity
- Data type compatibility
- Security (SQL injection prevention)
- Performance considerations

OUTPUT FORMAT:
{
    "is_valid": true/false,
    "syntax_errors": ["error1", "error2"],
    "semantic_errors": ["error1", "error2"],
    "security_issues": ["issue1", "issue2"],
    "performance_warnings": ["warning1", "warning2"],
    "corrected_sql": "CORRECTED SQL IF NEEDED",
    "validation_confidence": 0.95,
    "recommendations": ["rec1", "rec2"]
}

EXAMPLES:
Input: "SELECT * FROM film WHERE film_id = 1;"
Output: {
    "is_valid": true,
    "syntax_errors": [],
    "semantic_errors": [],
    "validation_confidence": 0.95
}

Input: "SELECT * FROM nonexistent_table;"
Output: {
    "is_valid": false,
    "semantic_errors": ["Table 'nonexistent_table' does not exist"],
    "validation_confidence": 0.90
}
"""

    async def process(self, input_data: Dict[str, Any]) -> AgentResponse:
        """Main processing method for SQL validation"""
        start_time = datetime.now()

        try:
            self.is_busy = True

            # Extract input data
            sql_query = input_data.get("sql_query", "")
            schema_data = input_data.get("schema_recognition", {})

            self.logger.info(f"Validating SQL: {sql_query[:50]}...")

            if not sql_query.strip():
                raise ValueError("Empty SQL query provided")

            # Step 1: Syntax validation
            syntax_result = self._validate_syntax(sql_query)

            # Step 2: Semantic validation
            semantic_result = await self._validate_semantic(sql_query, schema_data)

            # Step 3: Security validation
            security_result = self._validate_security(sql_query)

            # Step 4: Performance validation
            performance_result = self._validate_performance(sql_query)

            # Step 5: LLM validation (if needed)
            llm_result = await self._validate_with_llm(sql_query, schema_data)

            # Combine all validation results
            final_result = self._combine_validation_results(
                syntax_result, semantic_result, security_result,
                performance_result, llm_result, sql_query
            )

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
            self.logger.error(f"SQL validation failed: {str(e)}")

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

    def _validate_syntax(self, sql_query: str) -> Dict[str, Any]:
        """Rule-based syntax validation"""
        errors = []

        # Basic structure checks
        if not sql_query.strip().upper().startswith("SELECT"):
            errors.append("Query must start with SELECT")

        if "FROM" not in sql_query.upper():
            errors.append("Query must contain FROM clause")

        # Parentheses matching
        if sql_query.count('(') != sql_query.count(')'):
            errors.append("Unmatched parentheses")

        # Quote matching
        single_quotes = sql_query.count("'")
        if single_quotes % 2 != 0:
            errors.append("Unmatched single quotes")

        # Semicolon check
        if not sql_query.rstrip().endswith(';'):
            errors.append("Query should end with semicolon")

        return {
            "syntax_valid": len(errors) == 0,
            "syntax_errors": errors
        }

    async def _validate_semantic(self, sql_query: str, schema_data: Dict[str, Any]) -> Dict[str, Any]:
        """Semantic validation against schema"""
        errors = []

        # Extract table names from SQL
        tables_in_query = self._extract_table_names(sql_query)

        # Check if tables exist in schema
        valid_tables = schema_data.get("required_tables", [])
        for table in tables_in_query:
            if table not in self.dvd_tables:
                errors.append(f"Table '{table}' does not exist")

        # Check for common JOIN issues
        if "JOIN" in sql_query.upper():
            if "ON" not in sql_query.upper():
                errors.append("JOIN clause missing ON condition")

        return {
            "semantic_valid": len(errors) == 0,
            "semantic_errors": errors,
            "tables_found": tables_in_query
        }

    def _validate_security(self, sql_query: str) -> Dict[str, Any]:
        """Security validation - SQL injection prevention"""
        issues = []

        # Check for potential SQL injection patterns
        dangerous_patterns = [
            r"--", r"/\*", r"\*/", r"xp_", r"sp_", r"exec", r"execute",
            r"drop\s+table", r"delete\s+from", r"update\s+.*\s+set",
            r"insert\s+into", r"create\s+table", r"alter\s+table"
        ]

        for pattern in dangerous_patterns:
            if re.search(pattern, sql_query, re.IGNORECASE):
                issues.append(f"Potential security issue: {pattern}")

        return {
            "security_valid": len(issues) == 0,
            "security_issues": issues
        }

    def _validate_performance(self, sql_query: str) -> Dict[str, Any]:
        """Performance validation"""
        warnings = []

        # Check for missing LIMIT on large tables
        if "film" in sql_query.lower() and "LIMIT" not in sql_query.upper():
            warnings.append("Consider adding LIMIT for large table 'film'")

        # Check for SELECT *
        if "SELECT *" in sql_query.upper():
            warnings.append(
                "SELECT * may impact performance - specify columns")

        # Check for complex JOINs
        join_count = sql_query.upper().count("JOIN")
        if join_count > 3:
            warnings.append(
                f"Complex query with {join_count} JOINs may be slow")

        return {
            "performance_warnings": warnings
        }

    async def _validate_with_llm(self, sql_query: str, schema_data: Dict[str, Any]) -> Dict[str, Any]:
        """LLM-based validation for complex cases"""

        messages = [
            {"role": "system", "content": self.get_system_prompt()},
            {"role": "user", "content": f"""
Validate this PostgreSQL query:

SQL: {sql_query}
SCHEMA: {json.dumps(schema_data, indent=2)}

Please check for:
1. Syntax correctness
2. Semantic validity
3. Security issues
4. Performance concerns

Return validation result in JSON format.
"""}
        ]

        try:
            response = await self.call_llm(messages, temperature=0.0)
            llm_result = json.loads(response)
            return llm_result
        except Exception as e:
            self.logger.warning(f"LLM validation failed: {str(e)}")
            return {"llm_validation": "failed", "error": str(e)}

    def _extract_table_names(self, sql_query: str) -> List[str]:
        """Extract table names from SQL query"""
        tables = []

        # Simple regex to find table names after FROM and JOIN
        patterns = [
            r"FROM\s+(\w+)",
            r"JOIN\s+(\w+)",
            r"INNER\s+JOIN\s+(\w+)",
            r"LEFT\s+JOIN\s+(\w+)",
            r"RIGHT\s+JOIN\s+(\w+)"
        ]

        for pattern in patterns:
            matches = re.findall(pattern, sql_query, re.IGNORECASE)
            tables.extend(matches)

        return list(set(tables))

    def _combine_validation_results(self, syntax_result: Dict[str, Any],
                                    semantic_result: Dict[str, Any],
                                    security_result: Dict[str, Any],
                                    performance_result: Dict[str, Any],
                                    llm_result: Dict[str, Any],
                                    original_sql: str) -> Dict[str, Any]:
        """Combine all validation results"""

        # Determine overall validity
        is_valid = (
            syntax_result.get("syntax_valid", False) and
            semantic_result.get("semantic_valid", False) and
            security_result.get("security_valid", False)
        )

        # Combine all errors and warnings
        all_errors = (
            syntax_result.get("syntax_errors", []) +
            semantic_result.get("semantic_errors", []) +
            security_result.get("security_issues", [])
        )

        # Calculate confidence
        confidence = self._calculate_validation_confidence(
            syntax_result, semantic_result, security_result, llm_result
        )

        # Generate recommendations
        recommendations = self._generate_recommendations(
            syntax_result, semantic_result, performance_result
        )

        return {
            "is_valid": is_valid,
            "syntax_errors": syntax_result.get("syntax_errors", []),
            "semantic_errors": semantic_result.get("semantic_errors", []),
            "security_issues": security_result.get("security_issues", []),
            "performance_warnings": performance_result.get("performance_warnings", []),
            "all_errors": all_errors,
            "validation_confidence": confidence,
            "recommendations": recommendations,
            "original_sql": original_sql,
            "tables_analyzed": semantic_result.get("tables_found", []),
            "llm_validation": llm_result.get("is_valid", None)
        }

    def _calculate_validation_confidence(self, syntax_result: Dict[str, Any],
                                         semantic_result: Dict[str, Any],
                                         security_result: Dict[str, Any],
                                         llm_result: Dict[str, Any]) -> float:
        """Calculate validation confidence score"""

        confidence = 0.5  # Base confidence

        if syntax_result.get("syntax_valid", False):
            confidence += 0.2

        if semantic_result.get("semantic_valid", False):
            confidence += 0.2

        if security_result.get("security_valid", False):
            confidence += 0.1

        # Boost confidence if LLM also validates
        if llm_result.get("is_valid", False):
            confidence += 0.1

        return min(confidence, 1.0)

    def _generate_recommendations(self, syntax_result: Dict[str, Any],
                                  semantic_result: Dict[str, Any],
                                  performance_result: Dict[str, Any]) -> List[str]:
        """Generate recommendations for improvement"""
        recommendations = []

        if syntax_result.get("syntax_errors"):
            recommendations.append("Fix syntax errors before execution")

        if semantic_result.get("semantic_errors"):
            recommendations.append("Check table and column names")

        if performance_result.get("performance_warnings"):
            recommendations.extend(performance_result["performance_warnings"])

        return recommendations
