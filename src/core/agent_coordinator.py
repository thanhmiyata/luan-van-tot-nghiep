"""
Agent Coordinator for the Multi-Agent Text-to-SQL system.
Manages and orchestrates the interaction between different agents.
"""

import asyncio
from typing import Dict, List, Optional, Any, Callable
from dataclasses import dataclass
from enum import Enum
import uuid
from datetime import datetime

from ..agents.base_agent import BaseAgent, Message, MessageType
from ..agents.schema_agent import SchemaAgent
from .message_broker import message_broker, MessageBroker
from .logging import logger
from .config import settings


class WorkflowStatus(Enum):
    """Status of a workflow execution."""
    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"
    CANCELLED = "cancelled"


@dataclass
class WorkflowStep:
    """Represents a step in a workflow."""
    step_id: str
    agent_name: str
    action: str
    input_data: Dict[str, Any]
    depends_on: List[str] = None
    timeout: int = 30
    retry_count: int = 0
    max_retries: int = 3


@dataclass
class WorkflowResult:
    """Result of a workflow execution."""
    workflow_id: str
    status: WorkflowStatus
    steps_completed: List[str]
    steps_failed: List[str]
    results: Dict[str, Any]
    error_message: Optional[str] = None
    execution_time: Optional[float] = None


class AgentCoordinator:
    """
    Coordinates the Multi-Agent system for Text-to-SQL conversion.
    
    Responsibilities:
    - Managing agent lifecycle
    - Orchestrating workflows between agents
    - Handling complex multi-step operations
    - Monitoring agent health and performance
    - Load balancing and resource management
    """
    
    def __init__(self):
        self.agents: Dict[str, BaseAgent] = {}
        self.workflows: Dict[str, WorkflowResult] = {}
        self.message_broker: MessageBroker = message_broker
        self.running_workflows: Dict[str, asyncio.Task] = {}
        self.agent_health: Dict[str, Dict[str, Any]] = {}
        self._running = False
        
        # Workflow templates
        self.workflow_templates = {
            "text_to_sql": self._get_text_to_sql_workflow,
            "schema_analysis": self._get_schema_analysis_workflow,
            "query_optimization": self._get_query_optimization_workflow,
            "query_explanation": self._get_query_explanation_workflow
        }
    
    async def start(self) -> None:
        """Start the agent coordinator."""
        if self._running:
            return
        
        self._running = True
        
        # Start message broker
        await self.message_broker.start()
        
        # Initialize and register agents
        await self._initialize_agents()
        
        # Start monitoring task
        asyncio.create_task(self._monitor_agents())
        
        logger.info("Agent Coordinator started successfully")
    
    async def stop(self) -> None:
        """Stop the agent coordinator."""
        self._running = False
        
        # Cancel running workflows
        for workflow_id, task in self.running_workflows.items():
            task.cancel()
        
        # Stop all agents
        for agent in self.agents.values():
            # TODO: Add proper agent shutdown if needed
            pass
        
        # Stop message broker
        await self.message_broker.stop()
        
        logger.info("Agent Coordinator stopped")
    
    async def _initialize_agents(self) -> None:
        """Initialize and register all agents."""
        try:
            # Initialize Schema Agent
            schema_agent = SchemaAgent()
            await self._register_agent(schema_agent)
            
            # TODO: Initialize other agents as they are implemented:
            # - Query Planner Agent
            # - SQL Generator Agent
            # - Validator Agent
            # - Optimizer Agent
            # - Explainer Agent
            
            logger.info(f"Initialized {len(self.agents)} agents")
            
        except Exception as e:
            logger.error(f"Error initializing agents: {str(e)}")
            raise
    
    async def _register_agent(self, agent: BaseAgent) -> None:
        """Register an agent with the coordinator."""
        self.agents[agent.name] = agent
        self.message_broker.register_agent(agent)
        
        # Initialize health tracking
        self.agent_health[agent.name] = {
            "status": "healthy",
            "last_health_check": datetime.now(),
            "message_count": 0,
            "error_count": 0,
            "average_response_time": 0.0
        }
        
        # Start agent
        asyncio.create_task(agent.start())
        
        logger.info(f"Agent {agent.name} registered and started")
    
    async def execute_workflow(self, workflow_type: str, input_data: Dict[str, Any]) -> str:
        """
        Execute a predefined workflow.
        
        Args:
            workflow_type: Type of workflow to execute
            input_data: Input data for the workflow
            
        Returns:
            str: Workflow ID for tracking
        """
        workflow_id = str(uuid.uuid4())
        
        try:
            # Get workflow template
            if workflow_type not in self.workflow_templates:
                raise ValueError(f"Unknown workflow type: {workflow_type}")
            
            workflow_steps = self.workflow_templates[workflow_type](input_data)
            
            # Create workflow result tracker
            workflow_result = WorkflowResult(
                workflow_id=workflow_id,
                status=WorkflowStatus.PENDING,
                steps_completed=[],
                steps_failed=[],
                results={}
            )
            self.workflows[workflow_id] = workflow_result
            
            # Start workflow execution
            task = asyncio.create_task(
                self._execute_workflow_steps(workflow_id, workflow_steps)
            )
            self.running_workflows[workflow_id] = task
            
            logger.info(f"Started workflow {workflow_type} with ID: {workflow_id}")
            return workflow_id
            
        except Exception as e:
            logger.error(f"Error starting workflow {workflow_type}: {str(e)}")
            raise
    
    async def _execute_workflow_steps(self, workflow_id: str, steps: List[WorkflowStep]) -> None:
        """Execute workflow steps in the correct order."""
        start_time = datetime.now()
        workflow_result = self.workflows[workflow_id]
        workflow_result.status = WorkflowStatus.RUNNING
        
        try:
            # Build dependency graph
            remaining_steps = {step.step_id: step for step in steps}
            completed_steps = set()
            
            while remaining_steps:
                # Find steps that can be executed (all dependencies completed)
                ready_steps = []
                for step in remaining_steps.values():
                    if not step.depends_on or all(dep in completed_steps for dep in step.depends_on):
                        ready_steps.append(step)
                
                if not ready_steps:
                    raise RuntimeError("Circular dependency detected in workflow")
                
                # Execute ready steps in parallel
                tasks = []
                for step in ready_steps:
                    task = asyncio.create_task(
                        self._execute_workflow_step(workflow_id, step)
                    )
                    tasks.append((step.step_id, task))
                
                # Wait for all tasks to complete
                for step_id, task in tasks:
                    try:
                        result = await task
                        workflow_result.results[step_id] = result
                        workflow_result.steps_completed.append(step_id)
                        completed_steps.add(step_id)
                        del remaining_steps[step_id]
                        
                    except Exception as e:
                        workflow_result.steps_failed.append(step_id)
                        logger.error(f"Step {step_id} failed: {str(e)}")
                        
                        # Check if this is a critical step
                        step = remaining_steps.get(step_id)
                        if step and step.retry_count < step.max_retries:
                            step.retry_count += 1
                            logger.info(f"Retrying step {step_id} ({step.retry_count}/{step.max_retries})")
                        else:
                            raise
            
            # Workflow completed successfully
            workflow_result.status = WorkflowStatus.COMPLETED
            execution_time = (datetime.now() - start_time).total_seconds()
            workflow_result.execution_time = execution_time
            
            logger.info(f"Workflow {workflow_id} completed successfully in {execution_time:.2f}s")
            
        except Exception as e:
            workflow_result.status = WorkflowStatus.FAILED
            workflow_result.error_message = str(e)
            execution_time = (datetime.now() - start_time).total_seconds()
            workflow_result.execution_time = execution_time
            
            logger.error(f"Workflow {workflow_id} failed after {execution_time:.2f}s: {str(e)}")
        
        finally:
            # Clean up
            if workflow_id in self.running_workflows:
                del self.running_workflows[workflow_id]
    
    async def _execute_workflow_step(self, workflow_id: str, step: WorkflowStep) -> Any:
        """Execute a single workflow step."""
        try:
            # Get the target agent
            agent = self.agents.get(step.agent_name)
            if not agent:
                raise ValueError(f"Agent {step.agent_name} not found")
            
            # Create message for the agent
            message = Message(
                id=str(uuid.uuid4()),
                sender="AgentCoordinator",
                receiver=step.agent_name,
                message_type=MessageType.REQUEST,
                content={
                    "action": step.action,
                    "workflow_id": workflow_id,
                    "step_id": step.step_id,
                    **step.input_data
                },
                timestamp=datetime.now(),
                correlation_id=workflow_id
            )
            
            # Send message through broker
            success = await self.message_broker.send_message(message)
            if not success:
                raise RuntimeError(f"Failed to send message to {step.agent_name}")
            
            # Wait for response (simplified - in reality, you'd use proper message correlation)
            # TODO: Implement proper response waiting mechanism
            await asyncio.sleep(0.1)  # Placeholder
            
            return {"step_id": step.step_id, "status": "completed"}
            
        except Exception as e:
            logger.error(f"Error executing step {step.step_id}: {str(e)}")
            raise
    
    def _get_text_to_sql_workflow(self, input_data: Dict[str, Any]) -> List[WorkflowStep]:
        """Get workflow steps for text-to-SQL conversion."""
        natural_language_query = input_data.get("query", "")
        
        return [
            WorkflowStep(
                step_id="analyze_schema",
                agent_name="SchemaAgent",
                action="analyze_schema",
                input_data={"schema_name": input_data.get("schema_name")}
            ),
            WorkflowStep(
                step_id="understand_query",
                agent_name="QueryPlannerAgent",  # To be implemented
                action="understand_query",
                input_data={"query": natural_language_query},
                depends_on=["analyze_schema"]
            ),
            WorkflowStep(
                step_id="generate_sql",
                agent_name="SQLGeneratorAgent",  # To be implemented
                action="generate_sql",
                input_data={"query": natural_language_query},
                depends_on=["understand_query"]
            ),
            WorkflowStep(
                step_id="validate_sql",
                agent_name="ValidatorAgent",  # To be implemented
                action="validate_sql",
                input_data={},
                depends_on=["generate_sql"]
            ),
            WorkflowStep(
                step_id="optimize_sql",
                agent_name="OptimizerAgent",  # To be implemented
                action="optimize_sql",
                input_data={},
                depends_on=["validate_sql"]
            ),
            WorkflowStep(
                step_id="explain_query",
                agent_name="ExplainerAgent",  # To be implemented
                action="explain_query",
                input_data={},
                depends_on=["optimize_sql"]
            )
        ]
    
    def _get_schema_analysis_workflow(self, input_data: Dict[str, Any]) -> List[WorkflowStep]:
        """Get workflow steps for schema analysis."""
        return [
            WorkflowStep(
                step_id="analyze_schema",
                agent_name="SchemaAgent",
                action="analyze_schema",
                input_data={"schema_name": input_data.get("schema_name")}
            ),
            WorkflowStep(
                step_id="get_schema_summary",
                agent_name="SchemaAgent",
                action="get_schema_summary",
                input_data={},
                depends_on=["analyze_schema"]
            )
        ]
    
    def _get_query_optimization_workflow(self, input_data: Dict[str, Any]) -> List[WorkflowStep]:
        """Get workflow steps for query optimization."""
        return [
            WorkflowStep(
                step_id="validate_query",
                agent_name="SchemaAgent",
                action="validate_query",
                input_data={"query": input_data.get("query")}
            ),
            WorkflowStep(
                step_id="optimize_query",
                agent_name="OptimizerAgent",  # To be implemented
                action="optimize_query",
                input_data={"query": input_data.get("query")},
                depends_on=["validate_query"]
            )
        ]
    
    def _get_query_explanation_workflow(self, input_data: Dict[str, Any]) -> List[WorkflowStep]:
        """Get workflow steps for query explanation."""
        return [
            WorkflowStep(
                step_id="analyze_query_structure",
                agent_name="SchemaAgent",
                action="validate_query",
                input_data={"query": input_data.get("query")}
            ),
            WorkflowStep(
                step_id="explain_query",
                agent_name="ExplainerAgent",  # To be implemented
                action="explain_query",
                input_data={"query": input_data.get("query")},
                depends_on=["analyze_query_structure"]
            )
        ]
    
    async def get_workflow_status(self, workflow_id: str) -> Optional[WorkflowResult]:
        """Get the status of a workflow."""
        return self.workflows.get(workflow_id)
    
    async def cancel_workflow(self, workflow_id: str) -> bool:
        """Cancel a running workflow."""
        if workflow_id in self.running_workflows:
            task = self.running_workflows[workflow_id]
            task.cancel()
            
            workflow = self.workflows.get(workflow_id)
            if workflow:
                workflow.status = WorkflowStatus.CANCELLED
            
            return True
        return False
    
    async def _monitor_agents(self) -> None:
        """Background task to monitor agent health."""
        while self._running:
            try:
                for agent_name, agent in self.agents.items():
                    health_info = self.agent_health[agent_name]
                    
                    # Perform health check
                    is_healthy = await agent.health_check()
                    health_info["status"] = "healthy" if is_healthy else "unhealthy"
                    health_info["last_health_check"] = datetime.now()
                    
                    # Update metrics
                    agent_status = agent.get_status()
                    health_info["message_count"] = agent_status["metrics"]["messages_processed"]
                    health_info["error_count"] = agent_status["metrics"]["errors_count"]
                    health_info["average_response_time"] = agent_status["metrics"]["average_processing_time"]
                
                await asyncio.sleep(30)  # Check every 30 seconds
                
            except Exception as e:
                logger.error(f"Error in agent monitoring: {str(e)}")
                await asyncio.sleep(30)
    
    def get_system_status(self) -> Dict[str, Any]:
        """Get overall system status."""
        return {
            "coordinator_running": self._running,
            "total_agents": len(self.agents),
            "healthy_agents": sum(1 for health in self.agent_health.values() if health["status"] == "healthy"),
            "active_workflows": len(self.running_workflows),
            "completed_workflows": len([w for w in self.workflows.values() if w.status == WorkflowStatus.COMPLETED]),
            "failed_workflows": len([w for w in self.workflows.values() if w.status == WorkflowStatus.FAILED]),
            "agent_health": self.agent_health,
            "message_broker_status": self.message_broker.get_status()
        }


# Global coordinator instance
agent_coordinator = AgentCoordinator() 