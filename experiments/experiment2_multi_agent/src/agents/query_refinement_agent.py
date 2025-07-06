"""
Agent 1: Query Refinement Agent
Chức năng: Làm rõ và chuẩn hóa câu hỏi
Input: Raw natural language query (English/Vietnamese)
Output: Refined, standardized query
"""
import asyncio
from datetime import datetime
from typing import Dict, Any, List, Optional
import re

from .base_agent import BaseAgent, AgentResponse
from ..config import config


class QueryRefinementAgent(BaseAgent):
    """
    Agent đầu tiên trong pipeline - làm sạch và chuẩn hóa user input
    Xử lý cả tiếng Anh và tiếng Việt
    """

    def __init__(self):
        super().__init__(config.agents["query_refinement"])
        self.supported_languages = ["en", "vi"]
        self.ambiguous_terms = {
            "vi": {
                "phim": ["film", "movie"],
                "khách hàng": ["customer", "client"],
                "diễn viên": ["actor", "actress"],
                "thể loại": ["category", "genre"],
                "thuê": ["rental", "rent"],
                "thanh toán": ["payment", "transaction"]
            },
            "en": {
                "movie": ["film"],
                "client": ["customer"],
                "genre": ["category"],
                "rent": ["rental"],
                "transaction": ["payment"]
            }
        }

    def get_system_prompt(self) -> str:
        return """Bạn là Query Refinement Agent trong hệ thống Multi-Agent Text-to-SQL.

NHIỆM VỤ:
1. Làm rõ câu hỏi không rõ ràng hoặc mơ hồ
2. Chuẩn hóa thuật ngữ theo database schema
3. Bổ sung context cần thiết cho các agent khác
4. Xử lý cả tiếng Anh và tiếng Việt

NGUYÊN TẮC:
- Giữ nguyên ý nghĩa gốc của câu hỏi
- Làm rõ các thuật ngữ mơ hồ
- Chuẩn hóa format câu hỏi
- Xác định ngôn ngữ và độ phức tạp
- Không thêm thông tin không cần thiết

OUTPUT FORMAT:
{
    "refined_query": "Câu hỏi đã được làm rõ",
    "original_query": "Câu hỏi gốc",
    "language": "en/vi",
    "complexity_level": "1-5",
    "key_terms": ["term1", "term2"],
    "ambiguities_resolved": ["clarification1", "clarification2"],
    "context_needed": ["additional_info1", "additional_info2"]
}

EXAMPLES:
Input: "Có bao nhiêu phim?"
Output: {
    "refined_query": "Có tổng cộng bao nhiêu bộ phim trong cơ sở dữ liệu?",
    "language": "vi",
    "complexity_level": "1",
    "key_terms": ["phim", "đếm", "tổng số"],
    "ambiguities_resolved": ["Làm rõ đếm tổng số phim trong database"]
}
"""

    async def process(self, input_data: Dict[str, Any]) -> AgentResponse:
        """
        Main processing method for query refinement
        """
        start_time = datetime.now()

        try:
            self.is_busy = True
            self.logger.info(
                f"Processing query refinement for: {input_data.get('query', '')[:50]}...")

            # Extract input
            raw_query = input_data.get("query", "")
            user_context = input_data.get("context", {})

            if not raw_query.strip():
                raise ValueError("Empty query provided")

            # Detect language
            language = self._detect_language(raw_query)

            # Pre-process query
            preprocessed = self._preprocess_query(raw_query, language)

            # Get refinement from LLM
            refined_result = await self._refine_query_with_llm(preprocessed, language, user_context)

            # Post-process and validate
            final_result = self._post_process_refinement(
                refined_result, raw_query, language)

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
            self.logger.error(f"Query refinement failed: {str(e)}")

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

    def _detect_language(self, query: str) -> str:
        """Detect query language (Vietnamese or English)"""
        vietnamese_chars = re.search(
            r'[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]', query.lower())

        vietnamese_keywords = ['có', 'bao', 'nhiêu',
                               'là', 'gì', 'nào', 'của', 'trong', 'với', 'và']
        vietnamese_word_count = sum(
            1 for word in vietnamese_keywords if word in query.lower())

        if vietnamese_chars or vietnamese_word_count >= 2:
            return "vi"
        return "en"

    def _preprocess_query(self, query: str, language: str) -> str:
        """Basic preprocessing of query"""
        # Remove extra whitespace
        query = re.sub(r'\s+', ' ', query.strip())

        # Fix common typos based on language
        if language == "vi":
            # Vietnamese-specific fixes
            query = query.replace("bao nhieu", "bao nhiêu")
            query = query.replace("khach hang", "khách hàng")
            query = query.replace("dien vien", "diễn viên")
        else:
            # English-specific fixes
            query = query.replace("how many", "how many")
            query = query.replace("whats", "what is")
            query = query.replace("dont", "don't")

        return query

    async def _refine_query_with_llm(self, query: str, language: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """Use LLM to refine and clarify the query"""

        messages = [
            {"role": "system", "content": self.get_system_prompt()},
            {"role": "user", "content": f"""
Hãy làm rõ và chuẩn hóa câu hỏi sau:

QUERY: {query}
LANGUAGE: {language}
CONTEXT: {context}

Trả về kết quả theo định dạng JSON đã yêu cầu."""}
        ]

        response = await self.call_llm(messages, temperature=0.1)

        # Parse JSON response
        try:
            import json
            result = json.loads(response)
            return result
        except json.JSONDecodeError:
            # Fallback parsing if JSON is malformed
            return self._fallback_parse_response(response, query, language)

    def _fallback_parse_response(self, response: str, original_query: str, language: str) -> Dict[str, Any]:
        """Fallback parsing when LLM doesn't return proper JSON"""

        # Extract refined query from response
        lines = response.split('\n')
        refined_query = original_query

        for line in lines:
            if 'refined_query' in line.lower() or 'câu hỏi' in line.lower():
                # Try to extract the refined query
                parts = line.split(':', 1)
                if len(parts) > 1:
                    refined_query = parts[1].strip().strip('"').strip("'")
                    break

        return {
            "refined_query": refined_query,
            "original_query": original_query,
            "language": language,
            "complexity_level": "3",  # Default medium complexity
            "key_terms": self._extract_key_terms(refined_query, language),
            "ambiguities_resolved": ["Fallback processing used"],
            "context_needed": []
        }

    def _extract_key_terms(self, query: str, language: str) -> List[str]:
        """Extract key terms from query"""
        terms = []

        if language == "vi":
            # Vietnamese key terms
            vi_terms = ['phim', 'khách hàng', 'diễn viên',
                        'thể loại', 'thuê', 'thanh toán', 'cửa hàng']
            for term in vi_terms:
                if term in query.lower():
                    terms.append(term)
        else:
            # English key terms
            en_terms = ['film', 'movie', 'customer', 'actor',
                        'category', 'rental', 'payment', 'store']
            for term in en_terms:
                if term in query.lower():
                    terms.append(term)

        # Add query types
        if any(word in query.lower() for word in ['bao nhiêu', 'how many', 'count']):
            terms.append('count')
        if any(word in query.lower() for word in ['liệt kê', 'list', 'show']):
            terms.append('list')
        if any(word in query.lower() for word in ['tìm', 'find', 'search']):
            terms.append('search')

        return list(set(terms))

    def _post_process_refinement(self, result: Dict[str, Any], original_query: str, language: str) -> Dict[str, Any]:
        """Post-process and validate the refinement result"""

        # Ensure all required fields exist
        final_result = {
            "refined_query": result.get("refined_query", original_query),
            "original_query": original_query,
            "language": language,
            "complexity_level": str(result.get("complexity_level", "3")),
            "key_terms": result.get("key_terms", []),
            "ambiguities_resolved": result.get("ambiguities_resolved", []),
            "context_needed": result.get("context_needed", []),
            "refinement_confidence": self._calculate_confidence(result, original_query),
            "suggested_clarifications": self._generate_clarifications(result, language)
        }

        # Validate complexity level
        try:
            complexity = int(final_result["complexity_level"])
            if complexity < 1 or complexity > 5:
                final_result["complexity_level"] = "3"
        except (ValueError, TypeError):
            final_result["complexity_level"] = "3"

        return final_result

    def _calculate_confidence(self, result: Dict[str, Any], original_query: str) -> float:
        """Calculate confidence score for refinement"""
        score = 0.5  # Base score

        # Add score based on completeness
        if result.get("refined_query") and result["refined_query"] != original_query:
            score += 0.2

        if result.get("key_terms") and len(result["key_terms"]) > 0:
            score += 0.2

        if result.get("ambiguities_resolved") and len(result["ambiguities_resolved"]) > 0:
            score += 0.1

        return min(score, 1.0)

    def _generate_clarifications(self, result: Dict[str, Any], language: str) -> List[str]:
        """Generate suggested clarifications for ambiguous queries"""
        clarifications = []

        key_terms = result.get("key_terms", [])

        if "count" in key_terms:
            if language == "vi":
                clarifications.append(
                    "Bạn có muốn đếm tổng số hay đếm theo điều kiện cụ thể?")
            else:
                clarifications.append(
                    "Do you want to count total or with specific conditions?")

        if "phim" in key_terms or "film" in key_terms:
            if language == "vi":
                clarifications.append(
                    "Bạn có muốn thông tin về phim cụ thể nào không?")
            else:
                clarifications.append(
                    "Do you want information about specific films?")

        return clarifications

    async def get_refinement_suggestions(self, query: str) -> List[str]:
        """Get suggestions for improving query clarity"""
        language = self._detect_language(query)

        suggestions = []

        # Check for vague terms
        vague_terms = {
            "vi": ["tất cả", "một số", "nhiều", "ít"],
            "en": ["all", "some", "many", "few"]
        }

        for term in vague_terms.get(language, []):
            if term in query.lower():
                if language == "vi":
                    suggestions.append(
                        f"Thay '{term}' bằng số lượng cụ thể hoặc điều kiện rõ ràng hơn")
                else:
                    suggestions.append(
                        f"Replace '{term}' with specific numbers or clearer conditions")

        return suggestions
