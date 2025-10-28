"""
Simple benchmark script cho Multi-Agent SQL System
Chạy test với 3 models và dataset mẫu
"""

from src.utils.metrics import MetricsCalculator
from src.utils.data_loader import DataLoader
from src.models.model_6_step import Model6Step
from src.models.model_4_step import Model4Step
from src.models.model_3_step import Model3Step
from src.core.models import NLQuestion, DatabaseSchema, ModelType
import sys
import json
import time
from pathlib import Path
from datetime import datetime
from loguru import logger

# Add project root to path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))


# Configure logging
log_file = project_root / "logs" / \
    f"benchmark_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
log_file.parent.mkdir(exist_ok=True)
logger.add(log_file, rotation="10 MB", level="INFO")


def load_test_data(num_questions: int = 10):
    """Load test questions and schema"""
    print(f"[*] Loading test data ({num_questions} questions)...")

    # Load questions from train_spider.json
    questions_file = project_root / "train_spider.json"
    tables_file = project_root.parent / "experiments" / \
        "test-suite-sql-eval" / "tables.json"

    try:
        if questions_file.exists():
            with open(questions_file, 'r', encoding='utf-8') as f:
                data = json.load(f)

            # Get first N questions from first database
            if data:
                # Find most common db_id
                db_ids = [item.get('db_id', '') for item in data]
                from collections import Counter
                most_common_db = Counter(db_ids).most_common(1)[0][0]

                # Filter questions for this database
                filtered_data = [item for item in data if item.get(
                    'db_id') == most_common_db][:num_questions]

                questions = []
                for i, item in enumerate(filtered_data):
                    questions.append(NLQuestion(
                        question=item.get('question', ''),
                        db_id=item.get('db_id', ''),
                        question_id=str(i)
                    ))

                # Load schema
                if tables_file.exists():
                    schema = DataLoader.load_database_schema(
                        str(tables_file), most_common_db)
                else:
                    # Create sample schema
                    print("[WARN] Using sample schema (tables.json not found)")
                    schema = create_sample_schema()

                print(
                    f"[OK] Loaded {len(questions)} questions for database: {most_common_db}")
                return questions, schema

        # Fallback to sample data
        print("[WARN] Using sample data (train_spider.json not found)")
        return create_sample_data(num_questions)

    except Exception as e:
        print(f"[ERROR] Failed to load data: {e}")
        logger.error(f"Failed to load data: {e}")
        return create_sample_data(num_questions)


def create_sample_data(num_questions: int = 5):
    """Create sample questions and schema for testing"""
    questions, schema = DataLoader.create_sample_dataset(num_questions)
    print(f"[OK] Created {len(questions)} sample questions")
    return questions, schema


def create_sample_schema():
    """Create a minimal sample schema"""
    return DatabaseSchema(
        db_id="sample",
        table_names_original=["student", "instructor"],
        column_names_original=[
            [0, "id"], [0, "name"],
            [1, "id"], [1, "name"]
        ],
        column_types=["text", "text", "text", "text"]
    )


def run_benchmark(model, model_name: str, questions: list, schema: DatabaseSchema):
    """Run benchmark for a single model"""
    print(f"\n{'='*60}")
    print(f"Testing: {model_name}")
    print(f"{'='*60}")

    results = []
    start_time = time.time()

    for i, question in enumerate(questions, 1):
        print(f"[{i}/{len(questions)}] {question.question[:50]}...", end=" ")

        try:
            result = model.process(question, schema)

            if result.final_sql and not result.error:
                print(f"OK ({result.execution_time:.2f}s)")
            else:
                print(
                    f"FAIL ({result.error[:30] if result.error else 'No SQL'})")

            results.append(result)

        except Exception as e:
            print(f"ERROR: {str(e)[:30]}")
            logger.error(f"Question {i} failed: {e}")

    total_time = time.time() - start_time

    # Calculate metrics
    success_count = len([r for r in results if r.final_sql and not r.error])
    total_api_calls = sum(r.api_calls for r in results)
    avg_time = total_time / len(questions) if questions else 0

    print(f"\n[SUMMARY] {model_name}")
    print(
        f"  Success: {success_count}/{len(questions)} ({success_count/len(questions)*100:.1f}%)")
    print(f"  Total time: {total_time:.2f}s")
    print(f"  Avg time/question: {avg_time:.2f}s")
    print(f"  Total API calls: {total_api_calls}")
    print(f"  Avg API calls: {total_api_calls/len(questions):.1f}")

    return results


def compare_results(all_results: dict):
    """Compare results from all models"""
    print(f"\n{'='*60}")
    print("COMPARISON SUMMARY")
    print(f"{'='*60}")
    print(f"{'Model':<20} {'Success':<10} {'Avg Time':<12} {'Avg API':<10}")
    print(f"{'-'*60}")

    for model_name, results in all_results.items():
        if results:
            success_rate = len(
                [r for r in results if r.final_sql and not r.error]) / len(results)
            avg_time = sum(r.execution_time for r in results) / len(results)
            avg_api = sum(r.api_calls for r in results) / len(results)

            print(
                f"{model_name:<20} {success_rate:>7.1%}   {avg_time:>8.2f}s    {avg_api:>6.1f}")


def save_results(all_results: dict, output_dir: Path):
    """Save benchmark results to files"""
    output_dir.mkdir(exist_ok=True)
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')

    for model_name, results in all_results.items():
        # Save SQL predictions
        sql_file = output_dir / \
            f"predict_{model_name.replace(' ', '_')}_{timestamp}.sql"
        with open(sql_file, 'w', encoding='utf-8') as f:
            for result in results:
                f.write((result.final_sql or "SELECT 1;") + "\n")

        print(f"[SAVED] {sql_file}")


def main():
    """Main benchmark function"""
    print("="*60)
    print("Multi-Agent SQL System - Simple Benchmark")
    print("="*60)

    # Load test data
    questions, schema = load_test_data(num_questions=10)

    print(f"\n[SETUP]")
    print(f"  Database: {schema.db_id}")
    print(f"  Tables: {len(schema.table_names_original)}")
    print(f"  Questions: {len(questions)}")

    # Initialize models
    models = {
        "3-Step Lightweight": Model3Step(),
        "4-Step Balanced": Model4Step(),
        "6-Step Enhanced": Model6Step()
    }

    # Run benchmarks
    all_results = {}

    for model_name, model in models.items():
        try:
            results = run_benchmark(model, model_name, questions, schema)
            all_results[model_name] = results
        except Exception as e:
            print(f"[ERROR] {model_name} failed: {e}")
            logger.error(f"{model_name} failed completely: {e}")

    # Compare results
    if all_results:
        compare_results(all_results)

        # Save results
        output_dir = project_root / "output"
        save_results(all_results, output_dir)

    print(f"\n[COMPLETE] Benchmark finished!")
    print(f"[LOG] Check {log_file} for details")


if __name__ == "__main__":
    main()
