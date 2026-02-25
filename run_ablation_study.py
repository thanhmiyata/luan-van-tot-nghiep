#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Ablation Study: 50 stratified questions × 4 pipeline variants.

Variants:
    1. full_6step   — All 6 agents (Question Analyzer → Schema Selector → Query Planner → SQL Expert → SQL Refiner → SQL Validator)
    2. no_planner   — 5 agents (skip Query Planner)
    3. no_refiner   — 5 agents (skip SQL Refiner)
    4. baseline_4step — 4 agents (skip Query Planner + SQL Refiner)

Usage:
    # Step 1: Sample 50 questions (run once)
    python run_ablation_study.py --sample

    # Step 2: Run a variant
    python run_ablation_study.py --variant full_6step
    python run_ablation_study.py --variant no_planner
    python run_ablation_study.py --variant no_refiner
    python run_ablation_study.py --variant baseline_4step

    # Step 3: Evaluate all variants
    python run_ablation_study.py --evaluate

    # Step 4: Generate summary table
    python run_ablation_study.py --summary
"""

import os
import sys
import json
import csv
import random
import argparse
import sqlite3
import time
from pathlib import Path
from datetime import datetime
from collections import Counter

# --- Paths ---
BASE_DIR = Path(__file__).parent
DATA_DIR = BASE_DIR / "data"
SPIDER_DEV_FILE = DATA_DIR / "dev.json"
TABLES_FILE = DATA_DIR / "tables.json"
SPIDER_DB_DIR = DATA_DIR / "spider_data" / "database"
EVAL_DIR = BASE_DIR / "experiments" / "test-suite-sql-eval"
OUTPUT_DIR = BASE_DIR / "output" / "ablation"

SAMPLE_FILE = OUTPUT_DIR / "ablation_questions.json"
SEED = 42
MAX_RETRIES = 5
INITIAL_BACKOFF = 15  # seconds


# ============================================================
# Difficulty classification (from Spider evaluation)
# ============================================================

HARDNESS_COMPONENT1 = ('where', 'group', 'order', 'limit', 'join', 'or', 'like')
HARDNESS_COMPONENT2 = ('except', 'union', 'intersect')
WHERE_OPS = ('not', 'between', '=', '>', '<', '>=', '<=', '!=', 'in', 'like', 'is', 'exists')
AGG_OPS = ('none', 'max', 'min', 'count', 'sum', 'avg')
UNIT_OPS = ('none', '-', '+', '*', '/')


def condition_has_or(conds):
    return 'or' in conds[1::2]

def condition_has_like(conds):
    return WHERE_OPS.index('like') in [c[1] for c in conds[::2]]

def condition_has_sql(conds):
    for c in conds[::2]:
        if isinstance(c[3], dict) or isinstance(c[4], dict):
            return True
    return False

def val_has_op(val_unit):
    return val_unit[0] != UNIT_OPS.index('none')

def has_agg(unit):
    return unit[0] != AGG_OPS.index('none')

def count_component1(sql):
    count = 0
    if len(sql['where']) > 0:
        count += 1
    if len(sql['groupBy']) > 0:
        count += 1
    if len(sql['orderBy']) > 0:
        count += 1
    if sql['limit'] is not None:
        count += 1
    if len(sql['from']['table_units']) > 0:
        for t in sql['from']['table_units']:
            if t[0] == 'sql':
                count += 1
        if len(sql['from']['table_units']) > 1:
            count += 1
    if len(sql['where']) > 0 and condition_has_or(sql['where']):
        count += 1
    if len(sql['where']) > 0 and condition_has_like(sql['where']):
        count += 1
    return count

def count_component2(sql):
    count = 0
    if sql.get('intersect') is not None:
        count += 1
    if sql.get('union') is not None:
        count += 1
    if sql.get('except') is not None:
        count += 1
    return count

def count_others(sql):
    count = 0
    agg_count = 0
    for unit in sql['select'][1]:
        if has_agg(unit):
            agg_count += 1
    agg_count -= len(sql['select'][1])
    if agg_count > 0:
        count += 1
    if len(sql['where']) > 0:
        for cond in sql['where'][::2]:
            if isinstance(cond[3], dict) or isinstance(cond[4], dict):
                count += 1
    if len(sql['groupBy']) > 0 and len(sql['having']) > 0:
        count += 1
    return count

def eval_hardness(sql):
    c1 = count_component1(sql)
    c2 = count_component2(sql)
    co = count_others(sql)
    if c1 <= 1 and co == 0 and c2 == 0:
        return "easy"
    elif (co <= 2 and c1 <= 1 and c2 == 0) or (c1 <= 2 and co < 2 and c2 == 0):
        return "medium"
    elif (co > 2 and c1 <= 2 and c2 == 0) or (2 < c1 <= 3 and co <= 2 and c2 == 0) or (c1 <= 1 and co == 0 and c2 <= 1):
        return "hard"
    else:
        return "extra"


def classify_questions_by_difficulty(dev_data, tables_data):
    """Parse each gold SQL and classify its difficulty using Spider's eval_hardness."""
    sys.path.insert(0, str(EVAL_DIR))
    from process_sql import get_schema, Schema, get_sql

    db_schemas = {}
    classified = {"easy": [], "medium": [], "hard": [], "extra": []}

    for idx, item in enumerate(dev_data):
        db_id = item["db_id"]
        gold_sql_str = item["query"]

        try:
            if db_id not in db_schemas:
                db_path = SPIDER_DB_DIR / db_id / f"{db_id}.sqlite"
                if not db_path.exists():
                    db_path_alt = EVAL_DIR / "database" / db_id / f"{db_id}.sqlite"
                    if db_path_alt.exists():
                        db_path = db_path_alt
                    else:
                        continue
                db_schemas[db_id] = Schema(get_schema(str(db_path)))

            g_sql = get_sql(db_schemas[db_id], gold_sql_str)
            hardness = eval_hardness(g_sql)
            item["_index"] = idx
            item["_hardness"] = hardness
            classified[hardness].append(item)
        except Exception:
            pass

    return classified


