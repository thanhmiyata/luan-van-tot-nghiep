#!/usr/bin/env python3
"""Smoke-test 4-step / 6-step on a stratified 30-question Dr.Spider-340 subset.

Isolated under output/smoke_drspider30/ — does not touch Spider-dev benchmark trees.

Sampling (seed=42):
  - 1 sample from each of 17 perturbation types (17)
  - +13 extra samples from 13 randomly chosen types (total 30)
  → every type covered; 13 types have 2 samples.

Usage:
  source venv/bin/activate
  python scripts/smoke_test_drspider30.py --pipeline both
  python scripts/smoke_test_drspider30.py --pipeline 6step --no-fresh
"""

from __future__ import annotations

import argparse
import json
import os
import random
import shutil
import sqlite3
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import run_complete_nl2sql_pipeline as pipe  # noqa: E402

QUESTIONS_PATH = ROOT / "experiments/round2/drspider/drspider_340_questions.json"
GOLD_PATH = ROOT / "experiments/round2/drspider/drspider_340_gold_sql.json"
PERTURBATION_TYPES = [
    "DB_DBcontent_equivalence",
    "DB_schema_abbreviation",
    "DB_schema_synonym",
    "NLQ_column_attribute",
    "NLQ_column_carrier",
    "NLQ_column_synonym",
    "NLQ_column_value",
    "NLQ_keyword_carrier",
    "NLQ_keyword_synonym",
    "NLQ_multitype",
    "NLQ_others",
    "NLQ_value_synonym",
    "SQL_DB_number",
    "SQL_DB_text",
    "SQL_NonDB_number",
    "SQL_comparison",
    "SQL_sort_order",
]


def load_aligned() -> list[dict]:
    questions = json.loads(QUESTIONS_PATH.read_text(encoding="utf-8"))["items"]
    golds = {
        item["sample_id"]: item
        for item in json.loads(GOLD_PATH.read_text(encoding="utf-8"))["items"]
    }
    aligned = []
    for item in questions:
        gold = golds[item["sample_id"]]
        row = dict(item)
        row["gold_sql"] = gold["gold_sql"]
        aligned.append(row)
    return aligned


def sample_30(items: list[dict], seed: int = 42, n: int = 30) -> list[dict]:
    """Stratified subset; if n >= len(items) return the full aligned set."""
    if n >= len(items):
        return sorted(items, key=lambda x: x["sample_index"])

    rng = random.Random(seed)
    by_type: dict[str, list[dict]] = defaultdict(list)
    for item in items:
        by_type[item["perturbation_type"]].append(item)

    selected: list[dict] = []
    selected_ids: set[str] = set()
    for ptype in PERTURBATION_TYPES:
        pool = by_type[ptype]
        choice = rng.choice(pool)
        selected.append(choice)
        selected_ids.add(choice["sample_id"])

    extra_types = rng.sample(PERTURBATION_TYPES, n - len(PERTURBATION_TYPES))
    for ptype in extra_types:
        pool = [x for x in by_type[ptype] if x["sample_id"] not in selected_ids]
        choice = rng.choice(pool)
        selected.append(choice)
        selected_ids.add(choice["sample_id"])

    selected.sort(key=lambda x: x["sample_index"])
    return selected


def copy_raw_cache(src_pipeline_dir: Path, dst_pipeline_dir: Path) -> int:
    """Copy q*.json raw caches so resume can skip already-finished samples."""
    src_raw = src_pipeline_dir / "raw_responses"
    if not src_raw.is_dir():
        return 0
    copied = 0
    for src_file in src_raw.rglob("q*.json"):
        rel = src_file.relative_to(src_raw)
        dst_file = dst_pipeline_dir / "raw_responses" / rel
        dst_file.parent.mkdir(parents=True, exist_ok=True)
        if not dst_file.exists():
            shutil.copy2(src_file, dst_file)
            copied += 1
    return copied

