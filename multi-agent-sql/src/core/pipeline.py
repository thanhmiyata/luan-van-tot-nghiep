"""
Core pipeline orchestrator for Multi-Agent SQL system
"""

import time
import json
from typing import Dict, List, Tuple, Any, Optional
from loguru import logger

from config.settings import settings, MODEL_TYPES
from src.core.models import (
    ModelType, AgentType, PipelineContext, PipelineResult,
    NLQuestion, DatabaseSchema, QuestionMetrics
)
from src.core.base_agent import BaseAgent, AgentError


class Pipeline:
    """Main pipeline orchestrator that manages the flow between agents"""

    def __init__(self, model_type: ModelType):
        self.model_type = model_type
        self.model_config = MODEL_TYPES[model_type.value]
        self.agents: Dict[AgentType, BaseAgent] = {}
        self.workflow: List[Tuple[AgentType, str]] = []

        # Initialize agents and workflow
        self._setup_workflow()
        self._initialize_agents()

        logger.info(
            f"Initialized {model_type.value} pipeline with {len(self.agents)} agents")

    def _setup_workflow(self):
        """Define the workflow for this model type"""
        if self.model_type == ModelType.THREE_STEP:
            self.workflow = [
                (AgentType.SQL_EXPERT, "generate_sql"),
                (AgentType.SQL_VALIDATOR, "validate_sql")
            ]
        elif self.model_type == ModelType.FOUR_STEP:
            self.workflow = [
                (AgentType.QUESTION_ANALYZER, "analyze_question"),
                (AgentType.SCHEMA_SELECTOR, "filter_schema"),
                (AgentType.SQL_EXPERT, "generate_sql"),
                (AgentType.SQL_VALIDATOR, "validate_sql")
            ]
        elif self.model_type == ModelType.SIX_STEP:
            self.workflow = [
                (AgentType.QUERY_REFINEMENT, "refine_query"),
                (AgentType.ENTITY_RECOGNITION, "recognize_entities"),
                (AgentType.QUESTION_ANALYZER, "analyze_question"),
                (AgentType.SCHEMA_SELECTOR, "filter_schema"),
                (AgentType.SQL_EXPERT, "generate_sql"),
                (AgentType.SQL_VALIDATOR, "validate_sql")
            ]
        else:
            raise ValueError(f"Unsupported model type: {self.model_type}")

    def _initialize_agents(self):
        """Initialize all required agents for this pipeline"""
        from src.core.agent_factory import AgentFactory

        required_agents = set(agent_type for agent_type, _ in self.workflow)

        for agent_type in required_agents:
            try:
                agent = AgentFactory.create_agent(agent_type, self.model_type)
                self.agents[agent_type] = agent
                logger.debug(f"Initialized {agent_type.value} agent")
            except Exception as e:
                logger.error(
                    f"Failed to initialize {agent_type.value} agent: {e}")
                raise

    def process(self, question: NLQuestion, schema: DatabaseSchema) -> PipelineResult:
        """
        Process a question through the complete pipeline

        Args:
            question: Natural language question
            schema: Database schema

        Returns:
            PipelineResult with SQL and metrics
        """
        start_time = time.time()
        api_calls = 0

        # Initialize context
        context = PipelineContext(
            question=question,
            db_schema=schema
        )

        try:
            logger.info(f"Processing question: {question.question[:50]}...")

            # Execute workflow steps
            for i, (agent_type, task_name) in enumerate(self.workflow):
                step_start = time.time()

                logger.debug(
                    f"Step {i+1}/{len(self.workflow)}: {agent_type.value}.{task_name}")

                # Get agent and execute task
                agent = self.agents[agent_type]
                result = agent.execute(context)

                # Update context with results
                self._update_context(context, agent_type, result)

                # Track metrics
                api_calls += 1
                step_time = time.time() - step_start

                logger.debug(f"Step {i+1} completed in {step_time:.2f}s")

            # Calculate total time
            execution_time = time.time() - start_time

            # Create result
            result = PipelineResult(
                question_id=question.question_id or f"q_{int(time.time())}",
                db_id=question.db_id,
                original_question=question.question,
                final_sql=context.final_sql or "",
                explanation=context.explanation or "",
                error=context.error,
                execution_time=execution_time,
                api_calls=api_calls,
                model_type=self.model_type,
                context=context
            )

            logger.info(
                f"Pipeline completed in {execution_time:.2f}s with {api_calls} API calls")
            return result

        except Exception as e:
            execution_time = time.time() - start_time
            error_msg = f"Pipeline failed: {str(e)}"
            logger.error(error_msg)

            # Return error result
            return PipelineResult(
                question_id=question.question_id or f"q_error_{int(time.time())}",
                db_id=question.db_id,
                original_question=question.question,
                final_sql="",
                explanation="",
                error=error_msg,
                execution_time=execution_time,
                api_calls=api_calls,
                model_type=self.model_type,
                context=context
            )

    def _update_context(self, context: PipelineContext, agent_type: AgentType, result: Dict[str, Any]):
        """Update pipeline context with agent results"""
        try:
            if agent_type == AgentType.QUERY_REFINEMENT:
                context.refined_question = result.get(
                    'refined_question', context.question.question)

            elif agent_type == AgentType.ENTITY_RECOGNITION:
                context.entities = result.get('entities')

            elif agent_type == AgentType.QUESTION_ANALYZER:
                context.analysis = result.get('analysis')

            elif agent_type == AgentType.SCHEMA_SELECTOR:
                context.filtered_schema = result.get(
                    'filtered_schema', context.db_schema)

            elif agent_type == AgentType.SQL_EXPERT:
                context.generated_sql = result.get('sql', '')

            elif agent_type == AgentType.SQL_VALIDATOR:
                context.final_sql = result.get('sql', '')
                context.explanation = result.get('explanation', '')
                context.error = result.get('error')

        except Exception as e:
            logger.error(
                f"Failed to update context for {agent_type.value}: {e}")
            context.error = f"Context update error: {str(e)}"

    def get_metrics(self) -> Dict[str, Any]:
        """Get pipeline performance metrics"""
        agent_metrics = {}
        total_api_calls = 0
        total_time = 0.0

        for agent_type, agent in self.agents.items():
            metrics = agent.get_metrics()
            agent_metrics[agent_type.value] = metrics
            total_api_calls += metrics['api_calls']
            total_time += metrics['total_time']

        return {
            'model_type': self.model_type.value,
            'total_api_calls': total_api_calls,
            'total_time': total_time,
            'agent_metrics': agent_metrics,
            'workflow_steps': len(self.workflow)
        }

    def reset_metrics(self):
        """Reset all agent metrics"""
        for agent in self.agents.values():
            agent.reset_metrics()

    def process_batch(self, questions: List[NLQuestion], schema: DatabaseSchema) -> List[PipelineResult]:
        """
        Process a batch of questions

        Args:
            questions: List of questions to process
            schema: Database schema

        Returns:
            List of PipelineResults
        """
        results = []

        logger.info(
            f"Processing batch of {len(questions)} questions with {self.model_type.value}")

        for i, question in enumerate(questions):
            logger.info(f"Processing question {i+1}/{len(questions)}")

            try:
                result = self.process(question, schema)
                results.append(result)

            except Exception as e:
                logger.error(f"Failed to process question {i+1}: {e}")
                # Create error result
                error_result = PipelineResult(
                    question_id=question.question_id or f"q_error_{i}",
                    db_id=question.db_id,
                    original_question=question.question,
                    final_sql="",
                    explanation="",
                    error=str(e),
                    execution_time=0.0,
                    api_calls=0,
                    model_type=self.model_type
                )
                results.append(error_result)

        logger.info(f"Batch processing completed: {len(results)} results")
        return results


