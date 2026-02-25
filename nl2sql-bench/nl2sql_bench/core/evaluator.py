"""
Evaluator class for NL2SQL-Bench.

This module provides the main evaluation orchestrator that runs NL2SQL systems
against benchmark datasets and computes standardized metrics.
"""

import json
import os
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional, Union

from pydantic import BaseModel, Field

from nl2sql_bench.core.base import NL2SQLInput, NL2SQLOutput, NL2SQLSystem
from nl2sql_bench.datasets.spider import SpiderDataset
from nl2sql_bench.metrics.exact_match import compute_exact_match
from nl2sql_bench.metrics.execution import exec_match, exec_match_with_details


class DifficultyMetrics(BaseModel):
    """Metrics breakdown by difficulty level."""
    
    total: int = Field(default=0, description="Total questions at this difficulty")
    exact_match: float = Field(default=0.0, description="Exact match accuracy")
    execution_accuracy: float = Field(default=0.0, description="Execution accuracy")
    em_correct: int = Field(default=0, description="Number of EM correct")
    ex_correct: int = Field(default=0, description="Number of EX correct")


class ErrorDetail(BaseModel):
    """Details about a single evaluation error."""
    
    index: int = Field(..., description="Question index")
    question: str = Field(..., description="Natural language question")
    db_id: str = Field(..., description="Database identifier")
    gold_sql: str = Field(..., description="Gold SQL query")
    pred_sql: str = Field(..., description="Predicted SQL query")
    difficulty: str = Field(default="unknown", description="Question difficulty")
    em_match: bool = Field(default=False, description="Exact match result")
    ex_match: bool = Field(default=False, description="Execution match result")
    error_message: Optional[str] = Field(None, description="Error during prediction")


class EvaluationResult(BaseModel):
    """
    Complete evaluation results.
    
    Contains overall metrics, per-difficulty breakdown, and error details.
    """
    
    total: int = Field(..., description="Total number of questions evaluated")
    exact_match: float = Field(..., description="Overall exact match accuracy")
    execution_accuracy: float = Field(..., description="Overall execution accuracy")
    
    by_difficulty: Dict[str, DifficultyMetrics] = Field(
        default_factory=dict,
        description="Metrics breakdown by difficulty level"
    )
    
    errors: List[ErrorDetail] = Field(
        default_factory=list,
        description="Details of incorrect predictions"
    )
    
    metadata: Dict[str, Any] = Field(
        default_factory=dict,
        description="Evaluation metadata (system name, timestamp, etc.)"
    )
    
    def summary(self) -> str:
        """Generate human-readable summary."""
        lines = [
            "",
            "=" * 60,
            "NL2SQL-Bench Evaluation Results",
            "=" * 60,
            f"System: {self.metadata.get('system_name', 'Unknown')} "
            f"v{self.metadata.get('system_version', '?')}",
            f"Dataset: {self.metadata.get('dataset', 'Unknown')} "
            f"({self.total} questions)",
            f"Timestamp: {self.metadata.get('timestamp', 'Unknown')}",
            "",
            "OVERALL METRICS",
            "-" * 40,
            f"  Exact Match:        {self.exact_match:.1%}",
            f"  Execution Accuracy: {self.execution_accuracy:.1%}",
            "",
        ]
        
        if self.by_difficulty:
            lines.append("BY DIFFICULTY")
            lines.append("-" * 40)
            for diff, metrics in sorted(self.by_difficulty.items()):
                lines.append(
                    f"  {diff.capitalize():8s}: {metrics.exact_match:.1%} EM | "
                    f"{metrics.execution_accuracy:.1%} EX ({metrics.total} questions)"
                )
            lines.append("")
        
        lines.append("=" * 60)
        return "\n".join(lines)
    
    def to_json(self, path: Union[str, Path]) -> None:
        """Save results to JSON file."""
        with open(path, "w", encoding="utf-8") as f:
            f.write(self.model_dump_json(indent=2))


