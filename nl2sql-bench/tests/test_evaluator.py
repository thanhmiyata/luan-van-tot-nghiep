"""
Unit tests for NL2SQL-Bench.

Run with: pytest tests/test_evaluator.py -v
"""

import json
import os
import tempfile
from pathlib import Path
from typing import List
from unittest.mock import MagicMock, patch

import pytest

from nl2sql_bench.core.base import NL2SQLInput, NL2SQLOutput, NL2SQLSystem
from nl2sql_bench.core.evaluator import Evaluator, EvaluationResult, DifficultyMetrics
from nl2sql_bench.datasets.spider import SpiderDataset
from nl2sql_bench.metrics.exact_match import (
    compute_exact_match,
    normalize_sql,
    extract_tables,
    extract_columns,
)
from nl2sql_bench.metrics.execution import exec_match, compute_execution_accuracy
from nl2sql_bench.analysis.error_taxonomy import (
    ErrorCategory,
    classify_error,
    analyze_errors,
)


# =============================================================================
# Test Fixtures
# =============================================================================

@pytest.fixture
def sample_schema():
    """Sample Spider schema for testing."""
    return {
        "db_id": "test_db",
        "table_names_original": ["users", "orders"],
        "column_names_original": [
            [-1, "*"],
            [0, "user_id"],
            [0, "name"],
            [0, "age"],
            [1, "order_id"],
            [1, "user_id"],
            [1, "amount"],
        ],
        "column_types": ["number", "text", "number", "number", "number", "number"],
        "primary_keys": [1, 4],
        "foreign_keys": [[5, 1]],
    }


@pytest.fixture
def sample_input(sample_schema):
    """Sample NL2SQLInput for testing."""
    return NL2SQLInput(
        question="How many users are there?",
        db_id="test_db",
        schema=sample_schema,
    )


@pytest.fixture
def mock_system():
    """Mock NL2SQL system for testing."""
    class MockSystem(NL2SQLSystem):
        def __init__(self, sql_response: str = "SELECT COUNT(*) FROM users"):
            self._sql_response = sql_response
        
        @property
        def name(self) -> str:
            return "MockSystem"
        
        @property
        def version(self) -> str:
            return "1.0.0"
        
        def predict(self, input: NL2SQLInput) -> NL2SQLOutput:
            return NL2SQLOutput(sql=self._sql_response)
    
    return MockSystem


@pytest.fixture
def temp_spider_data():
    """Create temporary Spider-like dataset structure."""
    with tempfile.TemporaryDirectory() as tmpdir:
        # Create dev.json
        questions = [
            {
                "db_id": "test_db",
                "question": "How many users are there?",
                "query": "SELECT COUNT(*) FROM users",
                "hardness": "easy",
            },
            {
                "db_id": "test_db",
                "question": "What are the names of users older than 25?",
                "query": "SELECT name FROM users WHERE age > 25",
                "hardness": "medium",
            },
        ]
        
        with open(os.path.join(tmpdir, "dev.json"), "w") as f:
            json.dump(questions, f)
        
        # Create tables.json
        tables = [
            {
                "db_id": "test_db",
                "table_names_original": ["users"],
                "column_names_original": [[-1, "*"], [0, "user_id"], [0, "name"], [0, "age"]],
                "column_types": ["number", "text", "number"],
                "primary_keys": [1],
                "foreign_keys": [],
            }
        ]
        
        with open(os.path.join(tmpdir, "tables.json"), "w") as f:
            json.dump(tables, f)
        
        yield tmpdir


# =============================================================================
# Test NL2SQLInput
# =============================================================================

class TestNL2SQLInput:
    """Tests for NL2SQLInput model."""
    
    def test_create_input(self, sample_schema):
        """Test creating NL2SQLInput with required fields."""
        input = NL2SQLInput(
            question="Test question",
            db_id="test_db",
            schema=sample_schema,
        )
        
        assert input.question == "Test question"
        assert input.db_id == "test_db"
        assert input.schema == sample_schema
        assert input.evidence is None
    
    def test_input_with_evidence(self, sample_schema):
        """Test creating NL2SQLInput with optional evidence."""
        input = NL2SQLInput(
            question="Test question",
            db_id="test_db",
            schema=sample_schema,
            evidence="This is a hint",
        )
        
        assert input.evidence == "This is a hint"
    
    def test_input_validation_missing_question(self, sample_schema):
        """Test that missing question raises validation error."""
        with pytest.raises(Exception):  # Pydantic ValidationError
            NL2SQLInput(
                db_id="test_db",
                schema=sample_schema,
            )
    
    def test_input_validation_missing_db_id(self, sample_schema):
        """Test that missing db_id raises validation error."""
        with pytest.raises(Exception):
            NL2SQLInput(
                question="Test question",
                schema=sample_schema,
            )


