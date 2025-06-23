"""
Configuration management for the Multi-Agent Text-to-SQL system.
"""

from typing import Optional
from pydantic import Field
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    # LLM API Configuration
    openai_api_key: Optional[str] = Field(default=None, env="OPENAI_API_KEY")
    anthropic_api_key: Optional[str] = Field(default=None, env="ANTHROPIC_API_KEY")
    google_api_key: Optional[str] = Field(default=None, env="GOOGLE_API_KEY")
    deepseek_api_key: Optional[str] = Field(default=None, env="DEEPSEEK_API_KEY")
    
    openai_model: str = Field(default="gpt-4-1106-preview", env="OPENAI_MODEL")
    anthropic_model: str = Field(default="claude-3-sonnet-20240229", env="ANTHROPIC_MODEL")
    google_model: str = Field(default="gemini-pro", env="GOOGLE_MODEL")
    deepseek_model: str = Field(default="deepseek-chat", env="DEEPSEEK_MODEL")
    
    default_llm_provider: str = Field(default="openai", env="DEFAULT_LLM_PROVIDER")
    
    # Database Configuration
    database_url: Optional[str] = Field(default=None, env="DATABASE_URL")
    db_host: str = Field(default="localhost", env="DB_HOST")
    db_port: int = Field(default=5432, env="DB_PORT")
    db_name: str = Field(default="dvdrental", env="DB_NAME")
    db_user: Optional[str] = Field(default=None, env="DB_USER")
    db_password: Optional[str] = Field(default=None, env="DB_PASSWORD")
    
    # System Configuration
    debug: bool = Field(default=False, env="DEBUG")
    log_level: str = Field(default="INFO", env="LOG_LEVEL")
    environment: str = Field(default="development", env="ENVIRONMENT")
    
    # API Configuration
    api_host: str = Field(default="0.0.0.0", env="API_HOST")
    api_port: int = Field(default=8000, env="API_PORT")
    api_reload: bool = Field(default=True, env="API_RELOAD")
    
    # Agent Configuration
    max_retries: int = Field(default=3, env="MAX_RETRIES")
    timeout_seconds: int = Field(default=30, env="TIMEOUT_SECONDS")
    enable_caching: bool = Field(default=True, env="ENABLE_CACHING")
    
    # Performance Configuration
    max_concurrent_requests: int = Field(default=10, env="MAX_CONCURRENT_REQUESTS")
    request_timeout: int = Field(default=60, env="REQUEST_TIMEOUT")
    
    # Monitoring
    enable_metrics: bool = Field(default=True, env="ENABLE_METRICS")
    metrics_port: int = Field(default=9090, env="METRICS_PORT")
    
    # Optional: Redis Configuration
    redis_url: Optional[str] = Field(default=None, env="REDIS_URL")
    redis_host: str = Field(default="localhost", env="REDIS_HOST")
    redis_port: int = Field(default=6379, env="REDIS_PORT")
    redis_db: int = Field(default=0, env="REDIS_DB")
    
    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        case_sensitive = False
        extra = "ignore"  # Ignore extra fields from .env


# Global settings instance
settings = Settings()


def get_settings() -> Settings:
    """Get application settings."""
    return settings


def get_config() -> dict:
    """Get configuration as dictionary for backward compatibility."""
    settings_obj = get_settings()
    return {
        "OPENAI_API_KEY": settings_obj.openai_api_key,
        "ANTHROPIC_API_KEY": settings_obj.anthropic_api_key, 
        "GOOGLE_API_KEY": settings_obj.google_api_key,
        "DEEPSEEK_API_KEY": settings_obj.deepseek_api_key,
        "OPENAI_MODEL": settings_obj.openai_model,
        "ANTHROPIC_MODEL": settings_obj.anthropic_model,
        "GOOGLE_MODEL": settings_obj.google_model,
        "DEEPSEEK_MODEL": settings_obj.deepseek_model,
        "DEFAULT_LLM_PROVIDER": settings_obj.default_llm_provider,
        "DATABASE_URL": settings_obj.database_url,
        "DB_HOST": settings_obj.db_host,
        "DB_PORT": settings_obj.db_port,
        "DB_NAME": settings_obj.db_name,
        "DB_USER": settings_obj.db_user,
        "DB_PASSWORD": settings_obj.db_password,
        "DEBUG": settings_obj.debug,
    } 