class Evaluator:
    """
    Main evaluator for NL2SQL systems.
    
    Orchestrates the evaluation process:
    1. Iterates through dataset
    2. Calls system.predict() for each input
    3. Computes EM and EX metrics
    4. Aggregates results by difficulty
    5. Saves results
    
    Example:
        ```python
        dataset = SpiderDataset(data_dir="./spider", split="dev")
        evaluator = Evaluator(dataset=dataset, db_dir="./spider/database")
        
        results = evaluator.run(my_system, verbose=True)
        print(results.summary())
        results.to_json("results/my_system.json")
        ```
    
    Attributes:
        dataset: SpiderDataset instance.
        db_dir: Path to database directory.
        output_dir: Path to save results.
    """
    
    def __init__(
        self,
        dataset: SpiderDataset,
        db_dir: Union[str, Path],
        output_dir: Union[str, Path] = "results/",
    ):
        """
        Initialize evaluator.
        
        Args:
            dataset: SpiderDataset instance to evaluate on.
            db_dir: Path to directory containing SQLite databases.
            output_dir: Path to save evaluation results.
        """
        self.dataset = dataset
        self.db_dir = Path(db_dir)
        self.output_dir = Path(output_dir)
        
        # Ensure output directory exists
        self.output_dir.mkdir(parents=True, exist_ok=True)
    
    def run(
        self,
        system: NL2SQLSystem,
        verbose: bool = True,
        save_results: bool = True,
        timeout_seconds: int = 30,
        max_questions: Optional[int] = None,
    ) -> EvaluationResult:
        """
        Run evaluation on the given NL2SQL system.
        
        Args:
            system: NL2SQL system implementing predict() method.
            verbose: Print progress information.
            save_results: Save results to output_dir.
            timeout_seconds: Timeout for SQL execution.
            max_questions: Maximum questions to evaluate (for testing).
            
        Returns:
            EvaluationResult with complete metrics and error details.
        """
        # Initialize counters
        total = min(len(self.dataset), max_questions or len(self.dataset))
        em_correct = 0
        ex_correct = 0
        errors: List[ErrorDetail] = []
        
        # Per-difficulty tracking
        difficulty_stats: Dict[str, Dict[str, int]] = {}
        
        if verbose:
            print(f"\nEvaluating {system.name} v{system.version}")
            print(f"Dataset: {self.dataset.split} ({total} questions)")
            print("-" * 50)
        
        # Iterate through dataset
        for idx in range(total):
            # Get input and gold SQL
            nl2sql_input = self.dataset.get_input(idx)
            gold_sql = self.dataset.get_gold_sql(idx)
            difficulty = self.dataset.get_difficulty(idx)
            
            # Initialize difficulty stats
            if difficulty not in difficulty_stats:
                difficulty_stats[difficulty] = {
                    "total": 0, "em_correct": 0, "ex_correct": 0
                }
            difficulty_stats[difficulty]["total"] += 1
            
            # Run prediction
            error_msg = None
            try:
                output = system.predict(nl2sql_input)
                pred_sql = output.sql
                if output.error:
                    error_msg = output.error
            except Exception as e:
                pred_sql = ""
                error_msg = str(e)
            
            # Compute metrics
            em_match = compute_exact_match(pred_sql, gold_sql) if pred_sql else False
            
            # Get database path for execution
            db_path = self.db_dir / nl2sql_input.db_id / f"{nl2sql_input.db_id}.sqlite"
            
            ex_match = False
            if pred_sql and db_path.exists():
                ex_match = exec_match(
                    pred_sql, gold_sql, str(db_path), timeout_seconds
                )
            
            # Update counters
            if em_match:
                em_correct += 1
                difficulty_stats[difficulty]["em_correct"] += 1
            if ex_match:
                ex_correct += 1
                difficulty_stats[difficulty]["ex_correct"] += 1
            
            # Record errors (EM or EX failure)
            if not em_match or not ex_match:
                errors.append(ErrorDetail(
                    index=idx,
                    question=nl2sql_input.question,
                    db_id=nl2sql_input.db_id,
                    gold_sql=gold_sql,
                    pred_sql=pred_sql,
                    difficulty=difficulty,
                    em_match=em_match,
                    ex_match=ex_match,
                    error_message=error_msg,
                ))
            
            # Progress reporting
            if verbose and (idx + 1) % 100 == 0:
                current_em = em_correct / (idx + 1)
                current_ex = ex_correct / (idx + 1)
                print(f"  Progress: {idx + 1}/{total} | EM: {current_em:.1%} | EX: {current_ex:.1%}")
        
        # Compute final metrics
        overall_em = em_correct / total if total > 0 else 0.0
        overall_ex = ex_correct / total if total > 0 else 0.0
        
        # Build difficulty breakdown
        by_difficulty: Dict[str, DifficultyMetrics] = {}
        for diff, stats in difficulty_stats.items():
            diff_total = stats["total"]
            by_difficulty[diff] = DifficultyMetrics(
                total=diff_total,
                exact_match=stats["em_correct"] / diff_total if diff_total > 0 else 0.0,
                execution_accuracy=stats["ex_correct"] / diff_total if diff_total > 0 else 0.0,
                em_correct=stats["em_correct"],
                ex_correct=stats["ex_correct"],
            )
        
        # Build result
        result = EvaluationResult(
            total=total,
            exact_match=overall_em,
            execution_accuracy=overall_ex,
            by_difficulty=by_difficulty,
            errors=errors,
            metadata={
                "system_name": system.name,
                "system_version": system.version,
                "dataset": f"Spider {self.dataset.split}",
                "timestamp": datetime.now().isoformat(),
                "timeout_seconds": timeout_seconds,
            }
        )
        
        if verbose:
            print(result.summary())
        
        # Save results
        if save_results:
            output_path = self.output_dir / f"{system.name}_{self.dataset.split}.json"
            result.to_json(output_path)
            if verbose:
                print(f"\nResults saved to: {output_path}")
        
        return result
    
    def run_comparison(
        self,
        systems: List[NL2SQLSystem],
        verbose: bool = True,
    ) -> Dict[str, EvaluationResult]:
        """
        Run evaluation on multiple systems for comparison.
        
        Args:
            systems: List of NL2SQL systems to evaluate.
            verbose: Print progress information.
            
        Returns:
            Dictionary mapping system name to EvaluationResult.
        """
        results = {}
        
        for system in systems:
            if verbose:
                print(f"\n{'='*60}")
                print(f"Evaluating: {system.name}")
                print(f"{'='*60}")
            
            result = self.run(system, verbose=verbose)
            results[system.name] = result
        
        # Print comparison summary
        if verbose and len(systems) > 1:
            print(f"\n{'='*60}")
            print("COMPARISON SUMMARY")
            print(f"{'='*60}")
            print(f"{'System':<30} {'EM':>10} {'EX':>10}")
            print("-" * 52)
            for name, result in sorted(
                results.items(), 
                key=lambda x: x[1].execution_accuracy, 
                reverse=True
            ):
                print(f"{name:<30} {result.exact_match:>9.1%} {result.execution_accuracy:>9.1%}")
        
        return results