# ============================================================
# Step 1: Sample 50 stratified questions
# ============================================================

def sample_questions():
    """Sample ~50 questions, stratified by difficulty."""
    print("=" * 60)
    print("STEP 1: Sampling 50 stratified questions from Spider dev set")
    print("=" * 60)

    with open(SPIDER_DEV_FILE, "r", encoding="utf-8") as f:
        dev_data = json.load(f)
    with open(TABLES_FILE, "r", encoding="utf-8") as f:
        tables_data = json.load(f)

    print(f"  Total dev questions: {len(dev_data)}")
    print("  Classifying by difficulty...")
    classified = classify_questions_by_difficulty(dev_data, tables_data)

    for h in ["easy", "medium", "hard", "extra"]:
        print(f"    {h:12s}: {len(classified[h])} questions")

    target = {"easy": 13, "medium": 13, "hard": 12, "extra": 12}
    random.seed(SEED)
    sampled = []

    for hardness, n in target.items():
        pool = classified[hardness]
        if len(pool) < n:
            print(f"  WARNING: Only {len(pool)} {hardness} questions available (need {n})")
            n = len(pool)
        chosen = random.sample(pool, n)
        sampled.extend(chosen)

    table_lookup = {t["db_id"]: t for t in tables_data}
    questions = []
    for item in sampled:
        db_id = item["db_id"]
        tbl = table_lookup.get(db_id, {})
        questions.append({
            "index": item["_index"],
            "db_id": db_id,
            "question": item["question"],
            "gold_query": item["query"],
            "hardness": item["_hardness"],
            "table_names_original": tbl.get("table_names_original", []),
            "column_names_original": tbl.get("column_names_original", []),
            "column_types": tbl.get("column_types", []),
            "foreign_keys": tbl.get("foreign_keys", []),
            "primary_keys": tbl.get("primary_keys", []),
        })

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    with open(SAMPLE_FILE, "w", encoding="utf-8") as f:
        json.dump(questions, f, ensure_ascii=False, indent=2)

    dist = Counter(q["hardness"] for q in questions)
    print(f"\n  Sampled {len(questions)} questions:")
    for h in ["easy", "medium", "hard", "extra"]:
        print(f"    {h:12s}: {dist.get(h, 0)}")
    print(f"  Saved to: {SAMPLE_FILE}")
    return questions


# ============================================================
# Step 2: Run a single variant
# ============================================================

VARIANT_CONFIG = {
    "full_6step":     {"pipeline": "6step", "skip_planner": False, "skip_refiner": False},
    "no_planner":     {"pipeline": "6step", "skip_planner": True,  "skip_refiner": False},
    "no_refiner":     {"pipeline": "6step", "skip_planner": False, "skip_refiner": True},
    "baseline_4step": {"pipeline": "4step", "skip_planner": True,  "skip_refiner": True},
}


