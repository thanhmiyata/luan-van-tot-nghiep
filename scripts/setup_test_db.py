#!/usr/bin/env python3
"""
Setup script to create a test database with sample tables.
This will help test the Multi-Agent Text-to-SQL system.
"""

import asyncio
import sys
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import create_async_engine
from src.core.config import settings
from src.core.logging import logger


async def create_test_database():
    """Create a test database with sample tables."""
    try:
        # Convert sync URL to async URL
        async_url = settings.database_url.replace("postgresql://", "postgresql+asyncpg://")
        
        # Create async engine
        engine = create_async_engine(async_url, echo=True)
        
        async with engine.begin() as conn:
            # Create sample tables for testing
            
            # Users table
            await conn.execute(text("""
                CREATE TABLE IF NOT EXISTS users (
                    id SERIAL PRIMARY KEY,
                    username VARCHAR(50) UNIQUE NOT NULL,
                    email VARCHAR(100) UNIQUE NOT NULL,
                    full_name VARCHAR(100),
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    is_active BOOLEAN DEFAULT true
                );
            """))
            
            # Categories table
            await conn.execute(text("""
                CREATE TABLE IF NOT EXISTS categories (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR(50) NOT NULL,
                    description TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
            """))
            
            # Products table
            await conn.execute(text("""
                CREATE TABLE IF NOT EXISTS products (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR(100) NOT NULL,
                    description TEXT,
                    price DECIMAL(10, 2) NOT NULL,
                    category_id INTEGER REFERENCES categories(id),
                    stock_quantity INTEGER DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
            """))
            
            # Orders table
            await conn.execute(text("""
                CREATE TABLE IF NOT EXISTS orders (
                    id SERIAL PRIMARY KEY,
                    user_id INTEGER REFERENCES users(id),
                    total_amount DECIMAL(10, 2) NOT NULL,
                    status VARCHAR(20) DEFAULT 'pending',
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
            """))
            
            # Order Items table
            await conn.execute(text("""
                CREATE TABLE IF NOT EXISTS order_items (
                    id SERIAL PRIMARY KEY,
                    order_id INTEGER REFERENCES orders(id),
                    product_id INTEGER REFERENCES products(id),
                    quantity INTEGER NOT NULL,
                    unit_price DECIMAL(10, 2) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
            """))
            
            # Reviews table
            await conn.execute(text("""
                CREATE TABLE IF NOT EXISTS reviews (
                    id SERIAL PRIMARY KEY,
                    product_id INTEGER REFERENCES products(id),
                    user_id INTEGER REFERENCES users(id),
                    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
                    comment TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
            """))
            
            logger.info("Sample tables created successfully")
            
        # Insert sample data
        await insert_sample_data(engine)
        
        await engine.dispose()
        logger.info("Test database setup completed successfully")
        
    except Exception as e:
        logger.error(f"Error setting up test database: {str(e)}")
        raise


