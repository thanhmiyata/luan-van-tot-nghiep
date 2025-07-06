"""
Base Agent class cho Multi-Agent Text-to-SQL System
Foundation class cho 6 specialized agents
"""
import asyncio
import json
import logging
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Dict, Any, Optional, List
from datetime import datetime
import openai
import anthropic
import google.generativeai as genai

from ..config import AgentConfig, config


@dataclass
class AgentMessage:
    """Message format cho agent communication"""
    sender: str
    receiver: str
    message_type: str
    content: Dict[str, Any]
    timestamp: datetime
    message_id: str


@dataclass
class AgentResponse:
    """Response format cho agent output"""
    agent_name: str
    success: bool
    data: Dict[str, Any]
    error_message: Optional[str] = None
    processing_time: float = 0.0
    timestamp: datetime = None


class BaseAgent(ABC):
    """
    Base class cho tất cả 6 agents trong multi-agent system
    Implement common functionality: LLM calls, error handling, logging
    """

    def __init__(self, agent_config: AgentConfig):
        self.config = agent_config
        self.name = agent_config.name
        self.model_name = agent_config.model_name
        self.logger = logging.getLogger(f"MultiAgent.{self.name}")

        # Initialize LLM clients
        self.openai_client = openai.OpenAI(api_key=config.OPENAI_API_KEY)
        self.anthropic_client = anthropic.Anthropic(
            api_key=config.ANTHROPIC_API_KEY)
        genai.configure(api_key=config.GOOGLE_API_KEY)

        # Agent state
        self.is_busy = False
        self.last_error = None
        self.performance_metrics = {
            "total_requests": 0,
            "successful_requests": 0,
            "average_response_time": 0.0,
            "error_count": 0
        }

        self.logger.info(
            f"Initialized {self.name} with model {self.model_name}")

    @abstractmethod
    async def process(self, input_data: Dict[str, Any]) -> AgentResponse:
        """
        Main processing method - must be implemented by each agent
        """
        pass

    @abstractmethod
    def get_system_prompt(self) -> str:
        """
        Get system prompt specific to this agent
        """
        pass

    async def call_llm(self, messages: List[Dict[str, str]], **kwargs) -> str:
        """
        Universal LLM caller supporting GPT-4, Claude, Gemini
        """
        start_time = datetime.now()

        try:
            self.logger.debug(
                f"Calling LLM {self.model_name} with {len(messages)} messages")

            # GPT-4 models
            if "gpt-" in self.model_name.lower():
                response = await self._call_openai(messages, **kwargs)

            # Claude models
            elif "claude-" in self.model_name.lower():
                response = await self._call_anthropic(messages, **kwargs)

            # Gemini models
            elif "gemini-" in self.model_name.lower():
                response = await self._call_google(messages, **kwargs)

            else:
                raise ValueError(f"Unsupported model: {self.model_name}")

            # Update performance metrics
            processing_time = (datetime.now() - start_time).total_seconds()
            self._update_metrics(True, processing_time)

            return response

        except Exception as e:
            processing_time = (datetime.now() - start_time).total_seconds()
            self._update_metrics(False, processing_time)
            self.logger.error(f"LLM call failed: {str(e)}")
            raise

    async def _call_openai(self, messages: List[Dict[str, str]], **kwargs) -> str:
        """Call OpenAI GPT models"""
        try:
            response = await asyncio.to_thread(
                self.openai_client.chat.completions.create,
                model=self.model_name,
                messages=messages,
                temperature=kwargs.get('temperature', self.config.temperature),
                max_tokens=kwargs.get('max_tokens', self.config.max_tokens),
                timeout=kwargs.get('timeout', self.config.timeout)
            )
            return response.choices[0].message.content
        except Exception as e:
            self.logger.error(f"OpenAI API error: {str(e)}")
            raise

    async def _call_anthropic(self, messages: List[Dict[str, str]], **kwargs) -> str:
        """Call Anthropic Claude models"""
        try:
            # Convert messages format for Claude
            system_msg = ""
            user_messages = []

            for msg in messages:
                if msg["role"] == "system":
                    system_msg = msg["content"]
                else:
                    user_messages.append(msg)

            response = await asyncio.to_thread(
                self.anthropic_client.messages.create,
                model=self.model_name,
                system=system_msg,
                messages=user_messages,
                temperature=kwargs.get('temperature', self.config.temperature),
                max_tokens=kwargs.get('max_tokens', self.config.max_tokens),
                timeout=kwargs.get('timeout', self.config.timeout)
            )
            return response.content[0].text
        except Exception as e:
            self.logger.error(f"Anthropic API error: {str(e)}")
            raise

    async def _call_google(self, messages: List[Dict[str, str]], **kwargs) -> str:
        """Call Google Gemini models"""
        try:
            model = genai.GenerativeModel(self.model_name)

            # Convert messages to Gemini format
            prompt = ""
            for msg in messages:
                if msg["role"] == "system":
                    prompt += f"System: {msg['content']}\n\n"
                elif msg["role"] == "user":
                    prompt += f"Human: {msg['content']}\n\n"
                elif msg["role"] == "assistant":
                    prompt += f"Assistant: {msg['content']}\n\n"

            response = await asyncio.to_thread(
                model.generate_content,
                prompt,
                generation_config=genai.types.GenerationConfig(
                    temperature=kwargs.get(
                        'temperature', self.config.temperature),
                    max_output_tokens=kwargs.get(
                        'max_tokens', self.config.max_tokens),
                )
            )
            return response.text
        except Exception as e:
            self.logger.error(f"Google API error: {str(e)}")
            raise

    def _update_metrics(self, success: bool, processing_time: float):
        """Update performance metrics"""
        self.performance_metrics["total_requests"] += 1
        if success:
            self.performance_metrics["successful_requests"] += 1
        else:
            self.performance_metrics["error_count"] += 1

        # Update average response time
        total = self.performance_metrics["total_requests"]
        current_avg = self.performance_metrics["average_response_time"]
        self.performance_metrics["average_response_time"] = (
            (current_avg * (total - 1) + processing_time) / total
        )

    def get_metrics(self) -> Dict[str, Any]:
        """Get agent performance metrics"""
        return {
            "agent_name": self.name,
            "model_name": self.model_name,
            "metrics": self.performance_metrics.copy(),
            "success_rate": (
                self.performance_metrics["successful_requests"] /
                max(self.performance_metrics["total_requests"], 1)
            ),
            "is_busy": self.is_busy,
            "last_error": self.last_error
        }

    async def health_check(self) -> bool:
        """Check if agent is healthy and responsive"""
        try:
            test_messages = [
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": "Reply with just 'OK' if you can understand this."}
            ]

            response = await self.call_llm(test_messages, max_tokens=10)
            return "OK" in response.upper()

        except Exception as e:
            self.logger.error(f"Health check failed: {str(e)}")
            return False

    def reset_metrics(self):
        """Reset performance metrics"""
        self.performance_metrics = {
            "total_requests": 0,
            "successful_requests": 0,
            "average_response_time": 0.0,
            "error_count": 0
        }
        self.logger.info(f"Reset metrics for {self.name}")
