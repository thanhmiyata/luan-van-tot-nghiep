#!/usr/bin/env python3
"""
Demo script for Multi-Agent Text-to-SQL System
Shows the system capabilities without requiring database setup.
"""

import sys
import os
import asyncio
from pathlib import Path
from datetime import datetime

# Add project root to path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

# Set environment variables
os.environ['OPENAI_API_KEY'] = 'demo_key'
os.environ['ANTHROPIC_API_KEY'] = 'demo_key'
os.environ['DATABASE_URL'] = 'postgresql://demo@localhost:5432/demo_db'
os.environ['DEBUG'] = 'True'
os.environ['LOG_LEVEL'] = 'INFO'

async def demo_message_system():
    """Demonstrate the message passing system."""
    print("🔄 Testing Message System")
    print("-" * 50)
    
    from src.agents.base_agent import Message, MessageType
    from src.core.message_broker import MessageBroker
    
    # Create message broker
    broker = MessageBroker()
    await broker.start()
    
    # Create a test message
    message = Message(
        id="demo-001",
        sender="DemoSender",
        receiver="DemoReceiver",
        message_type=MessageType.REQUEST,
        content={
            "query": "Show me all users from the database",
            "timestamp": datetime.now().isoformat()
        },
        timestamp=datetime.now()
    )
    
    print(f"✅ Created message: {message.id}")
    print(f"   From: {message.sender} → To: {message.receiver}")
    print(f"   Type: {message.message_type.value}")
    print(f"   Content: {message.content}")
    
    # Send message
    await broker.send_message(message)
    print("✅ Message sent successfully")
    
    await broker.stop()
    print("🎉 Message system demo completed!\n")

async def demo_agent_capabilities():
    """Demonstrate agent capabilities without database."""
    print("🤖 Testing Agent Capabilities")
    print("-" * 50)
    
    from src.agents.base_agent import Message, MessageType
    from src.agents.schema_agent import SchemaAgent
    
    # Create schema agent
    agent = SchemaAgent()
    
    print(f"✅ Created Schema Agent: {agent.id}")
    print(f"   Status: {agent.status.value}")
    print(f"   Capabilities: {agent.capabilities}")
    
    # Test agent health
    health = await agent.get_health()
    print(f"✅ Agent Health Check:")
    print(f"   Healthy: {health['healthy']}")
    print(f"   Uptime: {health['uptime_seconds']:.2f}s")
    print(f"   Messages Processed: {health['messages_processed']}")
    
    print("🎉 Agent capabilities demo completed!\n")

async def demo_coordination_system():
    """Demonstrate the agent coordination system."""
    print("🎯 Testing Coordination System")  
    print("-" * 50)
    
    from src.core.agent_coordinator import AgentCoordinator
    from src.agents.schema_agent import SchemaAgent
    
    # Create coordinator
    coordinator = AgentCoordinator()
    
    # Register a demo agent
    schema_agent = SchemaAgent()
    await coordinator.register_agent(schema_agent)
    
    print(f"✅ Registered agent: {schema_agent.id}")
    
    # Get system status
    status = await coordinator.get_system_status()
    print(f"✅ System Status:")
    print(f"   Active Agents: {status['active_agents']}")
    print(f"   Total Workflows: {status['total_workflows']}")
    print(f"   Active Workflows: {status['active_workflows']}")
    
    # List available workflows
    workflows = coordinator.list_available_workflows()
    print(f"✅ Available Workflows: {list(workflows.keys())}")
    
    await coordinator.shutdown()
    print("🎉 Coordination system demo completed!\n")

def demo_api_info():
    """Show API information."""
    print("🌐 API Information")
    print("-" * 50)
    
    try:
        from src.api.main import app
        
        routes = []
        for route in app.routes:
            if hasattr(route, 'methods') and hasattr(route, 'path'):
                methods = list(route.methods) if route.methods else ['GET']
                routes.append(f"{', '.join(methods)} {route.path}")
            elif hasattr(route, 'path'):
                routes.append(f"GET {route.path}")
        
        print("✅ Available API Endpoints:")
        for route in sorted(routes):
            print(f"   {route}")
        
        print("\n✅ To start the API server:")
        print("   uvicorn src.api.main:app --host 0.0.0.0 --port 8000 --reload")
        print("\n✅ Then visit:")
        print("   http://localhost:8000/docs (Swagger UI)")
        print("   http://localhost:8000/redoc (ReDoc)")
        
    except Exception as e:
        print(f"❌ Error loading API info: {str(e)}")
    
    print("🎉 API information demo completed!\n")

async def main():
    """Run all demos."""
    print("🚀 Multi-Agent Text-to-SQL System Demo")
    print("=" * 60)
    print("This demo showcases the system capabilities without requiring")
    print("a database connection or LLM API keys.\n")
    
    try:
        # Run async demos
        await demo_message_system()
        await demo_agent_capabilities()
        await demo_coordination_system()
        
        # Run sync demo
        demo_api_info()
        
        print("✅ All demos completed successfully!")
        print("\n🎯 Next Steps:")
        print("1. Install asyncpg for database support:")
        print("   pip install asyncpg")
        print("\n2. Set up a real PostgreSQL database:")
        print("   createdb your_database_name")
        print("\n3. Configure environment variables:")
        print("   Copy test.env to .env and update values")
        print("\n4. Add LLM API keys for full functionality:")
        print("   - OpenAI API Key")
        print("   - Anthropic API Key")
        print("\n5. Start the system:")
        print("   uvicorn src.api.main:app --reload")
        
    except Exception as e:
        print(f"❌ Demo error: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    asyncio.run(main()) 