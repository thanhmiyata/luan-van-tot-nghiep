"""
Schema Agent for the Multi-Agent Text-to-SQL system.
Responsible for understanding, analyzing, and providing information about database schemas.
"""

from typing import Dict, List, Optional, Any, Tuple
from dataclasses import dataclass
from enum import Enum
import json
import re
from sqlalchemy import MetaData, Table, Column, inspect
from sqlalchemy.sql import text

from .base_agent import BaseAgent, Message, MessageType, AgentCapability
from ..database.connection import db_manager
from ..core.logging import get_agent_logger


class RelationshipType(Enum):
    """Types of relationships between tables."""
    ONE_TO_ONE = "one_to_one"
    ONE_TO_MANY = "one_to_many"
    MANY_TO_MANY = "many_to_many"


@dataclass
class TableInfo:
    """Information about a database table."""
    name: str
    schema: Optional[str]
    columns: List[Dict[str, Any]]
    primary_keys: List[str]
    foreign_keys: List[Dict[str, Any]]
    indexes: List[Dict[str, Any]]
    constraints: List[Dict[str, Any]]
    row_count: Optional[int] = None
    description: Optional[str] = None


@dataclass
class ColumnInfo:
    """Information about a table column."""
    name: str
    data_type: str
    nullable: bool
    default_value: Any
    is_primary_key: bool
    is_foreign_key: bool
    foreign_key_reference: Optional[str]
    description: Optional[str] = None
    sample_values: Optional[List[Any]] = None


@dataclass
class Relationship:
    """Represents a relationship between tables."""
    source_table: str
    target_table: str
    source_columns: List[str]
    target_columns: List[str]
    relationship_type: RelationshipType
    constraint_name: Optional[str] = None


