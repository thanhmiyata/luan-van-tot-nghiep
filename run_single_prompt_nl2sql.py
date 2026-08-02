#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Single-prompt NL2SQL: one LLM call per Spider dev question.
Writes gold.sql and predict.sql (SQL\\tdb_id per line) for experiments/test-suite-sql-eval,
same layout as the multi-step pipeline outputs.

Requires:
- OpenAI: OPENAI_API_KEY
- Gemini: GOOGLE_API_KEY (or GEMINI_API_KEY)
- DeepSeek (OpenAI-compatible): DEEPSEEK_API_KEY (provider `deepseek`, model `deepseek-reasoner`)
  (.env at project root / src/nl2sql_6step/.env)
"""

from __future__ import annotations

import argparse
import json
import os
import random
import re
import sys
import time
from pathlib import Path
from typing import Any, Dict, List, Optional

from dotenv import load_dotenv

PROJECT_ROOT = Path(__file__).resolve().parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from run_complete_nl2sql_pipeline import normalize_sql_for_spider

# Load API keys the same way as other runners
load_dotenv(PROJECT_ROOT / ".env")
load_dotenv(PROJECT_ROOT / "src" / "nl2sql_6step" / ".env")


def _build_db_schema_map(tables_path: Path) -> Dict[str, Dict[str, Any]]:
    with open(tables_path, "r", encoding="utf-8") as f:
        tables_data = json.load(f)
    out: Dict[str, Dict[str, Any]] = {}
    for entry in tables_data:
        db_id = entry.get("db_id")
        if db_id:
            out[db_id] = entry
    return out


def format_schema_spider(schema: Dict[str, Any]) -> str:
    """Turn one Spider tables.json record into a compact text schema."""
    lines: List[str] = [f"Database id: {schema.get('db_id', 'unknown')}", ""]
    tables = schema.get("table_names_original", [])
    columns = schema.get("column_names_original", [])
    column_types = schema.get("column_types", [])

    for table_idx, table_name in enumerate(tables):
        table_cols: List[str] = []
        for col_idx, (tbl_idx, col_name) in enumerate(columns):
            if tbl_idx == table_idx:
                ctype = column_types[col_idx] if col_idx < len(column_types) else "text"
                table_cols.append(f"  - {col_name} ({ctype})")
        lines.append(f"Table {table_name}:")
        lines.extend(table_cols)
        lines.append("")

    foreign_keys = schema.get("foreign_keys", [])
    if foreign_keys:
        lines.append("Foreign keys (column index pairs):")
        for fk in foreign_keys:
            if len(fk) >= 2:
                i0, i1 = fk[0], fk[1]
                c0 = columns[i0][1] if i0 < len(columns) else "?"
                c1 = columns[i1][1] if i1 < len(columns) else "?"
                lines.append(f"  {c0} -> {c1}")
        lines.append("")

    return "\n".join(lines).strip()


PROMPT_TEMPLATE = """You are an expert in SQLite. Given the schema and the question, output ONE valid SQLite query.

{schema}

Question: {question}

Rules:
- Return ONLY the SQL query, no markdown, no explanation.
- Use table and column names exactly as in the schema.
- The query must be executable on SQLite.

