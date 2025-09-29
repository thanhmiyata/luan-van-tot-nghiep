"""
Base agent class for Multi-Agent SQL system
"""

import time
import yaml
from abc import ABC, abstractmethod
from typing import Dict, Any, Optional
from pathlib import Path

import google.generativeai as genai
from loguru import logger

from config.settings import settings
from src.core.models import AgentType, ModelType, PipelineContext


class BaseAgent(ABC):
    """Base class for all agents in the system"""

    def __init__(self, agent_type: AgentType, model_type: ModelType):
        self.agent_type = agent_type
        self.model_type = model_type
        self.model_name = settings.default_model
        self.temperature = settings.temperature
        self.max_tokens = settings.max_tokens
        self.timeout = settings.timeout

        # Initialize AI model
        self._setup_model()

        # Load prompts
        self.prompts = self._load_prompts()

        # Metrics tracking
        self.api_calls = 0
        self.total_time = 0.0

    def _setup_model(self):
        """Setup the AI model"""
        try:
            # Use gemini_api_key as primary, fallback to google_api_key
            api_key = settings.gemini_api_key or settings.google_api_key
            if not api_key:
                raise ValueError(
                    "No API key found. Please set GEMINI_API_KEY or GOOGLE_API_KEY")

            genai.configure(api_key=api_key)
            self.model = genai.GenerativeModel(self.model_name)
            logger.info(
                f"Initialized {self.agent_type} agent with {self.model_name}")
        except Exception as e:
            logger.error(f"Failed to setup model for {self.agent_type}: {e}")
            raise

    def _load_prompts(self) -> Dict[str, Any]:
        """Load prompt templates for this agent"""
        prompt_file = settings.prompts_dir / f"{self.agent_type.value}.yaml"

        if not prompt_file.exists():
            logger.warning(f"Prompt file not found: {prompt_file}")
            return {}

        try:
            with open(prompt_file, 'r', encoding='utf-8') as f:
                prompts = yaml.safe_load(f)

            # Get prompts for specific model type
            if 'prompts' in prompts and self.model_type.value in prompts['prompts']:
                return prompts['prompts'][self.model_type.value]
            else:
                logger.warning(
                    f"No prompts found for {self.agent_type} - {self.model_type}")
                return {}

        except Exception as e:
            logger.error(f"Failed to load prompts for {self.agent_type}: {e}")
            return {}

    def _call_llm(self, prompt: str, **kwargs) -> str:
        """Make a call to the language model"""
        start_time = time.time()

        try:
            # Configure generation parameters
            generation_config = {
                'temperature': self.temperature,
                'max_output_tokens': self.max_tokens,
                **kwargs
            }

            # Make the API call
            response = self.model.generate_content(
                prompt,
                generation_config=generation_config
            )

            # Track metrics
            self.api_calls += 1
            call_time = time.time() - start_time
            self.total_time += call_time

            logger.debug(f"{self.agent_type} API call took {call_time:.2f}s")

            return response.text

        except Exception as e:
            logger.error(f"LLM call failed for {self.agent_type}: {e}")
            raise

    def _format_prompt(self, template: str, **kwargs) -> str:
        """Format prompt template with provided arguments"""
        try:
            return template.format(**kwargs)
        except KeyError as e:
            logger.error(
                f"Missing template variable for {self.agent_type}: {e}")
            raise
        except Exception as e:
            logger.error(f"Failed to format prompt for {self.agent_type}: {e}")
            raise

    @abstractmethod
    def execute(self, context: PipelineContext) -> Dict[str, Any]:
        """Execute the agent's task"""
        pass

    def get_metrics(self) -> Dict[str, Any]:
        """Get agent performance metrics"""
        return {
            'agent_type': self.agent_type.value,
            'model_type': self.model_type.value,
            'api_calls': self.api_calls,
            'total_time': self.total_time,
            'avg_time_per_call': self.total_time / max(self.api_calls, 1)
        }

    def reset_metrics(self):
        """Reset performance metrics"""
        self.api_calls = 0
        self.total_time = 0.0


class AgentError(Exception):
    """Base exception for agent errors"""

    def __init__(self, agent_type: AgentType, message: str, original_error: Optional[Exception] = None):
        self.agent_type = agent_type
        self.message = message
        self.original_error = original_error
        super().__init__(f"{agent_type.value}: {message}")


class AgentTimeoutError(AgentError):
    """Agent execution timeout error"""
    pass


class AgentValidationError(AgentError):
    """Agent input/output validation error"""
    pass
