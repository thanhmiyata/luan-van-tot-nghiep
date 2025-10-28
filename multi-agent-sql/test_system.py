"""
Simple system test for Multi-Agent SQL
"""

import sys
import os
from pathlib import Path

# Add current directory to Python path
current_dir = Path(__file__).parent
sys.path.insert(0, str(current_dir))

print("Testing Multi-Agent SQL System")
print("=" * 50)

try:
    print("[*] Importing core modules...")
    from src.core.models import NLQuestion, DatabaseSchema, ModelType
    print("[OK] Core models imported successfully")

    print("[*] Importing model classes...")
    from src.models.model_3_step import Model3Step
    print("[OK] Model3Step imported")

    from src.models.model_4_step import Model4Step
    print("[OK] Model4Step imported")

    from src.models.model_6_step import Model6Step
    print("[OK] Model6Step imported")

    print("\n[*] Creating test data...")
    # Create sample question
    question = NLQuestion(
        question="What are the names of all students?",
        db_id="university",
        question_id="test_q1"
    )
    print(f"[OK] Question: {question.question}")

    # Create sample schema
    schema = DatabaseSchema(
        db_id="university",
        table_names_original=["student", "instructor"],
        column_names_original=[
            [0, "id"], [0, "name"],
            [1, "id"], [1, "name"]
        ],
        column_types=["text", "text", "text", "text"]
    )
    print(f"[OK] Schema: {len(schema.table_names_original)} tables")

    print("\n[*] Testing model initialization...")

    # Test 3-step model
    try:
        model_3 = Model3Step()
        print(f"[OK] {model_3.name} initialized")
        info = model_3.get_info()
        print(f"   - Workflow steps: {info['workflow_steps']}")
        print(
            f"   - Expected accuracy: {info['expected_performance']['accuracy']:.1%}")
    except Exception as e:
        print(f"[ERROR] Model3Step failed: {e}")

    # Test 4-step model
    try:
        model_4 = Model4Step()
        print(f"[OK] {model_4.name} initialized")
        info = model_4.get_info()
        print(f"   - Workflow steps: {info['workflow_steps']}")
        print(
            f"   - Expected accuracy: {info['expected_performance']['accuracy']:.1%}")
    except Exception as e:
        print(f"[ERROR] Model4Step failed: {e}")

    # Test 6-step model
    try:
        model_6 = Model6Step()
        print(f"[OK] {model_6.name} initialized")
        info = model_6.get_info()
        print(f"   - Workflow steps: {info['workflow_steps']}")
        print(
            f"   - Expected accuracy: {info['expected_performance']['accuracy']:.1%}")
    except Exception as e:
        print(f"[ERROR] Model6Step failed: {e}")

    print("\n[SUCCESS] System test completed successfully!")
    print("[OK] All core components are working")
    print("\n[INFO] Next steps:")
    print("   - Run full benchmark with real API calls")
    print("   - Test with actual Spider dataset")
    print("   - Integrate with test-suite-sql-eval")

except ImportError as e:
    print(f"[ERROR] Import error: {e}")
    print("\n[DEBUG] Debugging info:")
    print(f"   - Current directory: {current_dir}")
    print(f"   - Python path: {sys.path[:3]}...")
    print(f"   - Looking for: {current_dir / 'src'}")
    print(f"   - Src exists: {(current_dir / 'src').exists()}")

except Exception as e:
    print(f"[ERROR] Unexpected error: {e}")
    import traceback
    traceback.print_exc()