def run_variant(variant_name: str):
    """Run one ablation variant on the 50 sampled questions."""
    print("=" * 60)
    print(f"STEP 2: Running variant '{variant_name}'")
    print("=" * 60)

    if variant_name not in VARIANT_CONFIG:
        print(f"  ERROR: Unknown variant '{variant_name}'. Options: {list(VARIANT_CONFIG.keys())}")
        return

    if not SAMPLE_FILE.exists():
        print("  ERROR: Sample file not found. Run --sample first.")
        return

    with open(SAMPLE_FILE, "r", encoding="utf-8") as f:
        questions = json.load(f)

    config = VARIANT_CONFIG[variant_name]
    pipeline_type = config["pipeline"]
    skip_planner = config["skip_planner"]
    skip_refiner = config["skip_refiner"]

    if pipeline_type == "6step":
        nl2sql_base = BASE_DIR / "src" / "nl2sql_6step"
    else:
        nl2sql_base = BASE_DIR / "src" / "nl2sql_4step"

    base_str = str(nl2sql_base)
    if base_str not in sys.path:
        sys.path.insert(0, base_str)

    from dotenv import load_dotenv
    load_dotenv(nl2sql_base / ".env")

    if pipeline_type == "6step":
        from nl2sql_flow.main import NL2SQLFlow, NLQuestions, SQLDbSchema, NL2SQLResult
        from nl2sql_flow.crews.nl2sql_crew.nl2sql_crew import Nl2SqlCrew
    else:
        from nl2sql_flow.main import NL2SQLFlow, NLQuestions, SQLDbSchema, NL2SQLResult

    variant_dir = OUTPUT_DIR / variant_name
    os.makedirs(variant_dir, exist_ok=True)

    # Resume support: only keep successfully completed entries
    log_file = variant_dir / "results_log.json"
    if log_file.exists():
        with open(log_file, "r", encoding="utf-8") as f:
            all_prev = json.load(f)
        results_log = [r for r in all_prev if r.get("pred_sql")]
        completed_indices = {r["index"] for r in results_log}
        gold_lines = [f"{r['gold_sql']}\t{r['db_id']}" for r in results_log]
        pred_lines = [f"{r['pred_sql']}\t{r['db_id']}" for r in results_log]
        print(f"  Resuming: {len(results_log)}/{len(questions)} successfully done.")
    else:
        gold_lines = []
        pred_lines = []
        results_log = []
        completed_indices = set()

    total = len(questions)

    for i, q in enumerate(questions, 1):
        if q["index"] in completed_indices:
            continue

        print(f"\n  [{i}/{total}] ({q['hardness']}) {q['question'][:60]}...")

        pred_sql = ""
        for attempt in range(MAX_RETRIES):
            start_t = time.time()
            try:
                if pipeline_type == "4step":
                    flow_result = NL2SQLFlow(
                        _question=NLQuestions(question=q["question"], db_id=q["db_id"]),
                        _raw_schema=SQLDbSchema(
                            db_id=q["db_id"],
                            table_names_original=q["table_names_original"],
                            column_names_original=q["column_names_original"],
                            column_types=q["column_types"],
                            foreign_keys=q.get("foreign_keys", []),
                            primary_keys=q.get("primary_keys", []),
                        )
                    ).kickoff()
                    pred_sql = flow_result.result.sql
                else:
                    pred_sql = run_6step_with_ablation(
                        q, skip_planner=skip_planner, skip_refiner=skip_refiner,
                        NL2SQLFlow=NL2SQLFlow, NLQuestions=NLQuestions,
                        SQLDbSchema=SQLDbSchema, NL2SQLResult=NL2SQLResult,
                        Nl2SqlCrew=Nl2SqlCrew,
                    )

                elapsed = time.time() - start_t
                print(f"    -> SQL: {(pred_sql or 'ERROR')[:70]}... ({elapsed:.1f}s)")
                break

            except Exception as e:
                elapsed = time.time() - start_t
                err_str = str(e)
                is_rate_limit = any(kw in err_str for kw in ["429", "RESOURCE_EXHAUSTED", "quota", "rate"])
                if is_rate_limit and attempt < MAX_RETRIES - 1:
                    wait = INITIAL_BACKOFF * (2 ** attempt)
                    print(f"    -> Rate limited. Waiting {wait}s before retry {attempt+2}/{MAX_RETRIES}...")
                    time.sleep(wait)
                else:
                    print(f"    -> ERROR: {err_str[:120]} ({elapsed:.1f}s)")
                    break

        gold_lines.append(f"{q['gold_query']}\t{q['db_id']}")
        pred_lines.append(f"{pred_sql}\t{q['db_id']}")
        results_log.append({
            "index": q["index"],
            "db_id": q["db_id"],
            "question": q["question"],
            "hardness": q["hardness"],
            "gold_sql": q["gold_query"],
            "pred_sql": pred_sql,
            "time_s": round(elapsed, 2),
        })

        # Incremental save after each question
        _save_variant_files(variant_dir, gold_lines, pred_lines, results_log)

    success_count = sum(1 for r in results_log if r["pred_sql"])
    print(f"\n  Variant '{variant_name}' complete: {success_count}/{total} questions generated SQL")
    print(f"  Files saved to: {variant_dir}/")