def eval_db_id(sample: dict) -> str:
    # Unique, filesystem-safe id so DB-perturbed clones never collide.
    return f"s{sample['sample_index']:03d}_{sample['db_id']}"


def load_schema_for_sample(sample: dict) -> dict:
    tables = json.loads(
        (ROOT / sample["tables_relpath"]).read_text(encoding="utf-8")
    )
    for table in tables:
        if table["db_id"] == sample["db_id"]:
            return table
    raise KeyError(
        f"db_id={sample['db_id']} not in {sample['tables_relpath']}"
    )


def collect_samples_from_path(
    db_path: Path, table_schema: dict, max_values: int = 4, max_len: int = 30
) -> list[list[str]]:
    columns = table_schema["column_names_original"]
    types = table_schema["column_types"]
    samples: list[list[str]] = [[] for _ in columns]
    if not db_path.is_file():
        return samples
    try:
        con = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
        con.text_factory = lambda b: b.decode(errors="replace")
        tables = table_schema["table_names_original"]
        for idx, (t_idx, col_name) in enumerate(columns):
            if t_idx < 0 or idx >= len(types) or types[idx] != "text":
                continue
            try:
                rows = con.execute(
                    f'SELECT DISTINCT "{col_name}" FROM "{tables[t_idx]}" '
                    f'WHERE "{col_name}" IS NOT NULL LIMIT {max_values}'
                ).fetchall()
                samples[idx] = [str(r[0])[:max_len] for r in rows]
            except Exception:
                pass
        con.close()
    except Exception:
        pass
    return samples


def stage_databases(samples: list[dict], stage_root: Path) -> dict[str, Path]:
    """Copy each sample sqlite under stage_root/{eval_db_id}/{eval_db_id}.sqlite."""
    stage_root.mkdir(parents=True, exist_ok=True)
    mapping: dict[str, Path] = {}
    for sample in samples:
        eid = eval_db_id(sample)
        src = ROOT / sample["database_relpath"]
        dst_dir = stage_root / eid
        dst_dir.mkdir(parents=True, exist_ok=True)
        dst = dst_dir / f"{eid}.sqlite"
        if not dst.exists() or dst.stat().st_size != src.stat().st_size:
            shutil.copy2(src, dst)
        mapping[sample["sample_id"]] = dst
    return mapping


def build_test_questions(samples: list[dict]) -> list[dict]:
    questions = []
    for sample in samples:
        schema = load_schema_for_sample(sample)
        db_path = ROOT / sample["database_relpath"]
        eid = eval_db_id(sample)
        questions.append(
            {
                "question_index": sample["sample_index"],
                "sample_id": sample["sample_id"],
                "perturbation_group": sample["perturbation_group"],
                "perturbation_type": sample["perturbation_type"],
                "difficulty": sample["difficulty"],
                "source_db_id": sample["db_id"],
                "db_id": eid,
                "question": sample["question"],
                "gold_query": sample["gold_sql"],
                "table_names_original": schema["table_names_original"],
                "column_names_original": schema["column_names_original"],
                "column_types": schema["column_types"],
                "foreign_keys": schema.get("foreign_keys", []),
                "primary_keys": schema.get("primary_keys", []),
                "column_sample_values": collect_samples_from_path(db_path, schema),
                "database_abspath": str(db_path.resolve()),
            }
        )
    return questions


def build_tables_json(samples: list[dict], out_path: Path) -> None:
    tables_out = []
    for sample in samples:
        schema = dict(load_schema_for_sample(sample))
        schema["db_id"] = eval_db_id(sample)
        tables_out.append(schema)
    out_path.write_text(json.dumps(tables_out, ensure_ascii=False), encoding="utf-8")


