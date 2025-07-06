"""
Multi-Agent Coordinator
Điều phối 6 agents trong pipeline Text-to-SQL
Pipeline: Query Refinement → Schema Recognition → Query Planning → SQL Generation → Validation → Response Generation
"""
import asyncio
import json
import logging
from datetime import datetime
from typing import Dict, Any, List, Optional
import psycopg2
from psycopg2.extras import RealDictCursor

from .config import config, PERFORMANCE_TARGETS
from .agents import (
    QueryRefinementAgent, SchemaRecognitionAgent, QueryPlanningAgent,
    SqlGeneratorAgent, ValidationAgent, ResponseGenerationAgent
)


class MultiAgentCoordinator:
    """
    Coordinator điều phối 6 agents theo pipeline
    Target: 90%+ accuracy (theo paper thầy: 91.95%)
    """

    def __init__(self):
        self.logger = logging.getLogger("MultiAgentCoordinator")

        # Initialize all 6 agents
        self.agents = {
            "query_refinement": QueryRefinementAgent(),
            "schema_recognition": SchemaRecognitionAgent(),
            "query_planning": QueryPlanningAgent(),
            "sql_generator": SqlGeneratorAgent(),
            "validation": ValidationAgent(),
            "response_generation": ResponseGenerationAgent()
        }

        # Coordination state
        self.pipeline_state = {}
        self.performance_metrics = {
            "total_queries": 0,
            "successful_queries": 0,
            "failed_queries": 0,
            "average_response_time": 0.0,
            "agent_performance": {}
        }

        self.logger.info("Multi-Agent Coordinator initialized with 6 agents")

    async def process_query(self, user_query: str, user_context: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Main method - process user query through 6-agent pipeline
        """
        start_time = datetime.now()

        try:
            self.logger.info(f"Processing query: {user_query[:50]}...")

            # Initialize pipeline state
            pipeline_data = {
                "original_query": user_query,
                "user_context": user_context or {},
                "pipeline_start_time": start_time,
                "agent_results": {}
            }

            # Step 1: Query Refinement Agent
            refinement_result = await self.agents["query_refinement"].process({
                "query": user_query,
                "context": user_context or {}
            })

            if not refinement_result.success:
                return self._create_error_response("Query refinement failed", refinement_result.error_message)

            pipeline_data["agent_results"]["query_refinement"] = refinement_result.data
            refined_query = refinement_result.data.get(
                "refined_query", user_query)
            language = refinement_result.data.get("language", "vi")

            # Step 2: Schema Recognition Agent
            schema_result = await self.agents["schema_recognition"].process({
                "refined_query": refined_query,
                "language": language
            })

            if not schema_result.success:
                return self._create_error_response("Schema recognition failed", schema_result.error_message)

            pipeline_data["agent_results"]["schema_recognition"] = schema_result.data

            # Step 3: Query Planning Agent
            planning_result = await self.agents["query_planning"].process({
                "refined_query": refined_query,
                "schema_recognition": schema_result.data,
                "language": language
            })

            if not planning_result.success:
                return self._create_error_response("Query planning failed", planning_result.error_message)

            pipeline_data["agent_results"]["query_planning"] = planning_result.data

            # Step 4: SQL Generator Agent
            sql_result = await self.agents["sql_generator"].process({
                "refined_query": refined_query,
                "query_plan": planning_result.data,
                "schema_recognition": schema_result.data
            })

            if not sql_result.success:
                return self._create_error_response("SQL generation failed", sql_result.error_message)

            pipeline_data["agent_results"]["sql_generator"] = sql_result.data
            sql_query = sql_result.data.get("sql_query", "")

            # Step 5: Validation Agent
            validation_result = await self.agents["validation"].process({
                "sql_query": sql_query,
                "schema_recognition": schema_result.data
            })

            if not validation_result.success:
                return self._create_error_response("SQL validation failed", validation_result.error_message)

            pipeline_data["agent_results"]["validation"] = validation_result.data

            # Execute SQL if valid
            sql_execution_result = None
            if validation_result.data.get("is_valid", False):
                try:
                    sql_execution_result = await self._execute_sql(sql_query)
                except Exception as e:
                    self.logger.error(f"SQL execution failed: {str(e)}")
                    sql_execution_result = {"error": str(e)}

            # Step 6: Response Generation Agent
            response_result = await self.agents["response_generation"].process({
                "refined_query": refined_query,
                "sql_query": sql_query,
                "sql_results": sql_execution_result,
                "validation_result": validation_result.data,
                "language": language,
                "total_processing_time": (datetime.now() - start_time).total_seconds()
            })

            if not response_result.success:
                return self._create_error_response("Response generation failed", response_result.error_message)

            pipeline_data["agent_results"]["response_generation"] = response_result.data

            # Compile final result
            total_time = (datetime.now() - start_time).total_seconds()

            final_result = {
                "success": True,
                "user_query": user_query,
                "refined_query": refined_query,
                "language": language,
                "sql_query": sql_query,
                "sql_results": sql_execution_result,
                "response": response_result.data,
                "pipeline_performance": {
                    "total_time": total_time,
                    "agent_times": {
                        agent: result.processing_time
                        for agent, result in {
                            "query_refinement": refinement_result,
                            "schema_recognition": schema_result,
                            "query_planning": planning_result,
                            "sql_generator": sql_result,
                            "validation": validation_result,
                            "response_generation": response_result
                        }.items()
                    },
                    "meets_target": total_time < PERFORMANCE_TARGETS["response_time"]
                },
                "agent_results": pipeline_data["agent_results"]
            }

            # Update performance metrics
            self._update_performance_metrics(final_result)

            return final_result

        except Exception as e:
            self.logger.error(f"Pipeline failed: {str(e)}")
            return self._create_error_response("Pipeline execution failed", str(e))

    async def _execute_sql(self, sql_query: str) -> Any:
        """Execute SQL query on database"""
        try:
            conn = psycopg2.connect(config.DATABASE_URL)
            cursor = conn.cursor(cursor_factory=RealDictCursor)

            # Execute query
            cursor.execute(sql_query)

            # Fetch results
            if sql_query.strip().upper().startswith("SELECT"):
                results = cursor.fetchall()
                # Convert to list of dicts for JSON serialization
                return [dict(row) for row in results]
            else:
                return {"affected_rows": cursor.rowcount}

        except Exception as e:
            self.logger.error(f"SQL execution error: {str(e)}")
            raise
        finally:
            if 'conn' in locals():
                conn.close()

    def _create_error_response(self, error_type: str, error_message: str) -> Dict[str, Any]:
        """Create standardized error response"""
        return {
            "success": False,
            "error_type": error_type,
            "error_message": error_message,
            "timestamp": datetime.now().isoformat()
        }

    def _update_performance_metrics(self, result: Dict[str, Any]):
        """Update coordinator performance metrics"""
        self.performance_metrics["total_queries"] += 1

        if result["success"]:
            self.performance_metrics["successful_queries"] += 1
        else:
            self.performance_metrics["failed_queries"] += 1

        # Update average response time
        total_time = result.get("pipeline_performance",
                                {}).get("total_time", 0)
        total_queries = self.performance_metrics["total_queries"]
        current_avg = self.performance_metrics["average_response_time"]

        self.performance_metrics["average_response_time"] = (
            (current_avg * (total_queries - 1) + total_time) / total_queries
        )

    def get_performance_report(self) -> Dict[str, Any]:
        """Get comprehensive performance report"""

        # Calculate accuracy
        total = self.performance_metrics["total_queries"]
        successful = self.performance_metrics["successful_queries"]
        accuracy = (successful / total) if total > 0 else 0.0

        # Get agent-specific metrics
        agent_metrics = {}
        for agent_name, agent in self.agents.items():
            agent_metrics[agent_name] = agent.get_metrics()

        return {
            "coordinator_metrics": {
                "total_queries": total,
                "successful_queries": successful,
                "failed_queries": self.performance_metrics["failed_queries"],
                "accuracy": accuracy,
                "average_response_time": self.performance_metrics["average_response_time"],
                "meets_accuracy_target": accuracy >= PERFORMANCE_TARGETS["overall_accuracy"],
                "meets_response_time_target": self.performance_metrics["average_response_time"] < PERFORMANCE_TARGETS["response_time"]
            },
            "agent_metrics": agent_metrics,
            "target_comparison": {
                "target_accuracy": PERFORMANCE_TARGETS["overall_accuracy"],
                "actual_accuracy": accuracy,
                "target_response_time": PERFORMANCE_TARGETS["response_time"],
                "actual_response_time": self.performance_metrics["average_response_time"]
            }
        }

    async def health_check(self) -> Dict[str, Any]:
        """Check health of all agents"""
        health_status = {}

        for agent_name, agent in self.agents.items():
            try:
                is_healthy = await agent.health_check()
                health_status[agent_name] = {
                    "healthy": is_healthy,
                    "status": "OK" if is_healthy else "FAILED"
                }
            except Exception as e:
                health_status[agent_name] = {
                    "healthy": False,
                    "status": "ERROR",
                    "error": str(e)
                }

        # Overall health
        all_healthy = all(status["healthy"]
                          for status in health_status.values())

        return {
            "overall_health": "HEALTHY" if all_healthy else "UNHEALTHY",
            "agent_health": health_status,
            "timestamp": datetime.now().isoformat()
        }

    async def batch_process(self, queries: List[str]) -> List[Dict[str, Any]]:
        """Process multiple queries in batch"""
        results = []

        for query in queries:
            result = await self.process_query(query)
            results.append(result)

        return results

    def reset_metrics(self):
        """Reset all performance metrics"""
        self.performance_metrics = {
            "total_queries": 0,
            "successful_queries": 0,
            "failed_queries": 0,
            "average_response_time": 0.0,
            "agent_performance": {}
        }

        # Reset agent metrics
        for agent in self.agents.values():
            agent.reset_metrics()

        self.logger.info("Performance metrics reset")
