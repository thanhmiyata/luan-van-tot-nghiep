#!/usr/bin/env python3
"""Smoke-test 4-step on car_1 with N sampled questions (isolated output).

Does NOT touch official benchmark progress / raw_responses under output/nl2sql_4step/.
Compares EX/EM against the previous full car_1 run on the SAME question indices
(when those raw files exist).

Usage:
  source venv/bin/activate
  python scripts/smoke_test_4step_car1.py
  python scripts/smoke_test_4step_car1.py --num_questions 30 --seed 42
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import run_complete_nl2sql_pipeline as pipe  # noqa: E402


def _baseline_from_previous_raw(questions: list[dict], baseline_raw_dir: Path, out_dir: Path):
    """Build gold/predict from previous full-run raw for the same indices; eval EX/EM."""
    gold_lines = []
    pred_lines = []
    missing = []
    for q in questions:
        qidx = q["question_index"]
        raw_file = baseline_raw_dir / f"q{qidx:04d}.json"
        if not raw_file.exists():
            missing.append(qidx)
            continue
        cached = json.loads(raw_file.read_text(encoding="utf-8"))
        gold = (cached.get("gold_query") or q["gold_query"] or "").strip().replace("\n", " ")
        pred = (cached.get("final_sql") or "").strip().replace("\n", " ") or "SELECT 1"
        db_id = cached.get("db_id") or q["db_id"]
        gold_lines.append(f"{gold}\t{db_id}")
        pred_lines.append(f"{pred}\t{db_id}")

    if missing:
        print(f"⚠️  Baseline thiếu {len(missing)} raw file(s): {missing[:10]}...")
        return None

    cmp_dir = out_dir / "baseline_same_indices"
    cmp_dir.mkdir(parents=True, exist_ok=True)
    gold_path = cmp_dir / "gold.sql"
    pred_path = cmp_dir / "predict.sql"
    gold_path.write_text("\n".join(gold_lines) + "\n", encoding="utf-8")
    pred_path.write_text("\n".join(pred_lines) + "\n", encoding="utf-8")
    print(f"\n📐 Đánh giá baseline (cùng {len(questions)} chỉ số câu từ lần chạy car_1 trước)...")
    return pipe.run_evaluation(str(gold_path), str(pred_path))


def main() -> int:
    parser = argparse.ArgumentParser(description="Smoke-test 4-step car_1 sample")
    parser.add_argument("--num_questions", type=int, default=30)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--db_id", default="car_1")
    parser.add_argument(
        "--output-dir",
        default="output/smoke_4step_car1",
        help="Thư mục output riêng (không đụng benchmark chính)",
    )
    parser.add_argument(
        "--fresh",
        action="store_true",
        help="Xóa output-dir trước khi chạy (mặc định: bật nếu thư mục đã có raw)",
    )
    parser.add_argument(
        "--no-fresh",
        action="store_true",
        help="Giữ raw trong output-dir (cho phép resume smoke run)",
    )
    args = parser.parse_args()

    out_dir = ROOT / args.output_dir
    if args.fresh or (out_dir.exists() and not args.no_fresh):
        if out_dir.exists():
            print(f"🧹 Xóa output smoke cũ: {out_dir}")
            shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    pipe.configure_pipeline("4step")
    # Redirect ALL pipeline I/O away from official benchmark tree
    pipe.PIPELINE_OUTPUT_DIR = out_dir
    print(f"📁 Smoke output dir: {pipe.PIPELINE_OUTPUT_DIR}")

    if not pipe.setup_environment():
        print("❌ Setup thất bại")
        return 1

    questions = pipe.get_test_questions(
        num_questions=args.num_questions,
        db_id=args.db_id,
        seed=args.seed,
    )
    indices = [q["question_index"] for q in questions]
    (out_dir / "sample_indices.json").write_text(
        json.dumps(
            {
                "db_id": args.db_id,
                "num_questions": len(questions),
                "seed": args.seed,
                "question_indices": indices,
            },
            indent=2,
        ),
        encoding="utf-8",
    )

    t0 = time.time()
    csv_filename, results = pipe.run_nl2sql_system(questions)
    if not csv_filename:
        print("❌ Pipeline thất bại")
        return 1

    gold_file, predict_file = pipe.convert_csv_to_evaluation_format(csv_filename)
    new_metrics = pipe.run_evaluation(gold_file, predict_file)
    elapsed = time.time() - t0

    baseline_raw = ROOT / "output" / "nl2sql_4step" / "raw_responses" / args.db_id
    old_metrics = None
    if baseline_raw.is_dir():
        old_metrics = _baseline_from_previous_raw(questions, baseline_raw, out_dir)
    else:
        print(f"⚠️  Không có baseline raw tại {baseline_raw}")

    new_ex = float(new_metrics.get("execution_rate") or 0)
    new_em = float(new_metrics.get("exact_match_rate") or 0)

    print("\n" + "=" * 72)
    print(f"SMOKE 4-step | {args.db_id} | n={len(questions)} | seed={args.seed}")
    print("=" * 72)
    print(f"NEW (sau update) : EX={new_ex:.1f}%  EM={new_em:.1f}%  ({elapsed/60:.1f} phút)")
    if old_metrics is not None:
        old_ex = float(old_metrics.get("execution_rate") or 0)
        old_em = float(old_metrics.get("exact_match_rate") or 0)
        print(f"OLD (cùng 30 câu): EX={old_ex:.1f}%  EM={old_em:.1f}%")
        print(f"Δ                : EX={new_ex - old_ex:+.1f}  EM={new_em - old_em:+.1f}")
        print("(So sánh công bằng trên cùng question_index; không phải full 92 câu)")
    else:
        print("Không so được baseline cùng chỉ số.")
    print(f"Full car_1 trước đó (92 câu, tham khảo): EX=56.5% EM=32.6%")
    print(f"Artifacts: {out_dir}")
    print("=" * 72)

    summary = {
        "db_id": args.db_id,
        "num_questions": len(questions),
        "seed": args.seed,
        "question_indices": indices,
        "new": {"execution_rate": new_ex, "exact_match_rate": new_em, "elapsed_sec": elapsed},
        "old_same_indices": (
            {
                "execution_rate": float(old_metrics.get("execution_rate") or 0),
                "exact_match_rate": float(old_metrics.get("exact_match_rate") or 0),
            }
            if old_metrics is not None
            else None
        ),
        "full_car1_previous_ref": {"execution_rate": 56.5, "exact_match_rate": 32.6},
    }
    (out_dir / "smoke_summary.json").write_text(
        json.dumps(summary, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
