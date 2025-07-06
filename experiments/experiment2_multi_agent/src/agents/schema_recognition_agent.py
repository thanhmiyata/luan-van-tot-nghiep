"""
Agent 2: Schema Recognition Agent
Chức năng: Nhận diện entities và map với database schema
Input: Refined query + Database schema
Output: Identified tables, columns, relationships
Tech: GLiNER model + schema mapping
"""
import asyncio
from datetime import datetime
from typing import Dict, Any, List, Optional, Tuple
import re
import psycopg2
from psycopg2.extras import RealDictCursor

from .base_agent import BaseAgent, AgentResponse
from ..config import config, SPECIALIZED_MODELS


class SchemaRecognitionAgent(BaseAgent):
    """
    Agent thứ 2 trong pipeline - nhận diện entities và mapping với database schema
    Sử dụng GLiNER model để extract entities từ query
    """

    def __init__(self):
        super().__init__(config.agents["schema_recognition"])
        self.gliner_model = None
        self.schema_cache = {}
        self.entity_mappings = {}
        self.relationship_cache = {}

        # Initialize GLiNER model (lazy loading)
        self._init_gliner_model()

        # Load database schema
        self._load_database_schema()

    def _init_gliner_model(self):
        """Initialize GLiNER model for entity recognition"""
        try:
            from gliner import GLiNER
            self.gliner_model = GLiNER.from_pretrained(
                SPECIALIZED_MODELS["ner"]["model_name"]
            )
            self.logger.info("GLiNER model loaded successfully")
        except ImportError:
            self.logger.warning(
                "GLiNER not available, using fallback entity recognition")
            self.gliner_model = None
        except Exception as e:
            self.logger.error(f"Failed to load GLiNER model: {str(e)}")
            self.gliner_model = None

    def _load_database_schema(self):
        """Load and cache database schema information"""
        try:
            conn = psycopg2.connect(config.DATABASE_URL)
            cursor = conn.cursor(cursor_factory=RealDictCursor)

            # Get all tables and their columns
            cursor.execute("""
                SELECT 
                    t.table_name,
                    c.column_name,
                    c.data_type,
                    c.is_nullable,
                    c.column_default,
                    tc.constraint_type
                FROM information_schema.tables t
                LEFT JOIN information_schema.columns c ON t.table_name = c.table_name
                LEFT JOIN information_schema.table_constraints tc ON t.table_name = tc.table_name
                WHERE t.table_schema = 'public'
                ORDER BY t.table_name, c.ordinal_position;
            """)

            schema_info = cursor.fetchall()

            # Organize schema by table
            for row in schema_info:
                table_name = row['table_name']
                if table_name not in self.schema_cache:
                    self.schema_cache[table_name] = {
                        'columns': [],
                        'primary_keys': [],
                        'foreign_keys': [],
                        'description': self._get_table_description(table_name)
                    }

                if row['column_name']:
                    self.schema_cache[table_name]['columns'].append({
                        'name': row['column_name'],
                        'type': row['data_type'],
                        'nullable': row['is_nullable'],
                        'default': row['column_default']
                    })

            # Get foreign key relationships
            cursor.execute("""
                SELECT
                    tc.table_name,
                    kcu.column_name,
                    ccu.table_name AS foreign_table_name,
                    ccu.column_name AS foreign_column_name
                FROM information_schema.table_constraints AS tc
                JOIN information_schema.key_column_usage AS kcu
                    ON tc.constraint_name = kcu.constraint_name
                    AND tc.table_schema = kcu.table_schema
                JOIN information_schema.constraint_column_usage AS ccu
                    ON ccu.constraint_name = tc.constraint_name
                    AND ccu.table_schema = tc.table_schema
                WHERE tc.constraint_type = 'FOREIGN KEY'
                    AND tc.table_schema = 'public';
            """)

            fk_info = cursor.fetchall()
            for row in fk_info:
                table_name = row['table_name']
                if table_name in self.schema_cache:
                    self.schema_cache[table_name]['foreign_keys'].append({
                        'column': row['column_name'],
                        'references_table': row['foreign_table_name'],
                        'references_column': row['foreign_column_name']
                    })

            conn.close()
            self.logger.info(
                f"Loaded schema for {len(self.schema_cache)} tables")

        except Exception as e:
            self.logger.error(f"Failed to load database schema: {str(e)}")
            self.schema_cache = {}

    def _get_table_description(self, table_name: str) -> str:
        """Get human-readable description of table"""
        descriptions = {
            'film': 'Bảng chứa thông tin các bộ phim',
            'actor': 'Bảng chứa thông tin các diễn viên',
            'customer': 'Bảng chứa thông tin khách hàng',
            'category': 'Bảng chứa các thể loại phim',
            'rental': 'Bảng chứa thông tin thuê phim',
            'payment': 'Bảng chứa thông tin thanh toán',
            'inventory': 'Bảng chứa thông tin tồn kho phim',
            'store': 'Bảng chứa thông tin cửa hàng',
            'staff': 'Bảng chứa thông tin nhân viên',
            'address': 'Bảng chứa thông tin địa chỉ',
            'city': 'Bảng chứa thông tin thành phố',
            'country': 'Bảng chứa thông tin quốc gia'
        }
        return descriptions.get(table_name, f'Bảng {table_name}')

    def get_system_prompt(self) -> str:
        return """Bạn là Schema Recognition Agent trong hệ thống Multi-Agent Text-to-SQL.

NHIỆM VỤ:
1. Nhận diện entities trong refined query
2. Map entities với database schema (tables, columns)
3. Xác định relationships giữa các tables
4. Đánh giá độ chính xác của mapping

NGUYÊN TẮC:
- Sử dụng GLiNER model để extract entities
- Map chính xác entities với schema
- Xác định JOIN relationships cần thiết
- Đánh giá confidence score cho mỗi mapping

DATABASE SCHEMA CONTEXT:
- film: bảng phim (title, description, rating, length, etc.)
- actor: bảng diễn viên (first_name, last_name)
- customer: bảng khách hàng (first_name, last_name, email)
- category: bảng thể loại (name)
- rental: bảng thuê phim (rental_date, return_date)
- payment: bảng thanh toán (amount, payment_date)
- inventory: bảng tồn kho
- store: bảng cửa hàng

OUTPUT FORMAT:
{
    "entities": [
        {
            "text": "extracted entity",
            "type": "entity type",
            "confidence": 0.95,
            "mapped_table": "table_name",
            "mapped_column": "column_name",
            "mapping_confidence": 0.90
        }
    ],
    "required_tables": ["table1", "table2"],
    "required_joins": [
        {
            "table1": "table_name",
            "table2": "table_name", 
            "join_type": "INNER JOIN",
            "condition": "table1.id = table2.foreign_id"
        }
    ],
    "schema_confidence": 0.85,
    "potential_ambiguities": ["ambiguity1", "ambiguity2"]
}
"""

    async def process(self, input_data: Dict[str, Any]) -> AgentResponse:
        """
        Main processing method for schema recognition
        """
        start_time = datetime.now()

        try:
            self.is_busy = True
            refined_query = input_data.get("refined_query", "")
            language = input_data.get("language", "en")

            self.logger.info(
                f"Processing schema recognition for: {refined_query[:50]}...")

            # Extract entities using GLiNER + fallback
            entities = await self._extract_entities(refined_query, language)

            # Map entities to database schema
            schema_mapping = await self._map_entities_to_schema(entities, refined_query, language)

            # Determine required JOINs
            join_analysis = self._analyze_required_joins(schema_mapping)

            # Validate and score the mapping
            validation_result = self._validate_schema_mapping(
                schema_mapping, join_analysis)

            # Compile final result
            final_result = {
                "entities": entities,
                "required_tables": schema_mapping.get("required_tables", []),
                "required_joins": join_analysis.get("required_joins", []),
                "schema_confidence": validation_result.get("overall_confidence", 0.0),
                "potential_ambiguities": validation_result.get("ambiguities", []),
                "schema_analysis": {
                    "complexity_score": validation_result.get("complexity_score", 0),
                    "join_complexity": len(join_analysis.get("required_joins", [])),
                    "table_count": len(schema_mapping.get("required_tables", [])),
                    "confidence_breakdown": validation_result.get("confidence_breakdown", {})
                }
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
            self.logger.error(f"Schema recognition failed: {str(e)}")

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

    async def _extract_entities(self, query: str, language: str) -> List[Dict[str, Any]]:
        """Extract entities from query using GLiNER + fallback methods"""
        entities = []

        # Try GLiNER first
        if self.gliner_model:
            try:
                entities.extend(await self._extract_entities_gliner(query, language))
            except Exception as e:
                self.logger.warning(f"GLiNER extraction failed: {str(e)}")

        # Fallback to rule-based extraction
        fallback_entities = self._extract_entities_fallback(query, language)

        # Merge and deduplicate
        entities.extend(fallback_entities)
        entities = self._deduplicate_entities(entities)

        return entities

    async def _extract_entities_gliner(self, query: str, language: str) -> List[Dict[str, Any]]:
        """Extract entities using GLiNER model"""
        # Define entity types for DVD rental domain
        entity_types = [
            "film", "movie", "actor", "customer", "category", "rental",
            "payment", "store", "inventory", "staff", "address"
        ]

        if language == "vi":
            entity_types.extend([
                "phim", "diễn viên", "khách hàng", "thể loại", "thuê",
                "thanh toán", "cửa hàng", "tồn kho", "nhân viên", "địa chỉ"
            ])

        # Extract entities
        entities = self.gliner_model.predict_entities(
            query,
            entity_types,
            threshold=SPECIALIZED_MODELS["ner"]["threshold"]
        )

        result = []
        for entity in entities:
            result.append({
                "text": entity["text"],
                "type": entity["label"],
                "confidence": entity["score"],
                "start": entity["start"],
                "end": entity["end"],
                "source": "gliner"
            })

        return result

    def _extract_entities_fallback(self, query: str, language: str) -> List[Dict[str, Any]]:
        """Fallback rule-based entity extraction"""
        entities = []

        # Define patterns for different entity types
        if language == "vi":
            patterns = {
                "film": r"\b(phim|bộ phim)\b",
                "actor": r"\b(diễn viên|nam diễn viên|nữ diễn viên)\b",
                "customer": r"\b(khách hàng|khách)\b",
                "category": r"\b(thể loại|loại phim)\b",
                "rental": r"\b(thuê|cho thuê|mượn)\b",
                "payment": r"\b(thanh toán|trả tiền|tiền)\b",
                "store": r"\b(cửa hàng|cửa tiệm)\b",
                "inventory": r"\b(tồn kho|kho)\b"
            }
        else:
            patterns = {
                "film": r"\b(film|movie|movies)\b",
                "actor": r"\b(actor|actress|actors)\b",
                "customer": r"\b(customer|client|customers)\b",
                "category": r"\b(category|genre|categories)\b",
                "rental": r"\b(rental|rent|rented)\b",
                "payment": r"\b(payment|transaction|pay)\b",
                "store": r"\b(store|shop)\b",
                "inventory": r"\b(inventory|stock)\b"
            }

        for entity_type, pattern in patterns.items():
            matches = re.finditer(pattern, query, re.IGNORECASE)
            for match in matches:
                entities.append({
                    "text": match.group(),
                    "type": entity_type,
                    "confidence": 0.8,  # Rule-based confidence
                    "start": match.start(),
                    "end": match.end(),
                    "source": "rule-based"
                })

        return entities

    def _deduplicate_entities(self, entities: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Remove duplicate entities"""
        seen = set()
        result = []

        for entity in entities:
            # Create a key based on text and type
            key = (entity["text"].lower(), entity["type"])
            if key not in seen:
                seen.add(key)
                result.append(entity)

        return result

    async def _map_entities_to_schema(self, entities: List[Dict[str, Any]], query: str, language: str) -> Dict[str, Any]:
        """Map extracted entities to database schema"""

        # Use LLM to help with mapping
        messages = [
            {"role": "system", "content": self.get_system_prompt()},
            {"role": "user", "content": f"""
Map the following entities to the database schema:

QUERY: {query}
LANGUAGE: {language}
ENTITIES: {entities}

AVAILABLE TABLES: {list(self.schema_cache.keys())}

For each entity, determine:
1. Most appropriate table
2. Most appropriate column (if applicable)
3. Confidence score (0-1)

Return mapping in JSON format."""}
        ]

        response = await self.call_llm(messages, temperature=0.0)

        # Parse response and validate
        try:
            import json
            mapping_result = json.loads(response)

            # Validate and enhance mapping
            validated_mapping = self._validate_and_enhance_mapping(
                mapping_result, entities)

            return validated_mapping

        except json.JSONDecodeError:
            # Fallback to rule-based mapping
            return self._fallback_schema_mapping(entities, query, language)

    def _fallback_schema_mapping(self, entities: List[Dict[str, Any]], query: str, language: str) -> Dict[str, Any]:
        """Fallback schema mapping when LLM fails"""

        # Simple rule-based mapping
        entity_to_table = {
            "film": "film",
            "phim": "film",
            "movie": "film",
            "actor": "actor",
            "diễn viên": "actor",
            "customer": "customer",
            "khách hàng": "customer",
            "category": "category",
            "thể loại": "category",
            "rental": "rental",
            "thuê": "rental",
            "payment": "payment",
            "thanh toán": "payment",
            "store": "store",
            "cửa hàng": "store",
            "inventory": "inventory",
            "tồn kho": "inventory"
        }

        required_tables = set()
        mapped_entities = []

        for entity in entities:
            entity_type = entity["type"]
            table_name = entity_to_table.get(entity_type)

            if table_name and table_name in self.schema_cache:
                required_tables.add(table_name)
                mapped_entities.append({
                    **entity,
                    "mapped_table": table_name,
                    "mapped_column": None,
                    "mapping_confidence": 0.7
                })

        return {
            "required_tables": list(required_tables),
            "mapped_entities": mapped_entities,
            "mapping_method": "fallback"
        }

    def _validate_and_enhance_mapping(self, mapping_result: Dict[str, Any], original_entities: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Validate and enhance the mapping result"""

        # Ensure all required tables exist in schema
        required_tables = mapping_result.get("required_tables", [])
        valid_tables = [t for t in required_tables if t in self.schema_cache]

        # Add missing tables based on entities
        for entity in original_entities:
            if entity["type"] in ["film", "phim", "movie"] and "film" not in valid_tables:
                valid_tables.append("film")
            elif entity["type"] in ["customer", "khách hàng"] and "customer" not in valid_tables:
                valid_tables.append("customer")

        return {
            "required_tables": valid_tables,
            "mapped_entities": mapping_result.get("entities", original_entities),
            "mapping_method": "llm_enhanced"
        }

    def _analyze_required_joins(self, schema_mapping: Dict[str, Any]) -> Dict[str, Any]:
        """Analyze required JOINs based on schema mapping"""

        required_tables = schema_mapping.get("required_tables", [])
        required_joins = []

        # Define common JOIN patterns for DVD rental schema
        join_patterns = {
            ("film", "film_actor"): {
                "condition": "film.film_id = film_actor.film_id",
                "type": "INNER JOIN"
            },
            ("film_actor", "actor"): {
                "condition": "film_actor.actor_id = actor.actor_id",
                "type": "INNER JOIN"
            },
            ("film", "film_category"): {
                "condition": "film.film_id = film_category.film_id",
                "type": "INNER JOIN"
            },
            ("film_category", "category"): {
                "condition": "film_category.category_id = category.category_id",
                "type": "INNER JOIN"
            },
            ("film", "inventory"): {
                "condition": "film.film_id = inventory.film_id",
                "type": "INNER JOIN"
            },
            ("inventory", "rental"): {
                "condition": "inventory.inventory_id = rental.inventory_id",
                "type": "INNER JOIN"
            },
            ("rental", "customer"): {
                "condition": "rental.customer_id = customer.customer_id",
                "type": "INNER JOIN"
            },
            ("rental", "payment"): {
                "condition": "rental.rental_id = payment.rental_id",
                "type": "INNER JOIN"
            },
            ("customer", "store"): {
                "condition": "customer.store_id = store.store_id",
                "type": "INNER JOIN"
            }
        }

        # Find required joins
        for i, table1 in enumerate(required_tables):
            for j, table2 in enumerate(required_tables):
                if i < j:  # Avoid duplicates
                    # Check direct join
                    if (table1, table2) in join_patterns:
                        required_joins.append({
                            "table1": table1,
                            "table2": table2,
                            "join_type": join_patterns[(table1, table2)]["type"],
                            "condition": join_patterns[(table1, table2)]["condition"]
                        })
                    elif (table2, table1) in join_patterns:
                        required_joins.append({
                            "table1": table2,
                            "table2": table1,
                            "join_type": join_patterns[(table2, table1)]["type"],
                            "condition": join_patterns[(table2, table1)]["condition"]
                        })

        return {
            "required_joins": required_joins,
            "join_complexity": len(required_joins),
            "join_analysis": "automatic"
        }

    def _validate_schema_mapping(self, schema_mapping: Dict[str, Any], join_analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Validate the complete schema mapping"""

        required_tables = schema_mapping.get("required_tables", [])
        required_joins = join_analysis.get("required_joins", [])

        # Calculate confidence scores
        table_confidence = 1.0 if all(
            t in self.schema_cache for t in required_tables) else 0.7
        join_confidence = 1.0 if len(required_joins) > 0 else 0.8

        overall_confidence = (table_confidence + join_confidence) / 2

        # Identify potential ambiguities
        ambiguities = []
        if len(required_tables) > 5:
            ambiguities.append("Complex query với nhiều tables")
        if len(required_joins) > 3:
            ambiguities.append("Multiple JOINs có thể ảnh hưởng performance")

        return {
            "overall_confidence": overall_confidence,
            "confidence_breakdown": {
                "table_mapping": table_confidence,
                "join_analysis": join_confidence
            },
            "complexity_score": len(required_tables) + len(required_joins),
            "ambiguities": ambiguities
        }

    def get_schema_summary(self) -> Dict[str, Any]:
        """Get summary of loaded database schema"""
        return {
            "total_tables": len(self.schema_cache),
            "tables": list(self.schema_cache.keys()),
            "schema_loaded": bool(self.schema_cache),
            "gliner_available": self.gliner_model is not None
        }
