"""
Agent 3: Query Planning Agent
Chức năng: Lập kế hoạch thực thi SQL query
Input: Entities + Schema mapping  
Output: Query execution plan
Tech: ReAct approach (Reason + Act + Observe)
"""
import asyncio
import json
from datetime import datetime
from typing import Dict, Any, List, Optional

from .base_agent import BaseAgent, AgentResponse
from ..config import config


class QueryPlanningAgent(BaseAgent):
    """
    Agent thứ 3 trong pipeline - lập kế hoạch thực thi SQL query
    Sử dụng ReAct approach để reasoning và planning
    """

    def __init__(self):
        super().__init__(config.agents["query_planning"])
        self.query_patterns = {
            "count": {"complexity": 1, "template": "SELECT COUNT(*) FROM {table}"},
            "list": {"complexity": 2, "template": "SELECT {columns} FROM {table}"},
            "join": {"complexity": 3, "template": "SELECT {columns} FROM {table1} JOIN {table2}"},
            "aggregate": {"complexity": 4, "template": "SELECT {agg_func}({column}) FROM {table}"},
            "complex": {"complexity": 5, "template": "Complex multi-table query"}
        }

    def get_system_prompt(self) -> str:
        return """Bạn là Query Planning Agent - chuyên gia lập kế hoạch SQL query.

NHIỆM VỤ:
1. Phân tích refined query và schema mapping
2. Lập kế hoạch thực thi SQL theo ReAct approach
3. Xác định query type và complexity
4. Tối ưu hóa performance

ReAct APPROACH:
- REASON: Phân tích yêu cầu và schema
- ACT: Lập kế hoạch execution steps
- OBSERVE: Đánh giá và tối ưu plan

OUTPUT FORMAT:
{
    "query_type": "count/list/join/aggregate/complex",
    "complexity_level": "1-5",
    "execution_plan": {
        "steps": [
            {
                "step_number": 1,
                "action": "SELECT/JOIN/WHERE/ORDER",
                "description": "Mô tả bước thực hiện",
                "tables": ["table1", "table2"],
                "columns": ["col1", "col2"],
                "conditions": ["condition1"]
            }
        ]
    },
    "performance_notes": ["note1", "note2"],
    "estimated_complexity": "LOW/MEDIUM/HIGH"
}

EXAMPLES:
Query: "Có bao nhiêu phim?"
Plan: {
    "query_type": "count",
    "complexity_level": "1",
    "execution_plan": {
        "steps": [
            {
                "step_number": 1,
                "action": "SELECT COUNT",
                "description": "Đếm tổng số records trong bảng film",
                "tables": ["film"],
                "columns": ["*"],
                "conditions": []
            }
        ]
    }
}
"""

    async def process(self, input_data: Dict[str, Any]) -> AgentResponse:
        """Main processing method for query planning"""
        start_time = datetime.now()

        try:
            self.is_busy = True

            # Extract input data
            refined_query = input_data.get("refined_query", "")
            schema_data = input_data.get("schema_recognition", {})
            language = input_data.get("language", "en")

            self.logger.info(f"Planning query: {refined_query[:50]}...")

            # Step 1: REASON - Analyze query and schema
            analysis = await self._reason_about_query(refined_query, schema_data, language)

            # Step 2: ACT - Create execution plan
            execution_plan = await self._create_execution_plan(analysis)

            # Step 3: OBSERVE - Validate and optimize plan
            optimized_plan = self._optimize_plan(execution_plan)

            # Compile final result
            final_result = {
                "query_type": analysis.get("query_type", "unknown"),
                "complexity_level": analysis.get("complexity_level", "3"),
                "execution_plan": optimized_plan,
                "performance_notes": analysis.get("performance_notes", []),
                "estimated_complexity": analysis.get("estimated_complexity", "MEDIUM"),
                "reasoning_trace": analysis.get("reasoning_steps", []),
                "optimization_applied": optimized_plan.get("optimizations", [])
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
            self.logger.error(f"Query planning failed: {str(e)}")

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

    async def _reason_about_query(self, query: str, schema_data: Dict[str, Any], language: str) -> Dict[str, Any]:
        """REASON: Analyze query requirements and schema"""

        messages = [
            {"role": "system", "content": self.get_system_prompt()},
            {"role": "user", "content": f"""
Analyze this query for planning:

QUERY: {query}
LANGUAGE: {language}
SCHEMA_DATA: {json.dumps(schema_data, indent=2)}

Please provide detailed analysis including:
1. Query type identification
2. Complexity assessment
3. Required tables and relationships
4. Performance considerations
"""}
        ]

        response = await self.call_llm(messages, temperature=0.2)

        try:
            analysis = json.loads(response)
            return analysis
        except json.JSONDecodeError:
            return self._fallback_analysis(query, schema_data, language)

    def _fallback_analysis(self, query: str, schema_data: Dict[str, Any], language: str) -> Dict[str, Any]:
        """Fallback analysis when LLM fails"""

        # Simple pattern matching
        query_lower = query.lower()

        if any(word in query_lower for word in ['count', 'bao nhiêu', 'số lượng']):
            query_type = "count"
            complexity = "1"
        elif any(word in query_lower for word in ['list', 'show', 'liệt kê', 'hiển thị']):
            query_type = "list"
            complexity = "2"
        elif any(word in query_lower for word in ['join', 'kết hợp', 'liên kết']):
            query_type = "join"
            complexity = "3"
        else:
            query_type = "unknown"
            complexity = "3"

        return {
            "query_type": query_type,
            "complexity_level": complexity,
            "estimated_complexity": "MEDIUM",
            "performance_notes": ["Fallback analysis applied"],
            "reasoning_steps": ["Pattern matching used due to LLM parsing failure"]
        }

    async def _create_execution_plan(self, analysis: Dict[str, Any]) -> Dict[str, Any]:
        """ACT: Create detailed execution plan"""

        query_type = analysis.get("query_type", "unknown")

        if query_type == "count":
            return self._create_count_plan(analysis)
        elif query_type == "list":
            return self._create_list_plan(analysis)
        elif query_type == "join":
            return self._create_join_plan(analysis)
        elif query_type == "aggregate":
            return self._create_aggregate_plan(analysis)
        else:
            return self._create_generic_plan(analysis)

    def _create_count_plan(self, analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Create plan for COUNT queries"""
        return {
            "steps": [
                {
                    "step_number": 1,
                    "action": "SELECT COUNT",
                    "description": "Thực hiện đếm số lượng records",
                    "tables": analysis.get("required_tables", ["film"]),
                    "columns": ["*"],
                    "conditions": analysis.get("conditions", [])
                }
            ],
            "estimated_rows": 1,
            "performance_impact": "LOW"
        }

    def _create_list_plan(self, analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Create plan for LIST queries"""
        return {
            "steps": [
                {
                    "step_number": 1,
                    "action": "SELECT",
                    "description": "Lấy danh sách dữ liệu",
                    "tables": analysis.get("required_tables", ["film"]),
                    "columns": analysis.get("required_columns", ["*"]),
                    "conditions": analysis.get("conditions", [])
                }
            ],
            "estimated_rows": "VARIABLE",
            "performance_impact": "MEDIUM"
        }

    def _create_join_plan(self, analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Create plan for JOIN queries"""
        return {
            "steps": [
                {
                    "step_number": 1,
                    "action": "JOIN",
                    "description": "Kết hợp dữ liệu từ multiple tables",
                    "tables": analysis.get("required_tables", []),
                    "columns": analysis.get("required_columns", []),
                    "conditions": analysis.get("join_conditions", [])
                }
            ],
            "estimated_rows": "HIGH",
            "performance_impact": "HIGH"
        }

    def _create_aggregate_plan(self, analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Create plan for AGGREGATE queries"""
        return {
            "steps": [
                {
                    "step_number": 1,
                    "action": "AGGREGATE",
                    "description": "Thực hiện tính toán aggregate",
                    "tables": analysis.get("required_tables", []),
                    "columns": analysis.get("aggregate_columns", []),
                    "conditions": analysis.get("conditions", [])
                }
            ],
            "estimated_rows": "VARIABLE",
            "performance_impact": "MEDIUM"
        }

    def _create_generic_plan(self, analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Create generic plan for unknown query types"""
        return {
            "steps": [
                {
                    "step_number": 1,
                    "action": "GENERIC",
                    "description": "Thực hiện query generic",
                    "tables": analysis.get("required_tables", []),
                    "columns": ["*"],
                    "conditions": []
                }
            ],
            "estimated_rows": "UNKNOWN",
            "performance_impact": "MEDIUM"
        }

    def _optimize_plan(self, plan: Dict[str, Any]) -> Dict[str, Any]:
        """OBSERVE: Optimize execution plan"""

        optimizations = []

        # Add indexes recommendation
        if plan.get("performance_impact") == "HIGH":
            optimizations.append("Consider adding indexes on join columns")

        # Add LIMIT recommendation for large results
        if plan.get("estimated_rows") == "HIGH":
            optimizations.append("Consider adding LIMIT clause")

        # Add ORDER BY optimization
        steps = plan.get("steps", [])
        if len(steps) > 1:
            optimizations.append("Consider query execution order optimization")

        plan["optimizations"] = optimizations
        plan["optimized"] = True

        return plan