# =============================================================================
# Test NL2SQLOutput
# =============================================================================

class TestNL2SQLOutput:
    """Tests for NL2SQLOutput model."""
    
    def test_create_output_minimal(self):
        """Test creating output with minimal fields."""
        output = NL2SQLOutput(sql="SELECT * FROM users")
        
        assert output.sql == "SELECT * FROM users"
        assert output.confidence == 1.0  # Default
        assert output.intermediate_steps is None
        assert output.error is None
    
    def test_create_output_full(self):
        """Test creating output with all fields."""
        output = NL2SQLOutput(
            sql="SELECT * FROM users",
            confidence=0.85,
            intermediate_steps=[{"step": "analysis", "output": "done"}],
            error=None,
        )
        
        assert output.confidence == 0.85
        assert len(output.intermediate_steps) == 1
    
    def test_output_confidence_bounds(self):
        """Test that confidence is bounded between 0 and 1."""
        # Valid confidence
        output = NL2SQLOutput(sql="SELECT 1", confidence=0.5)
        assert output.confidence == 0.5
        
        # Edge cases
        output = NL2SQLOutput(sql="SELECT 1", confidence=0.0)
        assert output.confidence == 0.0
        
        output = NL2SQLOutput(sql="SELECT 1", confidence=1.0)
        assert output.confidence == 1.0
    
    def test_output_with_error(self):
        """Test creating output with error message."""
        output = NL2SQLOutput(
            sql="",
            confidence=0.0,
            error="Failed to generate SQL",
        )
        
        assert output.sql == ""
        assert output.error == "Failed to generate SQL"


# =============================================================================
# Test SpiderDataset
# =============================================================================

class TestSpiderDataset:
    """Tests for SpiderDataset loader."""
    
    def test_load_dataset(self, temp_spider_data):
        """Test loading Spider dataset."""
        dataset = SpiderDataset(data_dir=temp_spider_data, split="dev")
        
        assert len(dataset) == 2
    
    def test_get_input(self, temp_spider_data):
        """Test getting NL2SQLInput from dataset."""
        dataset = SpiderDataset(data_dir=temp_spider_data, split="dev")
        input = dataset.get_input(0)
        
        assert isinstance(input, NL2SQLInput)
        assert input.question == "How many users are there?"
        assert input.db_id == "test_db"
    
    def test_get_gold_sql(self, temp_spider_data):
        """Test getting gold SQL."""
        dataset = SpiderDataset(data_dir=temp_spider_data, split="dev")
        gold = dataset.get_gold_sql(0)
        
        assert gold == "SELECT COUNT(*) FROM users"
    
    def test_get_difficulty(self, temp_spider_data):
        """Test getting difficulty level."""
        dataset = SpiderDataset(data_dir=temp_spider_data, split="dev")
        
        assert dataset.get_difficulty(0) == "easy"
        assert dataset.get_difficulty(1) == "medium"
    
    def test_iteration(self, temp_spider_data):
        """Test iterating over dataset."""
        dataset = SpiderDataset(data_dir=temp_spider_data, split="dev")
        
        inputs = list(dataset)
        assert len(inputs) == 2
        assert all(isinstance(inp, NL2SQLInput) for inp in inputs)
    
    def test_summary(self, temp_spider_data):
        """Test dataset summary."""
        dataset = SpiderDataset(data_dir=temp_spider_data, split="dev")
        summary = dataset.summary()
        
        assert summary["total"] == 2
        assert summary["split"] == "dev"
        assert "easy" in summary["by_difficulty"]
    
    def test_invalid_split(self, temp_spider_data):
        """Test that invalid split raises error."""
        with pytest.raises(ValueError, match="Invalid split"):
            SpiderDataset(data_dir=temp_spider_data, split="invalid")
    
    def test_file_not_found(self):
        """Test that missing file raises error."""
        with pytest.raises(FileNotFoundError):
            SpiderDataset(data_dir="/nonexistent/path", split="dev")


# =============================================================================
# Test Metrics
# =============================================================================

