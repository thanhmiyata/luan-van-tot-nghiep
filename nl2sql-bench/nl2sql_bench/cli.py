"""
Command-line interface for NL2SQL-Bench.

Provides commands for evaluating NL2SQL systems and analyzing results.

Usage:
    nl2sql-bench evaluate --system mypackage.MySystem --dataset ./spider_data
    nl2sql-bench compare --results results/system1.json results/system2.json
    nl2sql-bench analyze --results results/evaluation.json
"""

import argparse
import importlib
import json
import os
import sys
from pathlib import Path
from typing import List, Optional, Type

from nl2sql_bench.core.base import NL2SQLSystem
from nl2sql_bench.core.evaluator import Evaluator, EvaluationResult
from nl2sql_bench.datasets.spider import SpiderDataset
from nl2sql_bench.analysis.reporter import (
    generate_cli_summary,
    generate_json_report,
    generate_markdown_report,
    compare_results,
)
from nl2sql_bench.analysis.error_taxonomy import analyze_errors


def load_system_class(system_path: str) -> Type[NL2SQLSystem]:
    """
    Load NL2SQLSystem class from module path.
    
    Args:
        system_path: Dotted path to system class (e.g., "mypackage.MySystem")
        
    Returns:
        NL2SQLSystem subclass.
        
    Raises:
        ImportError: If module or class not found.
        TypeError: If class doesn't inherit from NL2SQLSystem.
    """
    parts = system_path.rsplit(".", 1)
    if len(parts) != 2:
        raise ImportError(
            f"Invalid system path: {system_path}. "
            "Expected format: module.ClassName"
        )
    
    module_path, class_name = parts
    
    try:
        module = importlib.import_module(module_path)
    except ImportError as e:
        raise ImportError(f"Failed to import module '{module_path}': {e}")
    
    if not hasattr(module, class_name):
        raise ImportError(f"Class '{class_name}' not found in module '{module_path}'")
    
    cls = getattr(module, class_name)
    
    if not isinstance(cls, type) or not issubclass(cls, NL2SQLSystem):
        raise TypeError(
            f"'{system_path}' is not a subclass of NL2SQLSystem"
        )
    
    return cls


def cmd_evaluate(args: argparse.Namespace) -> int:
    """Execute the evaluate command."""
    print("NL2SQL-Bench Evaluation")
    print("=" * 60)
    
    # Validate dataset path
    if not os.path.exists(args.dataset):
        print(f"Error: Dataset path not found: {args.dataset}")
        return 1
    
    # Load system
    print(f"\nLoading system: {args.system}")
    try:
        system_cls = load_system_class(args.system)
        system = system_cls()
    except (ImportError, TypeError) as e:
        print(f"Error loading system: {e}")
        return 1
    
    print(f"System: {system.name} v{system.version}")
    
    # Load dataset
    print(f"\nLoading dataset from: {args.dataset}")
    try:
        dataset = SpiderDataset(data_dir=args.dataset, split=args.split)
    except FileNotFoundError as e:
        print(f"Error loading dataset: {e}")
        return 1
    
    print(f"Loaded {len(dataset)} questions ({args.split} split)")
    
    # Determine database directory
    db_dir = args.db_dir
    if db_dir is None:
        db_dir = os.path.join(args.dataset, "database")
    
    if not os.path.exists(db_dir):
        print(f"Warning: Database directory not found: {db_dir}")
        print("Execution accuracy cannot be computed without databases.")
    
    # Create output directory
    os.makedirs(args.output, exist_ok=True)
    
    # Initialize evaluator
    evaluator = Evaluator(
        dataset=dataset,
        db_dir=db_dir,
        output_dir=args.output,
    )
    
    # Run evaluation
    print("\n" + "-" * 60)
    print("Starting evaluation...")
    print("-" * 60)
    
    results = evaluator.run(
        system=system,
        verbose=args.verbose,
        max_questions=args.max_questions,
        timeout_seconds=args.timeout,
    )
    
    # Generate reports
    if args.format in ("json", "all"):
        json_path = os.path.join(args.output, f"{system.name}_results.json")
        generate_json_report(results, output_path=json_path)
        print(f"\nJSON report: {json_path}")
    
    if args.format in ("markdown", "all"):
        md_path = os.path.join(args.output, f"{system.name}_results.md")
        generate_markdown_report(results, output_path=md_path)
        print(f"Markdown report: {md_path}")
    
    return 0


