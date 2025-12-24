#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Đánh giá Exact Match và Field Select cho Text-to-SQL trên Spider 1.0
dựa trên cặp file gold.sql & predict.sql (4-step và 6-step).

Giả định format file:
    <SQL>\t<db_id>

Metric:
- Exact Match (SQL): % truy vấn có chuỗi SQL (đã chuẩn hóa đơn giản) trùng hoàn toàn.
- Field Select (per-query): % truy vấn có danh sách trường trong mệnh đề SELECT
  trùng hoàn toàn (sau khi chuẩn hóa đơn giản).
- Field Accuracy (per-field): % trường SELECT đúng trên tổng số trường gold.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
from typing import List, Tuple

import pandas as pd


# Xác định project root: file này nằm trong thư mục `test/`
PROJECT_ROOT = Path(__file__).resolve().parent.parent

# Thư mục mặc định chứa output của 4-step và 6-step
DEFAULT_4STEP_GOLD = PROJECT_ROOT / "output" / "nl2sql_4step" / "gold.sql"
DEFAULT_4STEP_PRED = PROJECT_ROOT / "output" / "nl2sql_4step" / "predict.sql"
DEFAULT_6STEP_GOLD = PROJECT_ROOT / "output" / "nl2sql_6step" / "gold.sql"
DEFAULT_6STEP_PRED = PROJECT_ROOT / "output" / "nl2sql_6step" / "predict.sql"

# Thư mục lưu log phân tích
LOG_DIR = PROJECT_ROOT / "evaluation_logs"
LOG_DIR.mkdir(exist_ok=True)
EXACT_FIELD_LOG_PATH = LOG_DIR / "exact_field_spider1.csv"


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


def normalize_sql(sql: str) -> str:
    """
    Chuẩn hóa SQL đơn giản để so sánh:
    - Bỏ ; cuối câu nếu có.
    - Chuẩn hóa khoảng trắng (split rồi join bằng 1 space).
    - Không thay đổi chữ hoa/thường để tránh mất thông tin trong tên cột.
    """
    s = sql.strip().rstrip(";")
    tokens = s.split()
    return " ".join(tokens)


def extract_select_fields(sql: str) -> List[str]:
    """
    Trích danh sách biểu thức trong mệnh đề SELECT của truy vấn ngoài cùng.
    Cách làm đơn giản:
    - Tìm "select" đầu tiên và " from " đầu tiên (case-insensitive).
    - Lấy phần giữa rồi tách theo dấu phẩy.
    - Giữ nguyên biểu thức (có thể chứa hàm COUNT, alias, v.v.).
    """
    s = sql.strip().rstrip(";")
    lower = s.lower()

    idx_select = lower.find("select ")
    idx_from = lower.find(" from ")
    if idx_select == -1 or idx_from == -1 or idx_from <= idx_select:
        return []

    select_part = s[idx_select + len("select ") : idx_from]
    parts = [p.strip() for p in select_part.split(",")]
    # Bỏ phần rỗng (nếu có)
    return [p for p in parts if p]


def fields_equal(f1: str, f2: str) -> bool:
    """
    So sánh 2 biểu thức trường sau khi:
    - strip
    - chuẩn hóa khoảng trắng
    - so sánh case-insensitive
    """
    n1 = " ".join(f1.split()).strip().lower()
    n2 = " ".join(f2.split()).strip().lower()
    return n1 == n2


@dataclass
class ExactFieldMetrics:
    exact_match_queries: int = 0
    field_select_correct_queries: int = 0
    total_queries: int = 0
    correct_fields: int = 0
    total_gold_fields: int = 0

    def as_percentages(self) -> Tuple[float, float, float]:
        """
        Trả về:
        - exact_match_percent
        - field_select_percent (per-query, all fields đúng)
        - field_accuracy_percent (per-field)
        """
        if self.total_queries == 0:
            return 0.0, 0.0, 0.0
        exact_match = self.exact_match_queries / self.total_queries * 100.0
        field_select = self.field_select_correct_queries / self.total_queries * 100.0
        if self.total_gold_fields == 0:
            field_acc = 0.0
        else:
            field_acc = self.correct_fields / self.total_gold_fields * 100.0
        return exact_match, field_select, field_acc