class TestExactMatch:
    """Tests for exact match metric."""
    
    def test_identical_sql(self):
        """Test exact match for identical SQL."""
        sql = "SELECT COUNT(*) FROM users"
        assert compute_exact_match(sql, sql) is True
    
    def test_case_insensitive(self):
        """Test that comparison is case-insensitive."""
        pred = "select count(*) from users"
        gold = "SELECT COUNT(*) FROM users"
        assert compute_exact_match(pred, gold) is True
    
    def test_whitespace_normalization(self):
        """Test whitespace normalization."""
        pred = "SELECT   COUNT(*)   FROM   users"
        gold = "SELECT COUNT(*) FROM users"
        assert compute_exact_match(pred, gold) is True
    
    def test_different_columns(self):
        """Test mismatch with different columns."""
        pred = "SELECT name FROM users"
        gold = "SELECT age FROM users"
        assert compute_exact_match(pred, gold) is False
    
    def test_different_tables(self):
        """Test mismatch with different tables."""
        pred = "SELECT * FROM users"
        gold = "SELECT * FROM orders"
        assert compute_exact_match(pred, gold) is False
    
    def test_normalize_sql(self):
        """Test SQL normalization."""
        sql = "  select count(*)  from users;  "
        normalized = normalize_sql(sql)
        assert normalized == "SELECT COUNT(*) FROM USERS"
    
    def test_extract_tables(self):
        """Test table extraction."""
        sql = "SELECT * FROM users JOIN orders ON users.id = orders.user_id"
        tables = extract_tables(normalize_sql(sql))
        assert "USERS" in tables
        assert "ORDERS" in tables


class TestExecutionAccuracy:
    """Tests for execution accuracy metric."""
    
    @pytest.fixture
    def temp_db(self):
        """Create temporary SQLite database."""
        with tempfile.NamedTemporaryFile(suffix=".sqlite", delete=False) as f:
            import sqlite3
            conn = sqlite3.connect(f.name)
            cursor = conn.cursor()
            
            # Create test table
            cursor.execute("""
                CREATE TABLE users (
                    id INTEGER PRIMARY KEY,
                    name TEXT,
                    age INTEGER
                )
            """)
            
            # Insert test data
            cursor.execute("INSERT INTO users VALUES (1, 'Alice', 30)")
            cursor.execute("INSERT INTO users VALUES (2, 'Bob', 25)")
            cursor.execute("INSERT INTO users VALUES (3, 'Charlie', 35)")
            
            conn.commit()
            conn.close()
            
            yield f.name
            
            os.unlink(f.name)
    
    def test_exec_match_identical(self, temp_db):
        """Test execution match for identical queries."""
        sql = "SELECT COUNT(*) FROM users"
        assert exec_match(sql, sql, temp_db) is True
    
    def test_exec_match_equivalent(self, temp_db):
        """Test execution match for equivalent queries."""
        pred = "SELECT COUNT(*) FROM users WHERE age > 20"
        gold = "SELECT COUNT(*) FROM users WHERE age >= 21"
        # Both should return 3 (all users are > 20)
        assert exec_match(pred, gold, temp_db) is True
    
    def test_exec_match_different(self, temp_db):
        """Test execution match for different results."""
        pred = "SELECT COUNT(*) FROM users"
        gold = "SELECT COUNT(*) FROM users WHERE age > 30"
        assert exec_match(pred, gold, temp_db) is False
    
    def test_exec_match_syntax_error(self, temp_db):
        """Test execution match with syntax error."""
        pred = "SELEC COUNT(*) FROM users"  # Typo
        gold = "SELECT COUNT(*) FROM users"
        assert exec_match(pred, gold, temp_db) is False
    
    def test_compute_execution_accuracy(self, temp_db):
        """Test batch execution accuracy computation."""
        predictions = [
            "SELECT COUNT(*) FROM users",
            "SELECT name FROM users WHERE age > 30",
        ]
        golds = [
            "SELECT COUNT(*) FROM users",
            "SELECT name FROM users WHERE age >= 31",  # Equivalent
        ]
        db_paths = [temp_db, temp_db]
        
        accuracy = compute_execution_accuracy(predictions, golds, db_paths)
        assert accuracy == 1.0  # Both should match


# =============================================================================
# Test Error Taxonomy
# =============================================================================

