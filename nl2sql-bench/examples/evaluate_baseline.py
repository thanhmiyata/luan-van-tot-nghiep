"""
Example: Evaluate the Multi-Agent 6-Step Baseline.

This script demonstrates how to evaluate the Multi-Agent 6-Step baseline
system against the Spider dataset.

Usage:
    python evaluate_baseline.py --spider-path /path/to/spider

Requirements:
    - Spider dataset downloaded
    - CrewAI and LLM API keys configured
"""

import argparse
import os
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from nl2sql_bench import SpiderDataset, Evaluator


def main():
    parser = argparse.ArgumentParser(
        description="Evaluate Multi-Agent 6-Step baseline on Spider"
    )
    parser.add_argument(
        "--spider-path",
        type=str,
        default=os.getenv("SPIDER_PATH", "./spider_data"),
        help="Path to Spider dataset directory",
    )
    parser.add_argument(
        "--project-path",
        type=str,
        default=None,
        help="Path to nl2sql_6step project (auto-detected if not provided)",
    )
    parser.add_argument(
        "--output-dir",
        type=str,
        default="./results",
        help="Directory to save evaluation results",
    )
    parser.add_argument(
        "--max-questions",
        type=int,
        default=None,
        help="Maximum questions to evaluate (for testing)",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Print verbose progress information",
    )
    parser.add_argument(
        "--use-simplified",
        action="store_true",
        help="Use simplified version (doesn't require full pipeline)",
    )
    
    args = parser.parse_args()
    
    # Validate Spider path
    if not os.path.exists(args.spider_path):
        print(f"Error: Spider dataset not found at: {args.spider_path}")
        print("\nPlease download the Spider dataset and set --spider-path")
        print("or set the SPIDER_PATH environment variable.")
        sys.exit(1)
    
    # Load dataset
    print(f"Loading Spider dataset from: {args.spider_path}")
    dataset = SpiderDataset(data_dir=args.spider_path, split="dev")
    print(f"Loaded {len(dataset)} questions")
    
    # Initialize system
    if args.use_simplified:
        from nl2sql_bench.baselines.multi_agent_6step import SimplifiedMultiAgent6Step
        
        print("\nUsing simplified Multi-Agent system (single LLM)")
        system = SimplifiedMultiAgent6Step(
            llm_provider="openai",
            model_name="gpt-4o",
        )
    else:
        from nl2sql_bench.baselines.multi_agent_6step import MultiAgent6StepSystem
        
        print("\nUsing full Multi-Agent 6-Step system")
        system = MultiAgent6StepSystem(
            project_path=args.project_path,
            verbose=args.verbose,
        )
    
    print(f"System: {system.name} v{system.version}")
    
    # Initialize evaluator
    db_dir = os.path.join(args.spider_path, "database")
    evaluator = Evaluator(
        dataset=dataset,
        db_dir=db_dir,
        output_dir=args.output_dir,
    )
    
    # Run evaluation
    print("\n" + "="*60)
    print("Starting Evaluation")
    print("="*60)
    
    results = evaluator.run(
        system=system,
        verbose=True,
        max_questions=args.max_questions,
    )
    
    # Print summary
    print(results.summary())
    
    # Save detailed report
    from nl2sql_bench.analysis.reporter import (
        generate_json_report,
        generate_markdown_report,
    )
    
    json_path = generate_json_report(
        results,
        output_path=os.path.join(args.output_dir, f"{system.name}_report.json"),
    )
    print(f"\nJSON report saved to: {json_path}")
    
    md_path = generate_markdown_report(
        results,
        output_path=os.path.join(args.output_dir, f"{system.name}_report.md"),
    )
    print(f"Markdown report saved to: {md_path}")


if __name__ == "__main__":
    main()