def cmd_compare(args: argparse.Namespace) -> int:
    """Execute the compare command."""
    print("NL2SQL-Bench Comparison")
    print("=" * 60)
    
    # Load results
    results = {}
    for result_path in args.results:
        if not os.path.exists(result_path):
            print(f"Error: Result file not found: {result_path}")
            return 1
        
        try:
            with open(result_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            
            # Reconstruct EvaluationResult from JSON
            system_name = data.get("summary", {}).get("system_name", Path(result_path).stem)
            result = EvaluationResult(
                total=data["summary"]["total_questions"],
                exact_match=data["summary"]["exact_match"],
                execution_accuracy=data["summary"]["execution_accuracy"],
                metadata=data.get("metadata", {}),
                by_difficulty={},  # Would need to reconstruct
            )
            results[system_name] = result
            
        except (json.JSONDecodeError, KeyError) as e:
            print(f"Error parsing {result_path}: {e}")
            return 1
    
    # Generate comparison
    if args.format == "markdown":
        print(compare_results(results, output_format="markdown"))
    else:
        print(compare_results(results, output_format="cli"))
    
    return 0


def cmd_analyze(args: argparse.Namespace) -> int:
    """Execute the analyze command."""
    print("NL2SQL-Bench Error Analysis")
    print("=" * 60)
    
    if not os.path.exists(args.results):
        print(f"Error: Result file not found: {args.results}")
        return 1
    
    try:
        with open(args.results, "r", encoding="utf-8") as f:
            data = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        return 1
    
    # Extract errors
    errors = data.get("error_examples", [])
    if not errors:
        print("No error examples found in results file.")
        return 0
    
    # Convert to analysis format
    error_dicts = [
        {
            "pred_sql": e.get("pred_sql", ""),
            "gold_sql": e.get("gold_sql", ""),
            "question": e.get("question", ""),
            "db_id": e.get("db_id", ""),
        }
        for e in errors
    ]
    
    # Run analysis
    analysis = analyze_errors(error_dicts, top_n_examples=args.examples)
    
    # Print results
    print(f"\nTotal errors analyzed: {analysis['total_errors']}")
    print("\nError Categories (sorted by frequency):")
    print("-" * 50)
    
    for cat, count in analysis["by_category"].items():
        if count > 0:
            pct = analysis["by_category_percentage"][cat]
            cat_display = cat.replace("_", " ").upper()
            print(f"  {cat_display:25s}: {count:>4d} ({pct:>5.1%})")
    
    # Show examples if requested
    if args.show_examples:
        print("\n" + "=" * 60)
        print("Example Errors")
        print("=" * 60)
        
        for cat, examples in analysis["examples"].items():
            if examples:
                print(f"\n--- {cat.replace('_', ' ').upper()} ---")
                for i, ex in enumerate(examples[:2], 1):
                    print(f"\n  Example {i}:")
                    print(f"    Question: {ex['question'][:60]}...")
                    print(f"    Gold:     {ex['gold_sql'][:60]}...")
                    print(f"    Pred:     {ex['pred_sql'][:60]}...")
    
    # Save analysis if output specified
    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            json.dump(analysis, f, indent=2, ensure_ascii=False)
        print(f"\nAnalysis saved to: {args.output}")
    
    return 0


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        prog="nl2sql-bench",
        description="NL2SQL-Bench: Evaluation Framework for NL2SQL Systems",
    )
    
    subparsers = parser.add_subparsers(dest="command", help="Available commands")
    
    # =========================================================================
    # Evaluate command
    # =========================================================================
    eval_parser = subparsers.add_parser(
        "evaluate",
        help="Evaluate an NL2SQL system on a dataset",
    )
    eval_parser.add_argument(
        "--system",
        type=str,
        required=True,
        help="Python module path to NL2SQLSystem class (e.g., mypackage.MySystem)",
    )
    eval_parser.add_argument(
        "--dataset",
        type=str,
        required=True,
        help="Path to Spider dataset directory",
    )
    eval_parser.add_argument(
        "--db-dir",
        type=str,
        default=None,
        help="Path to database directory (default: <dataset>/database)",
    )
    eval_parser.add_argument(
        "--split",
        type=str,
        default="dev",
        choices=["dev", "train"],
        help="Dataset split to evaluate (default: dev)",
    )
    eval_parser.add_argument(
        "--output",
        type=str,
        default="./results",
        help="Output directory for results (default: ./results)",
    )
    eval_parser.add_argument(
        "--format",
        type=str,
        default="all",
        choices=["json", "markdown", "all"],
        help="Output format (default: all)",
    )
    eval_parser.add_argument(
        "--max-questions",
        type=int,
        default=None,
        help="Maximum questions to evaluate (for testing)",
    )
    eval_parser.add_argument(
        "--timeout",
        type=int,
        default=30,
        help="SQL execution timeout in seconds (default: 30)",
    )
    eval_parser.add_argument(
        "--verbose",
        action="store_true",
        help="Print verbose progress information",
    )
    eval_parser.set_defaults(func=cmd_evaluate)
    
    # =========================================================================
    # Compare command
    # =========================================================================
    compare_parser = subparsers.add_parser(
        "compare",
        help="Compare results from multiple systems",
    )
    compare_parser.add_argument(
        "--results",
        type=str,
        nargs="+",
        required=True,
        help="Paths to result JSON files",
    )
    compare_parser.add_argument(
        "--format",
        type=str,
        default="cli",
        choices=["cli", "markdown"],
        help="Output format (default: cli)",
    )
    compare_parser.set_defaults(func=cmd_compare)
    
    # =========================================================================
    # Analyze command
    # =========================================================================
    analyze_parser = subparsers.add_parser(
        "analyze",
        help="Analyze errors from evaluation results",
    )
    analyze_parser.add_argument(
        "--results",
        type=str,
        required=True,
        help="Path to evaluation result JSON file",
    )
    analyze_parser.add_argument(
        "--output",
        type=str,
        default=None,
        help="Path to save analysis JSON (optional)",
    )
    analyze_parser.add_argument(
        "--examples",
        type=int,
        default=3,
        help="Number of example errors per category (default: 3)",
    )
    analyze_parser.add_argument(
        "--show-examples",
        action="store_true",
        help="Show example errors in output",
    )
    analyze_parser.set_defaults(func=cmd_analyze)
    
    # =========================================================================
    # Parse and execute
    # =========================================================================
    args = parser.parse_args()
    
    if args.command is None:
        parser.print_help()
        return 0
    
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
