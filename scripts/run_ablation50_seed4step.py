#!/usr/bin/env python3
"""Ablation on 50 stratified Spider-dev questions with hybrid 4→6 seed.

Seeds Analyzer (+ Schema + optionally Direct) from ``output/nl2sql_4step``
raw_responses, then calls only the remaining 6-step LLM stages.

Variants:
  no_planner  — SKIP_PLANNER=1, seed Analyzer+Schema+Direct
                → LLM: Refiner (if needed) + Validator
  no_refiner  — SKIP_REFINER=1, seed Analyzer+Schema only
                → LLM: Planner + Direct + Planned + Validator

Also reports locked 4-step / 6-step EX on the same 50 questions (offline).

Usage:
  python scripts/run_ablation50_seed4step.py
  python scripts/run_ablation50_seed4step.py --variants no_planner
  python scripts/run_ablation50_seed4step.py --eval-only
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import random
import shutil
import sys
import time
from collections import Counter
from datetime import datetime
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(PROJECT_ROOT / "src" / "nl2sql_6step"))
sys.path.insert(0, str(PROJECT_ROOT / "experiments" / "test-suite-sql-eval"))

from dotenv import load_dotenv

load_dotenv(PROJECT_ROOT / ".env")

FOUR_OUT = PROJECT_ROOT / "output" / "nl2sql_4step"
SIX_OUT = PROJECT_ROOT / "output" / "nl2sql_6step"
OUT_ROOT = PROJECT_ROOT / "output" / "ablation50_seed4step"
SAMPLE_FILE = OUT_ROOT / "sample50.json"
SEED = 42
TARGET = {"easy": 13, "medium": 13, "hard": 12, "extra": 12}


def _classify_hardness(dev_data):
    from process_sql import Schema, get_schema, get_sql
    from evaluation import Evaluator

    db_root = PROJECT_ROOT / "experiments" / "test-suite-sql-eval" / "database"
    if not db_root.exists():
        db_root = PROJECT_ROOT / "data" / "spider_data" / "database"
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
            row = dict(item)
            row["_index"] = idx
            row["_hardness"] = h
            classified[h].append(row)
        except Exception:
            continue
    return classified


def build_sample(force: bool = False) -> list:
    OUT_ROOT.mkdir(parents=True, exist_ok=True)
    if SAMPLE_FILE.exists() and not force:
        return json.loads(SAMPLE_FILE.read_text(encoding="utf-8"))

    import run_complete_nl2sql_pipeline as pl

    pl.configure_pipeline("6step")
    tables = {
        t["db_id"]: t
        for t in json.loads((PROJECT_ROOT / "data" / "tables.json").read_text())
    }
    dev = json.loads((PROJECT_ROOT / "data" / "dev.json").read_text())
    classified = _classify_hardness(dev)
    rng = random.Random(SEED)
    sampled = []
    for h, n in TARGET.items():
        pool = classified[h]
        take = min(n, len(pool))
        sampled.extend(rng.sample(pool, take) if take else [])

    questions = []
    for item in sampled:
        t = tables[item["db_id"]]
        sample_values = pl.collect_column_sample_values(item["db_id"], t)
        questions.append(
            {
                "question_index": item["_index"],
                "db_id": item["db_id"],
                "question": item["question"],
                "gold_query": item["query"],
                "hardness": item["_hardness"],
                "table_names_original": t.get("table_names_original", []),
                "column_names_original": t.get("column_names_original", []),
                "column_types": t.get("column_types", []),
                "foreign_keys": t.get("foreign_keys", []),
                "primary_keys": t.get("primary_keys", []),
                "column_sample_values": sample_values,
            }
        )
    SAMPLE_FILE.write_text(
        json.dumps(questions, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print(f"Sampled {len(questions)}: {dict(Counter(q['hardness'] for q in questions))}")
    print(f"Saved {SAMPLE_FILE}")
    return questions


def _sql_only(line: str) -> str:
    return line.split("\t", 1)[0].strip().rstrip(";")


def offline_locked_scores(questions: list) -> dict:
    """EX/EM of locked full_dev predict lines on the sample (no LLM)."""
    from exec_eval import eval_exec_match

    db_root = PROJECT_ROOT / "experiments" / "test-suite-sql-eval" / "database"
    # Map spider global index -> full_dev line via gold db order rebuild
    # Easier: look up by matching gold SQL + db in per_db files via question_index
    # 4/6 raw and per_db use spider global index in filenames for raw; per_db is local order.
    # Use full_dev gold which is db-grouped — match via 4step raw final_sql / gold from sample.

    results = {}
    for pipe, out in [("4step", FOUR_OUT), ("6step", SIX_OUT)]:
        pred_by_qi = {}
        for db_dir in (out / "raw_responses").iterdir():
            if not db_dir.is_dir() or db_dir.name.startswith("_"):
                continue
            for f in db_dir.glob("q*.json"):
                obj = json.loads(f.read_text(encoding="utf-8"))
                qi = obj.get("question_index")
                if qi is None:
                    continue
                pred_by_qi[int(qi)] = (obj.get("final_sql") or "").strip()

        # Prefer per_db/full via raw final (already synced for 6-step)
        # For 4-step also use raw final_sql
        ex_ok = em_ok = 0
        for q in questions:
            qi = int(q["question_index"])
            gold = q["gold_query"].strip()
            pred = pred_by_qi.get(qi, "")
            db_path = str(db_root / q["db_id"] / f"{q['db_id']}.sqlite")
            try:
                if pred and eval_exec_match(
                    db_path, pred, gold, True, False, False
                ):
                    ex_ok += 1
            except Exception:
                pass
            # rough EM: normalize whitespace/case
            g_n = " ".join(gold.lower().replace('"', "'").split())
            p_n = " ".join(pred.lower().replace('"', "'").split())
            if g_n == p_n:
                em_ok += 1
        n = len(questions)
        results[pipe] = {
            "n": n,
            "ex": round(100.0 * ex_ok / n, 1),
            "em_approx": round(100.0 * em_ok / n, 1),
            "ex_correct": ex_ok,
            "note": "EM is string-normalize approx; EX is official exec_eval",
        }
    return results


def official_eval(variant_dir: Path) -> dict:
    import run_complete_nl2sql_pipeline as pl

    pl.configure_pipeline("6step")
    gold = variant_dir / "gold.sql"
    pred = variant_dir / "predict.sql"
    metrics = pl.run_evaluation(str(gold), str(pred)) or {}
    return metrics


def run_variant(name: str, questions: list, limit: int | None = None) -> dict:
    import run_complete_nl2sql_pipeline as pl
    from nl2sql_flow.main import (
        NL2SQLFlow,
        NLQuestions,
        SQLDbSchema,
        load_four_step_seed_file,
        map_four_step_seed_to_six_steps,
    )

    pl.configure_pipeline("6step")
    variant_dir = OUT_ROOT / name
    raw_dir = variant_dir / "raw_responses"
    if variant_dir.exists():
        shutil.rmtree(variant_dir)
    variant_dir.mkdir(parents=True)
    raw_dir.mkdir(parents=True)

    # Ablation env
    os.environ["NL2SQL_SEED_FROM_4STEP"] = str(FOUR_OUT)
    # Gemini prepaid credits may be empty; prefer GPT-4o for remaining LLM steps.
    for key, val in {
        "NL2SQL_QUERY_PLANNER_MODEL": "openai/gpt-4o",
        "NL2SQL_QUERY_PLANNER_FALLBACK_MODEL": "openai/gpt-4o",
        "NL2SQL_DIRECT_SQL_MODEL": "openai/gpt-4o",
        "NL2SQL_PLANNED_SQL_MODEL": "openai/gpt-4o",
        "NL2SQL_PLANNED_SQL_FALLBACK_MODEL": "openai/gpt-4o",
        "NL2SQL_SQL_REFINER_MODEL": "openai/gpt-4o",
        "NL2SQL_SQL_REFINER_FALLBACK_MODEL": "openai/gpt-4o",
        "NL2SQL_SQL_VALIDATOR_MODEL": "openai/gpt-4o",
        "NL2SQL_SQL_VALIDATOR_FALLBACK_MODEL": "openai/gpt-4o",
    }.items():
        os.environ.setdefault(key, val)
    if name == "no_planner":
        os.environ["NL2SQL_SKIP_PLANNER"] = "1"
        os.environ.pop("NL2SQL_SKIP_REFINER", None)
        os.environ["NL2SQL_SEED_INCLUDE_DIRECT"] = "1"
    elif name == "no_refiner":
        os.environ["NL2SQL_SKIP_REFINER"] = "1"
        os.environ.pop("NL2SQL_SKIP_PLANNER", None)
        # Seed Analyzer+Schema+Direct from 4-step; LLM: Planner + Planned + Validator
        os.environ["NL2SQL_SEED_INCLUDE_DIRECT"] = "1"
    else:
        raise ValueError(name)

    qs = questions[:limit] if limit else questions
    rows = []
    t0 = time.time()
    llm_calls = 0
    seeded_ok = 0

    for i, q in enumerate(qs, 1):
        qi = int(q["question_index"])
        print(
            f"\n=== [{name}] {i}/{len(qs)} qi={qi} ({q['hardness']}) "
            f"{q['db_id']}: {q['question'][:60]}..."
        )
        four_raw = load_four_step_seed_file(
            FOUR_OUT, q["db_id"], qi, q["question"]
        )
        seed_steps = map_four_step_seed_to_six_steps(four_raw) if four_raw else {}
        if seed_steps:
            seeded_ok += 1
            print("  seed:", ", ".join(sorted(seed_steps.keys())))
        else:
            print("  WARNING: no 4-step seed; full LLM for early steps")

        flow = NL2SQLFlow(
            _question=NLQuestions(question=q["question"], db_id=q["db_id"]),
            _raw_schema=SQLDbSchema(
                db_id=q["db_id"],
                table_names=q["table_names_original"],
                table_names_original=q["table_names_original"],
                column_names=q["column_names_original"],
                column_names_original=q["column_names_original"],
                column_types=q["column_types"],
                foreign_keys=q.get("foreign_keys", []),
                primary_keys=q.get("primary_keys", []),
                column_sample_values=q.get("column_sample_values", []),
            ),
            seed_steps=seed_steps,
        )
        try:
            result = flow.kickoff()
            sql = (result.result.sql or "").strip()
            err = result.result.error or ""
        except Exception as e:
            sql, err = "", f"{type(e).__name__}: {e}"
            print("  FLOW ERROR:", err)

        traces = getattr(flow, "step_traces", []) or []
        calls = sum(
            1
            for t in traces
            if not t.get("seeded")
            and not t.get("skipped")
            and t.get("success", True)
            and t.get("attempt", 1) >= 0
            and t.get("raw_response")
            and not str(t.get("effective_model", "")).startswith("seed:")
        )
        # Count non-seeded successful LLM attempts more carefully
        calls = 0
        for t in traces:
            if t.get("seeded") or t.get("skipped"):
                continue
            if t.get("error") and not t.get("raw_response"):
                continue
            # each attempt entry is a call
            calls += 1
        llm_calls += calls

        db_raw = raw_dir / q["db_id"]
        db_raw.mkdir(exist_ok=True)
        payload = {
            "question_index": qi,
            "pipeline": f"ablation_{name}",
            "db_id": q["db_id"],
            "question": q["question"],
            "gold_query": q["gold_query"],
            "hardness": q["hardness"],
            "steps": traces,
            "final_sql": sql,
            "error": err,
            "seeded_steps": sorted(seed_steps.keys()),
            "timestamp": datetime.now().isoformat(),
        }
        (db_raw / f"q{qi:04d}.json").write_text(
            json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8"
        )
        rows.append(
            {
                "db_id": q["db_id"],
                "question": q["question"],
                "gold_query": q["gold_query"],
                "sql": sql,
                "error": err,
                "question_index": qi,
                "hardness": q["hardness"],
            }
        )

    # Write gold/predict for Spider eval (gold\tdb)
    gold_lines = []
    pred_lines = []
    for r in rows:
        gold_lines.append(f"{r['gold_query']}\t{r['db_id']}")
        pred_lines.append(r["sql"] if r["sql"] else "SELECT 1")
    (variant_dir / "gold.sql").write_text("\n".join(gold_lines) + "\n", encoding="utf-8")
    (variant_dir / "predict.sql").write_text(
        "\n".join(pred_lines) + "\n", encoding="utf-8"
    )
    csv_path = variant_dir / f"results_{name}.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(
            f,
            fieldnames=[
                "question_index",
                "db_id",
                "hardness",
                "question",
                "gold_query",
                "sql",
                "error",
            ],
        )
        w.writeheader()
        w.writerows(rows)

    metrics = official_eval(variant_dir)
    summary = {
        "variant": name,
        "n": len(rows),
        "seeded_ok": seeded_ok,
        "llm_step_traces": llm_calls,
        "elapsed_sec": round(time.time() - t0, 1),
        "execution_rate": metrics.get("execution_rate"),
        "exact_match_rate": metrics.get("exact_match_rate"),
        "metrics": metrics,
        "protocol": {
            "seed_from": str(FOUR_OUT),
            "skip_planner": name == "no_planner",
            "skip_refiner": name == "no_refiner",
            "include_direct_seed": name == "no_planner",
        },
        "finished_at": datetime.now().isoformat(),
    }
    (variant_dir / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    # cleanup env
    for k in (
        "NL2SQL_SKIP_PLANNER",
        "NL2SQL_SKIP_REFINER",
        "NL2SQL_SEED_INCLUDE_DIRECT",
        "NL2SQL_SEED_FROM_4STEP",
    ):
        os.environ.pop(k, None)
    return summary


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--variants",
        nargs="+",
        default=["no_planner", "no_refiner"],
        choices=["no_planner", "no_refiner"],
    )
    parser.add_argument("--limit", type=int, default=None)
    parser.add_argument("--resample", action="store_true")
    parser.add_argument("--eval-only", action="store_true")
    args = parser.parse_args()

    questions = build_sample(force=args.resample)
    offline = offline_locked_scores(questions)
    print("\n=== Offline locked scores on same 50 ===")
    print(json.dumps(offline, indent=2))

    summaries = {"offline_locked": offline, "variants": {}}
    if not args.eval_only:
        for name in args.variants:
            print(f"\n######## RUN {name} ########")
            summaries["variants"][name] = run_variant(
                name, questions, limit=args.limit
            )
    else:
        for name in args.variants:
            sfile = OUT_ROOT / name / "summary.json"
            if sfile.exists():
                summaries["variants"][name] = json.loads(
                    sfile.read_text(encoding="utf-8")
                )

    # Re-eval if summaries missing metrics
    for name in args.variants:
        vdir = OUT_ROOT / name
        if (vdir / "predict.sql").exists() and name not in summaries["variants"]:
            m = official_eval(vdir)
            summaries["variants"][name] = {
                "variant": name,
                "execution_rate": m.get("execution_rate"),
                "exact_match_rate": m.get("exact_match_rate"),
            }

    out = OUT_ROOT / "ablation50_summary.json"
    out.write_text(json.dumps(summaries, ensure_ascii=False, indent=2), encoding="utf-8")
    print("\n======== ABLATION-50 SUMMARY ========")
    print(
        f"{'Config':40s} {'EM':>7} {'EX':>7} {'n':>4}"
    )
    o4 = offline["4step"]
    o6 = offline["6step"]
    print(
        f"{'4-stage (locked, same 50)':40s} {o4['em_approx']:7.1f} {o4['ex']:7.1f} {o4['n']:4d}"
    )
    for name, s in summaries["variants"].items():
        em = s.get("exact_match_rate")
        ex = s.get("execution_rate")
        n = s.get("n", 50)
        em_s = f"{em:.1f}" if em is not None else "  --"
        ex_s = f"{ex:.1f}" if ex is not None else "  --"
        label = (
            "5-stage w/o Planner (seed 4-step)"
            if name == "no_planner"
            else "5-stage w/o Refiner (seed 4-step)"
        )
        print(f"{label:40s} {em_s:>7} {ex_s:>7} {n:4d}")
    print(
        f"{'6-stage (locked, same 50)':40s} {o6['em_approx']:7.1f} {o6['ex']:7.1f} {o6['n']:4d}"
    )
    print(f"\nWrote {out}")


if __name__ == "__main__":
    main()
