#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Ablation Study: 50 stratified questions × 4 pipeline variants.

Học tập 100% từ run_complete_nl2sql_pipeline.py — dùng chung setup, convert, evaluation.
Chỉ thêm: (1) stratified sampling từ dev.json, (2) ablation variants (skip planner/refiner).

Variants:
    full_6step   — All 6 agents
    no_planner   — 5 agents (skip Query Planner)
    no_refiner   — 5 agents (skip SQL Refiner)
    baseline_4step — 4 agents (dùng pipeline 4-step)

Usage:
    python run_ablation_study.py --sample
    python run_ablation_study.py --variant full_6step
    python run_ablation_study.py --variant no_planner
    python run_ablation_study.py --variant no_refiner
    python run_ablation_study.py --variant baseline_4step
    python run_ablation_study.py --evaluate
    python run_ablation_study.py --summary
"""

import os
import sys
import json
import csv
import random
import argparse
import subprocess
import time
import re
from pathlib import Path
from datetime import datetime
from collections import Counter

# Import từ pipeline chính
from run_complete_nl2sql_pipeline import (
    DATA_DIR,
    SPIDER_DATA_DIR,
    OUTPUT_BASE_DIR,
    configure_pipeline,
    setup_environment,
    run_nl2sql_system,
    convert_csv_to_evaluation_format,
    run_evaluation,
    print_results_table,
)

# Ablation-specific
BASE_DIR = Path(__file__).parent
SPIDER_DEV_FILE = DATA_DIR / "dev.json"
TABLES_FILE = DATA_DIR / "tables.json"
EVAL_DIR = BASE_DIR / "experiments" / "test-suite-sql-eval"
OUTPUT_DIR = OUTPUT_BASE_DIR / "ablation"
SAMPLE_FILE = OUTPUT_DIR / "ablation_questions.json"
SEED = 42

VARIANT_CONFIG = {
    "full_6step":     {"pipeline": "6step", "skip_planner": False, "skip_refiner": False},
    "no_planner":     {"pipeline": "6step", "skip_planner": True,  "skip_refiner": False},
    "no_refiner":     {"pipeline": "6step", "skip_planner": False, "skip_refiner": True},
    "baseline_4step": {"pipeline": "4step", "skip_planner": True,  "skip_refiner": True},
}


# ============================================================
# Step 1: Sample 50 stratified questions (dùng Spider eval hardness)
# ============================================================

def _classify_hardness(dev_data):
    """Phân loại difficulty dùng Spider evaluation logic."""
    sys.path.insert(0, str(EVAL_DIR))
    from process_sql import get_schema, Schema, get_sql
    from evaluation import Evaluator

    db_root = EVAL_DIR / "database" if (EVAL_DIR / "database").exists() else SPIDER_DATA_DIR / "database"
    classified = {"easy": [], "medium": [], "hard": [], "extra": []}
    schemas = {}
    evaluator = Evaluator()

    for idx, item in enumerate(dev_data):
        db_id = item["db_id"]
        db_path = db_root / db_id / f"{db_id}.sqlite"
        if not db_path.exists():
            continue
        try:
            if db_id not in schemas:
                schemas[db_id] = Schema(get_schema(str(db_path)))
            g_sql = get_sql(schemas[db_id], item["query"])
            h = evaluator.eval_hardness(g_sql)
            item["_index"], item["_hardness"] = idx, h
            classified[h].append(item)
        except Exception:
            pass
    return classified


def sample_questions():
    """Sample 50 câu stratified theo difficulty."""
    print("=" * 60)
    print("STEP 1: Sampling 50 stratified questions from Spider dev")
    print("=" * 60)

    with open(SPIDER_DEV_FILE, "r", encoding="utf-8") as f:
        dev_data = json.load(f)
    with open(TABLES_FILE, "r", encoding="utf-8") as f:
        tables_data = json.load(f)

    classified = _classify_hardness(dev_data)
    for h in ["easy", "medium", "hard", "extra"]:
        print(f"  {h:10s}: {len(classified[h])}")

    target = {"easy": 13, "medium": 13, "hard": 12, "extra": 12}
    random.seed(SEED)
    sampled = []
    table_map = {t["db_id"]: t for t in tables_data}

    for h, n in target.items():
        pool = classified[h]
        n = min(n, len(pool)) if pool else 0
        if n:
            sampled.extend(random.sample(pool, n))

    questions = []
    for item in sampled:
        t = table_map.get(item["db_id"], {})
        questions.append({
            "db_id": item["db_id"],
            "question": item["question"],
            "gold_query": item["query"],
            "hardness": item["_hardness"],
            "table_names_original": t.get("table_names_original", []),
            "column_names_original": t.get("column_names_original", []),
            "column_types": t.get("column_types", []),
            "foreign_keys": t.get("foreign_keys", []),
            "primary_keys": t.get("primary_keys", []),
        })

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    with open(SAMPLE_FILE, "w", encoding="utf-8") as f:
        json.dump(questions, f, ensure_ascii=False, indent=2)

    dist = Counter(q["hardness"] for q in questions)
    print(f"\n  Sampled {len(questions)}: {dict(dist)}")
    print(f"  Saved: {SAMPLE_FILE}\n")
    return questions


# ============================================================
# Step 2: Run variant — dùng run_nl2sql_system khi có thể
# ============================================================

def run_6step_ablation(questions, skip_planner, skip_refiner, variant_dir):
    """Chạy 6-step với ablation (skip planner/refiner)."""
    import run_complete_nl2sql_pipeline as pl
    pl.configure_pipeline("6step")
    pl.PIPELINE_OUTPUT_DIR = variant_dir
    from nl2sql_flow.crews.nl2sql_crew.nl2sql_crew import Nl2SqlCrew
    from nl2sql_flow.main import NLQuestions, SQLDbSchema

    def parse_json_safely(text: str):
        def iter_json_candidates(raw_text: str):
            stripped = raw_text.strip()
            if stripped:
                yield stripped

            for match in re.finditer(r'```(?:json)?\s*(.*?)\s*```', raw_text, re.DOTALL | re.IGNORECASE):
                candidate = match.group(1).strip()
                if candidate:
                    yield candidate

            stack = 0
            start_idx = None
            objects = []
            for idx, ch in enumerate(raw_text):
                if ch == "{":
                    if stack == 0:
                        start_idx = idx
                    stack += 1
                elif ch == "}":
                    if stack > 0:
                        stack -= 1
                        if stack == 0 and start_idx is not None:
                            candidate = raw_text[start_idx:idx + 1].strip()
                            if candidate:
                                objects.append(candidate)
                            start_idx = None

            for candidate in reversed(objects):
                yield candidate

        for candidate in iter_json_candidates(text or ""):
            try:
                return json.loads(candidate)
            except Exception:
                continue
        return {}

    def crew_json(output):
        raw_text = getattr(output, "raw", "") or ""
        parsed = parse_json_safely(raw_text)
        if parsed:
            return parsed
        try:
            return output.to_dict()
        except Exception:
            return {}

    crew = Nl2SqlCrew()
    results = []
    for i, q in enumerate(questions, 1):
        hardness = q.get("hardness", "fixed")
        print(f"\n  [{i}/{len(questions)}] ({hardness}) {q['question'][:50]}...")
        schema = SQLDbSchema(
            db_id=q["db_id"],
            table_names_original=q["table_names_original"],
            column_names_original=q["column_names_original"],
            column_types=q["column_types"],
            foreign_keys=q.get("foreign_keys", []),
            primary_keys=q.get("primary_keys", []),
        )
        qa_output = crew.question_analysis_crew().kickoff(inputs={"question": q["question"], "raw_db_schema": schema.model_dump_json()})
        qa = crew_json(qa_output)
        ss_output = crew.select_needed_schema_crew().kickoff(inputs={"question": q["question"], "raw_db_schema": schema.model_dump_json(), "question_analysis": json.dumps(qa)})
        ss = crew_json(ss_output)
        db_schema = SQLDbSchema(**ss)
        qp = {}
        if not skip_planner:
            qp_output = crew.query_planning_crew().kickoff(inputs={"question": q["question"], "db_schema": db_schema.model_dump_json(), "question_analysis": json.dumps(qa)})
            qp = crew_json(qp_output)
        gen_output = crew.generated_sql_crew().kickoff(inputs={"question": q["question"], "db_schema": db_schema.model_dump_json(), "question_analysis": json.dumps(qa), "query_plan": json.dumps(qp)})
        gen = crew_json(gen_output)
        sql = gen.get("sql", getattr(gen_output, "raw", "")) or ""
        if not skip_refiner:
            ref_output = crew.sql_refinement_crew().kickoff(inputs={"question": q["question"], "db_schema": db_schema.model_dump_json(), "sql": sql, "question_analysis": json.dumps(qa), "query_plan": json.dumps(qp)})
            ref = crew_json(ref_output)
            sql = ref.get("sql", sql)
        val_output = crew.validate_sql_crew().kickoff(inputs={"question": q["question"], "db_schema": db_schema.model_dump_json(), "sql": sql, "question_analysis": json.dumps(qa)})
        val = crew_json(val_output)
        sql = val.get("sql", sql)
        results.append({"db_id": q["db_id"], "question": q["question"], "gold_query": q["gold_query"], "sql": sql or "", "explain": "", "error": ""})
    return results


def run_variant(variant_name: str, limit: int = None):
    """Chạy một variant — tái sử dụng pipeline."""
    if variant_name not in VARIANT_CONFIG:
        print(f"  ERROR: Unknown variant. Options: {list(VARIANT_CONFIG.keys())}")
        return
    if not SAMPLE_FILE.exists():
        print("  ERROR: Run --sample first.")
        return

    with open(SAMPLE_FILE, "r", encoding="utf-8") as f:
        questions = json.load(f)
    if limit is not None:
        questions = questions[:limit]
        print(f"  [LIMIT] Using first {len(questions)} questions")

    cfg = VARIANT_CONFIG[variant_name]
    pt = cfg["pipeline"]
    variant_dir = OUTPUT_DIR / variant_name
    os.makedirs(variant_dir, exist_ok=True)

    # Override output dir cho pipeline
    import run_complete_nl2sql_pipeline as pl
    pl.configure_pipeline(pt)
    pl.PIPELINE_OUTPUT_DIR = variant_dir

    print("=" * 60)
    print(f"STEP 2: Running variant '{variant_name}'")
    print("=" * 60)

    if cfg["pipeline"] == "4step" or (cfg["pipeline"] == "6step" and not cfg["skip_planner"] and not cfg["skip_refiner"]):
        # full_6step hoặc baseline_4step — dùng run_nl2sql_system trực tiếp
        if not setup_environment():
            return
        t0 = time.time()
        csv_fn, results = run_nl2sql_system(questions)
        if not csv_fn:
            return
        duration = time.time() - t0
    else:
        # no_planner hoặc no_refiner
        if not setup_environment():
            return
        results = run_6step_ablation(questions, cfg["skip_planner"], cfg["skip_refiner"], variant_dir)
        ts = datetime.now().strftime("%Y%m%d%H%M%S")
        csv_fn = variant_dir / f"nl2sql_ablation_{variant_name}_{ts}.csv"
        with open(csv_fn, "w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=["db_id", "question", "gold_query", "sql", "explain", "error"])
            w.writeheader()
            w.writerows(results)
        duration = 0

    gold_file, predict_file = convert_csv_to_evaluation_format(csv_fn)
    eval_metrics = run_evaluation(gold_file, predict_file)
    if cfg["pipeline"] == "4step" or not cfg["skip_planner"] and not cfg["skip_refiner"]:
        print_results_table(1, len(questions), eval_metrics or {}, duration)
    success = sum(1 for r in results if r.get("sql"))
    print(f"\n  Variant '{variant_name}': {success}/{len(questions)} SQL | Files: {variant_dir}/")


# ============================================================
# Step 3–4: Evaluate & Summary
# ============================================================

def evaluate_all():
    """Đánh giá tất cả variants đã chạy."""
    print("=" * 60)
    print("STEP 3: Evaluating all variants")
    print("=" * 60)
    for v in VARIANT_CONFIG:
        d = OUTPUT_DIR / v
        g, p = d / "gold.sql", d / "predict.sql"
        if not (g.exists() and p.exists()):
            print(f"  SKIP {v}")
            continue
        print(f"\n  Eval {v}...")
        em = run_evaluation(g, p)
        if em:
            print(f"    EX={em.get('execution_rate', 0):.1f}% EM={em.get('exact_match_rate', 0):.1f}%")


def print_summary():
    """In bảng so sánh ablation."""
    print("=" * 60)
    print("STEP 4: Ablation Summary")
    print("=" * 60)
    # Re-run evaluation nếu cần, hoặc parse kết quả có sẵn
    for v in ["full_6step", "no_planner", "no_refiner", "baseline_4step"]:
        g, p = OUTPUT_DIR / v / "gold.sql", OUTPUT_DIR / v / "predict.sql"
        if g.exists() and p.exists():
            run_evaluation(g, p)
    print("\n  Note: Results on 50 stratified questions.")


def main():
    parser = argparse.ArgumentParser(description="NL2SQL Ablation Study")
    parser.add_argument("--sample", action="store_true")
    parser.add_argument("--variant", choices=list(VARIANT_CONFIG.keys()))
    parser.add_argument("--limit", type=int, default=None, help="Limit number of questions (e.g. 10 for quick test)")
    parser.add_argument("--evaluate", action="store_true")
    parser.add_argument("--summary", action="store_true")
    args = parser.parse_args()

    if args.sample:
        sample_questions()
    if args.variant:
        run_variant(args.variant, limit=args.limit)
    if args.evaluate:
        evaluate_all()
    if args.summary:
        print_summary()
    if not any([args.sample, args.variant, args.evaluate, args.summary]):
        parser.print_help()


if __name__ == "__main__":
    main()
