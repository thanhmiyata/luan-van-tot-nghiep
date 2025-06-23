"""
Database connection and session management for the Multi-Agent Text-to-SQL system.
"""

from typing import AsyncGenerator
from sqlalchemy import create_engine, MetaData
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import declarative_base, sessionmaker
from sqlalchemy.pool import NullPool
import asyncio

from ..core.config import settings
from ..core.logging import logger


# Base class for all database models
Base = declarative_base()

# Metadata for reflecting existing databases
metadata = MetaData()

class DatabaseManager:
    """Manages database connections and sessions."""
    
    def __init__(self):
        self.engine = None
        self.async_engine = None
        self.SessionLocal = None
        self.AsyncSessionLocal = None
        self._initialized = False
    
    def initialize_sync_engine(self) -> None:
        """Initialize synchronous database engine."""
        try:
            self.engine = create_engine(
                settings.database_url,
                pool_pre_ping=True,
                pool_recycle=300,
                echo=settings.debug
            )
            
            self.SessionLocal = sessionmaker(
                autocommit=False,
                autoflush=False,
                bind=self.engine
            )
            
            logger.info("Synchronous database engine initialized")
            
        except Exception as e:
            logger.error(f"Failed to initialize sync database engine: {str(e)}")
            raise
    
    def initialize_async_engine(self) -> None:
        """Initialize asynchronous database engine."""
        try:
            # Convert sync URL to async URL for PostgreSQL
            async_url = settings.database_url.replace("postgresql://", "postgresql+asyncpg://")
            
            self.async_engine = create_async_engine(
                async_url,
                pool_pre_ping=True,
                pool_recycle=300,
                echo=settings.debug,
                poolclass=NullPool if settings.environment == "test" else None
            )
            
            self.AsyncSessionLocal = async_sessionmaker(
                bind=self.async_engine,
                class_=AsyncSession,
                expire_on_commit=False
            )
            
            logger.info("Asynchronous database engine initialized")
            
        except Exception as e:
            logger.error(f"Failed to initialize async database engine: {str(e)}")
            raise
    
    def initialize(self) -> None:
        """Initialize both sync and async engines."""
        if self._initialized:
            return
        
        self.initialize_sync_engine()
        self.initialize_async_engine()
        self._initialized = True
        logger.info("Database manager fully initialized")
    
    async def get_async_session(self) -> AsyncGenerator[AsyncSession, None]:
        """
        Get an async database session.
        
        Yields:
            AsyncSession: Database session
        """
        if not self._initialized:
            self.initialize()
        
        async with self.AsyncSessionLocal() as session:
            try:
                yield session
            except Exception:
                await session.rollback()
                raise
            finally:
                await session.close()
    
    def get_sync_session(self):
        """
        Get a sync database session.
        
        Returns:
            Database session
        """
        if not self._initialized:
            self.initialize()
        
        return self.SessionLocal()
    
    async def test_connection(self) -> bool:
        """
        Test database connection.
        
        Returns:
            bool: True if connection is successful, False otherwise
        """
        try:
            async with self.async_engine.begin() as conn:
                await conn.execute("SELECT 1")
            logger.info("Database connection test successful")
            return True
        except Exception as e:
            logger.error(f"Database connection test failed: {str(e)}")
            return False
    
    async def create_tables(self) -> None:
        """Create all tables defined in the models."""
        try:
            async with self.async_engine.begin() as conn:
                await conn.run_sync(Base.metadata.create_all)
            logger.info("Database tables created successfully")
        except Exception as e:
            logger.error(f"Failed to create database tables: {str(e)}")
            raise
    
    async def drop_tables(self) -> None:
        """Drop all tables (use with caution!)."""
        try:
            async with self.async_engine.begin() as conn:
                await conn.run_sync(Base.metadata.drop_all)
            logger.info("Database tables dropped successfully")
        except Exception as e:
            logger.error(f"Failed to drop database tables: {str(e)}")
            raise
    
    async def reflect_database(self, schema: str = None) -> MetaData:
        """
        Reflect an existing database schema.
        
        Args:
            schema: Optional schema name to reflect
            
        Returns:
            MetaData: Reflected metadata
        """
        try:
            reflected_metadata = MetaData()
            
            async with self.async_engine.begin() as conn:
                await conn.run_sync(
                    reflected_metadata.reflect, 
                    schema=schema
                )
            
            logger.info(f"Database schema reflected successfully. Found {len(reflected_metadata.tables)} tables")
            return reflected_metadata
            
        except Exception as e:
            logger.error(f"Failed to reflect database schema: {str(e)}")
            raise
    
    async def close(self) -> None:
        """Close all database connections."""
        try:
            if self.async_engine:
                await self.async_engine.dispose()
            if self.engine:
                self.engine.dispose()
            logger.info("Database connections closed")
        except Exception as e:
            logger.error(f"Error closing database connections: {str(e)}")


# Global database manager instance
db_manager = DatabaseManager()


# Dependency for FastAPI routes
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """FastAPI dependency for getting database session."""
    async for db in db_manager.get_async_session():
        yield db


# Convenience functions
async def init_database():
    """Initialize database connection."""
    db_manager.initialize()
    
    # Test connection
    connection_ok = await db_manager.test_connection()
    if not connection_ok:
        raise RuntimeError("Database connection failed")
    
    # Create tables if they don't exist
    await db_manager.create_tables()


async def close_database():
    """Close database connections."""
    await db_manager.close() 