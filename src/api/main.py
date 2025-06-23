"""
FastAPI application for the Multi-Agent Text-to-SQL system.
Provides REST API endpoints to interact with the multi-agent system.
"""

from fastapi import FastAPI, HTTPException, Depends, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import Dict, List, Optional, Any
import asyncio
from datetime import datetime

from ..core.config import settings
from ..core.logging import logger
from ..core.agent_coordinator import agent_coordinator
from ..database.connection import init_database, close_database, get_db
from ..database.connection import AsyncSession


# Pydantic models for API requests/responses
class TextToSQLRequest(BaseModel):
    """Request model for text-to-SQL conversion."""
    query: str
    schema_name: Optional[str] = None
    database_name: Optional[str] = None
    include_explanation: bool = True
    optimize_query: bool = True


class TextToSQLResponse(BaseModel):
    """Response model for text-to-SQL conversion."""
    sql_query: str
    explanation: Optional[str] = None
    confidence_score: float
    execution_time: float
    workflow_id: str
    tables_used: List[str]
    optimized: bool


class SchemaAnalysisRequest(BaseModel):
    """Request model for schema analysis."""
    schema_name: Optional[str] = None
    include_relationships: bool = True
    include_sample_data: bool = False


class SchemaAnalysisResponse(BaseModel):
    """Response model for schema analysis."""
    schema_name: Optional[str]
    tables: List[Dict[str, Any]]
    relationships: List[Dict[str, Any]]
    table_count: int
    relationship_count: int
    analysis_timestamp: str


class WorkflowStatusResponse(BaseModel):
    """Response model for workflow status."""
    workflow_id: str
    status: str
    steps_completed: List[str]
    steps_failed: List[str]
    results: Dict[str, Any]
    error_message: Optional[str] = None
    execution_time: Optional[float] = None


class SystemStatusResponse(BaseModel):
    """Response model for system status."""
    coordinator_running: bool
    total_agents: int
    healthy_agents: int
    active_workflows: int
    completed_workflows: int
    failed_workflows: int
    agent_health: Dict[str, Any]
    message_broker_status: Dict[str, Any]