class SchemaAgent(BaseAgent):
    """
    Schema Agent responsible for:
    - Analyzing database schema structure
    - Extracting table and column information
    - Identifying relationships between tables
    - Providing schema-based recommendations for queries
    - Caching schema information for performance
    """
    
    def __init__(self):
        super().__init__(
            name="SchemaAgent",
            description="Analyzes and provides information about database schemas"
        )
        
        self.schema_cache: Dict[str, TableInfo] = {}
        self.relationships_cache: List[Relationship] = []
        self.metadata_cache: Optional[MetaData] = None
        self.last_schema_update: Optional[str] = None
        
        # Add capabilities
        self.add_capability(AgentCapability(
            name="schema_analysis",
            description="Analyze database schema structure",
            input_types=["database_connection", "schema_name"],
            output_types=["schema_info", "table_list", "relationship_map"]
        ))
        
        self.add_capability(AgentCapability(
            name="table_info",
            description="Get detailed information about a specific table",
            input_types=["table_name"],
            output_types=["table_info", "column_details"]
        ))
        
        self.add_capability(AgentCapability(
            name="relationship_discovery",
            description="Discover relationships between tables",
            input_types=["table_list"],
            output_types=["relationship_map", "join_suggestions"]
        ))
        
        self.add_capability(AgentCapability(
            name="query_validation",
            description="Validate query against schema",
            input_types=["sql_query"],
            output_types=["validation_result", "schema_errors"]
        ))
    
    async def process_message(self, message: Message) -> Message:
        """Process incoming messages and route to appropriate handlers."""
        try:
            content = message.content
            action = content.get("action")
            
            if action == "analyze_schema":
                result = await self._analyze_schema(content.get("schema_name"))
            elif action == "get_table_info":
                result = await self._get_table_info(content.get("table_name"))
            elif action == "find_relationships":
                result = await self._find_relationships(content.get("tables", []))
            elif action == "validate_query":
                result = await self._validate_query(content.get("query"))
            elif action == "suggest_joins":
                result = await self._suggest_joins(content.get("tables", []))
            elif action == "get_schema_summary":
                result = await self._get_schema_summary()
            else:
                result = {"error": f"Unknown action: {action}"}
            
            return Message(
                id="",
                sender=self.name,
                receiver=message.sender,
                message_type=MessageType.RESPONSE,
                content=result,
                timestamp=message.timestamp,
                correlation_id=message.correlation_id
            )
            
        except Exception as e:
            self.logger.error(f"Error processing message: {str(e)}")
            return Message(
                id="",
                sender=self.name,
                receiver=message.sender,
                message_type=MessageType.ERROR,
                content={"error": str(e)},
                timestamp=message.timestamp,
                correlation_id=message.correlation_id
            )
    
    def get_capabilities(self) -> List[AgentCapability]:
        """Return list of agent capabilities."""
        return self.capabilities
    
    async def _analyze_schema(self, schema_name: Optional[str] = None) -> Dict[str, Any]:
        """
        Analyze the database schema and extract structure information.
        
        Args:
            schema_name: Optional schema name to analyze
            
        Returns:
            Dict containing schema analysis results
        """
        try:
            self.logger.info(f"Analyzing schema: {schema_name or 'default'}")
            
            # Reflect database metadata
            metadata = await db_manager.reflect_database(schema_name)
            self.metadata_cache = metadata
            
            tables_info = []
            relationships = []
            
            # Analyze each table
            for table_name, table in metadata.tables.items():
                table_info = await self._extract_table_info(table)
                tables_info.append(table_info)
                self.schema_cache[table_name] = table_info
            
            # Discover relationships
            relationships = await self._discover_relationships(metadata)
            self.relationships_cache = relationships
            
            result = {
                "schema_name": schema_name,
                "tables": [table.name for table in tables_info],
                "table_count": len(tables_info),
                "relationship_count": len(relationships),
                "tables_info": [self._table_info_to_dict(table) for table in tables_info],
                "relationships": [self._relationship_to_dict(rel) for rel in relationships],
                "analysis_timestamp": self.last_schema_update
            }
            
            self.logger.info(f"Schema analysis completed. Found {len(tables_info)} tables and {len(relationships)} relationships")
            return result
            
        except Exception as e:
            self.logger.error(f"Error analyzing schema: {str(e)}")
            raise
    
    async def _extract_table_info(self, table: Table) -> TableInfo:
        """Extract detailed information about a table."""
        try:
            # Basic table information
            columns = []
            primary_keys = []
            foreign_keys = []
            
            # Extract column information
            for column in table.columns:
                col_info = {
                    "name": column.name,
                    "type": str(column.type),
                    "nullable": column.nullable,
                    "default": str(column.default) if column.default else None,
                    "primary_key": column.primary_key,
                    "foreign_key": bool(column.foreign_keys)
                }
                columns.append(col_info)
                
                if column.primary_key:
                    primary_keys.append(column.name)
            
            # Extract foreign key information
            for fk in table.foreign_keys:
                fk_info = {
                    "column": fk.parent.name,
                    "referenced_table": fk.column.table.name,
                    "referenced_column": fk.column.name,
                    "constraint_name": fk.constraint.name if fk.constraint else None
                }
                foreign_keys.append(fk_info)
            
            # Extract indexes
            indexes = []
            for index in table.indexes:
                index_info = {
                    "name": index.name,
                    "columns": [col.name for col in index.columns],
                    "unique": index.unique
                }
                indexes.append(index_info)
            
            # Get row count (if possible)
            row_count = await self._get_table_row_count(table.name)
            
            return TableInfo(
                name=table.name,
                schema=table.schema,
                columns=columns,
                primary_keys=primary_keys,
                foreign_keys=foreign_keys,
                indexes=indexes,
                constraints=[],  # TODO: Extract check constraints
                row_count=row_count
            )
            
        except Exception as e:
            self.logger.error(f"Error extracting table info for {table.name}: {str(e)}")
            raise
    
    async def _get_table_row_count(self, table_name: str) -> Optional[int]:
        """Get approximate row count for a table."""
        try:
            async for db in db_manager.get_async_session():
                result = await db.execute(text(f"SELECT COUNT(*) FROM {table_name}"))
                return result.scalar()
        except Exception as e:
            self.logger.warning(f"Could not get row count for {table_name}: {str(e)}")
            return None
    
    async def _discover_relationships(self, metadata: MetaData) -> List[Relationship]:
        """Discover relationships between tables based on foreign keys."""
        relationships = []
        
        try:
            for table_name, table in metadata.tables.items():
                for fk in table.foreign_keys:
                    # Determine relationship type
                    relationship_type = await self._determine_relationship_type(
                        table, fk.column.table, fk
                    )
                    
                    relationship = Relationship(
                        source_table=table.name,
                        target_table=fk.column.table.name,
                        source_columns=[fk.parent.name],
                        target_columns=[fk.column.name],
                        relationship_type=relationship_type,
                        constraint_name=fk.constraint.name if fk.constraint else None
                    )
                    relationships.append(relationship)
            
            return relationships
            
        except Exception as e:
            self.logger.error(f"Error discovering relationships: {str(e)}")
            return []
    
    async def _determine_relationship_type(self, source_table: Table, target_table: Table, fk) -> RelationshipType:
        """Determine the type of relationship between two tables."""
        # This is a simplified approach - in reality, you'd need more sophisticated logic
        # to determine relationship types accurately
        
        # Check if the foreign key column is unique or primary key
        fk_column = fk.parent
        if fk_column.primary_key or fk_column.unique:
            return RelationshipType.ONE_TO_ONE
        else:
            return RelationshipType.ONE_TO_MANY
    
    async def _get_table_info(self, table_name: str) -> Dict[str, Any]:
        """Get detailed information about a specific table."""
        try:
            # Check cache first
            if table_name in self.schema_cache:
                table_info = self.schema_cache[table_name]
                return {
                    "table_name": table_name,
                    "info": self._table_info_to_dict(table_info),
                    "from_cache": True
                }
            
            # If not in cache, analyze schema first
            await self._analyze_schema()
            
            if table_name in self.schema_cache:
                table_info = self.schema_cache[table_name]
                return {
                    "table_name": table_name,
                    "info": self._table_info_to_dict(table_info),
                    "from_cache": False
                }
            else:
                return {"error": f"Table {table_name} not found"}
                
        except Exception as e:
            self.logger.error(f"Error getting table info for {table_name}: {str(e)}")
            return {"error": str(e)}
    
    async def _find_relationships(self, tables: List[str]) -> Dict[str, Any]:
        """Find relationships between specified tables."""
        try:
            if not self.relationships_cache:
                await self._analyze_schema()
            
            relevant_relationships = []
            for rel in self.relationships_cache:
                if rel.source_table in tables or rel.target_table in tables:
                    relevant_relationships.append(rel)
            
            return {
                "tables": tables,
                "relationships": [self._relationship_to_dict(rel) for rel in relevant_relationships],
                "relationship_count": len(relevant_relationships)
            }
            
        except Exception as e:
            self.logger.error(f"Error finding relationships: {str(e)}")
            return {"error": str(e)}
    
    async def _validate_query(self, query: str) -> Dict[str, Any]:
        """Validate a SQL query against the current schema."""
        try:
            if not self.schema_cache:
                await self._analyze_schema()
            
            errors = []
            warnings = []
            
            # Extract table names from query (simple regex approach)
            table_pattern = r'\bFROM\s+(\w+)|JOIN\s+(\w+)'
            matches = re.finditer(table_pattern, query, re.IGNORECASE)
            
            referenced_tables = set()
            for match in matches:
                table_name = match.group(1) or match.group(2)
                referenced_tables.add(table_name.lower())
            
            # Check if tables exist
            for table_name in referenced_tables:
                if table_name not in [t.lower() for t in self.schema_cache.keys()]:
                    errors.append(f"Table '{table_name}' does not exist in schema")
            
            # TODO: Add more sophisticated validation
            # - Column existence
            # - Data type compatibility
            # - Join conditions
            
            return {
                "query": query,
                "valid": len(errors) == 0,
                "errors": errors,
                "warnings": warnings,
                "referenced_tables": list(referenced_tables)
            }
            
        except Exception as e:
            self.logger.error(f"Error validating query: {str(e)}")
            return {"error": str(e)}
    
    async def _suggest_joins(self, tables: List[str]) -> Dict[str, Any]:
        """Suggest possible JOIN conditions between tables."""
        try:
            if not self.relationships_cache:
                await self._analyze_schema()
            
            join_suggestions = []
            
            # Find relationships between the specified tables
            for i, table1 in enumerate(tables):
                for table2 in tables[i+1:]:
                    # Look for direct relationships
                    for rel in self.relationships_cache:
                        if ((rel.source_table == table1 and rel.target_table == table2) or
                            (rel.source_table == table2 and rel.target_table == table1)):
                            
                            join_suggestion = {
                                "table1": table1,
                                "table2": table2,
                                "join_type": "INNER JOIN",
                                "condition": f"{rel.source_table}.{rel.source_columns[0]} = {rel.target_table}.{rel.target_columns[0]}",
                                "relationship_type": rel.relationship_type.value
                            }
                            join_suggestions.append(join_suggestion)
            
            return {
                "tables": tables,
                "join_suggestions": join_suggestions,
                "suggestion_count": len(join_suggestions)
            }
            
        except Exception as e:
            self.logger.error(f"Error suggesting joins: {str(e)}")
            return {"error": str(e)}
    
    async def _get_schema_summary(self) -> Dict[str, Any]:
        """Get a summary of the current schema."""
        try:
            if not self.schema_cache:
                await self._analyze_schema()
            
            table_summary = []
            for table_info in self.schema_cache.values():
                summary = {
                    "name": table_info.name,
                    "column_count": len(table_info.columns),
                    "row_count": table_info.row_count,
                    "has_primary_key": bool(table_info.primary_keys),
                    "foreign_key_count": len(table_info.foreign_keys)
                }
                table_summary.append(summary)
            
            return {
                "total_tables": len(self.schema_cache),
                "total_relationships": len(self.relationships_cache),
                "tables": table_summary,
                "last_updated": self.last_schema_update
            }
            
        except Exception as e:
            self.logger.error(f"Error getting schema summary: {str(e)}")
            return {"error": str(e)}
    
    def _table_info_to_dict(self, table_info: TableInfo) -> Dict[str, Any]:
        """Convert TableInfo to dictionary."""
        return {
            "name": table_info.name,
            "schema": table_info.schema,
            "columns": table_info.columns,
            "primary_keys": table_info.primary_keys,
            "foreign_keys": table_info.foreign_keys,
            "indexes": table_info.indexes,
            "constraints": table_info.constraints,
            "row_count": table_info.row_count,
            "description": table_info.description
        }
    
    def _relationship_to_dict(self, relationship: Relationship) -> Dict[str, Any]:
        """Convert Relationship to dictionary."""
        return {
            "source_table": relationship.source_table,
            "target_table": relationship.target_table,
            "source_columns": relationship.source_columns,
            "target_columns": relationship.target_columns,
            "relationship_type": relationship.relationship_type.value,
            "constraint_name": relationship.constraint_name
        } 