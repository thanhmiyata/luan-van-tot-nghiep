"""
Data loading utilities for Multi-Agent SQL system
"""

import json
import sqlite3
from pathlib import Path
from typing import List, Dict, Any, Optional, Tuple
from loguru import logger

from src.core.models import NLQuestion, DatabaseSchema


class DataLoader:
    """Utility class for loading various data formats"""

    @staticmethod
    def load_spider_questions(file_path: str) -> List[NLQuestion]:
        """
        Load questions from Spider dataset format

        Args:
            file_path: Path to the JSON file containing questions

        Returns:
            List of NLQuestion objects
        """
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            questions = []
            for i, item in enumerate(data):
                question = NLQuestion(
                    question=item.get('question', ''),
                    db_id=item.get('db_id', ''),
                    question_id=item.get('question_id', f'q_{i}')
                )
                questions.append(question)

            logger.info(f"Loaded {len(questions)} questions from {file_path}")
            return questions

        except Exception as e:
            logger.error(f"Failed to load questions from {file_path}: {e}")
            raise

    @staticmethod
    def load_database_schema(tables_file: str, db_id: Optional[str] = None) -> DatabaseSchema:
        """
        Load database schema from tables.json format

        Args:
            tables_file: Path to tables.json file
            db_id: Specific database ID to load (if None, loads first available)

        Returns:
            DatabaseSchema object
        """
        try:
            with open(tables_file, 'r', encoding='utf-8') as f:
                tables_data = json.load(f)

            # Find the specified database or use the first one
            db_data = None
            if db_id:
                for db in tables_data:
                    if db.get('db_id') == db_id:
                        db_data = db
                        break
                if not db_data:
                    raise ValueError(
                        f"Database {db_id} not found in {tables_file}")
            else:
                db_data = tables_data[0] if tables_data else None

            if not db_data:
                raise ValueError(f"No database found in {tables_file}")

            schema = DatabaseSchema(
                db_id=db_data['db_id'],
                table_names_original=db_data.get('table_names_original', []),
                column_names_original=db_data.get('column_names_original', []),
                column_types=db_data.get('column_types', []),
                primary_keys=db_data.get('primary_keys', []),
                foreign_keys=db_data.get('foreign_keys', [])
            )

            logger.info(
                f"Loaded schema for database {schema.db_id} with {len(schema.table_names_original)} tables")
            return schema

        except Exception as e:
            logger.error(f"Failed to load schema from {tables_file}: {e}")
            raise

    @staticmethod
    def load_test_dataset(
        questions_file: Path,
        tables_file: Path,
        num_questions: Optional[int] = None,
        db_id: Optional[str] = None
    ) -> Tuple[List[NLQuestion], DatabaseSchema, List[str]]:
        """
        Load complete test dataset (questions + schema + gold queries)

        Args:
            questions_file: Path to questions JSON file
            tables_file: Path to tables.json file  
            num_questions: Number of questions to load (None = all)
            db_id: Specific database ID to use

        Returns:
            Tuple of (questions, schema, gold_queries)
        """
        # Load questions
        with open(questions_file, 'r', encoding='utf-8') as f:
            data = json.load(f)

        # If db_id not specified, use the most common db_id
        if not db_id:
            db_ids = [item.get('db_id', '') for item in data]
            from collections import Counter
            db_id = Counter(db_ids).most_common(1)[0][0]
            logger.info(f"Auto-selected database: {db_id}")

        # Filter questions for the selected database
        filtered_data = [item for item in data if item.get('db_id') == db_id]

        # Limit number of questions if specified
        if num_questions:
            filtered_data = filtered_data[:num_questions]

        # Extract questions and gold queries
        questions = []
        gold_queries = []

        for i, item in enumerate(filtered_data):
            question = NLQuestion(
                question=item.get('question', ''),
                db_id=item.get('db_id', ''),
                question_id=item.get('question_id', str(i))
            )
            questions.append(question)

            # Get gold SQL
            gold_sql = item.get('query', item.get('sql', ''))
            gold_queries.append(gold_sql)

        logger.info(f"Loaded {len(questions)} questions for database {db_id}")

        # Load schema
        schema = DataLoader.load_database_schema(str(tables_file), db_id)

        return questions, schema, gold_queries

    @staticmethod
    def save_results_to_sql_file(results: List[Dict[str, Any]], output_file: str):
        """
        Save pipeline results to SQL file format for evaluation

        Args:
            results: List of pipeline results
            output_file: Output SQL file path
        """
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                for result in results:
                    sql = result.get('final_sql', '').strip()
                    if not sql:
                        sql = "SELECT 1;"  # Placeholder for failed queries
                    f.write(sql + '\n')

            logger.info(f"Saved {len(results)} SQL queries to {output_file}")

        except Exception as e:
            logger.error(f"Failed to save results to {output_file}: {e}")
            raise

    @staticmethod
    def load_gold_sql(gold_file: str) -> List[str]:
        """
        Load gold standard SQL queries

        Args:
            gold_file: Path to gold SQL file

        Returns:
            List of SQL queries
        """
        try:
            with open(gold_file, 'r', encoding='utf-8') as f:
                queries = [line.strip() for line in f if line.strip()]

            logger.info(
                f"Loaded {len(queries)} gold SQL queries from {gold_file}")
            return queries

        except Exception as e:
            logger.error(f"Failed to load gold SQL from {gold_file}: {e}")
            raise

    @staticmethod
    def create_sample_dataset(size: int = 5) -> Tuple[List[NLQuestion], DatabaseSchema]:
        """
        Create a sample dataset for testing

        Args:
            size: Number of sample questions to create

        Returns:
            Tuple of (questions, schema)
        """
        # Sample questions
        sample_questions = [
            "What are the names of all students?",
            "How many instructors are there?",
            "What is the average salary of instructors?",
            "List all courses taught by instructors in the Computer Science department",
            "Find students who have taken more than 3 courses",
            "Which department has the highest average instructor salary?",
            "List all students who have not taken any courses",
            "What is the total number of credits for each student?",
            "Find the course with the most enrollments",
            "List instructors who teach more than 2 courses"
        ]

        questions = []
        for i in range(min(size, len(sample_questions))):
            question = NLQuestion(
                question=sample_questions[i],
                db_id="university",
                question_id=f"sample_q{i+1}"
            )
            questions.append(question)

        # Sample schema
        schema = DatabaseSchema(
            db_id="university",
            table_names_original=["student",
                                  "instructor", "course", "takes", "teaches"],
            column_names_original=[
                [0, "id"], [0, "name"], [0, "dept_name"],  # student
                [1, "id"], [1, "name"], [1, "dept_name"], [
                    1, "salary"],  # instructor
                [2, "course_id"], [2, "title"], [
                    2, "dept_name"], [2, "credits"],  # course
                [3, "student_id"], [3, "course_id"], [
                    3, "semester"], [3, "year"], [3, "grade"],  # takes
                [4, "instructor_id"], [4, "course_id"], [
                    4, "semester"], [4, "year"]  # teaches
            ],
            column_types=[
                "text", "text", "text",  # student
                "text", "text", "text", "number",  # instructor
                "text", "text", "text", "number",  # course
                "text", "text", "text", "number", "text",  # takes
                "text", "text", "text", "number"  # teaches
            ]
        )

        logger.info(f"Created sample dataset with {len(questions)} questions")
        return questions, schema


# Convenience functions
def load_spider_data(questions_file: str, tables_file: str, db_id: Optional[str] = None) -> Tuple[List[NLQuestion], DatabaseSchema]:
    """Convenience function to load Spider data"""
    return DataLoader.load_test_dataset(questions_file, tables_file, db_id)


def load_test_questions(file_path: str) -> List[NLQuestion]:
    """Convenience function to load test questions"""
    return DataLoader.load_spider_questions(file_path)
