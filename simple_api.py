#!/usr/bin/env python3
"""
Simple API server for Multi-Agent Text-to-SQL System
This version runs without database dependencies for initial testing.
"""

import os
import sys
from pathlib import Path
from datetime import datetime
from typing import Dict, Any

# Add project root to path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

# Set environment variables
os.environ['OPENAI_API_KEY'] = 'test_key'
os.environ['ANTHROPIC_API_KEY'] = 'test_key'
os.environ['DATABASE_URL'] = 'postgresql://test@localhost:5432/test_db'
os.environ['DEBUG'] = 'True'
os.environ['LOG_LEVEL'] = 'INFO'

from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import uvicorn

# Create FastAPI app
app = FastAPI(
    title="Multi-Agent Text-to-SQL System",
    description="A simple version for testing basic functionality",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Request/Response models
class TextToSQLRequest(BaseModel):
    query: str
    schema_context: str = ""

class TextToSQLResponse(BaseModel):
    sql_query: str
    explanation: str
    confidence: float

class HealthResponse(BaseModel):
    status: str
    timestamp: str
    version: str
    components: Dict[str, bool]

# Routes
@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Multi-Agent Text-to-SQL System",
        "version": "1.0.0",
        "status": "running",
        "docs": "/docs"
    }

@app.get("/api/v1/system/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    return HealthResponse(
        status="healthy",
        timestamp=datetime.now().isoformat(),
        version="1.0.0",
        components={
            "api": True,
            "agents": True,
            "message_broker": True
        }
    )

@app.get("/api/v1/system/status")
async def system_status():
    """System status endpoint"""
    return {
        "system": "Multi-Agent Text-to-SQL",
        "status": "running",
        "active_agents": 1,
        "total_workflows": 0,
        "active_workflows": 0,
        "uptime": "test_mode"
    }

@app.post("/api/v1/text-to-sql", response_model=TextToSQLResponse)
async def text_to_sql(request: TextToSQLRequest):
    """Convert natural language to SQL (mock response)"""
    
    # Mock SQL generation logic
    mock_sql = f"SELECT * FROM users WHERE name LIKE '%{request.query}%'"
    
    return TextToSQLResponse(
        sql_query=mock_sql,
        explanation=f"This query searches for records matching: {request.query}",
        confidence=0.85
    )

@app.get("/api/v1/analyze-schema")
async def analyze_schema():
    """Analyze database schema (mock response)"""
    return {
        "tables": [
            {
                "name": "users",
                "columns": ["id", "username", "email", "created_at"],
                "row_count": 150
            },
            {
                "name": "products", 
                "columns": ["id", "name", "price", "category_id"],
                "row_count": 89
            }
        ],
        "relationships": [
            {
                "from_table": "orders",
                "to_table": "users",
                "relationship_type": "many_to_one"
            }
        ]
    }

@app.get("/api/v1/agents")
async def list_agents():
    """List available agents"""
    return {
        "agents": [
            {
                "id": "schema-agent-001",
                "type": "SchemaAgent",
                "status": "active",
                "capabilities": ["schema_analysis", "table_info", "query_validation"]
            }
        ]
    }

# Error handlers
@app.exception_handler(Exception)
async def general_exception_handler(request, exc):
    return JSONResponse(
        status_code=500,
        content={"detail": f"Internal server error: {str(exc)}"}
    )

if __name__ == "__main__":
    print("🚀 Starting Simple Multi-Agent Text-to-SQL API Server")
    print("📖 API Documentation: http://localhost:8000/docs")
    print("🔍 Health Check: http://localhost:8000/api/v1/system/health")
    
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8000,
        reload=False,
        log_level="info"
    ) 