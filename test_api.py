#!/usr/bin/env python3
"""
Simple API test script for the Multi-Agent Text-to-SQL system.
"""

import sys
import os
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent  
sys.path.insert(0, str(project_root))

# Set environment variables
os.environ['OPENAI_API_KEY'] = 'test_key'
os.environ['ANTHROPIC_API_KEY'] = 'test_key'
os.environ['DATABASE_URL'] = f'postgresql://{os.getenv("USER", "postgres")}@localhost:5432/text2sql_db'
os.environ['DEBUG'] = 'True'
os.environ['LOG_LEVEL'] = 'INFO'

def test_api_import():
    """Test if the API can be imported and basic routes work."""
    try:
        from src.api.main import app
        print("✅ API app imported successfully")
        
        # Test route existence
        routes = [route.path for route in app.routes]
        print(f"Available routes: {routes}")
        
        return True
    except Exception as e:
        print(f"❌ API import error: {str(e)}")
        return False

def main():
    """Run API test."""
    print("🚀 Testing Multi-Agent Text-to-SQL API\n")
    
    if test_api_import():
        print("\n✅ API is ready!")
        print("\nTo start the server, run:")
        print("uvicorn src.api.main:app --host 0.0.0.0 --port 8000 --reload")
        print("\nThen test with:")
        print("curl http://localhost:8000/health")
        print("curl http://localhost:8000/docs")
    else:
        print("\n❌ API test failed")
        sys.exit(1)

if __name__ == "__main__":
    main() 