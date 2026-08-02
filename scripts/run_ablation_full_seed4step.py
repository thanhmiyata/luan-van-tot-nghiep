#!/usr/bin/env python3
"""Full Spider-dev ablation 5-stage with hybrid 4→5 seed (API).

Reuses Analyzer + Schema + Direct from ``output/nl2sql_4step/raw_responses``.
Only calls remaining LLM stages per variant. Does NOT touch locked 4/6-step
outputs.

Variants:
  no_planner — SKIP_PLANNER=1 → LLM: Refiner (if needed) + Validator
  no_refiner — SKIP_REFINER=1 → LLM: Planner + Planned + Validator

Usage:
  python scripts/run_ablation_full_seed4step.py --db-id world_1 --variants no_planner
  python scripts/run_ablation_full_seed4step.py --db-id world_1 --variants no_refiner
  python scripts/run_ablation_full_seed4step.py --all-dbs --variants no_planner no_refiner
  python scripts/run_ablation_full_seed4step.py --aggregate
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import sys
import time
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
OUT_ROOT = PROJECT_ROOT / "output" / "ablation_full_seed4step"
PROGRESS_FILE = SIX_OUT / "benchmark_progress.json"

# Match agents.yaml (conference backbone): Expert=GPT-4o; Planner/Refiner/Validator=Gemini.
GPT4O = "openai/gpt-4o"
GEMINI = "gemini/gemini-flash-latest"
CLAUDE = "anthropic/claude-sonnet-4-20250514"
# Per-role env → agents.yaml. Fallback: GPT-4o then Claude on 429/quota.
YAML_MODEL_ENV = {
    "NL2SQL_QUERY_PLANNER_MODEL": GEMINI,
    "NL2SQL_QUERY_PLANNER_FALLBACK_MODEL": GPT4O,
    "NL2SQL_DIRECT_SQL_MODEL": GPT4O,
    "NL2SQL_PLANNED_SQL_MODEL": GPT4O,
    "NL2SQL_PLANNED_SQL_FALLBACK_MODEL": CLAUDE,
    "NL2SQL_SQL_REFINER_MODEL": GEMINI,
    "NL2SQL_SQL_REFINER_FALLBACK_MODEL": GPT4O,
    "NL2SQL_SQL_VALIDATOR_MODEL": GEMINI,
    "NL2SQL_SQL_VALIDATOR_FALLBACK_MODEL": GPT4O,
}

CREDIT_FAIL_MARKERS = (
    "insufficient_quota",
    "exceeded your current quota",
    "billing",
    "credit balance",
    "rate_limit",
    "429",
    "RESOURCE_EXHAUSTED",
    "quota exceeded",
    "Your credit balance is too low",
    "insufficient credits",
)


def db_order() -> list[str]:
    if PROGRESS_FILE.exists():
        data = json.loads(PROGRESS_FILE.read_text(encoding="utf-8"))
        order = data.get("db_order") or []
        if order:
            return list(order)
    return [
        "world_1",
        "car_1",
        "cre_Doc_Template_Mgt",
        "dog_kennels",
        "flight_2",
        "student_transcripts_tracking",
        "tvshow",
        "wta_1",
        "network_1",
        "concert_singer",
        "pets_1",
        "orchestra",
        "poker_player",
        "employee_hire_evaluation",
        "course_teach",
        "singer",
        "museum_visit",
        "battle_death",
        "voter_1",
        "real_estate_properties",
    ]


def apply_yaml_models() -> None:
    """Force remaining LLM steps to agents.yaml roles (not all-GPT-4o)."""
    for key, val in YAML_MODEL_ENV.items():
        os.environ[key] = val


def apply_emergency_models(primary: str, fallback: str) -> None:
    """Only used after credit/quota failure on both Gemini and GPT-4o paths."""
    for key in YAML_MODEL_ENV:
        if "FALLBACK" in key:
            os.environ[key] = fallback
        else:
            os.environ[key] = primary


def looks_like_credit_failure(err: str) -> bool:
    low = (err or "").lower()
    return any(m.lower() in low for m in CREDIT_FAIL_MARKERS)


def set_variant_env(name: str) -> None:
    os.environ["NL2SQL_SEED_FROM_4STEP"] = str(FOUR_OUT)
    os.environ["NL2SQL_SEED_INCLUDE_DIRECT"] = "1"
    os.environ.setdefault("NL2SQL_STEP_TIMEOUT_SECONDS", "90")
    os.environ.setdefault("NL2SQL_STEP_MAX_RETRIES", "2")
    if name == "no_planner":
        os.environ["NL2SQL_SKIP_PLANNER"] = "1"
        os.environ.pop("NL2SQL_SKIP_REFINER", None)
    elif name == "no_refiner":
        os.environ["NL2SQL_SKIP_REFINER"] = "1"
        os.environ.pop("NL2SQL_SKIP_PLANNER", None)
    else:
        raise ValueError(name)


def clear_variant_env() -> None:
    for k in (
        "NL2SQL_SKIP_PLANNER",
        "NL2SQL_SKIP_REFINER",
        "NL2SQL_SEED_INCLUDE_DIRECT",
        "NL2SQL_SEED_FROM_4STEP",
    ):
        os.environ.pop(k, None)


def load_questions_for_db(db_id: str) -> list[dict]:
    import run_complete_nl2sql_pipeline as pl

    pl.configure_pipeline("6step")
    qs = pl.get_test_questions(num_questions=0, db_id=db_id)
    if not qs:
        raise RuntimeError(f"No questions for db_id={db_id}")
    return qs


def official_eval(variant_dir: Path) -> dict:
    import run_complete_nl2sql_pipeline as pl

    pl.configure_pipeline("6step")
    gold = variant_dir / "gold.sql"
    pred = variant_dir / "predict.sql"
    if not gold.exists() or not pred.exists():
        return {}
    return pl.run_evaluation(str(gold), str(pred)) or {}


def rebuild_db_artifacts(variant_dir: Path, db_id: str, questions: list[dict]) -> None:
    """Write per_db gold/predict from raw_responses (resume-safe order)."""
    raw_dir = variant_dir / "raw_responses" / db_id
    per_db = variant_dir / "per_db" / db_id
    per_db.mkdir(parents=True, exist_ok=True)
    gold_lines: list[str] = []
    pred_lines: list[str] = []
    missing = 0
    for q in questions:
        qi = int(q["question_index"])
        path = raw_dir / f"q{qi:04d}.json"
        gold = (q.get("gold_query") or q.get("query") or "").strip()
        sql = "SELECT 1"
        if path.is_file():
            obj = json.loads(path.read_text(encoding="utf-8"))
            sql = (obj.get("final_sql") or "").strip() or "SELECT 1"
            if obj.get("gold_query"):
                gold = str(obj["gold_query"]).strip()
        else:
            missing += 1
        gold_lines.append(f"{gold}\t{db_id}")
        pred_lines.append(sql)
    (per_db / "gold.sql").write_text("\n".join(gold_lines) + "\n", encoding="utf-8")
    (per_db / "predict.sql").write_text(
        "\n".join(pred_lines) + "\n", encoding="utf-8"
    )
    if missing:
        print(f"  WARNING: {missing} questions missing raw for {db_id}")


def rebuild_variant_aggregate(variant_dir: Path, order: list[str]) -> None:
    """Concatenate per_db gold/predict in db_order into variant root."""
    gold_all: list[str] = []
    pred_all: list[str] = []
    for db_id in order:
        per = variant_dir / "per_db" / db_id
        g = per / "gold.sql"
        p = per / "predict.sql"
        if not g.exists() or not p.exists():
            continue
        gold_all.extend(
            ln for ln in g.read_text(encoding="utf-8").splitlines() if ln.strip()
        )
        pred_all.extend(
            ln for ln in p.read_text(encoding="utf-8").splitlines() if ln.strip()
        )
    if not gold_all:
        return
    (variant_dir / "gold.sql").write_text("\n".join(gold_all) + "\n", encoding="utf-8")
    (variant_dir / "predict.sql").write_text(
        "\n".join(pred_all) + "\n", encoding="utf-8"
    )


def progress_path(variant: str) -> Path:
    return OUT_ROOT / variant / "progress.json"


def load_progress(variant: str) -> dict:
    path = progress_path(variant)
    if path.exists():
        return json.loads(path.read_text(encoding="utf-8"))
    return {
        "variant": variant,
        "db_order": db_order(),
        "databases": {},
        "created_at": datetime.now().isoformat(),
    }


def save_progress(variant: str, progress: dict) -> None:
    progress["updated_at"] = datetime.now().isoformat()
    path = progress_path(variant)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(progress, ensure_ascii=False, indent=2), encoding="utf-8")


def run_db_variant(
    name: str,
    db_id: str,
    *,
    force: bool = False,
    limit: int | None = None,
    primary_model: str = GEMINI,
    fallback_model: str = GPT4O,
    use_yaml_models: bool = True,
) -> dict:
    import run_complete_nl2sql_pipeline as pl
    from nl2sql_flow.main import (
        NL2SQLFlow,
        NLQuestions,
        SQLDbSchema,
        load_four_step_seed_file,
        map_four_step_seed_to_six_steps,
    )

    pl.configure_pipeline("6step")
    if not pl.setup_environment():
        raise RuntimeError("setup_environment failed")

    questions = load_questions_for_db(db_id)
    if limit:
        questions = questions[:limit]

    variant_dir = OUT_ROOT / name
    raw_dir = variant_dir / "raw_responses" / db_id
    raw_dir.mkdir(parents=True, exist_ok=True)

    set_variant_env(name)
    if use_yaml_models:
        apply_yaml_models()
        model_note = (
            f"yaml Planner/Refiner/Validator={GEMINI} Planned/Expert={GPT4O} "
            f"fallback={GPT4O}/{CLAUDE}"
        )
    else:
        apply_emergency_models(primary_model, fallback_model)
        model_note = f"emergency primary={primary_model} fallback={fallback_model}"
    print(
        f"\n######## [{name}] db={db_id} n={len(questions)} "
        f"models={model_note} ########"
    )

    seeded_ok = 0
    skipped_resume = 0
    ran = 0
    credit_stop = False
    t0 = time.time()
    rows_meta: list[dict] = []

    for i, q in enumerate(questions, 1):
        qi = int(q["question_index"])
        out_path = raw_dir / f"q{qi:04d}.json"
        if out_path.exists() and not force:
            skipped_resume += 1
            obj = json.loads(out_path.read_text(encoding="utf-8"))
            if obj.get("seeded_steps"):
                seeded_ok += 1
            rows_meta.append(
                {
                    "question_index": qi,
                    "status": "resume_skip",
                    "seeded": bool(obj.get("seeded_steps")),
                }
            )
            continue

        four_raw = load_four_step_seed_file(
            FOUR_OUT, q["db_id"], qi, q["question"]
        )
        seed_steps = map_four_step_seed_to_six_steps(four_raw) if four_raw else {}
        required = {"question_analysis", "schema_selector", "generate_sql_direct"}
        if not required.issubset(set(seed_steps.keys())):
            missing = sorted(required - set(seed_steps.keys()))
            raise RuntimeError(
                f"MISSING 4-step seed for {db_id} qi={qi}: need {sorted(required)}, "
                f"got {sorted(seed_steps.keys())}, missing={missing}. "
                f"Refusing silent full-rerun of early stages."
            )
        seeded_ok += 1

        print(
            f"\n=== [{name}] {db_id} {i}/{len(questions)} qi={qi} "
            f"seed={','.join(sorted(seed_steps.keys()))}"
        )
        print(f"  Q: {q['question'][:80]}...")

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
        sql, err = "", ""
        try:
            result = flow.kickoff()
            sql = (result.result.sql or "").strip()
            err = result.result.error or ""
        except Exception as e:
            sql, err = "", f"{type(e).__name__}: {e}"
            print("  FLOW ERROR:", err)

        if looks_like_credit_failure(err):
            # Escalate: yaml (Gemini+GPT4o) → all GPT-4o → all Claude; stop if still failing.
            for emergency_primary, emergency_fallback, label in (
                (GPT4O, CLAUDE, "GPT-4o"),
                (CLAUDE, CLAUDE, "Claude"),
            ):
                if use_yaml_models or primary_model != emergency_primary:
                    print(f"  credit/quota failure → emergency models={label}")
                    apply_emergency_models(emergency_primary, emergency_fallback)
                    use_yaml_models = False
                    primary_model = emergency_primary
                    fallback_model = emergency_fallback
                    try:
                        flow2 = NL2SQLFlow(
                            _question=NLQuestions(
                                question=q["question"], db_id=q["db_id"]
                            ),
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
                        result = flow2.kickoff()
                        sql = (result.result.sql or "").strip()
                        err = result.result.error or ""
                        flow = flow2
                    except Exception as e2:
                        sql, err = "", f"{type(e2).__name__}: {e2}"
                        print("  FALLBACK FLOW ERROR:", err)
                    if not looks_like_credit_failure(err):
                        break

            if looks_like_credit_failure(err):
                credit_stop = True
                print(
                    "\n!!! STOP: Gemini/GPT-4o/Claude all appear out of credit/quota."
                )
                print(f"    Last error: {err[:300]}")
                clear_variant_env()
                return {
                    "db_id": db_id,
                    "variant": name,
                    "status": "credit_exhausted",
                    "error": err,
                    "ran": ran,
                    "skipped_resume": skipped_resume,
                    "seeded_ok": seeded_ok,
                    "n": len(questions),
                }

        traces = getattr(flow, "step_traces", []) or []
        payload = {
            "question_index": qi,
            "pipeline": f"ablation_full_{name}",
            "db_id": q["db_id"],
            "question": q["question"],
            "gold_query": q.get("gold_query") or q.get("query") or "",
            "hardness": q.get("hardness"),
            "steps": traces,
            "final_sql": sql,
            "error": err,
            "seeded_steps": sorted(seed_steps.keys()),
            "models": {
                "policy": "agents.yaml" if use_yaml_models else "emergency",
                "planner_refiner_validator": GEMINI if use_yaml_models else primary_model,
                "planned_expert": GPT4O if use_yaml_models else primary_model,
                "fallback": fallback_model,
            },
            "timestamp": datetime.now().isoformat(),
        }
        out_path.write_text(
            json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8"
        )
        ran += 1
        rows_meta.append(
            {
                "question_index": qi,
                "status": "ok" if sql else "empty",
                "seeded": True,
                "error": err[:200] if err else "",
            }
        )

    rebuild_db_artifacts(variant_dir, db_id, questions)
    per_db = variant_dir / "per_db" / db_id
    metrics = official_eval(per_db) if (per_db / "predict.sql").exists() else {}

    # CSV for this DB
    csv_path = per_db / f"results_{name}.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(
            f, fieldnames=["question_index", "status", "seeded", "error"]
        )
        w.writeheader()
        w.writerows(rows_meta)

    summary = {
        "db_id": db_id,
        "variant": name,
        "status": "done",
        "n": len(questions),
        "ran": ran,
        "skipped_resume": skipped_resume,
        "seeded_ok": seeded_ok,
        "seed_pct": round(100.0 * seeded_ok / max(len(questions), 1), 1),
        "elapsed_sec": round(time.time() - t0, 1),
        "execution_rate": metrics.get("execution_rate"),
        "exact_match_rate": metrics.get("exact_match_rate"),
        "metrics": metrics,
        "primary_model": primary_model,
        "fallback_model": fallback_model,
        "model_policy": "agents.yaml" if use_yaml_models else "emergency",
        "yaml_models": YAML_MODEL_ENV if use_yaml_models else None,
        "finished_at": datetime.now().isoformat(),
        "credit_stop": credit_stop,
    }
    (per_db / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    progress = load_progress(name)
    progress["databases"][db_id] = {
        "status": summary["status"],
        "n": summary["n"],
        "ran": ran,
        "skipped_resume": skipped_resume,
        "seeded_ok": seeded_ok,
        "seed_pct": summary["seed_pct"],
        "execution_rate": summary.get("execution_rate"),
        "exact_match_rate": summary.get("exact_match_rate"),
        "finished_at": summary["finished_at"],
    }
    save_progress(name, progress)

    rebuild_variant_aggregate(variant_dir, db_order())
    clear_variant_env()

    print(
        f"\n>>> [{name}/{db_id}] done: seeded={seeded_ok}/{len(questions)} "
        f"({summary['seed_pct']}%) ran={ran} resume_skip={skipped_resume} "
        f"EX={summary.get('execution_rate')} EM={summary.get('exact_match_rate')}"
    )
    return summary


def aggregate_variant(name: str) -> dict:
    variant_dir = OUT_ROOT / name
    order = db_order()
    rebuild_variant_aggregate(variant_dir, order)
    metrics = official_eval(variant_dir)
    # Count lines
    pred = variant_dir / "predict.sql"
    n = 0
    if pred.exists():
        n = sum(1 for ln in pred.read_text(encoding="utf-8").splitlines() if ln.strip())
    summary = {
        "variant": name,
        "n": n,
        "execution_rate": metrics.get("execution_rate"),
        "exact_match_rate": metrics.get("exact_match_rate"),
        "metrics": metrics,
        "protocol": (
            "5-stage ablations reuse 4-step early-stage outputs "
            "(Analyzer/Schema/Direct) to isolate Planner/Refiner cost."
        ),
        "finished_at": datetime.now().isoformat(),
    }
    (variant_dir / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print(
        f"AGGREGATE [{name}] n={n} EX={summary.get('execution_rate')} "
        f"EM={summary.get('exact_match_rate')}"
    )
    return summary


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--db-id", type=str, default=None)
    parser.add_argument("--all-dbs", action="store_true")
    parser.add_argument(
        "--variants",
        nargs="+",
        default=["no_planner", "no_refiner"],
        choices=["no_planner", "no_refiner"],
    )
    parser.add_argument("--limit", type=int, default=None, help="debug: first N per DB")
    parser.add_argument("--force", action="store_true", help="rerun even if raw exists")
    parser.add_argument("--aggregate", action="store_true")
    parser.add_argument(
        "--primary-model",
        default=GEMINI,
        help="Only used with --force-all-same-model (legacy/emergency).",
    )
    parser.add_argument("--fallback-model", default=GPT4O)
    parser.add_argument(
        "--force-all-same-model",
        action="store_true",
        help="Override yaml roles; set every remaining LLM step to --primary-model.",
    )
    args = parser.parse_args()

    OUT_ROOT.mkdir(parents=True, exist_ok=True)

    if args.aggregate and not args.db_id and not args.all_dbs:
        for name in args.variants:
            aggregate_variant(name)
        return

    if args.all_dbs:
        targets = db_order()
    elif args.db_id:
        targets = [args.db_id]
    else:
        parser.error("Specify --db-id or --all-dbs (or --aggregate only)")

    print(f"OUT_ROOT={OUT_ROOT}")
    print(f"SEED={FOUR_OUT}")
    print(f"targets={targets}")
    print(f"variants={args.variants}")

    all_summaries: dict = {}
    for name in args.variants:
        all_summaries[name] = {}
        for db_id in targets:
            s = run_db_variant(
                name,
                db_id,
                force=args.force,
                limit=args.limit,
                primary_model=args.primary_model,
                fallback_model=args.fallback_model,
                use_yaml_models=not args.force_all_same_model,
            )
            all_summaries[name][db_id] = s
            if s.get("status") == "credit_exhausted":
                print("Stopping further DBs due to credit exhaustion.")
                (OUT_ROOT / "last_run_summary.json").write_text(
                    json.dumps(all_summaries, ensure_ascii=False, indent=2),
                    encoding="utf-8",
                )
                sys.exit(2)

        if args.aggregate or args.all_dbs or len(targets) > 1:
            all_summaries[name]["_aggregate"] = aggregate_variant(name)

    (OUT_ROOT / "last_run_summary.json").write_text(
        json.dumps(all_summaries, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print("\n======== DONE ========")
    for name, by_db in all_summaries.items():
        for db_id, s in by_db.items():
            if db_id.startswith("_"):
                continue
            print(
                f"  {name}/{db_id}: seed={s.get('seed_pct')}% "
                f"EX={s.get('execution_rate')} EM={s.get('exact_match_rate')} "
                f"ran={s.get('ran')} resume={s.get('skipped_resume')}"
            )


if __name__ == "__main__":
    main()