def write_gold_predict(results: list[dict], questions: list[dict], out_dir: Path):
    by_q = {r.get("question") + "||" + r.get("db_id"): r for r in results}
    # Prefer aligning by question_index via raw files if present
    gold_lines, pred_lines = [], []
    for q in questions:
        gold = (q["gold_query"] or "").strip().replace("\n", " ")
        pred = "SELECT 1"
        raw = (
            out_dir
            / "raw_responses"
            / q["db_id"]
            / f"q{q['question_index']:04d}.json"
        )
        if raw.exists():
            cached = json.loads(raw.read_text(encoding="utf-8"))
            pred = (cached.get("final_sql") or "").strip().replace("\n", " ") or "SELECT 1"
            pred = pipe.normalize_sql_for_spider(pred)
        else:
            key = q["question"] + "||" + q["db_id"]
            if key in by_q:
                pred = (by_q[key].get("sql") or "").strip().replace("\n", " ") or "SELECT 1"
                pred = pipe.normalize_sql_for_spider(pred)
        gold_lines.append(f"{gold}\t{q['db_id']}")
        pred_lines.append(f"{pred}\t{q['db_id']}")
    gold_path = out_dir / "gold.sql"
    pred_path = out_dir / "predict.sql"
    gold_path.write_text("\n".join(gold_lines) + "\n", encoding="utf-8")
    pred_path.write_text("\n".join(pred_lines) + "\n", encoding="utf-8")
    return gold_path, pred_path


def run_official_eval(gold_path: Path, pred_path: Path, db_root: Path, tables_path: Path):
    import subprocess

    eval_dir = (ROOT / "experiments/test-suite-sql-eval").resolve()
    eval_py = eval_dir / "evaluation.py"
    cmd = [
        sys.executable,
        str(eval_py),
        "--gold",
        str(gold_path.resolve()),
        "--pred",
        str(pred_path.resolve()),
        "--db",
        str(db_root.resolve()),
        "--etype",
        "all",
        "--table",
        str(tables_path.resolve()),
        "--plug_value",
    ]
    print("🚀", " ".join(cmd))
    proc = subprocess.run(
        cmd,
        cwd=str(eval_dir),
        capture_output=True,
        text=True,
    )
    text = (proc.stdout or "") + "\n" + (proc.stderr or "")
    print(text[-4000:])
    metrics = {"execution_rate": 0.0, "exact_match_rate": 0.0}
    import re

    for line in text.splitlines():
        if line.strip().startswith("execution"):
            m = re.search(r"execution\s+([0-9.]+)", line)
            if m:
                val = float(m.group(1))
                metrics["execution_rate"] = val * 100 if val <= 1.0 else val
        if "exact match" in line.lower():
            m = re.search(r"exact match\s+([0-9.]+)", line, re.I)
            if m:
                val = float(m.group(1))
                metrics["exact_match_rate"] = val * 100 if val <= 1.0 else val
    # fallback: last "all" column on execution/exact lines already parsed above
    return metrics, text


