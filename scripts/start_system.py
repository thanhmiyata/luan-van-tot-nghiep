#!/usr/bin/env python3
"""
Startup script for the Multi-Agent Text-to-SQL System.
This script initializes and starts all system components.
"""

import asyncio
import sys
import os
from pathlib import Path

# Add the project root to Python path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

try:
    import uvicorn
    from src.core.config import settings
    from src.core.logging import logger, setup_logging
    from src.database.connection import init_database, close_database
    from src.core.agent_coordinator import agent_coordinator
except ImportError as e:
    print(f"Error importing modules: {e}")
    print("Please ensure all dependencies are installed: pip install -r requirements.txt")
    sys.exit(1)


async def check_prerequisites():
    """Check if all prerequisites are met before starting the system."""
    logger.info("Checking system prerequisites...")
    
    # Check environment variables
    required_env_vars = [
        "DATABASE_URL", "DATABASE_USER", "DATABASE_PASSWORD",
        "OPENAI_API_KEY", "ANTHROPIC_API_KEY"
    ]
    
    missing_vars = []
    for var in required_env_vars:
        if not os.getenv(var):
            missing_vars.append(var)
    
    if missing_vars:
        logger.error(f"Missing required environment variables: {', '.join(missing_vars)}")
        logger.error("Please check your .env file or environment configuration")
        return False
    
    # Test database connection
    try:
        await init_database()
        logger.info("Database connection successful")
    except Exception as e:
        logger.error(f"Database connection failed: {str(e)}")
        logger.error("Please check your database configuration and ensure PostgreSQL is running")
        return False
    
    return True


async def start_system():
    """Start the multi-agent system."""
    try:
        # Setup logging
        setup_logging()
        logger.info("Starting Multi-Agent Text-to-SQL System...")
        
        # Check prerequisites
        if not await check_prerequisites():
            logger.error("Prerequisites check failed. System cannot start.")
            return False
        
        # Start agent coordinator
        await agent_coordinator.start()
        logger.info("Agent coordinator started successfully")
        
        logger.info("System initialization completed successfully")
        return True
        
    except Exception as e:
        logger.error(f"Error starting system: {str(e)}")
        return False


async def stop_system():
    """Stop the multi-agent system."""
    try:
        logger.info("Stopping Multi-Agent Text-to-SQL System...")
        
        # Stop agent coordinator
        await agent_coordinator.stop()
        logger.info("Agent coordinator stopped")
        
        # Close database connections
        await close_database()
        logger.info("Database connections closed")
        
        logger.info("System shutdown completed")
        
    except Exception as e:
        logger.error(f"Error stopping system: {str(e)}")


def run_api_server():
    """Run the FastAPI server."""
    try:
        logger.info(f"Starting API server on {settings.api_host}:{settings.api_port}")
        
        uvicorn.run(
            "src.api.main:app",
            host=settings.api_host,
            port=settings.api_port,
            reload=settings.api_reload,
            log_level=settings.log_level.lower(),
            workers=1  # Use single worker for async coordination
        )
        
    except KeyboardInterrupt:
        logger.info("Received shutdown signal")
    except Exception as e:
        logger.error(f"Error running API server: {str(e)}")
    finally:
        # Cleanup
        asyncio.run(stop_system())


def main():
    """Main entry point."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Multi-Agent Text-to-SQL System")
    parser.add_argument(
        "--mode",
        choices=["api", "test", "agents-only"],
        default="api",
        help="Run mode: api (default), test, or agents-only"
    )
    parser.add_argument(
        "--config-check",
        action="store_true",
        help="Check configuration and exit"
    )
    
    args = parser.parse_args()
    
    if args.config_check:
        print("Checking configuration...")
        success = asyncio.run(check_prerequisites())
        if success:
            print("✅ Configuration check passed")
            sys.exit(0)
        else:
            print("❌ Configuration check failed")
            sys.exit(1)
    
    if args.mode == "api":
        # Run full system with API server
        logger.info("Starting in API mode")
        run_api_server()
        
    elif args.mode == "test":
        # Run system tests
        logger.info("Starting in test mode")
        success = asyncio.run(start_system())
        if success:
            logger.info("System test completed successfully")
            asyncio.run(stop_system())
        else:
            logger.error("System test failed")
            sys.exit(1)
            
    elif args.mode == "agents-only":
        # Run only the agent system without API server
        logger.info("Starting in agents-only mode")
        try:
            success = asyncio.run(start_system())
            if success:
                logger.info("Agents started successfully. Press Ctrl+C to stop.")
                # Keep running until interrupted
                asyncio.run(asyncio.Event().wait())
        except KeyboardInterrupt:
            logger.info("Received shutdown signal")
        finally:
            asyncio.run(stop_system())


if __name__ == "__main__":
    main() 