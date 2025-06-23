#!/usr/bin/env python3
"""
Simple test script for the Multi-Agent Text-to-SQL system basic functionality.
Tests imports and basic class instantiation without database dependencies.
"""

import sys
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

def test_imports():
    """Test if all our modules can be imported."""
    print("Testing imports...")
    
    try:
        # Test core modules
        from src.core.config import settings
        print("✅ Config module imported successfully")
        
        from src.core.logging import logger, setup_logging
        print("✅ Logging module imported successfully")
        
        # Test base agent
        from src.agents.base_agent import BaseAgent, Message, MessageType
        print("✅ Base agent module imported successfully")
        
        # Test schema agent
        from src.agents.schema_agent import SchemaAgent
        print("✅ Schema agent module imported successfully")
        
        # Test message broker
        from src.core.message_broker import MessageBroker
        print("✅ Message broker module imported successfully")
        
        # Test agent coordinator
        from src.core.agent_coordinator import AgentCoordinator
        print("✅ Agent coordinator module imported successfully")
        
        print("\n🎉 All imports successful!")
        return True
        
    except Exception as e:
        print(f"❌ Import error: {str(e)}")
        return False


def test_basic_functionality():
    """Test basic functionality without database."""
    print("\nTesting basic functionality...")
    
    try:
        from src.agents.base_agent import Message, MessageType
        from src.core.message_broker import MessageBroker
        from datetime import datetime
        
        # Test message creation
        message = Message(
            id="test-001",
            sender="TestSender",
            receiver="TestReceiver", 
            message_type=MessageType.REQUEST,
            content={"test": "data"},
            timestamp=datetime.now()
        )
        print("✅ Message creation works")
        
        # Test message broker initialization
        broker = MessageBroker()
        print("✅ Message broker initialization works")
        
        print("\n🎉 Basic functionality test passed!")
        return True
        
    except Exception as e:
        print(f"❌ Functionality test error: {str(e)}")
        return False


def test_configuration():
    """Test configuration loading."""
    print("\nTesting configuration...")
    
    try:
        from src.core.config import settings
        
        print(f"✅ Debug mode: {settings.debug}")
        print(f"✅ Log level: {settings.log_level}")
        print(f"✅ API host: {settings.api_host}")
        print(f"✅ API port: {settings.api_port}")
        
        print("\n🎉 Configuration test passed!")
        return True
        
    except Exception as e:
        print(f"❌ Configuration test error: {str(e)}")
        return False


def main():
    """Run all tests."""
    print("🚀 Starting Multi-Agent Text-to-SQL System Tests\n")
    
    success = True
    
    # Run tests
    success &= test_imports()
    success &= test_basic_functionality() 
    success &= test_configuration()
    
    if success:
        print("\n✅ All tests passed! System is ready for testing.")
        print("\nNext steps:")
        print("1. Install asyncpg: pip install asyncpg")
        print("2. Setup database: python scripts/setup_test_db.py")
        print("3. Run system: python scripts/start_system.py --mode api")
    else:
        print("\n❌ Some tests failed. Please check the errors above.")
        sys.exit(1)


if __name__ == "__main__":
    main() 