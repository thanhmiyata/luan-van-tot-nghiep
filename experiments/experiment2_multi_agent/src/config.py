"""
Configuration file for Multi-Agent Text-to-SQL System
6-Agent Architecture theo paper thầy hướng dẫn
"""
import os
from dataclasses import dataclass
from typing import Dict, Any, Optional


@dataclass
class AgentConfig:
    """Configuration cho từng agent"""
    name: str
    model_name: str
    temperature: float = 0.1
    max_tokens: int = 2000
    timeout: int = 30
    retry_count: int = 3


@dataclass
class MultiAgentConfig:
    """Configuration tổng cho hệ thống multi-agent"""

    # Database configuration
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL", "postgresql://postgres:postgres@localhost:5432/dvdrental")

    # API Keys
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "")
    ANTHROPIC_API_KEY: str = os.getenv("ANTHROPIC_API_KEY", "")
    GOOGLE_API_KEY: str = os.getenv("GOOGLE_API_KEY", "")

    # Vector Database (Qdrant)
    QDRANT_URL: str = os.getenv("QDRANT_URL", "localhost")
    QDRANT_PORT: int = int(os.getenv("QDRANT_PORT", "6333"))

    # Agent timeout và coordination
    AGENT_TIMEOUT: int = 30
    MAX_RETRIES: int = 3
    COORDINATION_TIMEOUT: int = 120

    # 6 Agent configurations
    agents: Dict[str, AgentConfig] = None

    def __post_init__(self):
        """Initialize agent configurations"""
        if self.agents is None:
            self.agents = {
                "query_refinement": AgentConfig(
                    name="Query Refinement Agent",
                    model_name="gpt-4-turbo-preview",
                    temperature=0.1,
                    max_tokens=1000
                ),
                "schema_recognition": AgentConfig(
                    name="Schema Recognition Agent",
                    model_name="claude-3-5-sonnet-20241022",
                    temperature=0.0,
                    max_tokens=2000
                ),
                "query_planning": AgentConfig(
                    name="Query Planning Agent",
                    model_name="gpt-4-turbo-preview",
                    temperature=0.2,
                    max_tokens=1500
                ),
                "sql_generator": AgentConfig(
                    name="SQL Generator Agent",
                    model_name="gpt-4-turbo-preview",
                    temperature=0.0,
                    max_tokens=1000
                ),
                "validation": AgentConfig(
                    name="Validation Agent",
                    model_name="claude-3-5-sonnet-20241022",
                    temperature=0.0,
                    max_tokens=1000
                ),
                "response_generation": AgentConfig(
                    name="Response Generation Agent",
                    model_name="gpt-4-turbo-preview",
                    temperature=0.3,
                    max_tokens=2000
                )
            }


# Global configuration instance
config = MultiAgentConfig()

# Specialized model configurations (theo paper thầy)
SPECIALIZED_MODELS = {
    "embedder": {
        "model_name": "sentence-transformers/all-MiniLM-L6-v2",
        "max_seq_length": 512
    },
    "ner": {
        "model_name": "urchade/gliner_small-v2.1",
        "threshold": 0.5
    },
    "rerank": {
        "model_name": "BAAI/bge-reranker-base",
        "top_k": 10
    }
}

# Agent communication protocol
AGENT_MESSAGES = {
    "QUERY_REFINED": "query_refined",
    "SCHEMA_RECOGNIZED": "schema_recognized",
    "QUERY_PLANNED": "query_planned",
    "SQL_GENERATED": "sql_generated",
    "VALIDATION_COMPLETE": "validation_complete",
    "RESPONSE_GENERATED": "response_generated",
    "ERROR": "error",
    "RETRY": "retry"
}

# Performance benchmarks (theo target paper thầy: 91.95%)
PERFORMANCE_TARGETS = {
    "overall_accuracy": 0.90,  # 90%+
    "response_time": 10.0,     # < 10 seconds
    "agent_coordination": 0.95  # 95% success rate
}
