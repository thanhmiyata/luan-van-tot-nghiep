#!/usr/bin/env python3
"""Run remaining ablation DBs sequentially; print vs locked 4/6 after each DB."""

from __future__ import annotations

import json
import subprocess
import sys
from datetime import datetime
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
OUT = PROJECT_ROOT / "output" / "ablation_full_seed4step"
PROGRESS6 = PROJECT_ROOT / "output" / "nl2sql_6step" / "benchmark_progress.json"
PROGRESS4 = PROJECT_ROOT / "output" / "nl2sql_4step" / "benchmark_progress.json"
REPORT = OUT / "per_db_comparison.md"


def db_order() -> list[str]:
    return list(json.loads(PROGRESS6.read_text(encoding="utf-8"))["db_order"])


def locked_metrics(db_id: str) -> dict:
    out = {}
    for label, path in [("4step", PROGRESS4), ("6step", PROGRESS6)]:
        data = json.loads(path.read_text(encoding="utf-8"))
        row = data.get("databases", {}).get(db_id, {})
        out[label] = {
            "ex": row.get("execution_rate"),
            "em": row.get("exact_match_rate"),
            "n": row.get("num_questions"),
        }
    return out


def abl_metrics(variant: str, db_id: str) -> dict:
    p = OUT / variant / "per_db" / db_id / "summary.json"
    if not p.exists():
        return {}
    s = json.loads(p.read_text(encoding="utf-8"))
    return {
        "ex": s.get("execution_rate"),
        "em": s.get("exact_match_rate"),
        "n": s.get("n"),
        "seed_pct": s.get("seed_pct"),
        "ran": s.get("ran"),
        "elapsed_sec": s.get("elapsed_sec"),
    }


def both_done(db_id: str) -> bool:
    for v in ("no_planner", "no_refiner"):
        p = OUT / v / "progress.json"
        if not p.exists():
            return False
        row = json.loads(p.read_text(encoding="utf-8")).get("databases", {}).get(db_id)
        if not row or row.get("status") != "done":
            return False
    return True


def fmt(x):
    return f"{x:.1f}" if isinstance(x, (int, float)) else "--"


def report_db(db_id: str) -> str:
    locked = locked_metrics(db_id)
    np = abl_metrics("no_planner", db_id)
    nr = abl_metrics("no_refiner", db_id)
    lines = [
        f"### {db_id}",
        f"- time: {datetime.now().isoformat(timespec='seconds')}",
        f"- seed: no_planner={fmt(np.get('seed_pct'))}%  no_refiner={fmt(nr.get('seed_pct'))}%",
        "",
        "| Config | EX | EM | n |",
        "|---|---:|---:|---:|",
        f"| 4-step locked | {fmt(locked['4step']['ex'])} | {fmt(locked['4step']['em'])} | {locked['4step']['n'] or '--'} |",
        f"| 5-stage w/o Planner | {fmt(np.get('ex'))} | {fmt(np.get('em'))} | {np.get('n') or '--'} |",
        f"| 5-stage w/o Refiner | {fmt(nr.get('ex'))} | {fmt(nr.get('em'))} | {nr.get('n') or '--'} |",
        f"| 6-step locked | {fmt(locked['6step']['ex'])} | {fmt(locked['6step']['em'])} | {locked['6step']['n'] or '--'} |",
        "",
    ]
    # deltas vs 4-step
    if isinstance(np.get("ex"), (int, float)) and isinstance(locked["4step"]["ex"], (int, float)):
        lines.append(
            f"- ΔEX vs 4-step: no_planner={np['ex']-locked['4step']['ex']:+.1f}  "
            f"no_refiner={nr.get('ex', 0)-locked['4step']['ex']:+.1f}"
        )
    if isinstance(np.get("ex"), (int, float)) and isinstance(locked["6step"]["ex"], (int, float)):
        lines.append(
            f"- ΔEX vs 6-step: no_planner={np['ex']-locked['6step']['ex']:+.1f}  "
            f"no_refiner={nr.get('ex', 0)-locked['6step']['ex']:+.1f}"
        )
    lines.append("")
    text = "\n".join(lines)
    print("\n" + "=" * 60)
    print(text)
    print("=" * 60 + "\n", flush=True)
    OUT.mkdir(parents=True, exist_ok=True)
    with REPORT.open("a", encoding="utf-8") as f:
        f.write(text + "\n")
    return text


def run_db(db_id: str) -> int:
    cmd = [
        sys.executable,
        str(PROJECT_ROOT / "scripts" / "run_ablation_full_seed4step.py"),
        "--db-id",
        db_id,
        "--variants",
        "no_planner",
        "no_refiner",
    ]
    log = OUT / f"run_{db_id}_both.log"
    print(f"\n>>> START {db_id}  log={log}", flush=True)
    with log.open("w", encoding="utf-8") as f:
        proc = subprocess.run(
            cmd,
            cwd=str(PROJECT_ROOT),
            stdout=f,
            stderr=subprocess.STDOUT,
        )
    return proc.returncode


def main() -> int:
    order = db_order()
    remaining = [d for d in order if not both_done(d)]
    print(f"Remaining DBs ({len(remaining)}): {remaining}", flush=True)
    if not REPORT.exists():
        REPORT.write_text(
            "# Ablation full per-DB comparison\n\n"
            "5-stage ablations reuse 4-step early-stage outputs "
            "(Analyzer/Schema/Direct).\n\n"
            "**Model policy (from network_1 onward):** agents.yaml — "
            "Planner/Refiner/Validator = Gemini Flash; Planned/Expert = GPT-4o. "
            "Earlier DBs (world_1…wta_1) were run under an all-GPT-4o override "
            "(cost incident); kept as-is unless re-run.\n\n",
            encoding="utf-8",
        )
    # Ensure already-done DBs are in the report once
    for d in order:
        if both_done(d):
            # append only if not already present
            existing = REPORT.read_text(encoding="utf-8")
            if f"### {d}" not in existing:
                report_db(d)

    for i, db_id in enumerate(remaining, 1):
        print(f"\n######## [{i}/{len(remaining)}] {db_id} ########", flush=True)
        rc = run_db(db_id)
        if rc == 2:
            print(f"!!! STOP at {db_id}: credit exhausted (exit 2)", flush=True)
            report_db(db_id)
            return 2
        if rc != 0:
            print(f"!!! FAIL at {db_id}: exit={rc}", flush=True)
            report_db(db_id)
            return rc
        report_db(db_id)

    # Final aggregate
    print("\n>>> AGGREGATE both variants", flush=True)
    agg = subprocess.run(
        [
            sys.executable,
            str(PROJECT_ROOT / "scripts" / "run_ablation_full_seed4step.py"),
            "--aggregate",
            "--variants",
            "no_planner",
            "no_refiner",
        ],
        cwd=str(PROJECT_ROOT),
    )
    print(f"aggregate exit={agg.returncode}", flush=True)
    return agg.returncode


if __name__ == "__main__":
    raise SystemExit(main())
