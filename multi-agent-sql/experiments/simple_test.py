"""
Simple test script to verify the Multi-Agent SQL system works
"""

from loguru import logger
from src.core.models import NLQuestion, DatabaseSchema, ModelType
from src.models.model_3_step import Model3Step
from src.models.model_4_step import Model4Step
from src.models.model_6_step import Model6Step
import time
import sys
import os
from pathlib import Path

# Add project root to Python path FIRST
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

# Now import our modules


# Configure logging
logger.add("logs/simple_test.log", rotation="10 MB", level="INFO")


def create_sample_schema() -> DatabaseSchema:
    """Create a simple sample database schema for testing"""
    return DatabaseSchema(
        db_id="university",
        table_names_original=["student", "instructor",
                              "course", "takes", "teaches"],
        column_names_original=[
            [0, "id"],
            [0, "name"],
            [0, "dept_name"],
            [1, "id"],
            [1, "name"],
            [1, "dept_name"],
            [1, "salary"],
            [2, "course_id"],
            [2, "title"],
            [2, "dept_name"],
            [2, "credits"],
            [3, "student_id"],
            [3, "course_id"],
            [3, "semester"],
            [3, "year"],
            [3, "grade"],
            [4, "instructor_id"],
            [4, "course_id"],
            [4, "semester"],
            [4, "year"]
        ],
        column_types=[
            "text", "text", "text",  # student
            "text", "text", "text", "number",  # instructor
            "text", "text", "text", "number",  # course
            "text", "text", "text", "number", "text",  # takes
            "text", "text", "text", "number"  # teaches
        ]
    )


def create_sample_questions() -> list[NLQuestion]:
    """Create sample questions for testing"""
    return [
        NLQuestion(
            question="What are the names of all students?",
            db_id="university",
            question_id="q1"
        ),
        NLQuestion(
            question="How many instructors are there?",
            db_id="university",
            question_id="q2"
        ),
        NLQuestion(
            question="What is the average salary of instructors?",
            db_id="university",
            question_id="q3"
        ),
        NLQuestion(
            question="List all courses taught by instructors in the Computer Science department",
            db_id="university",
            question_id="q4"
        ),
        NLQuestion(
            question="Find students who have taken more than 3 courses",
            db_id="university",
            question_id="q5"
        )
    ]


def test_model(model, model_name: str, questions: list[NLQuestion], schema: DatabaseSchema):
    """Test a single model with sample questions"""
    logger.info(f"Testing {model_name}")
    print(f"\n🧪 Testing {model_name}")
    print("=" * 50)

    results = []
    total_time = 0
    total_api_calls = 0

    for i, question in enumerate(questions, 1):
        print(f"\n📝 Question {i}: {question.question}")

        try:
            start_time = time.time()
            result = model.process(question, schema)
            end_time = time.time()

            execution_time = end_time - start_time
            total_time += execution_time
            total_api_calls += result.api_calls

            print(f"✅ SQL: {result.final_sql}")
            print(f"⏱️  Time: {execution_time:.2f}s")
            print(f"🔄 API Calls: {result.api_calls}")

            if result.error:
                print(f"⚠️  Error: {result.error}")

            results.append(result)

        except Exception as e:
            print(f"❌ Failed: {e}")
            logger.error(
                f"Failed to process question {i} with {model_name}: {e}")

    # Summary
    success_count = len([r for r in results if r.final_sql and not r.error])
    print(f"\n📊 {model_name} Summary:")
    print(f"   • Success: {success_count}/{len(questions)} questions")
    print(f"   • Total time: {total_time:.2f}s")
    print(f"   • Avg time/question: {total_time/len(questions):.2f}s")
    print(f"   • Total API calls: {total_api_calls}")
    print(f"   • Avg API calls/question: {total_api_calls/len(questions):.1f}")

    return results


def main():
    """Main test function"""
    print("🚀 Multi-Agent SQL System - Simple Test")
    print("=" * 60)

    # Create test data
    schema = create_sample_schema()
    questions = create_sample_questions()

    print(f"📋 Test Setup:")
    print(f"   • Database: {schema.db_id}")
    print(f"   • Tables: {len(schema.table_names_original)}")
    print(f"   • Questions: {len(questions)}")

    # Initialize models
    try:
        model_3 = Model3Step()
        model_4 = Model4Step()
        model_6 = Model6Step()

        models = [
            (model_3, "3-Step Lightweight"),
            (model_4, "4-Step Balanced"),
            (model_6, "6-Step Enhanced")
        ]

        all_results = {}

        # Test each model
        for model, name in models:
            try:
                results = test_model(model, name, questions, schema)
                all_results[name] = results
            except Exception as e:
                print(f"❌ {name} failed completely: {e}")
                logger.error(f"{name} failed: {e}")

        # Final comparison
        print(f"\n📈 FINAL COMPARISON")
        print("=" * 60)
        print("| Model        | Success | Avg Time | Avg API | Status |")
        print("|--------------|---------|----------|---------|--------|")

        for name, results in all_results.items():
            if results:
                success_rate = len(
                    [r for r in results if r.final_sql and not r.error]) / len(results)
                avg_time = sum(
                    r.execution_time for r in results) / len(results)
                avg_api = sum(r.api_calls for r in results) / len(results)
                status = "✅ OK" if success_rate > 0.5 else "⚠️  Issues"

                print(
                    f"| {name:12} | {success_rate:5.1%}   | {avg_time:6.2f}s | {avg_api:5.1f}   | {status:6} |")

        print("\n✅ Test completed! Check logs/simple_test.log for details.")

    except Exception as e:
        print(f"❌ Test setup failed: {e}")
        logger.error(f"Test setup failed: {e}")


if __name__ == "__main__":
    main()