def per_group_ex(questions: list[dict], gold_path: Path, pred_path: Path, db_root: Path):
    """Lightweight EX by group using official denotation when possible; else sqlite bag-eq."""
    sys.path.insert(0, str(ROOT / "experiments/test-suite-sql-eval"))
    try:
        from exec_eval import eval_exec_match  # type: ignore
    except Exception:
        eval_exec_match = None

    golds = gold_path.read_text(encoding="utf-8").splitlines()
    preds = pred_path.read_text(encoding="utf-8").splitlines()
    rows = []
    for q, gline, pline in zip(questions, golds, preds):
        gsql = gline.rsplit("\t", 1)[0]
        psql = pline.rsplit("\t", 1)[0]
        db_file = db_root / q["db_id"] / f"{q['db_id']}.sqlite"
        ok = False
        if eval_exec_match is not None:
            try:
                ok = bool(
                    eval_exec_match(
                        str(db_file),
                        gsql,
                        psql,
                        plug_value=True,
                        keep_distinct=False,
                        progress_bar_for_each_datapoint=False,
                    )
                )
            except Exception:
                ok = False
        else:
            try:
                con = sqlite3.connect(f"file:{db_file}?mode=ro", uri=True)
                g = sorted(map(str, con.execute(gsql).fetchall()))
                p = sorted(map(str, con.execute(psql).fetchall()))
                ok = g == p
                con.close()
            except Exception:
                ok = False
        rows.append({**{k: q[k] for k in (
            "sample_id", "perturbation_group", "perturbation_type", "difficulty", "db_id"
        )}, "ex": ok})
    by_group = defaultdict(list)
    by_type = defaultdict(list)
    for r in rows:
        by_group[r["perturbation_group"]].append(r["ex"])
        by_type[r["perturbation_type"]].append(r["ex"])
    summary = {
        "overall": 100.0 * sum(r["ex"] for r in rows) / len(rows) if rows else 0.0,
        "by_group": {
            g: 100.0 * sum(v) / len(v) for g, v in sorted(by_group.items())
        },
        "by_type": {
            t: {"n": len(v), "ex": 100.0 * sum(v) / len(v)}
            for t, v in sorted(by_type.items())
        },
        "n_correct": sum(r["ex"] for r in rows),
        "n_total": len(rows),
    }
    return summary, rows