async def insert_sample_data(engine):
    """Insert sample data into the test tables."""
    try:
        async with engine.begin() as conn:
            # Insert categories
            await conn.execute(text("""
                INSERT INTO categories (name, description) VALUES
                ('Electronics', 'Electronic devices and gadgets'),
                ('Books', 'Books and educational materials'),
                ('Clothing', 'Apparel and accessories'),
                ('Home & Garden', 'Home improvement and garden supplies')
                ON CONFLICT DO NOTHING;
            """))
            
            # Insert users
            await conn.execute(text("""
                INSERT INTO users (username, email, full_name) VALUES
                ('johndoe', 'john@example.com', 'John Doe'),
                ('janesmit', 'jane@example.com', 'Jane Smith'),
                ('bobwilson', 'bob@example.com', 'Bob Wilson'),
                ('alicebrown', 'alice@example.com', 'Alice Brown'),
                ('charliegreen', 'charlie@example.com', 'Charlie Green')
                ON CONFLICT DO NOTHING;
            """))
            
            # Insert products
            await conn.execute(text("""
                INSERT INTO products (name, description, price, category_id, stock_quantity) VALUES
                ('Laptop Computer', 'High-performance laptop for work and gaming', 1299.99, 1, 25),
                ('Smartphone', 'Latest model smartphone with advanced features', 899.99, 1, 50),
                ('Python Programming Book', 'Comprehensive guide to Python programming', 49.99, 2, 100),
                ('T-Shirt', 'Comfortable cotton t-shirt', 19.99, 3, 200),
                ('Garden Tools Set', 'Complete set of garden tools', 89.99, 4, 30),
                ('Wireless Headphones', 'Noise-cancelling wireless headphones', 199.99, 1, 40),
                ('JavaScript Guide', 'Modern JavaScript development guide', 39.99, 2, 75),
                ('Running Shoes', 'Professional running shoes', 129.99, 3, 60)
                ON CONFLICT DO NOTHING;
            """))
            
            # Insert orders
            await conn.execute(text("""
                INSERT INTO orders (user_id, total_amount, status) VALUES
                (1, 1349.98, 'completed'),
                (2, 249.98, 'completed'),
                (3, 89.99, 'pending'),
                (1, 199.99, 'completed'),
                (4, 169.98, 'shipped')
                ON CONFLICT DO NOTHING;
            """))
            
            # Insert order items
            await conn.execute(text("""
                INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
                (1, 1, 1, 1299.99),
                (1, 3, 1, 49.99),
                (2, 4, 2, 19.99),
                (2, 6, 1, 199.99),
                (3, 5, 1, 89.99),
                (4, 6, 1, 199.99),
                (5, 8, 1, 129.99),
                (5, 7, 1, 39.99)
                ON CONFLICT DO NOTHING;
            """))
            
            # Insert reviews
            await conn.execute(text("""
                INSERT INTO reviews (product_id, user_id, rating, comment) VALUES
                (1, 1, 5, 'Excellent laptop, very fast and reliable'),
                (2, 2, 4, 'Great phone, battery life could be better'),
                (3, 1, 5, 'Best Python book I have read'),
                (4, 3, 3, 'Good quality but sizing runs small'),
                (6, 1, 5, 'Amazing sound quality, great for music'),
                (8, 4, 4, 'Very comfortable running shoes')
                ON CONFLICT DO NOTHING;
            """))
            
            logger.info("Sample data inserted successfully")
            
    except Exception as e:
        logger.error(f"Error inserting sample data: {str(e)}")
        raise


async def show_database_info(engine):
    """Show information about the created database."""
    try:
        async with engine.begin() as conn:
            # Get table information
            result = await conn.execute(text("""
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public' 
                ORDER BY table_name;
            """))
            tables = result.fetchall()
            
            logger.info(f"Created {len(tables)} tables:")
            for table in tables:
                logger.info(f"  - {table[0]}")
            
            # Get row counts
            for table in tables:
                table_name = table[0]
                result = await conn.execute(text(f"SELECT COUNT(*) FROM {table_name}"))
                count = result.scalar()
                logger.info(f"  {table_name}: {count} rows")
                
    except Exception as e:
        logger.error(f"Error showing database info: {str(e)}")


async def main():
    """Main function."""
    try:
        logger.info("Setting up test database...")
        await create_test_database()
        
        # Show database info
        async_url = settings.database_url.replace("postgresql://", "postgresql+asyncpg://")
        engine = create_async_engine(async_url)
        await show_database_info(engine)
        await engine.dispose()
        
        print("\n✅ Test database setup completed!")
        print("\nYou can now run the system with:")
        print("python scripts/start_system.py --mode api")
        
    except Exception as e:
        logger.error(f"Setup failed: {str(e)}")
        print(f"\n❌ Setup failed: {str(e)}")
        print("\nPlease check your database configuration in .env file")
        sys.exit(1)


if __name__ == "__main__":
    asyncio.run(main()) 