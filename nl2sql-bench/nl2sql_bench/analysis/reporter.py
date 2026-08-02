"""
Report generator for NL2SQL-Bench.

This module provides functions to generate evaluation reports in various formats.
"""

import json
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional, Union

from nl2sql_bench.core.evaluator import EvaluationResult
from nl2sql_bench.analysis.error_taxonomy import (
    ErrorCategory,
    analyze_errors,
    get_category_description,
)


def generate_json_report(
    result: EvaluationResult,
    error_analysis: Optional[Dict[str, Any]] = None,
    output_path: Optional[Union[str, Path]] = None,
    include_examples: bool = True,
) -> str:
    """
    Generate a comprehensive JSON report.
    
    Args:
        result: EvaluationResult from evaluator.
        error_analysis: Optional pre-computed error analysis.
        output_path: Path to save the JSON file. If None, returns JSON string.
        include_examples: Include example errors in report.
        
    Returns:
        Path to saved file (if output_path provided) or JSON string.
        
    Example:
        ```python
        result = evaluator.run(my_system)
        report_path = generate_json_report(result, output_path="report.json")
        ```
    """
    # Build error analysis if not provided
    if error_analysis is None and result.errors:
        error_dicts = [
            {
                "pred_sql": e.pred_sql,
                "gold_sql": e.gold_sql,
                "question": e.question,
                "db_id": e.db_id,
            }
            for e in result.errors
        ]
        error_analysis = analyze_errors(error_dicts)
    
    # Build report structure
    report = {
        "summary": {
            "system_name": result.metadata.get("system_name", "Unknown"),
            "system_version": result.metadata.get("system_version", "Unknown"),
            "dataset": result.metadata.get("dataset", "Unknown"),
            "total_questions": result.total,
            "exact_match": round(result.exact_match, 4),
            "execution_accuracy": round(result.execution_accuracy, 4),
            "timestamp": result.metadata.get("timestamp", datetime.now().isoformat()),
        },
        "by_difficulty": {
            diff: {
                "total": metrics.total,
                "exact_match": round(metrics.exact_match, 4),
                "execution_accuracy": round(metrics.execution_accuracy, 4),
                "em_correct": metrics.em_correct,
                "ex_correct": metrics.ex_correct,
            }
            for diff, metrics in result.by_difficulty.items()
        },
        "error_analysis": error_analysis or {},
        "metadata": result.metadata,
    }
    
    # Optionally include error examples
    if include_examples and result.errors:
        report["error_examples"] = [
            {
                "index": e.index,
                "question": e.question,
                "db_id": e.db_id,
                "difficulty": e.difficulty,
                "gold_sql": e.gold_sql,
                "pred_sql": e.pred_sql,
                "em_match": e.em_match,
                "ex_match": e.ex_match,
                "error_message": e.error_message,
            }
            for e in result.errors[:50]  # Limit to 50 examples
        ]
    
    # Convert to JSON
    json_str = json.dumps(report, indent=2, ensure_ascii=False)
    
    # Save or return
    if output_path:
        output_path = Path(output_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(json_str)
        return str(output_path)
    
    return json_str


def generate_cli_summary(
    result: EvaluationResult,
    error_analysis: Optional[Dict[str, Any]] = None,
    show_top_errors: int = 5,
) -> str:
    """
    Generate a formatted CLI summary report.
    
    Args:
        result: EvaluationResult from evaluator.
        error_analysis: Optional pre-computed error analysis.
        show_top_errors: Number of top error categories to show.
        
    Returns:
        Formatted string for terminal output.
        
    Example:
        ```python
        result = evaluator.run(my_system)
        print(generate_cli_summary(result))
        ```
    """
    # Build error analysis if not provided
    if error_analysis is None and result.errors:
        error_dicts = [
            {
                "pred_sql": e.pred_sql,
                "gold_sql": e.gold_sql,
                "question": e.question,
                "db_id": e.db_id,
            }
            for e in result.errors
        ]
        error_analysis = analyze_errors(error_dicts)
    
    lines = [
        "",
        "=" * 60,
        "         NL2SQL-Bench Evaluation Results",
        "=" * 60,
        "",
        f"System:    {result.metadata.get('system_name', 'Unknown')} "
        f"v{result.metadata.get('system_version', '?')}",
        f"Dataset:   {result.metadata.get('dataset', 'Unknown')} "
        f"({result.total} questions)",
        f"Timestamp: {result.metadata.get('timestamp', 'N/A')}",
        "",
        "-" * 60,
        "OVERALL METRICS",
        "-" * 60,
        "",
        f"  Exact Match:        {result.exact_match:>6.1%}",
        f"  Execution Accuracy: {result.execution_accuracy:>6.1%}",
        "",
    ]
    
    # By difficulty breakdown
    if result.by_difficulty:
        lines.extend([
            "-" * 60,
            "BY DIFFICULTY",
            "-" * 60,
            "",
        ])
        
        # Sort difficulties in standard order
        diff_order = ["easy", "medium", "hard", "extra", "unknown"]
        sorted_diffs = sorted(
            result.by_difficulty.items(),
            key=lambda x: diff_order.index(x[0]) if x[0] in diff_order else 99
        )
        
        for diff, metrics in sorted_diffs:
            lines.append(
                f"  {diff.capitalize():8s}: {metrics.exact_match:>5.1%} EM | "
                f"{metrics.execution_accuracy:>5.1%} EX  ({metrics.total:>4d} questions)"
            )
        lines.append("")
    
    # Error analysis
    if error_analysis and error_analysis.get("top_categories"):
        lines.extend([
            "-" * 60,
            "TOP ERROR CATEGORIES",
            "-" * 60,
            "",
        ])
        
        total_errors = error_analysis.get("total_errors", 0)
        
        for i, cat_info in enumerate(error_analysis["top_categories"][:show_top_errors], 1):
            cat = cat_info["category"]
            count = cat_info["count"]
            pct = cat_info["percentage"]
            
            # Format category name nicely
            cat_display = cat.replace("_", " ").upper()
            lines.append(f"  {i}. {cat_display:20s}: {pct:>5.1%} ({count} errors)")
        
        lines.append("")
        lines.append(f"  Total errors analyzed: {total_errors}")
        lines.append("")
    
    lines.append("=" * 60)
    
    return "\n".join(lines)


def generate_markdown_report(
    result: EvaluationResult,
    error_analysis: Optional[Dict[str, Any]] = None,
    output_path: Optional[Union[str, Path]] = None,
) -> str:
    """
    Generate a Markdown-formatted report.
    
    Args:
        result: EvaluationResult from evaluator.
        error_analysis: Optional pre-computed error analysis.
        output_path: Path to save the Markdown file.
        
    Returns:
        Path to saved file (if output_path provided) or Markdown string.
    """
    # Build error analysis if not provided
    if error_analysis is None and result.errors:
        error_dicts = [
            {
                "pred_sql": e.pred_sql,
                "gold_sql": e.gold_sql,
                "question": e.question,
                "db_id": e.db_id,
            }
            for e in result.errors
        ]
        error_analysis = analyze_errors(error_dicts)
    
    lines = [
        f"# NL2SQL-Bench Evaluation Report",
        "",
        "## Overview",
        "",
        f"- **System**: {result.metadata.get('system_name', 'Unknown')} "
        f"v{result.metadata.get('system_version', '?')}",
        f"- **Dataset**: {result.metadata.get('dataset', 'Unknown')}",
        f"- **Total Questions**: {result.total}",
        f"- **Timestamp**: {result.metadata.get('timestamp', 'N/A')}",
        "",
        "## Overall Metrics",
        "",
        "| Metric | Score |",
        "|--------|-------|",
        f"| Exact Match | {result.exact_match:.1%} |",
        f"| Execution Accuracy | {result.execution_accuracy:.1%} |",
        "",
    ]
    
    # By difficulty
    if result.by_difficulty:
        lines.extend([
            "## Results by Difficulty",
            "",
            "| Difficulty | Total | Exact Match | Execution Accuracy |",
            "|------------|-------|-------------|-------------------|",
        ])
        
        diff_order = ["easy", "medium", "hard", "extra", "unknown"]
        sorted_diffs = sorted(
            result.by_difficulty.items(),
            key=lambda x: diff_order.index(x[0]) if x[0] in diff_order else 99
        )
        
        for diff, metrics in sorted_diffs:
            lines.append(
                f"| {diff.capitalize()} | {metrics.total} | "
                f"{metrics.exact_match:.1%} | {metrics.execution_accuracy:.1%} |"
            )
        lines.append("")
    
    # Error analysis
    if error_analysis and error_analysis.get("top_categories"):
        lines.extend([
            "## Error Analysis",
            "",
            f"Total errors analyzed: {error_analysis.get('total_errors', 0)}",
            "",
            "### Error Categories",
            "",
            "| Category | Count | Percentage |",
            "|----------|-------|------------|",
        ])
        
        for cat_info in error_analysis["top_categories"]:
            cat = cat_info["category"]
            count = cat_info["count"]
            pct = cat_info["percentage"]
            cat_display = cat.replace("_", " ").title()
            lines.append(f"| {cat_display} | {count} | {pct:.1%} |")
        
        lines.append("")
        
        # Add category descriptions
        lines.extend([
            "### Category Descriptions",
            "",
        ])
        
        for cat_info in error_analysis["top_categories"]:
            cat = cat_info["category"]
            if cat_info["count"] > 0:
                try:
                    cat_enum = ErrorCategory(cat)
                    description = get_category_description(cat_enum)
                    cat_display = cat.replace("_", " ").title()
                    lines.append(f"- **{cat_display}**: {description}")
                except ValueError:
                    pass
        
        lines.append("")
    
    # Sample errors
    if result.errors:
        lines.extend([
            "## Sample Errors",
            "",
        ])
        
        for i, error in enumerate(result.errors[:5], 1):
            lines.extend([
                f"### Error {i}",
                "",
                f"- **Question**: {error.question}",
                f"- **Database**: {error.db_id}",
                f"- **Difficulty**: {error.difficulty}",
                f"- **EM Match**: {error.em_match}",
                f"- **EX Match**: {error.ex_match}",
                "",
                "**Gold SQL**:",
                "```sql",
                error.gold_sql,
                "```",
                "",
                "**Predicted SQL**:",
                "```sql",
                error.pred_sql if error.pred_sql else "(empty)",
                "```",
                "",
            ])
    
    md_content = "\n".join(lines)
    
    # Save or return
    if output_path:
        output_path = Path(output_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(md_content)
        return str(output_path)
    
    return md_content


def compare_results(
    results: Dict[str, EvaluationResult],
    output_format: str = "cli"
) -> str:
    """
    Generate comparison report for multiple systems.
    
    Args:
        results: Dictionary mapping system names to EvaluationResult.
        output_format: Output format ("cli" or "markdown").
        
    Returns:
        Formatted comparison string.
    """
    if output_format == "markdown":
        lines = [
            "# NL2SQL System Comparison",
            "",
            "| System | Version | Exact Match | Execution Accuracy |",
            "|--------|---------|-------------|-------------------|",
        ]
        
        sorted_results = sorted(
            results.items(),
            key=lambda x: x[1].execution_accuracy,
            reverse=True
        )
        
        for name, result in sorted_results:
            version = result.metadata.get("system_version", "?")
            lines.append(
                f"| {name} | {version} | "
                f"{result.exact_match:.1%} | {result.execution_accuracy:.1%} |"
            )
        
        return "\n".join(lines)
    
    else:  # CLI format
        lines = [
            "",
            "=" * 70,
            "                 NL2SQL System Comparison",
            "=" * 70,
            "",
            f"{'System':<30} {'Version':<10} {'EM':>10} {'EX':>10}",
            "-" * 70,
        ]
        
        sorted_results = sorted(
            results.items(),
            key=lambda x: x[1].execution_accuracy,
            reverse=True
        )
        
        for name, result in sorted_results:
            version = result.metadata.get("system_version", "?")
            lines.append(
                f"{name:<30} {version:<10} "
                f"{result.exact_match:>9.1%} {result.execution_accuracy:>9.1%}"
            )
        
        lines.extend([
            "",
            "=" * 70,
        ])
        
        return "\n".join(lines)