def run_pipeline(pipeline: str, questions: list[dict], out_dir: Path, db_root: Path):
    pipe.configure_pipeline(pipeline)
    pipe.PIPELINE_OUTPUT_DIR = out_dir
    out_dir.mkdir(parents=True, exist_ok=True)
    os.environ["SPIDER_DATABASE_DIR"] = str(db_root.resolve())

    if not pipe.setup_environment():
        raise RuntimeError("setup_environment failed")

    t0 = time.time()
    csv_filename, results = pipe.run_nl2sql_system(questions)
    if not csv_filename:
        raise RuntimeError(f"{pipeline} pipeline failed")
    gold_path, pred_path = write_gold_predict(results or [], questions, out_dir)
    tables_path = out_dir / "tables.json"
    # questions already have schemas encoded; rebuild from samples via gold db_id mapping
    # Use staged eval ids from questions
    tables_out = []
    # recover original sample schema via source fields stored on questions — rebuild from files
    qmeta = json.loads((out_dir.parent / "sample_manifest.json").read_text(encoding="utf-8"))
    sample_by_index = {s["sample_index"]: s for s in qmeta["samples"]}
    for q in questions:
        sample = sample_by_index[q["question_index"]]
        schema = dict(load_schema_for_sample(sample))
        schema["db_id"] = q["db_id"]
        tables_out.append(schema)
    tables_path.write_text(json.dumps(tables_out, ensure_ascii=False), encoding="utf-8")

    metrics, _ = run_official_eval(gold_path, pred_path, db_root, tables_path)
    group_summary, detail_rows = per_group_ex(questions, gold_path, pred_path, db_root)
    elapsed = time.time() - t0
    summary = {
        "pipeline": pipeline,
        "n": len(questions),
        "elapsed_sec": elapsed,
        "official": metrics,
        "ex_by_group": group_summary,
    }
    (out_dir / "smoke_summary.json").write_text(
        json.dumps(summary, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    (out_dir / "ex_detail.json").write_text(
        json.dumps(detail_rows, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    print("\n" + "=" * 72)
    print(f"Dr.Spider | {pipeline} | n={len(questions)}")
    print("=" * 72)
    print(
        f"Official: EX={metrics.get('execution_rate', 0):.1f}%  "
        f"EM={metrics.get('exact_match_rate', 0):.1f}%  ({elapsed/60:.1f} phút)"
    )
    print(f"EX bag/exec_eval: {group_summary['n_correct']}/{group_summary['n_total']} "
          f"= {group_summary['overall']:.1f}%")
    print("By group:", group_summary["by_group"])
    print(f"Artifacts: {out_dir}")
    print("=" * 72)
    return summary


def main() -> int:
    parser = argparse.ArgumentParser(description="Dr.Spider-340 smoke / full runner")
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--num_questions", type=int, default=30)
    parser.add_argument(
        "--all",
        action="store_true",
        help="Run full 340-item diagnostic set (ignores --num_questions).",
    )
    parser.add_argument(
        "--pipeline",
        choices=["4step", "6step", "both"],
        default="both",
    )
    parser.add_argument(
        "--output-dir",
        default="output/smoke_drspider30",
        help="Root output (contains sample_manifest + per-pipeline subdirs)",
    )
    parser.add_argument(
        "--seed-raw-from",
        default="",
        help="Copy existing raw_responses from this root (e.g. output/smoke_drspider30) for resume.",
    )
    parser.add_argument("--fresh", action="store_true")
    parser.add_argument("--no-fresh", action="store_true")
    args = parser.parse_args()

    out_root = ROOT / args.output_dir
    if args.fresh and out_root.exists():
        print(f"🧹 Xóa output cũ: {out_root}")
        shutil.rmtree(out_root)
    out_root.mkdir(parents=True, exist_ok=True)

    items = load_aligned()
    n = len(items) if args.all else args.num_questions
    samples = sample_30(items, seed=args.seed, n=n)
    print(
        f"📌 Selected {len(samples)} / {len(items)} | seed={args.seed} | "
        f"groups={dict(Counter(s['perturbation_group'] for s in samples))} | "
        f"types={len(set(s['perturbation_type'] for s in samples))}"
    )
    if len(samples) <= 40:
        for s in samples:
            print(
                f"  [{s['sample_index']:03d}] {s['perturbation_type']:<28} "
                f"{s['difficulty']:<7} {s['db_id']}"
            )
    else:
        print("  (full set — skip per-item listing)")

    manifest = {
        "protocol": "drspider340-full-v1" if args.all else "drspider340-smoke30-v1",
        "seed": args.seed,
        "num_questions": len(samples),
        "parent_questions": str(QUESTIONS_PATH.relative_to(ROOT)),
        "sample_ids": [s["sample_id"] for s in samples],
        "samples": samples,
        "type_counts": dict(Counter(s["perturbation_type"] for s in samples)),
        "group_counts": dict(Counter(s["perturbation_group"] for s in samples)),
        "difficulty_counts": dict(Counter(s["difficulty"] for s in samples)),
    }
    (out_root / "sample_manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8"
    )

    db_root = out_root / "database"
    print("📦 Staging SQLite databases...")
    stage_databases(samples, db_root)
    questions = build_test_questions(samples)
    build_tables_json(samples, out_root / "tables.json")

    pipelines = ["4step", "6step"] if args.pipeline == "both" else [args.pipeline]
    if args.seed_raw_from:
        seed_root = ROOT / args.seed_raw_from
        for p in pipelines:
            n_copied = copy_raw_cache(seed_root / p, out_root / p)
            print(f"⏩ Seeded {n_copied} raw cache file(s) for {p} from {seed_root / p}")

    summaries = {}
    for p in pipelines:
        pdir = out_root / p
        pdir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(out_root / "tables.json", pdir / "tables.json")
        summaries[p] = run_pipeline(p, questions, pdir, db_root)

    (out_root / "smoke_summary_all.json").write_text(
        json.dumps(summaries, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    if len(summaries) >= 1:
        label = f"Dr.Spider-{len(samples)}"
        print(f"\n📊 SO SÁNH NHANH 4-step vs 6-step ({label})")
        for p, s in summaries.items():
            ex = s["ex_by_group"]["overall"]
            em = s["official"].get("exact_match_rate", 0)
            g = s["ex_by_group"]["by_group"]
            print(f"  {p}: EX(exec_eval)={ex:.1f}% EM(official)={em:.1f}% | groups={g}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