def evaluate_exact_and_fields(
    gold_path: Path, pred_path: Path, model_type: str
) -> Tuple[ExactFieldMetrics, pd.DataFrame]:
    """
    Đánh giá Exact Match & Field Select cho 1 model từ cặp file gold.sql/predict.sql.
    Trả về:
    - metrics (ExactFieldMetrics)
    - df_log: DataFrame per-query (phục vụ lưu CSV/đọc phân tích).
    """
    gold_pairs = parse_sql_result_file(gold_path)
    pred_pairs = parse_sql_result_file(pred_path)

    total = min(len(gold_pairs), len(pred_pairs))
    metrics = ExactFieldMetrics(total_queries=total)

    rows_for_log: List[dict] = []

    for idx in range(total):
        line_no = idx + 1
        gold_sql, gold_db = gold_pairs[idx]
        pred_sql, pred_db = pred_pairs[idx]

        gold_norm = normalize_sql(gold_sql)
        pred_norm = normalize_sql(pred_sql)

        gold_fields = extract_select_fields(gold_sql)
        pred_fields = extract_select_fields(pred_sql)

        # Exact match SQL
        is_exact = gold_norm == pred_norm
        if is_exact:
            metrics.exact_match_queries += 1

        # Field-level
        gold_n_fields = len(gold_fields)
        pred_n_fields = len(pred_fields)

        metrics.total_gold_fields += gold_n_fields

        per_query_correct_fields = 0
        per_query_total_fields = gold_n_fields

        # So khớp theo vị trí
        for i, g_field in enumerate(gold_fields):
            if i < pred_n_fields and fields_equal(g_field, pred_fields[i]):
                metrics.correct_fields += 1
                per_query_correct_fields += 1

        field_select_ok = (
            gold_n_fields == pred_n_fields
            and gold_n_fields > 0
            and all(
                fields_equal(g, p)
                for g, p in zip(gold_fields, pred_fields)
            )
        )
        if field_select_ok:
            metrics.field_select_correct_queries += 1

        rows_for_log.append(
            {
                "model_type": model_type,
                "line_no": line_no,
                "db_id_gold": gold_db,
                "db_id_pred": pred_db,
                "gold_sql": gold_sql,
                "pred_sql": pred_sql,
                "exact_match_sql": int(is_exact),
                "gold_select": ", ".join(gold_fields),
                "pred_select": ", ".join(pred_fields),
                "field_select_ok": int(field_select_ok),
                "gold_n_fields": gold_n_fields,
                "pred_n_fields": pred_n_fields,
                "per_query_correct_fields": per_query_correct_fields,
                "per_query_total_gold_fields": per_query_total_fields,
            }
        )

    df_log = pd.DataFrame(rows_for_log)
    return metrics, df_log


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Đánh giá Exact Match & Field Select cho Spider 1.0 "
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
    print("📄 4-step gold:", four_gold_path)
    print("📄 4-step pred:", four_pred_path)
    print("📄 6-step gold:", six_gold_path)
    print("📄 6-step pred:", six_pred_path)

    # Đánh giá 4-step
    metrics_4, df_log_4 = evaluate_exact_and_fields(
        gold_path=four_gold_path,
        pred_path=four_pred_path,
        model_type="4-step",
    )

    # Đánh giá 6-step
    metrics_6, df_log_6 = evaluate_exact_and_fields(
        gold_path=six_gold_path,
        pred_path=six_pred_path,
        model_type="6-step",
    )

    em4, fs4, fa4 = metrics_4.as_percentages()
    em6, fs6, fa6 = metrics_6.as_percentages()

    print("\n================ Exact Match & Field Metrics (Spider 1.0) ================")
    print(f"Model 4-step:")
    print(f"  - Exact Match (SQL):       {em4:.2f} %")
    print(f"  - Field Select (per-query):{fs4:.2f} %")
    print(f"  - Field Accuracy (per-field): {fa4:.2f} %")
    print(f"  - Số truy vấn: {metrics_4.total_queries}")

    print(f"\nModel 6-step:")
    print(f"  - Exact Match (SQL):       {em6:.2f} %")
    print(f"  - Field Select (per-query):{fs6:.2f} %")
    print(f"  - Field Accuracy (per-field): {fa6:.2f} %")
    print(f"  - Số truy vấn: {metrics_6.total_queries}")
    print("=======================================================================")

    # Gộp log và lưu CSV
    df_all = pd.concat([df_log_4, df_log_6], ignore_index=True)
    df_all.to_csv(EXACT_FIELD_LOG_PATH, index=False, encoding="utf-8")
    print(f"\n📁 Đã lưu log chi tiết Exact/Field tại: {EXACT_FIELD_LOG_PATH}")
    print(f"   Số lượng dòng: {len(df_all)}")


if __name__ == "__main__":
    main()