class PipelineError(Exception):
    """Pipeline execution error"""

    def __init__(self, message: str, model_type: ModelType, step: Optional[str] = None):
        self.message = message
        self.model_type = model_type
        self.step = step
        super().__init__(f"{model_type.value} pipeline error: {message}")


class PipelineManager:
    """Manager for multiple pipeline instances"""

    def __init__(self):
        self.pipelines: Dict[ModelType, Pipeline] = {}

    def get_pipeline(self, model_type: ModelType) -> Pipeline:
        """Get or create a pipeline for the specified model type"""
        if model_type not in self.pipelines:
            self.pipelines[model_type] = Pipeline(model_type)
        return self.pipelines[model_type]

    def process_with_model(self, model_type: ModelType, question: NLQuestion, schema: DatabaseSchema) -> PipelineResult:
        """Process a question with a specific model type"""
        pipeline = self.get_pipeline(model_type)
        return pipeline.process(question, schema)

    def get_all_metrics(self) -> Dict[str, Any]:
        """Get metrics from all pipelines"""
        return {
            model_type.value: pipeline.get_metrics()
            for model_type, pipeline in self.pipelines.items()
        }

    def reset_all_metrics(self):
        """Reset metrics for all pipelines"""
        for pipeline in self.pipelines.values():
            pipeline.reset_metrics()


# Global pipeline manager instance
pipeline_manager = PipelineManager()