# Create FastAPI application
app = FastAPI(
    title="Multi-Agent Text-to-SQL System",
    description="AI-powered system for converting natural language to PostgreSQL queries using multiple specialized agents",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def startup_event():
    """Initialize the system on startup."""
    try:
        logger.info("Starting Multi-Agent Text-to-SQL System...")
        
        # Initialize database
        await init_database()
        logger.info("Database initialized")
        
        # Start agent coordinator
        await agent_coordinator.start()
        logger.info("Agent coordinator started")
        
        logger.info("System startup completed successfully")
        
    except Exception as e:
        logger.error(f"Error during startup: {str(e)}")
        raise


@app.on_event("shutdown")
async def shutdown_event():
    """Clean up resources on shutdown."""
    try:
        logger.info("Shutting down Multi-Agent Text-to-SQL System...")
        
        # Stop agent coordinator
        await agent_coordinator.stop()
        logger.info("Agent coordinator stopped")
        
        # Close database connections
        await close_database()
        logger.info("Database connections closed")
        
        logger.info("System shutdown completed")
        
    except Exception as e:
        logger.error(f"Error during shutdown: {str(e)}")


@app.get("/", response_model=Dict[str, str])
async def root():
    """Root endpoint with system information."""
    return {
        "name": "Multi-Agent Text-to-SQL System",
        "version": "1.0.0",
        "description": "AI-powered system for converting natural language to PostgreSQL queries",
        "status": "running",
        "timestamp": datetime.now().isoformat()
    }


@app.post("/api/v1/text-to-sql", response_model=TextToSQLResponse)
async def convert_text_to_sql(
    request: TextToSQLRequest,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db)
):
    """
    Convert natural language text to SQL query.
    
    This endpoint orchestrates the entire text-to-SQL pipeline:
    1. Schema analysis
    2. Query understanding
    3. SQL generation
    4. Validation and optimization
    5. Explanation generation
    """
    try:
        logger.info(f"Processing text-to-SQL request: {request.query}")
        
        # Prepare workflow input
        workflow_input = {
            "query": request.query,
            "schema_name": request.schema_name,
            "include_explanation": request.include_explanation,
            "optimize_query": request.optimize_query
        }
        
        # Execute text-to-SQL workflow
        workflow_id = await agent_coordinator.execute_workflow(
            workflow_type="text_to_sql",
            input_data=workflow_input
        )
        
        # Wait for workflow completion (with timeout)
        max_wait_time = 60  # 60 seconds timeout
        wait_interval = 1  # Check every second
        elapsed_time = 0
        
        while elapsed_time < max_wait_time:
            workflow_result = await agent_coordinator.get_workflow_status(workflow_id)
            
            if workflow_result and workflow_result.status.value in ["completed", "failed"]:
                break
            
            await asyncio.sleep(wait_interval)
            elapsed_time += wait_interval
        
        # Get final result
        workflow_result = await agent_coordinator.get_workflow_status(workflow_id)
        
        if not workflow_result:
            raise HTTPException(status_code=500, detail="Workflow not found")
        
        if workflow_result.status.value == "failed":
            raise HTTPException(
                status_code=500, 
                detail=f"Workflow failed: {workflow_result.error_message}"
            )
        
        if workflow_result.status.value != "completed":
            raise HTTPException(status_code=408, detail="Workflow timeout")
        
        # Extract results (this is simplified - in reality you'd parse the actual results)
        response = TextToSQLResponse(
            sql_query="SELECT * FROM example_table WHERE condition = 'value'",  # Placeholder
            explanation="This query retrieves all records from example_table where condition equals 'value'",
            confidence_score=0.95,
            execution_time=workflow_result.execution_time or 0.0,
            workflow_id=workflow_id,
            tables_used=["example_table"],
            optimized=request.optimize_query
        )
        
        logger.info(f"Successfully processed text-to-SQL request in {response.execution_time:.2f}s")
        return response
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error processing text-to-SQL request: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/v1/analyze-schema", response_model=SchemaAnalysisResponse)
async def analyze_schema(
    request: SchemaAnalysisRequest,
    db: AsyncSession = Depends(get_db)
):
    """
    Analyze database schema structure.
    
    Returns detailed information about tables, columns, relationships,
    and other schema metadata.
    """
    try:
        logger.info(f"Processing schema analysis request for: {request.schema_name or 'default schema'}")
        
        # Prepare workflow input
        workflow_input = {
            "schema_name": request.schema_name,
            "include_relationships": request.include_relationships,
            "include_sample_data": request.include_sample_data
        }
        
        # Execute schema analysis workflow
        workflow_id = await agent_coordinator.execute_workflow(
            workflow_type="schema_analysis",
            input_data=workflow_input
        )
        
        # Wait for completion
        max_wait_time = 30
        wait_interval = 1
        elapsed_time = 0
        
        while elapsed_time < max_wait_time:
            workflow_result = await agent_coordinator.get_workflow_status(workflow_id)
            
            if workflow_result and workflow_result.status.value in ["completed", "failed"]:
                break
            
            await asyncio.sleep(wait_interval)
            elapsed_time += wait_interval
        
        workflow_result = await agent_coordinator.get_workflow_status(workflow_id)
        
        if not workflow_result or workflow_result.status.value != "completed":
            raise HTTPException(status_code=500, detail="Schema analysis failed")
        
        # Extract schema analysis results (simplified)
        response = SchemaAnalysisResponse(
            schema_name=request.schema_name,
            tables=[],  # Would contain actual table information
            relationships=[],  # Would contain actual relationships
            table_count=0,
            relationship_count=0,
            analysis_timestamp=datetime.now().isoformat()
        )
        
        logger.info("Schema analysis completed successfully")
        return response
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error analyzing schema: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/v1/workflow/{workflow_id}", response_model=WorkflowStatusResponse)
async def get_workflow_status(workflow_id: str):
    """Get the status of a specific workflow."""
    try:
        workflow_result = await agent_coordinator.get_workflow_status(workflow_id)
        
        if not workflow_result:
            raise HTTPException(status_code=404, detail="Workflow not found")
        
        response = WorkflowStatusResponse(
            workflow_id=workflow_result.workflow_id,
            status=workflow_result.status.value,
            steps_completed=workflow_result.steps_completed,
            steps_failed=workflow_result.steps_failed,
            results=workflow_result.results,
            error_message=workflow_result.error_message,
            execution_time=workflow_result.execution_time
        )
        
        return response
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting workflow status: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


