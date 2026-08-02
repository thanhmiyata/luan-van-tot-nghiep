#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Đánh giá Execution Accuracy cho Text-to-SQL trên Spider 1.0.

Logic:
- Đọc lần lượt từng dòng từ gold.sql và predict.sql (4-step & 6-step).
- Mỗi dòng có format: <SQL>\t<db_id>.
- Kết nối động tới database SQLite tương ứng với db_id.
- Thực thi gold_sql và predicted_sql.
- So sánh kết quả theo quy tắc ORDER BY / set comparison.
- In accuracy cho từng model, lưu log các câu sai.
"""

from __future__ import annotations

import argparse
import json
import math
import sqlite3
from pathlib import Path
from typing import Any, List, Sequence, Tuple

import numpy as np
import pandas as pd
from tqdm import tqdm


# Xác định project root: file này nằm trong thư mục `test/`
PROJECT_ROOT = Path(__file__).resolve().parent.parent

# Cấu trúc Spider theo dự án: data/spider_data/database/<db_id>/<db_id>.sqlite
SPIDER_DB_ROOT = PROJECT_ROOT / "data" / "spider_data" / "database"

# Thư mục mặc định chứa output của 4-step và 6-step
DEFAULT_4STEP_GOLD = PROJECT_ROOT / "output" / "nl2sql_4step" / "gold.sql"
DEFAULT_4STEP_PRED = PROJECT_ROOT / "output" / "nl2sql_4step" / "predict.sql"
DEFAULT_6STEP_GOLD = PROJECT_ROOT / "output" / "nl2sql_6step" / "gold.sql"
DEFAULT_6STEP_PRED = PROJECT_ROOT / "output" / "nl2sql_6step" / "predict.sql"

# Thư mục lưu log phân tích lỗi
LOG_DIR = PROJECT_ROOT / "evaluation_logs"
LOG_DIR.mkdir(exist_ok=True)
FAILURE_LOG_PATH = LOG_DIR / "failure_analysis_spider1.csv"
PER_QUERY_LOG_PATH = LOG_DIR / "per_query_execution_spider1.csv"


def get_db_path(db_id: str) -> Path:
    """Tìm đường dẫn tới file SQLite giống logic của pipeline gốc."""
    db_path = SPIDER_DB_ROOT / db_id / f"{db_id}.sqlite"
    if not db_path.exists():
        raise FileNotFoundError(
            f"Không tìm thấy database cho db_id='{db_id}': {db_path}"
        )
    return db_path


def execute_query(conn: sqlite3.Connection, sql: str) -> List[Tuple[Any, ...]]:
    """Thực thi SQL và trả về list các dòng (tuple)."""
    cur = conn.cursor()
    cur.execute(sql)
    rows = cur.fetchall()
    return rows


def _is_number(x: Any) -> bool:
    return isinstance(x, (int, float, np.number))


def _normalize_for_sort(value: Any) -> Tuple[int, Any]:
    """Chuẩn hóa giá trị thành key sortable (type_rank, normalized_value)."""
    if value is None:
        return (0, 0)
    if _is_number(value):
        return (1, float(value))
    if isinstance(value, str):
        return (2, value.strip().lower())
    # fallback: dùng repr
    return (3, repr(value))


def _values_equal(a: Any, b: Any, rel_tol: float = 1e-5, abs_tol: float = 1e-5) -> bool:
    # Cùng None
    if a is None and b is None:
        return True

    # Một trong hai là None
    if a is None or b is None:
        return False

    # Numeric comparison
    if _is_number(a) and _is_number(b):
        try:
            return math.isclose(float(a), float(b), rel_tol=rel_tol, abs_tol=abs_tol)
        except (TypeError, ValueError):
            pass

    # String comparison (case-insensitive)
    if isinstance(a, str) or isinstance(b, str):
        return str(a).strip().lower() == str(b).strip().lower()

    # Fallback: so sánh trực tiếp
    return a == b


def _rows_shape_equal(rows1: Sequence[Sequence[Any]], rows2: Sequence[Sequence[Any]]) -> bool:
    if len(rows1) != len(rows2):
        return False
    if not rows1 and not rows2:
        return True

    # Kiểm tra số cột (giả định các dòng trong mỗi result có cùng số cột)
    cols1 = len(rows1[0])
    cols2 = len(rows2[0])
    return cols1 == cols2


def compare_results(
    gold_rows: Sequence[Sequence[Any]],
    pred_rows: Sequence[Sequence[Any]],
    gold_sql: str,
) -> bool:
    """
    So sánh kết quả theo quy tắc:
    - Nếu gold_sql có ORDER BY -> so sánh list theo thứ tự.
    - Nếu không -> sort cả hai (set comparison) rồi so sánh.
    """
    # Shape
    if not _rows_shape_equal(gold_rows, pred_rows):
        return False

    has_order_by = "order by" in gold_sql.lower()

    if not gold_rows and not pred_rows:
        # Cùng rỗng -> đúng
        return True

    if has_order_by:
        # Strict comparison theo thứ tự
        for r1, r2 in zip(gold_rows, pred_rows):
            if len(r1) != len(r2):
                return False
            for v1, v2 in zip(r1, r2):
                if not _values_equal(v1, v2):
                    return False
        return True

    # Set comparison: sort theo tất cả các cột
    def sort_key(row: Sequence[Any]) -> Tuple[Tuple[int, Any], ...]:
        return tuple(_normalize_for_sort(v) for v in row)

    sorted_gold = sorted(gold_rows, key=sort_key)
    sorted_pred = sorted(pred_rows, key=sort_key)

    for r1, r2 in zip(sorted_gold, sorted_pred):
        if len(r1) != len(r2):
            return False
        for v1, v2 in zip(r1, r2):
            if not _values_equal(v1, v2):
                return False
    return True


def parse_sql_result_file(path: Path) -> List[Tuple[str, str]]:
    """
    Đọc file kết quả dạng:
        <SQL>\t<db_id>
    Trả về list (sql, db_id).
    """
    if not path.exists():
        raise FileNotFoundError(f"Không tìm thấy file: {path}")

    pairs: List[Tuple[str, str]] = []
    with path.open("r", encoding="utf-8") as f:
        for line_no, line in enumerate(f, 1):
            line = line.rstrip("\n")
            if not line.strip():
                continue
            parts = line.split("\t")
            if len(parts) < 2:
                # Bỏ qua dòng không hợp lệ
                continue
            sql = parts[0].strip()
            db_id = parts[1].strip()
            if sql:
                pairs.append((sql, db_id))
    return pairs


def evaluate_model_from_sql_files(
    gold_path: Path,
    pred_path: Path,
    model_type: str,
    failure_logs: List[dict],
    per_query_logs: List[dict],
) -> float:
    """
    Đánh giá 1 model từ cặp file gold.sql & predict.sql, trả về accuracy (0-1).
    Ghi chi tiết lỗi vào failure_logs (list of dict).
    """
    gold_pairs = parse_sql_result_file(gold_path)
    pred_pairs = parse_sql_result_file(pred_path)

    total = min(len(gold_pairs), len(pred_pairs))
    if total == 0:
        return 0.0

    if len(gold_pairs) != len(pred_pairs):
        failure_logs.append(
            {
                "model_type": model_type,
                "db_id": "",
                "question": "",
                "gold_sql": "",
                "pred_sql": "",
                "error_type": "length_mismatch",
                "error_msg": f"Số dòng gold ({len(gold_pairs)}) != số dòng predict ({len(pred_pairs)})",
            }
        )

    correct = 0

    for idx in tqdm(range(total), desc=f"Evaluating {model_type}", unit="query"):
        line_no = idx + 1
        gold_sql, gold_db = gold_pairs[idx]
        pred_sql, pred_db = pred_pairs[idx]

        question = f"Line {line_no}"  # không có natural language question

        gold_sql = gold_sql.strip()
        pred_sql = pred_sql.strip()

        # Thông tin per-query cơ bản
        base_log = {
            "model_type": model_type,
            "line_no": line_no,
            "db_id": "",
            "question": question,
            "gold_sql": gold_sql,
            "pred_sql": pred_sql,
            "execute_correct": 0,
            "compare_mode": "",
            "gold_n_rows": None,
            "gold_n_cols": None,
            "pred_n_rows": None,
            "pred_n_cols": None,
            "error_type": "",
            "error_msg": "",
        }

        if not gold_db:
            log_entry = base_log.copy()
            log_entry.update(
                {
                    "db_id": gold_db,
                    "error_type": "missing_db",
                    "error_msg": "Thiếu db_id cho gold",
                }
            )
            failure_logs.append(log_entry)
            per_query_logs.append(log_entry)
            continue

        if gold_db != pred_db:
            log_entry = base_log.copy()
            log_entry.update(
                {
                    "db_id": gold_db,
                    "error_type": "db_id_mismatch",
                    "error_msg": f"db_id không khớp: gold='{gold_db}', pred='{pred_db}'",
                }
            )
            failure_logs.append(log_entry)
            per_query_logs.append(log_entry)
            continue

        db_id = gold_db
        base_log["db_id"] = db_id

        if not gold_sql:
            log_entry = base_log.copy()
            log_entry.update(
                {
                    "error_type": "missing_gold_sql",
                    "error_msg": "gold_sql rỗng",
                }
            )
            failure_logs.append(log_entry)
            per_query_logs.append(log_entry)
            continue

        if not pred_sql:
            log_entry = base_log.copy()
            log_entry.update(
                {
                    "error_type": "empty_prediction",
                    "error_msg": "predicted_sql rỗng",
                }
            )
            failure_logs.append(log_entry)
            per_query_logs.append(log_entry)
            continue

        try:
            db_path = get_db_path(db_id)
        except FileNotFoundError as e:
            log_entry = base_log.copy()
            log_entry.update(
                {
                    "error_type": "db_not_found",
                    "error_msg": str(e),
                }
            )
            failure_logs.append(log_entry)
            per_query_logs.append(log_entry)
            continue

        try:
            conn = sqlite3.connect(str(db_path))
        except sqlite3.Error as e:
            log_entry = base_log.copy()
            log_entry.update(
                {
                    "error_type": "db_connection_error",
                    "error_msg": str(e),
                }
            )
            failure_logs.append(log_entry)
            per_query_logs.append(log_entry)
            continue

        try:
            gold_rows = execute_query(conn, gold_sql)
        except sqlite3.Error as e:
            # Gold bị lỗi: về lý thuyết không nên xảy ra, nhưng vẫn log lại
            log_entry = base_log.copy()
            log_entry.update(
                {
                    "error_type": "gold_execution_error",
                    "error_msg": str(e),
                }
            )
            failure_logs.append(log_entry)
            per_query_logs.append(log_entry)
            conn.close()
            continue

        try:
            pred_rows = execute_query(conn, pred_sql)
        except sqlite3.Error as e:
            # predicted_sql lỗi cú pháp hoặc runtime -> điểm = 0
            log_entry = base_log.copy()
            log_entry.update(
                {
                    "error_type": "prediction_execution_error",
                    "error_msg": str(e),
                }
            )
            failure_logs.append(log_entry)
            per_query_logs.append(log_entry)
            conn.close()
            continue

        conn.close()

        # Cập nhật thông tin shape
        gold_n_rows = len(gold_rows)
        pred_n_rows = len(pred_rows)
        gold_n_cols = len(gold_rows[0]) if gold_rows else 0
        pred_n_cols = len(pred_rows[0]) if pred_rows else 0

        compare_mode = "ordered" if "order by" in gold_sql.lower() else "set"

        try:
            is_correct = compare_results(gold_rows, pred_rows, gold_sql)
        except Exception as e:  # phòng trường hợp lỗi so sánh
            log_entry = base_log.copy()
            log_entry.update(
                {
                    "compare_mode": compare_mode,
                    "gold_n_rows": gold_n_rows,
                    "gold_n_cols": gold_n_cols,
                    "pred_n_rows": pred_n_rows,
                    "pred_n_cols": pred_n_cols,
                    "error_type": "comparison_error",
                    "error_msg": str(e),
                }
            )
            failure_logs.append(log_entry)
            per_query_logs.append(log_entry)
            continue

        log_entry = base_log.copy()
        log_entry.update(
            {
                "compare_mode": compare_mode,
                "gold_n_rows": gold_n_rows,
                "gold_n_cols": gold_n_cols,
                "pred_n_rows": pred_n_rows,
                "pred_n_cols": pred_n_cols,
            }
        )

        if is_correct:
            correct += 1
            log_entry["execute_correct"] = 1
        else:
            # Phân loại lý do sai
            # Log toàn bộ kết quả thực thi để người dùng có thể xem lại
            try:
                log_entry["gold_result"] = json.dumps(
                    gold_rows, ensure_ascii=False
                )
                log_entry["pred_result"] = json.dumps(
                    pred_rows, ensure_ascii=False
                )
            except TypeError:
                # Fallback nếu có kiểu dữ liệu không JSON-serializable
                log_entry["gold_result"] = str(gold_rows)
                log_entry["pred_result"] = str(pred_rows)

            if not _rows_shape_equal(gold_rows, pred_rows):
                log_entry["error_type"] = "shape_mismatch"
                log_entry["error_msg"] = "Số dòng/cột khác nhau giữa gold và pred"
            else:
                log_entry["error_type"] = "value_mismatch"
                log_entry["error_msg"] = "Giá trị khác nhau dù shape giống"
            failure_logs.append(log_entry)

        per_query_logs.append(log_entry)

    return correct / float(total)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Đánh giá Execution Accuracy cho Spider 1.0 "
            "từ các file gold.sql & predict.sql (4-step & 6-step)."
        )
    )
    # 4-step
    parser.add_argument(
        "--four_step_gold",
        type=str,
        default=str(DEFAULT_4STEP_GOLD),
        help=(
            "Đường dẫn tới file gold.sql của model 4-step "
            f"(mặc định: {DEFAULT_4STEP_GOLD})"
        ),
    )
    parser.add_argument(
        "--four_step_pred",
        type=str,
        default=str(DEFAULT_4STEP_PRED),
        help=(
            "Đường dẫn tới file predict.sql của model 4-step "
            f"(mặc định: {DEFAULT_4STEP_PRED})"
        ),
    )
    # 6-step
    parser.add_argument(
        "--six_step_gold",
        type=str,
        default=str(DEFAULT_6STEP_GOLD),
        help=(
            "Đường dẫn tới file gold.sql của model 6-step "
            f"(mặc định: {DEFAULT_6STEP_GOLD})"
        ),
    )
    parser.add_argument(
        "--six_step_pred",
        type=str,
        default=str(DEFAULT_6STEP_PRED),
        help=(
            "Đường dẫn tới file predict.sql của model 6-step "
            f"(mặc định: {DEFAULT_6STEP_PRED})"
        ),
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    four_gold_path = Path(args.four_step_gold)
    four_pred_path = Path(args.four_step_pred)
    six_gold_path = Path(args.six_step_gold)
    six_pred_path = Path(args.six_step_pred)

    print("📂 Project root:", PROJECT_ROOT)
    print("📂 Spider DB root:", SPIDER_DB_ROOT)
    print("📄 4-step gold:", four_gold_path)
    print("📄 4-step pred:", four_pred_path)
    print("📄 6-step gold:", six_gold_path)
    print("📄 6-step pred:", six_pred_path)

    failure_logs: List[dict] = []
    per_query_logs: List[dict] = []

    # Đánh giá 4-step
    acc_4 = evaluate_model_from_sql_files(
        gold_path=four_gold_path,
        pred_path=four_pred_path,
        model_type="4-step",
        failure_logs=failure_logs,
        per_query_logs=per_query_logs,
    )

    # Đánh giá 6-step
    acc_6 = evaluate_model_from_sql_files(
        gold_path=six_gold_path,
        pred_path=six_pred_path,
        model_type="6-step",
        failure_logs=failure_logs,
        per_query_logs=per_query_logs,
    )

    acc_4_percent = acc_4 * 100.0
    acc_6_percent = acc_6 * 100.0

    print("\n==================== Evaluation Summary (Spider 1.0) ====================")
    print(f"Accuracy của Model 4-step: {acc_4_percent:.2f} %")
    print(f"Accuracy của Model 6-step: {acc_6_percent:.2f} %")
    print("=======================================================================")

    # Lưu failure logs
    if failure_logs:
        df = pd.DataFrame(failure_logs)
        df.to_csv(FAILURE_LOG_PATH, index=False, encoding="utf-8")
        print(f"\n📁 Đã lưu log chi tiết các câu sai tại: {FAILURE_LOG_PATH}")
        print(f"   Số lượng dòng log: {len(df)}")
    else:
        print("\n✅ Không có câu sai, không cần ghi failure log.")

    # Lưu per-query logs (bao gồm cả đúng và sai)
    if per_query_logs:
        df_all = pd.DataFrame(per_query_logs)
        df_all.to_csv(PER_QUERY_LOG_PATH, index=False, encoding="utf-8")
        print(f"📁 Đã lưu log chi tiết per-query tại: {PER_QUERY_LOG_PATH}")
        print(f"   Số lượng dòng: {len(df_all)}")


if __name__ == "__main__":
    main()