class TestErrorTaxonomy:
    """Tests for error taxonomy classification."""
    
    def test_classify_empty_prediction(self):
        """Test classification of empty prediction."""
        categories = classify_error("", "SELECT * FROM users")
        assert ErrorCategory.EMPTY_RESULT in categories
    
    def test_classify_field_selection_error(self):
        """Test classification of field selection error."""
        pred = "SELECT name FROM users"
        gold = "SELECT name, age FROM users"
        categories = classify_error(pred, gold)
        assert ErrorCategory.FIELD_SELECTION in categories
    
    def test_classify_join_error(self):
        """Test classification of JOIN error."""
        pred = "SELECT * FROM users"
        gold = "SELECT * FROM users JOIN orders ON users.id = orders.user_id"
        categories = classify_error(pred, gold)
        assert ErrorCategory.JOIN_PATH in categories
    
    def test_classify_aggregation_error(self):
        """Test classification of aggregation error."""
        pred = "SELECT COUNT(*) FROM users"
        gold = "SELECT SUM(age) FROM users"
        categories = classify_error(pred, gold)
        assert ErrorCategory.AGGREGATION in categories
    
    def test_classify_group_by_error(self):
        """Test classification of GROUP BY error."""
        pred = "SELECT name, COUNT(*) FROM users"
        gold = "SELECT name, COUNT(*) FROM users GROUP BY name"
        categories = classify_error(pred, gold)
        assert ErrorCategory.GROUP_BY in categories
    
    def test_analyze_errors(self):
        """Test batch error analysis."""
        errors = [
            {"pred_sql": "", "gold_sql": "SELECT * FROM users", "question": "Q1", "db_id": "db1"},
            {"pred_sql": "SELECT name FROM users", "gold_sql": "SELECT age FROM users", "question": "Q2", "db_id": "db1"},
        ]
        
        analysis = analyze_errors(errors)
        
        assert analysis["total_errors"] == 2
        assert "by_category" in analysis
        assert "by_category_percentage" in analysis
        assert "examples" in analysis


# =============================================================================
# Test Evaluator
# =============================================================================

class TestEvaluator:
    """Tests for Evaluator class."""
    
    def test_evaluation_result_model(self):
        """Test EvaluationResult model."""
        result = EvaluationResult(
            total=100,
            exact_match=0.768,
            execution_accuracy=0.840,
            by_difficulty={
                "easy": DifficultyMetrics(total=30, exact_match=0.9, execution_accuracy=0.95),
            },
            errors=[],
            metadata={"system_name": "TestSystem"},
        )
        
        assert result.total == 100
        assert result.exact_match == 0.768
        assert "easy" in result.by_difficulty
    
    def test_evaluation_result_summary(self):
        """Test EvaluationResult summary generation."""
        result = EvaluationResult(
            total=100,
            exact_match=0.768,
            execution_accuracy=0.840,
            by_difficulty={},
            errors=[],
            metadata={"system_name": "TestSystem", "system_version": "1.0"},
        )
        
        summary = result.summary()
        
        assert "TestSystem" in summary
        assert "76.8%" in summary
        assert "84.0%" in summary
    
    @pytest.mark.skip(reason="Requires actual database files")
    def test_evaluator_run(self, temp_spider_data, mock_system):
        """Test full evaluator run."""
        dataset = SpiderDataset(data_dir=temp_spider_data, split="dev")
        
        with tempfile.TemporaryDirectory() as tmpdir:
            evaluator = Evaluator(
                dataset=dataset,
                db_dir=tmpdir,
                output_dir=tmpdir,
            )
            
            system = mock_system()
            results = evaluator.run(system, verbose=False, save_results=False)
            
            assert results.total == 2
            assert 0.0 <= results.exact_match <= 1.0
            assert 0.0 <= results.execution_accuracy <= 1.0


# =============================================================================
# Test System Interface
# =============================================================================

class TestNL2SQLSystem:
    """Tests for NL2SQLSystem base class."""
    
    def test_system_implementation(self, mock_system, sample_input):
        """Test implementing NL2SQLSystem."""
        system = mock_system()
        
        assert system.name == "MockSystem"
        assert system.version == "1.0.0"
        
        output = system.predict(sample_input)
        assert output.sql == "SELECT COUNT(*) FROM users"
    
    def test_system_predict_batch(self, mock_system, sample_input):
        """Test batch prediction."""
        system = mock_system()
        inputs = [sample_input, sample_input]
        
        outputs = system.predict_batch(inputs)
        
        assert len(outputs) == 2
        assert all(o.sql == "SELECT COUNT(*) FROM users" for o in outputs)
    
    def test_system_repr(self, mock_system):
        """Test system string representation."""
        system = mock_system()
        assert "MockSystem" in repr(system)
        assert "1.0.0" in repr(system)


# =============================================================================
# Integration Tests
# =============================================================================

class TestIntegration:
    """Integration tests for the full pipeline."""
    
    def test_full_workflow(self, temp_spider_data, mock_system):
        """Test complete evaluation workflow."""
        # Load dataset
        dataset = SpiderDataset(data_dir=temp_spider_data, split="dev")
        assert len(dataset) == 2
        
        # Create system
        system = mock_system("SELECT COUNT(*) FROM users")
        
        # Get input and predict
        input = dataset.get_input(0)
        output = system.predict(input)
        
        # Check exact match
        gold = dataset.get_gold_sql(0)
        em = compute_exact_match(output.sql, gold)
        
        assert em is True


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
