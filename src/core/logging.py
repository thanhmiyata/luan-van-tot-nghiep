"""
Logging configuration for the Multi-Agent Text-to-SQL system.
"""

import sys
from loguru import logger
from .config import settings


def setup_logging():
    """Configure logging for the application."""
    
    # Remove default logger
    logger.remove()
    
    # Console logging
    logger.add(
        sys.stdout,
        level=settings.log_level,
        format="<green>{time:YYYY-MM-DD HH:mm:ss}</green> | "
               "<level>{level: <8}</level> | "
               "<cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> | "
               "<level>{message}</level>",
        colorize=True,
    )
    
    # File logging
    logger.add(
        "logs/app.log",
        level="DEBUG",
        format="{time:YYYY-MM-DD HH:mm:ss} | {level: <8} | {name}:{function}:{line} | {message}",
        rotation="10 MB",
        retention="7 days",
        compression="zip",
    )
    
    # Error file logging
    logger.add(
        "logs/error.log",
        level="ERROR",
        format="{time:YYYY-MM-DD HH:mm:ss} | {level: <8} | {name}:{function}:{line} | {message}",
        rotation="10 MB",
        retention="30 days",
        compression="zip",
    )
    
    # Agent-specific logging
    logger.add(
        "logs/agents.log",
        level="INFO",
        format="{time:YYYY-MM-DD HH:mm:ss} | {level: <8} | {extra[agent_name]} | {message}",
        filter=lambda record: "agent_name" in record["extra"],
        rotation="10 MB",
        retention="7 days",
    )
    
    return logger


def get_agent_logger(agent_name: str):
    """Get a logger for a specific agent."""
    return logger.bind(agent_name=agent_name)


# Initialize logging
setup_logging() 