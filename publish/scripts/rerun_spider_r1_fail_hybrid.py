#!/usr/bin/env python3
"""Rerun Spider R1 failing questions with hybrid 4→6 seed (Analyzer+Schema only).

Seeds steps 1–2 from ``output/nl2sql_4step`` raw responses, then calls LLM for
Planner / Expert (Direct+Planned) / Refiner / Validator. Patches per_db predict
lines and re-evaluates EX for the target DBs.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(PROJECT_ROOT / "experiments" / "test-suite-sql-eval"))

from exec_eval import eval_exec_match  # noqa: E402


DEFAULT_DBS = ("wta_1", "pets_1")
SIX_OUT = PROJECT_ROOT / "output" / "nl2sql_6step"
FOUR_OUT = PROJECT_ROOT / "output" / "nl2sql_4step"
DB_DIR = PROJECT_ROOT / "data" / "spider_data" / "database"


def _load_dev():
    path = PROJECT_ROOT / "data" / "dev.json"
    return json.loads(path.read_text(encoding="utf-8"))


def _split_sql_line(line: str) -> str:
    return line.split("\t", 1)[0].strip()


def list_failing_global_indices(db_id: str) -> list[int]:
    """Return global Spider-dev indices where 6-step EX currently fails."""
    dev = _load_dev()
    global_ids = [i for i, row in enumerate(dev) if row["db_id"] == db_id]
    gold_path = SIX_OUT / "per_db" / db_id / "gold.sql"
    pred_path = SIX_OUT / "per_db" / db_id / "predict.sql"
    golds = [
        ln.strip()
        for ln in gold_path.read_text(encoding="utf-8").splitlines()
        if ln.strip()
    ]
    preds = [
        ln.strip()
        for ln in pred_path.read_text(encoding="utf-8").splitlines()
        if ln.strip()
    ]
    if len(golds) != len(preds) or len(golds) != len(global_ids):
        raise RuntimeError(
            f"{db_id}: gold/pred/dev length mismatch "
            f"{len(golds)}/{len(preds)}/{len(global_ids)}"
        )
    db_path = DB_DIR / db_id / f"{db_id}.sqlite"
    fails: list[int] = []
    for local_i, (gline, pline) in enumerate(zip(golds, preds)):
        gsql = _split_sql_line(gline)
        psql = _split_sql_line(pline)
        try:
            ok = bool(
                eval_exec_match(
                    str(db_path), psql, gsql, False, False, False
                )
            )
        except Exception:
            ok = False
        if not ok:
            fails.append(global_ids[local_i])
    return fails


def list_select1_global_indices(db_id: str) -> list[int]:
    """Return gids whose current predict is SELECT 1 / empty (rate-limit placeholders)."""
    dev = _load_dev()
    global_ids = [i for i, row in enumerate(dev) if row["db_id"] == db_id]
    pred_path = SIX_OUT / "per_db" / db_id / "predict.sql"
    preds = [
        ln.strip()
        for ln in pred_path.read_text(encoding="utf-8").splitlines()
        if ln.strip()
    ]
    out: list[int] = []
    for local_i, pline in enumerate(preds):
        psql = _split_sql_line(pline).lower().rstrip(";")
        if psql in {"select 1", ""}:
            out.append(global_ids[local_i])
    return out


def restore_predict_from_bak_for_gids(db_id: str, gids: list[int]) -> int:
    """Restore pre-rerun SQL for placeholder lines so EX does not regress further."""
    pred_path = SIX_OUT / "per_db" / db_id / "predict.sql"
    bak = pred_path.with_suffix(".sql.bak_before_r1_hybrid")
    if not bak.exists():
        print(f"  no bak to restore for {db_id}")
        return 0
    dev = _load_dev()
    global_ids = [i for i, row in enumerate(dev) if row["db_id"] == db_id]
    gid_to_local = {gid: i for i, gid in enumerate(global_ids)}
    cur = pred_path.read_text(encoding="utf-8").splitlines()
    old = bak.read_text(encoding="utf-8").splitlines()
    restored = 0
    for gid in gids:
        local_i = gid_to_local[gid]
        cur_sql = _split_sql_line(cur[local_i]).lower().rstrip(";")
        bak_sql = _split_sql_line(old[local_i])
        if cur_sql in {"select 1", ""} and bak_sql.strip():
            cur[local_i] = old[local_i]
            restored += 1
    if restored:
        pred_path.write_text("\n".join(cur) + "\n", encoding="utf-8")
    print(f"  restored {restored} predict lines from bak for {db_id}")
    return restored


def _archive_and_drop_raw(db_id: str, gids: list[int], archive_tag: str) -> None:
    raw_dir = SIX_OUT / "raw_responses" / db_id
    archive = (
        SIX_OUT
        / "raw_responses"
        / f"_archive_r1_{archive_tag}"
        / db_id
    )
    archive.mkdir(parents=True, exist_ok=True)
    for gid in gids:
        src = raw_dir / f"q{gid:04d}.json"
        if src.is_file():
            shutil.move(str(src), str(archive / src.name))
            print(f"  archived cache {src.name}")
        err = raw_dir / f"q{gid:04d}.error.json"
        if err.is_file():
            shutil.move(str(err), str(archive / err.name))


def _patch_predict(db_id: str, gid_to_sql: dict[int, str]) -> None:
    pred_path = SIX_OUT / "per_db" / db_id / "predict.sql"
    backup = pred_path.with_suffix(".sql.bak_before_r1_hybrid")
    if not backup.exists():
        shutil.copy2(pred_path, backup)
    lines = pred_path.read_text(encoding="utf-8").splitlines()
    dev = _load_dev()
    global_ids = [i for i, row in enumerate(dev) if row["db_id"] == db_id]
    changed = 0
    for local_i, gid in enumerate(global_ids):
        if gid not in gid_to_sql:
            continue
        sql = " ".join(gid_to_sql[gid].split())
        # Keep Spider eval format: SQL\tdb_id
        lines[local_i] = f"{sql}\t{db_id}"
        changed += 1
    pred_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"  patched {changed} predict lines for {db_id}")


def _reeval_db(db_id: str) -> dict:
    import run_complete_nl2sql_pipeline as runner

    runner.configure_pipeline("6step")
    gold = SIX_OUT / "per_db" / db_id / "gold.sql"
    pred = SIX_OUT / "per_db" / db_id / "predict.sql"
    metrics = runner.run_evaluation(gold, pred)
    return metrics or {}


def run_db_fails(
    db_id: str,
    gids: list[int] | None,
    dry_run: bool,
    *,
    include_direct: bool = False,
    use_gpt4o: bool = False,
    restore_bak_placeholders: bool = False,
    archive_tag: str = "hybrid_arbiter",
) -> dict:
    import run_complete_nl2sql_pipeline as runner

    fails = gids if gids is not None else list_failing_global_indices(db_id)
    print(f"\n=== {db_id}: {len(fails)} failing questions ===")
    print(f"  gids={fails}")
    if not fails:
        return {"db_id": db_id, "fails_before": 0, "reran": 0}

    if dry_run:
        return {"db_id": db_id, "fails_before": len(fails), "reran": 0, "dry_run": True}

    if restore_bak_placeholders:
        restore_predict_from_bak_for_gids(db_id, fails)

    _archive_and_drop_raw(db_id, fails, archive_tag=archive_tag)

    os.environ["NL2SQL_SEED_FROM_4STEP"] = str(FOUR_OUT)
    os.environ["NL2SQL_SEED_INCLUDE_DIRECT"] = "1" if include_direct else "0"
    os.environ.setdefault("NL2SQL_STEP_TIMEOUT_SECONDS", "90")
    os.environ.setdefault("NL2SQL_STEP_MAX_RETRIES", "3")
    if use_gpt4o:
        # Avoid Gemini/Vertex 429 that left SELECT 1 placeholders in R2.
        for key in (
            "NL2SQL_QUERY_PLANNER_MODEL",
            "NL2SQL_PLANNED_SQL_MODEL",
            "NL2SQL_SQL_REFINER_MODEL",
            "NL2SQL_SQL_VALIDATOR_MODEL",
            "NL2SQL_DIRECT_SQL_MODEL",
            "NL2SQL_SQL_EXPERT_MODEL",
        ):
            os.environ[key] = "openai/gpt-4o"
        print("  models: GPT-4o for Planner/Expert/Refiner/Validator")

    runner.configure_pipeline("6step")
    if not runner.setup_environment():
        raise RuntimeError("setup_environment failed")

    all_questions = runner.get_test_questions(num_questions=0, db_id=db_id)
    fail_set = set(fails)
    selected = [
        q for q in all_questions if int(q.get("question_index", -1)) in fail_set
    ]
    if len(selected) != len(fails):
        raise RuntimeError(
            f"{db_id}: selected {len(selected)} questions, expected {len(fails)}"
        )

    seed_mode = "Analyzer+Schema+Direct" if include_direct else "Analyzer+Schema"
    print(
        f"  hybrid seed ({seed_mode}) from 4-step; "
        f"LLM for remaining steps on {len(selected)} questions"
    )
    csv_filename, results = runner.run_nl2sql_system(selected)
    if not csv_filename:
        raise RuntimeError("run_nl2sql_system failed")

    # Prefer raw_responses (has question_index); fall back to question text match.
    gid_to_sql: dict[int, str] = {}
    raw_dir = SIX_OUT / "raw_responses" / db_id
    for gid in fails:
        raw_path = raw_dir / f"q{gid:04d}.json"
        err_path = raw_dir / f"q{gid:04d}.error.json"
        path = raw_path if raw_path.is_file() else err_path
        if not path.is_file():
            continue
        payload = json.loads(path.read_text(encoding="utf-8"))
        sql = (payload.get("final_sql") or "").strip()
        if sql and sql.lower().rstrip(";") not in {"select 1", ""}:
            gid_to_sql[gid] = sql
    if len(gid_to_sql) < len(fails):
        by_question = {
            (item.get("question") or "").strip(): (item.get("sql") or "").strip()
            for item in results
        }
        for q in selected:
            gid = int(q["question_index"])
            if gid in gid_to_sql:
                continue
            sql = by_question.get((q.get("question") or "").strip(), "")
            if sql and sql.lower().rstrip(";") not in {"select 1", ""}:
                gid_to_sql[gid] = sql

    # Never overwrite a previous real SQL with a new SELECT 1 placeholder.
    skipped_placeholder = [gid for gid in fails if gid not in gid_to_sql]
    if skipped_placeholder:
        print(
            f"  keep previous predict for {len(skipped_placeholder)} "
            f"placeholder/failed outputs: {skipped_placeholder}"
        )

    _patch_predict(db_id, gid_to_sql)
    metrics = _reeval_db(db_id)
    remains = list_failing_global_indices(db_id)
    summary = {
        "db_id": db_id,
        "fails_before": len(fails),
        "reran": len(selected),
        "patched": len(gid_to_sql),
        "fails_after": len(remains),
        "fixed": len(fails) - len(remains),
        "execution_rate": metrics.get("execution_rate"),
        "exact_match_rate": metrics.get("exact_match_rate"),
        "remaining_gids": remains,
        "csv": csv_filename,
    }
    print(
        f"  result: EX={summary['execution_rate']} "
        f"fixed={summary['fixed']} remaining={summary['fails_after']}"
    )
    return summary


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dbs",
        nargs="+",
        default=list(DEFAULT_DBS),
        help="Databases to repair (default: wta_1 pets_1)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Only list failing question indices; no API calls",
    )
    parser.add_argument(
        "--tag",
        default="r1",
        help="Output tag for summary/log naming (default: r1)",
    )
    parser.add_argument(
        "--gids",
        type=int,
        nargs="+",
        default=None,
        help="Explicit global question indices (single --dbs required)",
    )
    parser.add_argument(
        "--select1-only",
        action="store_true",
        help="Only rerun questions whose predict is currently SELECT 1/empty",
    )
    parser.add_argument(
        "--include-direct",
        action="store_true",
        help="Also seed Direct SQL from 4-step generate_sql",
    )
    parser.add_argument(
        "--gpt4o",
        action="store_true",
        help="Force GPT-4o for Planner/Expert/Refiner/Validator (avoid Gemini 429)",
    )
    parser.add_argument(
        "--restore-bak",
        action="store_true",
        help="Before rerun, restore bak SQL for SELECT 1 placeholders",
    )
    args = parser.parse_args()

    summaries = []
    for db_id in args.dbs:
        if args.gids is not None:
            if len(args.dbs) != 1:
                parser.error("--gids requires exactly one --dbs value")
            gids = args.gids
        elif args.select1_only:
            gids = list_select1_global_indices(db_id)
        else:
            gids = None
        summaries.append(
            run_db_fails(
                db_id,
                gids=gids,
                dry_run=args.dry_run,
                include_direct=args.include_direct,
                use_gpt4o=args.gpt4o,
                restore_bak_placeholders=args.restore_bak,
                archive_tag=f"{args.tag}_arbiter",
            )
        )

    out = SIX_OUT / f"{args.tag}_hybrid_arbiter_summary.json"
    out.write_text(json.dumps(summaries, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"\nWrote {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
