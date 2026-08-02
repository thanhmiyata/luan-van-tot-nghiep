#!/usr/bin/env python3
"""Build a reproducible 340-instance diagnostic subset of Dr.Spider.

The sampler selects 20 post-perturbation instances from each of the 17
Dr.Spider perturbation types. Sampling is balanced by the official Spider
difficulty of the pre-perturbation SQL and uses globally unique Spider-dev
question IDs to avoid pseudoreplication.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


PROTOCOL_ID = "drspider340-v1"
DEFAULT_SEED = 42
DEFAULT_SAMPLES_PER_TYPE = 20
SOURCE_REPOSITORY = (
    "https://github.com/awslabs/diagnostic-robustness-text-to-sql"
)
SOURCE_COMMIT = "c64694a4a278ab0faff08ce7a3501d46f458b431"
SOURCE_ARCHIVE_URL = (
    "https://media.githubusercontent.com/media/"
    "awslabs/diagnostic-robustness-text-to-sql/"
    f"{SOURCE_COMMIT}/data.tar.gz"
)
SOURCE_ARCHIVE_SHA256 = (
    "d0f47e4d2c9202f4fd2d956a34e9dd1ff8180c1c9e58cf5b530c13fefaaa3ba9"
)

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
DIFFICULTY_ORDER = ["easy", "medium", "hard", "extra"]
WHERE_OPS = (
    "not",
    "between",
    "=",
    ">",
    "<",
    ">=",
    "<=",
    "!=",
    "in",
    "like",
    "is",
    "exists",
)
AGG_OPS = ("none", "max", "min", "count", "sum", "avg")


def parse_args() -> argparse.Namespace:
    script_dir = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(
        description="Create two aligned JSON artifacts for Dr.Spider-340."
    )
    parser.add_argument(
        "--source-root",
        type=Path,
        required=True,
        help="Extracted Dr.Spider data root containing the 17 perturbation dirs.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=script_dir,
        help="Destination directory for the two JSON files.",
    )
    parser.add_argument("--seed", type=int, default=DEFAULT_SEED)
    parser.add_argument(
        "--samples-per-type",
        type=int,
        default=DEFAULT_SAMPLES_PER_TYPE,
    )
    return parser.parse_args()


def stable_digest(*parts: object) -> str:
    value = "|".join(str(part) for part in parts)
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def load_json(path: Path) -> list[dict[str, Any]]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, list):
        raise ValueError(f"Expected a JSON array: {path}")
    return value


def load_gold(path: Path) -> list[tuple[str, str]]:
    rows: list[tuple[str, str]] = []
    for line_number, raw_line in enumerate(
        path.read_text(encoding="utf-8").splitlines(), start=1
    ):
        if not raw_line.strip():
            continue
        if "\t" not in raw_line:
            raise ValueError(f"Missing tab separator at {path}:{line_number}")
        sql, db_id = raw_line.rsplit("\t", 1)
        rows.append((sql, db_id))
    return rows


def has_aggregation(unit: list[Any]) -> bool:
    return unit[0] != AGG_OPS.index("none")


def nested_sql(sql: dict[str, Any]) -> list[dict[str, Any]]:
    nested: list[dict[str, Any]] = []
    conditions = (
        sql["from"]["conds"][::2]
        + sql["where"][::2]
        + sql["having"][::2]
    )
    for condition in conditions:
        if isinstance(condition[3], dict):
            nested.append(condition[3])
        if isinstance(condition[4], dict):
            nested.append(condition[4])
    for operation in ("intersect", "except", "union"):
        if sql[operation] is not None:
            nested.append(sql[operation])
    return nested


def count_component1(sql: dict[str, Any]) -> int:
    count = 0
    count += int(bool(sql["where"]))
    count += int(bool(sql["groupBy"]))
    count += int(bool(sql["orderBy"]))
    count += int(sql["limit"] is not None)
    if sql["from"]["table_units"]:
        count += len(sql["from"]["table_units"]) - 1

    connectors = (
        sql["from"]["conds"][1::2]
        + sql["where"][1::2]
        + sql["having"][1::2]
    )
    count += sum(token == "or" for token in connectors)
    conditions = (
        sql["from"]["conds"][::2]
        + sql["where"][::2]
        + sql["having"][::2]
    )
    count += sum(
        condition[1] == WHERE_OPS.index("like")
        for condition in conditions
    )
    return count


def count_aggregations(units: list[Any]) -> int:
    return sum(has_aggregation(unit) for unit in units)


def count_others(sql: dict[str, Any]) -> int:
    aggregation_count = count_aggregations(sql["select"][1])
    aggregation_count += count_aggregations(sql["where"][::2])
    aggregation_count += count_aggregations(sql["groupBy"])
    if sql["orderBy"]:
        aggregation_count += count_aggregations(
            [unit[1] for unit in sql["orderBy"][1] if unit[1]]
            + [unit[2] for unit in sql["orderBy"][1] if unit[2]]
        )
    aggregation_count += count_aggregations(sql["having"])

    count = int(aggregation_count > 1)
    count += int(len(sql["select"][1]) > 1)
    count += int(len(sql["where"]) > 1)
    count += int(len(sql["groupBy"]) > 1)
    return count


def spider_difficulty(sql: dict[str, Any]) -> str:
    """Return the official Spider evaluator hardness label."""
    component1 = count_component1(sql)
    component2 = len(nested_sql(sql))
    others = count_others(sql)

    if component1 <= 1 and others == 0 and component2 == 0:
        return "easy"
    if (
        (others <= 2 and component1 <= 1 and component2 == 0)
        or (component1 <= 2 and others < 2 and component2 == 0)
    ):
        return "medium"
    if (
        (others > 2 and component1 <= 2 and component2 == 0)
        or (2 < component1 <= 3 and others <= 2 and component2 == 0)
        or (component1 <= 1 and others == 0 and component2 <= 1)
    ):
        return "hard"
    return "extra"


def allocate_largest_remainder(
    counts: dict[str, int], sample_size: int
) -> dict[str, int]:
    total = sum(counts.values())
    if total < sample_size:
        raise ValueError(
            f"Only {total} unique base questions for requested sample {sample_size}"
        )

    exact = {
        difficulty: sample_size * counts[difficulty] / total
        for difficulty in DIFFICULTY_ORDER
    }
    quotas = {
        difficulty: int(exact[difficulty])
        for difficulty in DIFFICULTY_ORDER
    }
    remaining = sample_size - sum(quotas.values())
    tie_order = {name: index for index, name in enumerate(DIFFICULTY_ORDER)}
    ranked = sorted(
        DIFFICULTY_ORDER,
        key=lambda difficulty: (
            -(exact[difficulty] - quotas[difficulty]),
            tie_order[difficulty],
        ),
    )
    for difficulty in ranked[:remaining]:
        quotas[difficulty] += 1
    return quotas


def database_paths(
    perturbation_type: str, db_id: str
) -> tuple[str, str]:
    if perturbation_type.startswith("DB_"):
        database_relpath = (
            f"data/drspider/{perturbation_type}/"
            f"database_post_perturbation/{db_id}/{db_id}.sqlite"
        )
        tables_relpath = (
            f"data/drspider/{perturbation_type}/"
            "tables_post_perturbation.json"
        )
    else:
        database_relpath = (
            f"data/drspider/Spider-dev/databases/{db_id}/{db_id}.sqlite"
        )
        tables_relpath = "data/drspider/Spider-dev/tables.json"
    return database_relpath, tables_relpath


def validate_source_rows(
    perturbation_type: str,
    pre_questions: list[dict[str, Any]],
    post_questions: list[dict[str, Any]],
    pre_gold: list[tuple[str, str]],
    post_gold: list[tuple[str, str]],
) -> tuple[
    dict[int, list[int]],
    dict[int, str],
]:
    lengths = {
        len(pre_questions),
        len(post_questions),
        len(pre_gold),
        len(post_gold),
    }
    if len(lengths) != 1:
        raise ValueError(
            f"{perturbation_type}: pre/post question and gold lengths differ"
        )

    indices_by_qid: dict[int, list[int]] = defaultdict(list)
    difficulty_by_qid: dict[int, str] = {}

    for source_index, (pre_record, post_record) in enumerate(
        zip(pre_questions, post_questions)
    ):
        pre_qid = int(pre_record["q_id_spider_dev"])
        post_qid = int(post_record["q_id_spider_dev"])
        if pre_qid != post_qid:
            raise ValueError(
                f"{perturbation_type}[{source_index}]: pre/post qid mismatch"
            )

        pre_sql, pre_db_id = pre_gold[source_index]
        post_sql, post_db_id = post_gold[source_index]
        if pre_record["query"].strip() != pre_sql.strip():
            raise ValueError(
                f"{perturbation_type}[{source_index}]: pre JSON/gold SQL mismatch"
            )
        if post_record["query"].strip() != post_sql.strip():
            raise ValueError(
                f"{perturbation_type}[{source_index}]: post JSON/gold SQL mismatch"
            )
        if pre_record["db_id"].strip() != pre_db_id.strip():
            raise ValueError(
                f"{perturbation_type}[{source_index}]: pre db_id mismatch"
            )
        if post_record["db_id"].strip() != post_db_id.strip():
            raise ValueError(
                f"{perturbation_type}[{source_index}]: post db_id mismatch"
            )

        difficulty = spider_difficulty(pre_record["sql"])
        previous_difficulty = difficulty_by_qid.get(pre_qid)
        if (
            previous_difficulty is not None
            and previous_difficulty != difficulty
        ):
            raise ValueError(
                f"{perturbation_type}: qid {pre_qid} has inconsistent difficulty"
            )
        difficulty_by_qid[pre_qid] = difficulty
        indices_by_qid[pre_qid].append(source_index)

    return dict(indices_by_qid), difficulty_by_qid


def select_records(
    source_root: Path,
    seed: int,
    samples_per_type: int,
) -> tuple[list[dict[str, Any]], dict[str, dict[str, int]]]:
    globally_selected_qids: set[int] = set()
    selected: list[dict[str, Any]] = []
    quota_summary: dict[str, dict[str, int]] = {}

    for perturbation_rank, perturbation_type in enumerate(PERTURBATION_TYPES):
        perturbation_dir = source_root / perturbation_type
        pre_questions = load_json(
            perturbation_dir / "questions_pre_perturbation.json"
        )
        post_questions = load_json(
            perturbation_dir / "questions_post_perturbation.json"
        )
        pre_gold = load_gold(
            perturbation_dir / "gold_pre_perturbation.sql"
        )
        post_gold = load_gold(
            perturbation_dir / "gold_post_perturbation.sql"
        )

        indices_by_qid, difficulty_by_qid = validate_source_rows(
            perturbation_type,
            pre_questions,
            post_questions,
            pre_gold,
            post_gold,
        )
        difficulty_counts = Counter(difficulty_by_qid.values())
        quotas = allocate_largest_remainder(
            {
                difficulty: difficulty_counts[difficulty]
                for difficulty in DIFFICULTY_ORDER
            },
            samples_per_type,
        )
        quota_summary[perturbation_type] = quotas

        selected_qids: list[int] = []
        for difficulty in DIFFICULTY_ORDER:
            candidates = [
                qid
                for qid, qid_difficulty in difficulty_by_qid.items()
                if qid_difficulty == difficulty
                and qid not in globally_selected_qids
            ]
            candidates.sort(
                key=lambda qid: (
                    stable_digest(
                        PROTOCOL_ID,
                        seed,
                        perturbation_type,
                        difficulty,
                        qid,
                    ),
                    qid,
                )
            )
            requested = quotas[difficulty]
            if len(candidates) < requested:
                raise ValueError(
                    f"{perturbation_type}/{difficulty}: only "
                    f"{len(candidates)} globally unique qids for quota {requested}"
                )
            selected_qids.extend(candidates[:requested])

        for qid in selected_qids:
            source_indices = sorted(indices_by_qid[qid])
            source_index = min(
                source_indices,
                key=lambda index: (
                    stable_digest(
                        PROTOCOL_ID,
                        seed,
                        perturbation_type,
                        qid,
                        index,
                    ),
                    index,
                ),
            )
            post_record = post_questions[source_index]
            gold_sql, gold_db_id = post_gold[source_index]
            db_id = post_record["db_id"]
            if db_id != gold_db_id:
                raise ValueError(
                    f"{perturbation_type}[{source_index}]: selected db mismatch"
                )
            database_relpath, tables_relpath = database_paths(
                perturbation_type, db_id
            )
            selected.append(
                {
                    "_perturbation_rank": perturbation_rank,
                    "perturbation_group": perturbation_type.split("_", 1)[0],
                    "perturbation_type": perturbation_type,
                    "difficulty": difficulty_by_qid[qid],
                    "source_index": source_index,
                    "spider_dev_qid": qid,
                    "db_id": db_id,
                    "question": post_record["question"],
                    "gold_sql": gold_sql,
                    "database_relpath": database_relpath,
                    "tables_relpath": tables_relpath,
                }
            )
            globally_selected_qids.add(qid)

    selected.sort(
        key=lambda record: (
            record["_perturbation_rank"],
            record["spider_dev_qid"],
            record["source_index"],
        )
    )
    for sample_index, record in enumerate(selected):
        record["sample_index"] = sample_index
        record["sample_id"] = (
            f"{record['perturbation_type']}::"
            f"{record['spider_dev_qid']:04d}::"
            f"{record['source_index']:04d}"
        )
        del record["_perturbation_rank"]
    return selected, quota_summary


def build_metadata(
    items: list[dict[str, Any]],
    quotas: dict[str, dict[str, int]],
    seed: int,
    samples_per_type: int,
) -> dict[str, Any]:
    return {
        "dataset_name": "Dr.Spider-340 Diagnostic Subset",
        "protocol_id": PROTOCOL_ID,
        "source_repository": SOURCE_REPOSITORY,
        "source_commit": SOURCE_COMMIT,
        "source_archive_url": SOURCE_ARCHIVE_URL,
        "source_archive_sha256": SOURCE_ARCHIVE_SHA256,
        "split": "post_perturbation",
        "sampling_seed": seed,
        "samples_per_perturbation_type": samples_per_type,
        "perturbation_type_order": PERTURBATION_TYPES,
        "sampling_unit": "unique q_id_spider_dev",
        "global_unique_base_questions": True,
        "difficulty_source": "pre_perturbation parsed SQL",
        "difficulty_allocation": "largest_remainder proportional allocation",
        "difficulty_quotas": quotas,
        "item_count": len(items),
        "usage_note": (
            "This is a stratified diagnostic subset, not the official full "
            "Dr.Spider benchmark score."
        ),
    }


def write_json(path: Path, value: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    serialized = json.dumps(
        value,
        ensure_ascii=False,
        indent=2,
    ) + "\n"
    temporary_path = path.with_suffix(path.suffix + ".tmp")
    temporary_path.write_text(serialized, encoding="utf-8")
    temporary_path.replace(path)


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def validate_outputs(
    questions: list[dict[str, Any]],
    gold: list[dict[str, Any]],
    samples_per_type: int,
) -> None:
    expected_total = len(PERTURBATION_TYPES) * samples_per_type
    if len(questions) != expected_total or len(gold) != expected_total:
        raise ValueError("Output item count is not the expected total")

    question_ids = [item["sample_id"] for item in questions]
    gold_ids = [item["sample_id"] for item in gold]
    if question_ids != gold_ids:
        raise ValueError("Question and gold sample_id sequences differ")
    if len(set(question_ids)) != expected_total:
        raise ValueError("sample_id is not globally unique")
    if len({item["spider_dev_qid"] for item in questions}) != expected_total:
        raise ValueError("Spider-dev base qids are not globally unique")

    type_counts = Counter(item["perturbation_type"] for item in questions)
    expected_counts = {
        perturbation_type: samples_per_type
        for perturbation_type in PERTURBATION_TYPES
    }
    if dict(type_counts) != expected_counts:
        raise ValueError(f"Unexpected perturbation counts: {type_counts}")

    forbidden_question_keys = {
        "query",
        "sql",
        "gold_sql",
        "query_toks",
        "query_toks_no_value",
    }
    for question_item, gold_item in zip(questions, gold):
        if forbidden_question_keys.intersection(question_item):
            raise ValueError(
                f"Gold-bearing key leaked into {question_item['sample_id']}"
            )
        aligned_keys = [
            "sample_id",
            "sample_index",
            "perturbation_group",
            "perturbation_type",
            "difficulty",
            "source_index",
            "spider_dev_qid",
            "db_id",
        ]
        for key in aligned_keys:
            if question_item[key] != gold_item[key]:
                raise ValueError(
                    f"Alignment mismatch for {question_item['sample_id']}: {key}"
                )


def main() -> None:
    args = parse_args()
    source_root = args.source_root.resolve()
    output_dir = args.output_dir.resolve()

    selected, quotas = select_records(
        source_root=source_root,
        seed=args.seed,
        samples_per_type=args.samples_per_type,
    )
    metadata = build_metadata(
        selected,
        quotas,
        args.seed,
        args.samples_per_type,
    )

    common_keys = [
        "sample_id",
        "sample_index",
        "perturbation_group",
        "perturbation_type",
        "difficulty",
        "source_index",
        "spider_dev_qid",
        "db_id",
        "database_relpath",
        "tables_relpath",
    ]
    questions = [
        {
            **{key: record[key] for key in common_keys},
            "question": record["question"],
        }
        for record in selected
    ]
    gold = [
        {
            **{key: record[key] for key in common_keys},
            "gold_sql": record["gold_sql"],
        }
        for record in selected
    ]
    validate_outputs(questions, gold, args.samples_per_type)

    questions_path = output_dir / "drspider_340_questions.json"
    gold_path = output_dir / "drspider_340_gold_sql.json"
    write_json(
        questions_path,
        {
            "metadata": {**metadata, "artifact_role": "questions"},
            "items": questions,
        },
    )
    write_json(
        gold_path,
        {
            "metadata": {**metadata, "artifact_role": "gold_sql"},
            "items": gold,
        },
    )

    difficulty_counts = Counter(item["difficulty"] for item in questions)
    group_counts = Counter(item["perturbation_group"] for item in questions)
    print(f"questions={questions_path}")
    print(f"questions_sha256={file_sha256(questions_path)}")
    print(f"gold={gold_path}")
    print(f"gold_sha256={file_sha256(gold_path)}")
    print(f"items={len(questions)}")
    print(f"groups={dict(group_counts)}")
    print(f"difficulties={dict(difficulty_counts)}")


if __name__ == "__main__":
    main()