@app.delete("/api/v1/workflow/{workflow_id}")
async def cancel_workflow(workflow_id: str):
    """Cancel a running workflow."""
    try:
        success = await agent_coordinator.cancel_workflow(workflow_id)
        
        if not success:
            raise HTTPException(status_code=404, detail="Workflow not found or not running")
        
        return {"message": f"Workflow {workflow_id} cancelled successfully"}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error cancelling workflow: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/v1/system/status", response_model=SystemStatusResponse)
async def get_system_status():
    """Get overall system status and health information."""
    try:
        status = agent_coordinator.get_system_status()
        
        response = SystemStatusResponse(
            coordinator_running=status["coordinator_running"],
            total_agents=status["total_agents"],
            healthy_agents=status["healthy_agents"],
            active_workflows=status["active_workflows"],
            completed_workflows=status["completed_workflows"],
            failed_workflows=status["failed_workflows"],
            agent_health=status["agent_health"],
            message_broker_status=status["message_broker_status"]
        )
        
        return response
        
    except Exception as e:
        logger.error(f"Error getting system status: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/v1/system/health")
async def health_check():
    """Simple health check endpoint."""
    try:
        # Basic health checks
        system_status = agent_coordinator.get_system_status()
        
        is_healthy = (
            system_status["coordinator_running"] and
            system_status["healthy_agents"] > 0
        )
        
        if is_healthy:
            return {
                "status": "healthy",
                "timestamp": datetime.now().isoformat(),
                "agents": system_status["healthy_agents"],
                "workflows": system_status["active_workflows"]
            }
        else:
            return JSONResponse(
                status_code=503,
                content={
                    "status": "unhealthy",
                    "timestamp": datetime.now().isoformat(),
                    "details": system_status
                }
            )
            
    except Exception as e:
        logger.error(f"Health check failed: {str(e)}")
        return JSONResponse(
            status_code=503,
            content={
                "status": "unhealthy",
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }
        )


@app.get("/api/v1/agents")
async def list_agents():
    """List all available agents and their capabilities."""
    try:
        system_status = agent_coordinator.get_system_status()
        
        agents_info = []
        for agent_name, agent in agent_coordinator.agents.items():
            agent_status = agent.get_status()
            health = system_status["agent_health"].get(agent_name, {})
            
            agent_info = {
                "name": agent_name,
                "description": agent.description,
                "status": agent_status["status"],
                "capabilities": agent_status["capabilities"],
                "health": health,
                "metrics": agent_status["metrics"]
            }
            agents_info.append(agent_info)
        
        return {
            "agents": agents_info,
            "total_count": len(agents_info),
            "healthy_count": system_status["healthy_agents"]
        }
        
    except Exception as e:
        logger.error(f"Error listing agents: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


# Error handlers
@app.exception_handler(Exception)
async def general_exception_handler(request, exc):
    """General exception handler."""
    logger.error(f"Unhandled exception: {str(exc)}")
    return JSONResponse(
        status_code=500,
        content={
            "error": "Internal server error",
            "detail": str(exc) if settings.debug else "An unexpected error occurred"
        }
    )


if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run(
        "src.api.main:app",
        host=settings.api_host,
        port=settings.api_port,
        reload=settings.api_reload,
        log_level=settings.log_level.lower()
    ) 