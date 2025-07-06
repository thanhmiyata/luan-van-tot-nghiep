"""
Agent 6: Response Generation Agent
Chức năng: Format kết quả và generate explanation
Input: SQL results + Original query
Output: User-friendly response
Tech: BGE Rerank + response generation
"""
import asyncio
import json
from datetime import datetime
from typing import Dict, Any, List, Optional

from .base_agent import BaseAgent, AgentResponse
from ..config import config


class ResponseGenerationAgent(BaseAgent):
    """
    Agent cuối cùng trong pipeline - tạo response cho user
    Format kết quả và generate explanation
    """

    def __init__(self):
        super().__init__(config.agents["response_generation"])
        self.response_templates = {
            "vi": {
                "success": "Đã tìm thấy {count} kết quả cho câu hỏi của bạn.",
                "error": "Xin lỗi, có lỗi xảy ra khi xử lý câu hỏi của bạn.",
                "explanation": "Giải thích: {explanation}",
                "sql_used": "SQL được sử dụng: {sql}"
            },
            "en": {
                "success": "Found {count} results for your query.",
                "error": "Sorry, there was an error processing your query.",
                "explanation": "Explanation: {explanation}",
                "sql_used": "SQL used: {sql}"
            }
        }

    def get_system_prompt(self) -> str:
        return """Bạn là Response Generation Agent - chuyên gia tạo response cho user.

NHIỆM VỤ:
1. Format kết quả SQL thành response thân thiện
2. Generate explanation dễ hiểu
3. Cung cấp context và insights
4. Hỗ trợ cả tiếng Việt và tiếng Anh

NGUYÊN TẮC:
- Response rõ ràng, dễ hiểu
- Cung cấp số liệu cụ thể
- Giải thích cách query hoạt động
- Suggest câu hỏi follow-up nếu phù hợp
- Maintain friendly tone

OUTPUT FORMAT:
{
    "response": "Main response to user",
    "explanation": "How the query works",
    "sql_used": "SQL query that was executed",
    "results_summary": {
        "total_rows": 100,
        "execution_time": "1.2s",
        "query_complexity": "LOW"
    },
    "follow_up_suggestions": ["suggestion1", "suggestion2"],
    "language": "vi/en"
}

EXAMPLES:
Input: COUNT query result = 1000
Output: {
    "response": "Cơ sở dữ liệu có tổng cộng 1,000 bộ phim.",
    "explanation": "Truy vấn đếm tổng số records trong bảng film",
    "sql_used": "SELECT COUNT(*) FROM film;"
}
"""

    async def process(self, input_data: Dict[str, Any]) -> AgentResponse:
        """Main processing method for response generation"""
        start_time = datetime.now()

        try:
            self.is_busy = True

            # Extract input data
            original_query = input_data.get("refined_query", "")
            sql_query = input_data.get("sql_query", "")
            sql_results = input_data.get("sql_results", [])
            validation_result = input_data.get("validation_result", {})
            language = input_data.get("language", "vi")

            self.logger.info(
                f"Generating response for: {original_query[:50]}...")

            # Check if SQL was valid
            if not validation_result.get("is_valid", True):
                return await self._generate_error_response(
                    original_query, validation_result, language
                )

            # Generate main response
            main_response = await self._generate_main_response(
                original_query, sql_query, sql_results, language
            )

            # Generate explanation
            explanation = await self._generate_explanation(
                original_query, sql_query, sql_results, language
            )

            # Generate follow-up suggestions
            suggestions = await self._generate_follow_up_suggestions(
                original_query, sql_results, language
            )

            # Compile final response
            final_result = {
                "response": main_response,
                "explanation": explanation,
                "sql_used": sql_query,
                "results_summary": {
                    "total_rows": len(sql_results) if isinstance(sql_results, list) else 1,
                    "execution_time": input_data.get("total_processing_time", "N/A"),
                    "query_complexity": self._assess_complexity(sql_query)
                },
                "follow_up_suggestions": suggestions,
                "language": language,
                "original_query": original_query,
                "response_confidence": self._calculate_response_confidence(
                    main_response, explanation, sql_results
                )
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
            self.logger.error(f"Response generation failed: {str(e)}")

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

    async def _generate_main_response(self, query: str, sql: str, results: Any, language: str) -> str:
        """Generate main response using LLM"""

        messages = [
            {"role": "system", "content": self.get_system_prompt()},
            {"role": "user", "content": f"""
Generate a user-friendly response:

ORIGINAL QUERY: {query}
SQL EXECUTED: {sql}
RESULTS: {results}
LANGUAGE: {language}

Create a natural, informative response that answers the user's question.
"""}
        ]

        response = await self.call_llm(messages, temperature=0.3)

        # Extract main response from LLM output
        if language == "vi":
            return self._format_vietnamese_response(response, results)
        else:
            return self._format_english_response(response, results)

    def _format_vietnamese_response(self, response: str, results: Any) -> str:
        """Format Vietnamese response"""

        # If results is a list, get count
        if isinstance(results, list):
            count = len(results)
            if count == 0:
                return "Không tìm thấy kết quả nào cho câu hỏi của bạn."
            elif count == 1:
                return f"Tìm thấy {count} kết quả: {results[0] if results else 'N/A'}"
            else:
                return f"Tìm thấy {count} kết quả cho câu hỏi của bạn."

        # If results is a single value (like COUNT)
        if isinstance(results, (int, float)):
            return f"Kết quả là: {results:,}"

        # Use LLM response as fallback
        return response.strip()

    def _format_english_response(self, response: str, results: Any) -> str:
        """Format English response"""

        # If results is a list, get count
        if isinstance(results, list):
            count = len(results)
            if count == 0:
                return "No results found for your query."
            elif count == 1:
                return f"Found {count} result: {results[0] if results else 'N/A'}"
            else:
                return f"Found {count} results for your query."

        # If results is a single value (like COUNT)
        if isinstance(results, (int, float)):
            return f"The result is: {results:,}"

        # Use LLM response as fallback
        return response.strip()

    async def _generate_explanation(self, query: str, sql: str, results: Any, language: str) -> str:
        """Generate explanation of how the query works"""

        messages = [
            {"role": "system", "content": "Explain SQL queries in simple terms."},
            {"role": "user", "content": f"""
Explain this SQL query in simple terms:

ORIGINAL QUESTION: {query}
SQL QUERY: {sql}
LANGUAGE: {language}

Explain what the query does and how it works.
"""}
        ]

        explanation = await self.call_llm(messages, temperature=0.2)

        # Fallback explanation if LLM fails
        if not explanation.strip():
            if language == "vi":
                return f"Truy vấn SQL này thực hiện: {sql}"
            else:
                return f"This SQL query performs: {sql}"

        return explanation.strip()

    async def _generate_follow_up_suggestions(self, query: str, results: Any, language: str) -> List[str]:
        """Generate follow-up question suggestions"""

        suggestions = []

        # Analyze query type and suggest related questions
        query_lower = query.lower()

        if language == "vi":
            if "phim" in query_lower:
                suggestions.extend([
                    "Bạn có muốn xem thông tin chi tiết về phim nào đó không?",
                    "Bạn có muốn tìm phim theo thể loại không?",
                    "Bạn có muốn xem phim nào được thuê nhiều nhất không?"
                ])
            elif "khách hàng" in query_lower:
                suggestions.extend([
                    "Bạn có muốn xem thông tin thanh toán của khách hàng không?",
                    "Bạn có muốn tìm khách hàng VIP không?",
                    "Bạn có muốn xem lịch sử thuê phim của khách hàng không?"
                ])
            elif "count" in query_lower or "bao nhiêu" in query_lower:
                suggestions.extend([
                    "Bạn có muốn xem danh sách chi tiết không?",
                    "Bạn có muốn lọc theo điều kiện cụ thể không?",
                    "Bạn có muốn xem thống kê theo thời gian không?"
                ])
        else:
            if "film" in query_lower or "movie" in query_lower:
                suggestions.extend([
                    "Would you like to see details about specific films?",
                    "Would you like to find films by category?",
                    "Would you like to see the most rented films?"
                ])
            elif "customer" in query_lower:
                suggestions.extend([
                    "Would you like to see customer payment information?",
                    "Would you like to find VIP customers?",
                    "Would you like to see customer rental history?"
                ])
            elif "count" in query_lower or "how many" in query_lower:
                suggestions.extend([
                    "Would you like to see a detailed list?",
                    "Would you like to filter by specific criteria?",
                    "Would you like to see statistics over time?"
                ])

        return suggestions[:3]  # Return top 3 suggestions

    async def _generate_error_response(self, query: str, validation_result: Dict[str, Any], language: str) -> AgentResponse:
        """Generate error response when SQL validation fails"""

        errors = validation_result.get("all_errors", [])
        error_message = "; ".join(errors[:3])  # Show first 3 errors

        if language == "vi":
            response = f"Xin lỗi, không thể xử lý câu hỏi '{query}' do lỗi: {error_message}"
            suggestions = [
                "Hãy thử diễn đạt câu hỏi rõ ràng hơn",
                "Kiểm tra lại tên bảng và cột",
                "Hãy đơn giản hóa câu hỏi"
            ]
        else:
            response = f"Sorry, couldn't process query '{query}' due to errors: {error_message}"
            suggestions = [
                "Try rephrasing your question more clearly",
                "Check table and column names",
                "Try simplifying your question"
            ]

        return AgentResponse(
            agent_name=self.name,
            success=True,
            data={
                "response": response,
                "explanation": f"Validation errors: {error_message}",
                "sql_used": "N/A",
                "results_summary": {"total_rows": 0, "execution_time": "N/A"},
                "follow_up_suggestions": suggestions,
                "language": language,
                "error_details": validation_result
            },
            timestamp=datetime.now()
        )

    def _assess_complexity(self, sql: str) -> str:
        """Assess SQL query complexity"""

        sql_upper = sql.upper()

        # Count complexity indicators
        join_count = sql_upper.count("JOIN")
        subquery_count = sql_upper.count("SELECT") - 1  # Subtract main SELECT
        aggregate_count = len(
            [fn for fn in ["COUNT", "SUM", "AVG", "MAX", "MIN"] if fn in sql_upper])

        if join_count == 0 and subquery_count == 0 and aggregate_count <= 1:
            return "LOW"
        elif join_count <= 2 and subquery_count <= 1 and aggregate_count <= 2:
            return "MEDIUM"
        else:
            return "HIGH"

    def _calculate_response_confidence(self, response: str, explanation: str, results: Any) -> float:
        """Calculate confidence score for response"""

        confidence = 0.5  # Base confidence

        # Add confidence based on response quality
        if response and len(response) > 20:
            confidence += 0.2

        if explanation and len(explanation) > 20:
            confidence += 0.2

        # Add confidence based on results
        if results is not None:
            confidence += 0.1

        return min(confidence, 1.0)
