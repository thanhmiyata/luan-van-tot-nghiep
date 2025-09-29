"""
Global configuration settings for Multi-Agent SQL system
"""

import os
from pathlib import Path
from typing import Optional, List
from pydantic import Field
from pydantic_settings import BaseSettings
from dotenv import load_dotenv

# Load environment variables
load_dotenv()


class Settings(BaseSettings):
    """Global application settings"""

    # API Configuration
    google_api_key: Optional[str] = Field(None, env="GOOGLE_API_KEY")
    gemini_api_key: str = Field(..., env="GEMINI_API_KEY")
    openai_api_key: Optional[str] = Field(None, env="OPENAI_API_KEY")
    anthropic_api_key: Optional[str] = Field(None, env="ANTHROPIC_API_KEY")
    deepseek_api_key: Optional[str] = Field(None, env="DEEPSEEK_API_KEY")

    # Model Configuration
    default_model: str = Field("gemini-2.0-flash", env="DEFAULT_MODEL")
    temperature: float = Field(0.0, env="TEMPERATURE")
    max_tokens: int = Field(2048, env="MAX_TOKENS")
    timeout: int = Field(30, env="TIMEOUT")

    # Logging Configuration
    log_level: str = Field("INFO", env="LOG_LEVEL")
    log_file: str = Field("logs/multi_agent_sql.log", env="LOG_FILE")

    # Benchmark Configuration
    default_questions_count: int = Field(50, env="DEFAULT_QUESTIONS_COUNT")
    default_runs: int = Field(3, env="DEFAULT_RUNS")
    results_dir: str = Field("data/results", env="RESULTS_DIR")

    # Database Configuration
    database_dir: str = Field("data/schemas/database", env="DATABASE_DIR")
    tables_file: str = Field("data/schemas/tables.json", env="TABLES_FILE")

    # Test Suite Configuration
    test_suite_dir: str = Field("test-suite-sql-eval", env="TEST_SUITE_DIR")
    evaluation_timeout: int = Field(300, env="EVALUATION_TIMEOUT")

    # Project paths
    project_root: Path = Path(__file__).parent.parent
    config_dir: Path = project_root / "config"
    prompts_dir: Path = config_dir / "prompts"
    data_dir: Path = project_root / "data"
    src_dir: Path = project_root / "src"

    class Config:
        env_file = ".env"
        case_sensitive = False

    def __post_init__(self):
        """Create necessary directories"""
        self.data_dir.mkdir(exist_ok=True)
        self.results_dir_path.mkdir(parents=True, exist_ok=True)
        (self.project_root / "logs").mkdir(exist_ok=True)

    @property
    def results_dir_path(self) -> Path:
        """Get results directory as Path object"""
        return self.project_root / self.results_dir

    @property
    def database_dir_path(self) -> Path:
        """Get database directory as Path object"""
        return self.project_root / self.database_dir

    @property
    def tables_file_path(self) -> Path:
        """Get tables file as Path object"""
        return self.project_root / self.tables_file


# Global settings instance
settings = Settings()

# Model types configuration
MODEL_TYPES = {
    "3_step": {
        "name": "Lightweight",
        "description": "SQL Expert → SQL Validator",
        "agents": ["sql_expert", "sql_validator"],
        "expected_accuracy": 0.75,
        "expected_time_per_question": 4.5,
        "expected_api_calls": 3
    },
    "4_step": {
        "name": "Balanced",
        "description": "Question Analyzer → Schema Selector → SQL Expert → SQL Validator",
        "agents": ["question_analyzer", "schema_selector", "sql_expert", "sql_validator"],
        "expected_accuracy": 0.85,
        "expected_time_per_question": 6.8,
        "expected_api_calls": 4
    },
    "6_step": {
        "name": "Enhanced",
        "description": "Query Refinement → Entity Recognition → Question Analyzer → Schema Selector → SQL Expert → SQL Validator",
        "agents": ["query_refinement", "entity_recognition", "question_analyzer", "schema_selector", "sql_expert", "sql_validator"],
        "expected_accuracy": 0.92,
        "expected_time_per_question": 9.2,
        "expected_api_calls": 6
    }
}

# Agent configurations
AGENT_CONFIGS = {
    "sql_expert": {
        "model": "gemini-2.0-flash",
        "temperature": 0.0,
        "max_tokens": 1024,
        "required_for": ["3_step", "4_step", "6_step"]
    },
    "sql_validator": {
        "model": "gemini-2.0-flash",
        "temperature": 0.0,
        "max_tokens": 1024,
        "required_for": ["3_step", "4_step", "6_step"]
    },
    "question_analyzer": {
        "model": "gemini-2.0-flash",
        "temperature": 0.0,
        "max_tokens": 512,
        "required_for": ["4_step", "6_step"]
    },
    "schema_selector": {
        "model": "gemini-2.0-flash",
        "temperature": 0.0,
        "max_tokens": 1024,
        "required_for": ["4_step", "6_step"]
    },
    "query_refinement": {
        "model": "gemini-2.0-flash",
        "temperature": 0.0,
        "max_tokens": 512,
        "required_for": ["6_step"]
    },
    "entity_recognition": {
        "model": "gemini-2.0-flash",
        "temperature": 0.0,
        "max_tokens": 512,
        "required_for": ["6_step"]
    }
}