SQL:"""


def extract_sql_from_response(text: str) -> str:
    """Strip code fences and collapse to a single-line SQL where possible."""
    if not text or not text.strip():
        return ""
    t = text.strip()
    m = re.search(r"```(?:sql)?\s*([\s\S]*?)```", t, re.IGNORECASE)
    if m:
        t = m.group(1).strip()
    # Prefer first statement
    t = re.sub(r"\s+", " ", t).strip()
    t = t.rstrip(";").strip()
    return t


def run_openai(
    prompt: str,
    model: str,
    temperature: float,
    max_tokens: int,
    api_key: Optional[str],
    base_url: Optional[str] = None,
) -> str:
    from openai import OpenAI

    kwargs: Dict[str, Any] = {"api_key": api_key or os.getenv("OPENAI_API_KEY")}
    if base_url:
        kwargs["base_url"] = base_url
    client = OpenAI(**kwargs)
    resp = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=temperature,
        max_tokens=max_tokens,
    )
    content = resp.choices[0].message.content
    return (content or "").strip()


def run_gemini(
    prompt: str,
    model: str,
    temperature: float,
    max_tokens: int,
    api_key: Optional[str],
) -> str:
    import google.generativeai as genai

    key = api_key or os.getenv("GOOGLE_API_KEY") or os.getenv("GEMINI_API_KEY")
    if not key:
        raise RuntimeError("Set GOOGLE_API_KEY or GEMINI_API_KEY for Gemini.")
    genai.configure(api_key=key)
    gen_cfg = {"temperature": temperature, "max_output_tokens": max_tokens}
    model_obj = genai.GenerativeModel(model, generation_config=gen_cfg)
    response = model_obj.generate_content(prompt)
    try:
        return (response.text or "").strip()
    except ValueError as e:
        fb = getattr(response, "prompt_feedback", str(e))
        raise RuntimeError(f"Gemini returned no text: {fb}") from e


def main() -> None:
    parser = argparse.ArgumentParser(description="Single-prompt NL2SQL -> gold.sql & predict.sql")
    parser.add_argument(
        "--questions",
        type=Path,
        default=PROJECT_ROOT / "output" / "questions_dev.json",
        help="Spider dev questions JSON (default: output/questions_dev.json)",
    )
    parser.add_argument(
        "--tables",
        type=Path,
        default=PROJECT_ROOT / "data" / "tables.json",
        help="Spider tables.json (default: data/tables.json)",
    )
    parser.add_argument(
        "--out-dir",
        type=Path,
        default=PROJECT_ROOT / "output" / "nl2sql_single_prompt",
        help="Output directory for gold.sql and predict.sql",
    )
    parser.add_argument(
        "--provider",
        choices=("openai", "gemini", "deepseek"),
        default="openai",
        help="LLM backend: openai, gemini, or deepseek (DeepSeek-R1 via OpenAI-compatible API)",
    )
    parser.add_argument(
        "--model",
        type=str,
        default=None,
        help="Model id (default: gpt-4o / gemini-2.5-flash / deepseek-reasoner)",
    )
    parser.add_argument("--temperature", type=float, default=0.0)
    parser.add_argument("--max-tokens", type=int, default=2048)
    parser.add_argument("--offset", type=int, default=0, help="Skip first N questions (after --db-id filter)")
    parser.add_argument("--limit", type=int, default=None, help="Process at most N questions")
    parser.add_argument(
        "--db-id",
        type=str,
        default=None,
        help="Only use questions for this Spider db_id (e.g. flight_2)",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=None,
        help="Random seed: when len(questions) > --limit, sample LIMIT questions reproducibly",
    )
    parser.add_argument(
        "--delay",
        type=float,
        default=0.0,
        help="Seconds to sleep between API calls (rate limits)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Only write gold.sql from questions file (no API calls)",
    )
    args = parser.parse_args()

    if args.model is None:
        if args.provider == "gemini":
            args.model = "gemini-2.5-flash"
        elif args.provider == "deepseek":
            args.model = "deepseek-reasoner"
        else:
            args.model = "gpt-4o"

    if args.provider == "deepseek" and args.max_tokens == 2048:
        args.max_tokens = 8192

    if not args.questions.exists():
        print(f"Missing questions file: {args.questions}", file=sys.stderr)
        sys.exit(1)
    if not args.tables.exists():
        print(f"Missing tables file: {args.tables}", file=sys.stderr)
        sys.exit(1)

    with open(args.questions, "r", encoding="utf-8") as f:
        all_items: List[Dict[str, Any]] = json.load(f)

    working = all_items
    if args.db_id is not None:
        working = [x for x in working if x.get("db_id") == args.db_id]
        if not working:
            print(f"No questions for db_id={args.db_id!r}", file=sys.stderr)
            sys.exit(1)
        print(f"Filtered to db_id={args.db_id!r}: {len(working)} question(s).")

    if args.offset:
        working = working[args.offset :]

    if args.limit is not None:
        if args.seed is not None and len(working) > args.limit:
            rng = random.Random(args.seed)
            slice_items = rng.sample(working, args.limit)
            print(
                f"Sampled {args.limit} question(s) with seed={args.seed} "
                f"(from {len(working)} after offset).",
                flush=True,
            )
        else:
            slice_items = working[: args.limit]
            if args.seed is not None and len(working) <= (args.limit or len(working)):
                print(
                    "Note: --seed ignored (not subsampling; use more questions than --limit to sample).",
                    file=sys.stderr,
                )
    else:
        slice_items = working

    schema_by_db = _build_db_schema_map(args.tables)

    args.out_dir.mkdir(parents=True, exist_ok=True)
    gold_path = args.out_dir / "gold.sql"
    pred_path = args.out_dir / "predict.sql"

    missing_schema: List[str] = []

    with open(gold_path, "w", encoding="utf-8") as gold_f, open(
        pred_path, "w", encoding="utf-8"
    ) as pred_f:
        for i, item in enumerate(slice_items):
            db_id = item["db_id"]
            question = item["question"]
            gold_sql = item.get("query", "")

            gold_f.write(f"{gold_sql}\t{db_id}\n")

            if args.dry_run:
                pred_f.write(f"\t{db_id}\n")
                continue

            schema = schema_by_db.get(db_id)
            if schema is None:
                missing_schema.append(db_id)
                pred_f.write(f"\t{db_id}\n")
                continue

            schema_text = format_schema_spider(schema)
            prompt = PROMPT_TEMPLATE.format(schema=schema_text, question=question)

            try:
                if args.provider == "openai":
                    raw = run_openai(
                        prompt,
                        model=args.model,
                        temperature=args.temperature,
                        max_tokens=args.max_tokens,
                        api_key=os.getenv("OPENAI_API_KEY"),
                    )
                elif args.provider == "deepseek":
                    raw = run_openai(
                        prompt,
                        model=args.model,
                        temperature=args.temperature,
                        max_tokens=args.max_tokens,
                        api_key=os.getenv("DEEPSEEK_API_KEY"),
                        base_url="https://api.deepseek.com",
                    )
                else:
                    raw = run_gemini(
                        prompt,
                        model=args.model,
                        temperature=args.temperature,
                        max_tokens=args.max_tokens,
                        api_key=os.getenv("GOOGLE_API_KEY") or os.getenv("GEMINI_API_KEY"),
                    )
                sql = extract_sql_from_response(raw)
                sql = normalize_sql_for_spider(sql) if sql else ""
            except Exception as e:
                print(f"[{i + 1}/{len(slice_items)}] ERROR: {e}", file=sys.stderr)
                sql = ""

            pred_f.write(f"{sql}\t{db_id}\n")

            if (i + 1) % 50 == 0 or (i + 1) == len(slice_items):
                print(
                    f"Progress: {i + 1}/{len(slice_items)} (global index ~ {args.offset + i + 1})",
                    flush=True,
                )

            if args.delay > 0:
                time.sleep(args.delay)

    if missing_schema:
        print("Warning: missing schema for db_id:", sorted(set(missing_schema)), file=sys.stderr)

    print(f"Wrote:\n  {gold_path}\n  {pred_path}")
    print(
        "Evaluate (from repo root, after copying database to test-suite if needed):\n"
        f"  python experiments/test-suite-sql-eval/evaluation.py "
        f"--gold {gold_path} --pred {pred_path} "
        f"--db experiments/test-suite-sql-eval/database --etype all "
        f"--table experiments/test-suite-sql-eval/tables.json --plug_value"
    )


if __name__ == "__main__":
    main()
