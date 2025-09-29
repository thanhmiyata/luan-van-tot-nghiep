"""
Agent factory for creating different types of agents
"""

from typing import Optional
from loguru import logger

from src.core.models import AgentType, ModelType
from src.core.base_agent import BaseAgent


class AgentFactory:
    """Factory class for creating agents"""
    
    @staticmethod
    def create_agent(agent_type: AgentType, model_type: ModelType) -> BaseAgent:
        """
        Create an agent of the specified type
        
        Args:
            agent_type: Type of agent to create
            model_type: Model type for context-aware configuration
            
        Returns:
            Initialized agent instance
        """
        try:
            if agent_type == AgentType.QUERY_REFINEMENT:
                from src.agents.query_refinement import QueryRefinementAgent
                return QueryRefinementAgent(model_type)
                
            elif agent_type == AgentType.ENTITY_RECOGNITION:
                from src.agents.entity_recognition import EntityRecognitionAgent
                return EntityRecognitionAgent(model_type)
                
            elif agent_type == AgentType.QUESTION_ANALYZER:
                from src.agents.question_analyzer import QuestionAnalyzerAgent
                return QuestionAnalyzerAgent(model_type)
                
            elif agent_type == AgentType.SCHEMA_SELECTOR:
                from src.agents.schema_selector import SchemaSelectorAgent
                return SchemaSelectorAgent(model_type)
                
            elif agent_type == AgentType.SQL_EXPERT:
                from src.agents.sql_expert import SQLExpertAgent
                return SQLExpertAgent(model_type)
                
            elif agent_type == AgentType.SQL_VALIDATOR:
                from src.agents.sql_validator import SQLValidatorAgent
                return SQLValidatorAgent(model_type)
                
            else:
                raise ValueError(f"Unknown agent type: {agent_type}")
                
        except ImportError as e:
            logger.error(f"Failed to import agent {agent_type.value}: {e}")
            raise
        except Exception as e:
            logger.error(f"Failed to create agent {agent_type.value}: {e}")
            raise
    
    @staticmethod
    def get_required_agents(model_type: ModelType) -> list[AgentType]:
        """Get list of agents required for a model type"""
        if model_type == ModelType.THREE_STEP:
            return [AgentType.SQL_EXPERT, AgentType.SQL_VALIDATOR]
        elif model_type == ModelType.FOUR_STEP:
            return [
                AgentType.QUESTION_ANALYZER,
                AgentType.SCHEMA_SELECTOR, 
                AgentType.SQL_EXPERT,
                AgentType.SQL_VALIDATOR
            ]
        elif model_type == ModelType.SIX_STEP:
            return [
                AgentType.QUERY_REFINEMENT,
                AgentType.ENTITY_RECOGNITION,
                AgentType.QUESTION_ANALYZER,
                AgentType.SCHEMA_SELECTOR,
                AgentType.SQL_EXPERT,
                AgentType.SQL_VALIDATOR
            ]
        else:
            raise ValueError(f"Unknown model type: {model_type}")
    
    @staticmethod
    def validate_agent_availability(model_type: ModelType) -> bool:
        """Check if all required agents are available for a model type"""
        required_agents = AgentFactory.get_required_agents(model_type)
        
        for agent_type in required_agents:
            try:
                # Try to create the agent to check availability
                agent = AgentFactory.create_agent(agent_type, model_type)
                logger.debug(f"Agent {agent_type.value} is available")
            except Exception as e:
                logger.error(f"Agent {agent_type.value} is not available: {e}")
                return False
        
        return True
