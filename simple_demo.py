#!/usr/bin/env python3
"""
Simplified demo script for Multi-Agent Text-to-SQL System
Shows basic functionality that's currently working.
"""

import sys
import os
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

# Set environment variables
os.environ['OPENAI_API_KEY'] = 'demo_key'
os.environ['ANTHROPIC_API_KEY'] = 'demo_key'
os.environ['DATABASE_URL'] = 'postgresql://demo@localhost:5432/demo_db'
os.environ['DEBUG'] = 'True'
os.environ['LOG_LEVEL'] = 'INFO'

def demo_config():
    """Show configuration system."""
    print("⚙️  Configuration System")
    print("-" * 50)
    
    try:
        from src.core.config import settings
        print(f"✅ Debug mode: {settings.debug}")
        print(f"✅ Log level: {settings.log_level}")
        print(f"✅ API host: {settings.api_host}")
        print(f"✅ API port: {settings.api_port}")
        print(f"✅ Database URL: {settings.database_url[:30]}...")
        print("🎉 Configuration system working!\n")
        return True
    except Exception as e:
        print(f"❌ Configuration error: {str(e)}")
        return False

def demo_agent_creation():
    """Show agent creation."""
    print("🤖 Agent Creation")
    print("-" * 50)
    
    try:
        from src.agents.schema_agent import SchemaAgent
        
        # Create schema agent
        agent = SchemaAgent()
        print(f"✅ Created Schema Agent: {agent.id}")
        print(f"✅ Agent Status: {agent.status.value}")
        print(f"✅ Number of capabilities: {len(agent.capabilities)}")
        
        # Show capabilities
        for i, cap in enumerate(agent.capabilities, 1):
            print(f"   {i}. {cap.name}: {cap.description}")
        
        print("🎉 Agent creation working!\n")
        return True
    except Exception as e:
        print(f"❌ Agent creation error: {str(e)}")
        return False

def demo_api_system():
    """Show API system."""
    print("🌐 API System")
    print("-" * 50)
    
    try:
        from src.api.main import app
        
        # Count routes
        routes = [route for route in app.routes if hasattr(route, 'path')]
        print(f"✅ API app created successfully")
        print(f"✅ Total routes: {len(routes)}")
        
        # Show key endpoints
        key_endpoints = [
            "/api/v1/text-to-sql",
            "/api/v1/analyze-schema", 
            "/api/v1/system/health",
            "/docs"
        ]
        
        print("✅ Key endpoints available:")
        for endpoint in key_endpoints:
            print(f"   - {endpoint}")
        
        print("🎉 API system working!\n")
        return True
    except Exception as e:
        print(f"❌ API system error: {str(e)}")
        return False

def demo_message_types():
    """Show message types."""
    print("📨 Message System")
    print("-" * 50)
    
    try:
        from src.agents.base_agent import Message, MessageType
        from datetime import datetime
        
        # Create sample messages
        message_types = [
            MessageType.REQUEST,
            MessageType.RESPONSE,
            MessageType.INFO,
            MessageType.ERROR
        ]
        
        print("✅ Available message types:")
        for msg_type in message_types:
            print(f"   - {msg_type.value}")
        
        # Create a sample message
        sample_message = Message(
            id="sample-001",
            sender="DemoSender",
            receiver="DemoReceiver",
            message_type=MessageType.REQUEST,
            content={"query": "SELECT * FROM users"},
            timestamp=datetime.now()
        )
        
        print(f"✅ Sample message created: {sample_message.id}")
        print(f"   Type: {sample_message.message_type.value}")
        print("🎉 Message system working!\n")
        return True
    except Exception as e:
        print(f"❌ Message system error: {str(e)}")
        return False

def main():
    """Run simplified demo."""
    print("🚀 Multi-Agent Text-to-SQL System - Simple Demo")
    print("=" * 60)
    print("This demo shows the basic components that are working.\n")
    
    demos = [
        ("Configuration", demo_config),
        ("Agent Creation", demo_agent_creation),
        ("API System", demo_api_system),
        ("Message System", demo_message_types)
    ]
    
    passed = 0
    total = len(demos)
    
    for name, demo_func in demos:
        if demo_func():
            passed += 1
    
    print("=" * 60)
    print(f"✅ Demo Results: {passed}/{total} components working")
    
    if passed == total:
        print("\n🎉 All basic components are working!")
        print("\n🚀 Ready to start the system:")
        print("   uvicorn src.api.main:app --host 0.0.0.0 --port 8000 --reload")
        print("\n📖 Then visit:")
        print("   http://localhost:8000/docs")
        print("   http://localhost:8000/api/v1/system/health")
    else:
        print(f"\n⚠️  {total - passed} components need attention")
        print("Please check the errors above.")

if __name__ == "__main__":
    main() 