def _save_variant_files(variant_dir, gold_lines, pred_lines, results_log):
    """Save gold/predict/log files incrementally."""
    with open(variant_dir / "gold.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(gold_lines) + "\n")
    with open(variant_dir / "predict.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(pred_lines) + "\n")
    with open(variant_dir / "results_log.json", "w", encoding="utf-8") as f:
        json.dump(results_log, f, ensure_ascii=False, indent=2)


def run_6step_with_ablation(q, *, skip_planner, skip_refiner,
                            NL2SQLFlow, NLQuestions, SQLDbSchema, NL2SQLResult, Nl2SqlCrew):
    """Run 6-step pipeline with optional ablation (skip planner/refiner)."""
    import json as _json

    schema_obj = SQLDbSchema(
        db_id=q["db_id"],
        table_names_original=q["table_names_original"],
        column_names_original=q["column_names_original"],
        column_types=q["column_types"],
        foreign_keys=q.get("foreign_keys", []),
        primary_keys=q.get("primary_keys", []),
    )

    crew = Nl2SqlCrew()
    question_text = q["question"]
    raw_schema_json = schema_obj.model_dump_json()

    qa_result = crew.question_analysis_crew().kickoff(
        inputs={"question": question_text, "raw_db_schema": raw_schema_json}
    )
    question_analysis = qa_result.to_dict()

    ss_result = crew.select_needed_schema_crew().kickoff(
        inputs={
            "question": question_text,
            "raw_db_schema": raw_schema_json,
            "question_analysis": _json.dumps(question_analysis),
        }
    )
    db_schema = SQLDbSchema(**ss_result.to_dict())
    db_schema_json = db_schema.model_dump_json()

    query_plan = {}
    if not skip_planner:
        qp_result = crew.query_planning_crew().kickoff(
            inputs={
                "question": question_text,
                "db_schema": db_schema_json,
                "question_analysis": _json.dumps(question_analysis),
            }
        )
        query_plan = qp_result.to_dict()

    gen_result = crew.generated_sql_crew().kickoff(
        inputs={
            "question": question_text,
            "db_schema": db_schema_json,
            "question_analysis": _json.dumps(question_analysis),
            "query_plan": _json.dumps(query_plan),
        }
    )
    intermediate_sql = gen_result.to_dict()["sql"]

    if not skip_refiner:
        ref_result = crew.sql_refinement_crew().kickoff(
            inputs={
                "question": question_text,
                "db_schema": db_schema_json,
                "sql": intermediate_sql,
                "question_analysis": _json.dumps(question_analysis),
                "query_plan": _json.dumps(query_plan),
            }
        ).to_dict()
        final_sql = ref_result.get("sql", intermediate_sql)
    else:
        final_sql = intermediate_sql

    val_result = crew.validate_sql_crew().kickoff(
        inputs={
            "question": question_text,
            "db_schema": db_schema_json,
            "sql": final_sql,
            "question_analysis": _json.dumps(question_analysis),
        }
    ).to_dict()
    return val_result.get("sql", final_sql)


# ============================================================
# Step 3: Evaluate all variants
# ============================================================

def evaluate_all():
    """Run Spider evaluation on all completed variants."""
    print("=" * 60)
    print("STEP 3: Evaluating all variants")
    print("=" * 60)

    eval_script = EVAL_DIR / "evaluation.py"
    db_dir = EVAL_DIR / "database"
    table_file = EVAL_DIR / "tables.json"

    if not db_dir.exists():
        alt = SPIDER_DB_DIR
        if alt.exists():
            db_dir = alt
        else:
            print("  ERROR: No database directory found.")
            return

    import subprocess

    for variant_name in VARIANT_CONFIG:
        variant_dir = OUTPUT_DIR / variant_name
        gold_file = variant_dir / "gold.sql"
        pred_file = variant_dir / "predict.sql"
        if not gold_file.exists() or not pred_file.exists():
            print(f"  SKIP {variant_name}: no gold/predict files.")
            continue

        print(f"\n  Evaluating '{variant_name}'...")
        result_file = variant_dir / "eval_results.txt"

        cmd = [
            sys.executable, str(eval_script),
            "--gold", str(gold_file),
            "--pred", str(pred_file),
            "--db", str(db_dir),
            "--table", str(table_file),
            "--etype", "all",
        ]

        try:
            proc = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
            output = proc.stdout + "\n" + proc.stderr
            with open(result_file, "w", encoding="utf-8") as f:
                f.write(output)
            print(f"    Results saved to: {result_file}")
            for line in output.strip().split("\n")[-5:]:
                print(f"    {line}")
        except Exception as e:
            print(f"    ERROR: {e}")


# ============================================================
# Step 4: Summary table
# ============================================================

def print_summary():
    """Parse evaluation results and print comparison table."""
    print("=" * 60)
    print("STEP 4: Ablation Study Summary")
    print("=" * 60)

    results = {}
    for variant_name in VARIANT_CONFIG:
        result_file = OUTPUT_DIR / variant_name / "eval_results.txt"
        if not result_file.exists():
            continue
        with open(result_file, "r", encoding="utf-8") as f:
            content = f.read()
        em, ex = parse_eval_output(content)
        results[variant_name] = {"EM": em, "EX": ex}

    if not results:
        print("  No results found. Run --variant and --evaluate first.")
        return

    full_ex = results.get("full_6step", {}).get("EX")

    print(f"\n{'Variant':<20} {'EM (%)':<10} {'EX (%)':<10} {'Δ vs Full':<10}")
    print("-" * 50)
    for v in ["full_6step", "no_planner", "no_refiner", "baseline_4step"]:
        if v not in results:
            continue
        em = results[v]["EM"]
        ex = results[v]["EX"]
        delta = f"{ex - full_ex:+.1f}" if full_ex is not None and ex is not None else "—"
        em_str = f"{em:.1f}" if em is not None else "—"
        ex_str = f"{ex:.1f}" if ex is not None else "—"
        label = {"full_6step": "Full 6-step", "no_planner": "−Planner", "no_refiner": "−Refiner", "baseline_4step": "4-step"}[v]
        print(f"{label:<20} {em_str:<10} {ex_str:<10} {delta:<10}")

    print("\nNote: Results on a stratified sample of 50 questions; full-scale ablation is left for future work.")

    # Also print difficulty breakdown if available
    print_difficulty_breakdown(results)


def parse_eval_output(text):
    """Extract EM and EX from Spider evaluation output."""
    em = ex = None
    for line in text.split("\n"):
        parts = line.split()
        if not parts:
            continue
        if parts[0] == "exact" and "match" in line:
            try:
                ex_val = float(parts[-1])
                em = round(ex_val * 100, 1)
            except (ValueError, IndexError):
                pass
        if parts[0] == "execution":
            try:
                ex_val = float(parts[-1])
                ex = round(ex_val * 100, 1)
            except (ValueError, IndexError):
                pass
    return em, ex


def print_difficulty_breakdown(results):
    """Print difficulty breakdown from evaluation results."""
    has_breakdown = False
    for variant_name in ["full_6step", "baseline_4step"]:
        result_file = OUTPUT_DIR / variant_name / "eval_results.txt"
        if result_file.exists():
            with open(result_file, "r", encoding="utf-8") as f:
                content = f.read()
            if "easy" in content and "medium" in content:
                has_breakdown = True
                print(f"\n  Difficulty breakdown for '{variant_name}':")
                for line in content.split("\n"):
                    line = line.strip()
                    if any(kw in line for kw in ["easy", "medium", "hard", "extra", "all", "count", "execution", "exact"]):
                        print(f"    {line}")


# ============================================================
# Main
# ============================================================

def main():
    parser = argparse.ArgumentParser(description="NL2SQL Ablation Study (50 questions × 4 variants)")
    parser.add_argument("--sample", action="store_true", help="Sample 50 stratified questions")
    parser.add_argument("--variant", type=str, choices=list(VARIANT_CONFIG.keys()),
                        help="Run a specific variant")
    parser.add_argument("--evaluate", action="store_true", help="Evaluate all completed variants")
    parser.add_argument("--summary", action="store_true", help="Print summary comparison table")
    args = parser.parse_args()

    if not any([args.sample, args.variant, args.evaluate, args.summary]):
        parser.print_help()
        return

    if args.sample:
        sample_questions()

    if args.variant:
        run_variant(args.variant)

    if args.evaluate:
        evaluate_all()

    if args.summary:
        print_summary()


if __name__ == "__main__":
    main()
