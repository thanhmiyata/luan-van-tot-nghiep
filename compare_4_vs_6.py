#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
So sánh benchmark 2 pipeline NL2SQL: 4-step vs 6-step dựa trên kết quả đã có sẵn.

Logic:
- Chỉ đọc gold.sql và predict.sql từ lần chạy pipeline cuối cùng:
  - output/nl2sql_4step/gold.sql & predict.sql
  - output/nl2sql_6step/gold.sql & predict.sql
- Chạy benchmark (test-suite-sql-eval) trên cả hai để so sánh:
  - Execution Accuracy: % SQL thực thi đúng (kết quả khớp với gold)
  - Exact Match: % SQL khớp chính xác với gold
- In bảng so sánh chi tiết.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import run_complete_nl2sql_pipeline as full_pipeline


def benchmark_pipeline(pipeline_type: str) -> dict | None:
    """
    Benchmark một pipeline dựa trên gold.sql và predict.sql đã có sẵn.
    
    Returns:
        Dict với keys: 'pipeline', 'gold', 'predict', 'eval', hoặc None nếu lỗi.
    """
    print("\n" + "#" * 80)
    print(f"📊 BENCHMARK PIPELINE {pipeline_type.upper()}")
    print("#" * 80)
    
    # Cấu hình để có PIPELINE_OUTPUT_DIR đúng
    full_pipeline.configure_pipeline(pipeline_type)
    
    output_dir = full_pipeline.PIPELINE_OUTPUT_DIR
    if output_dir is None:
        print("❌ PIPELINE_OUTPUT_DIR chưa được cấu hình.")
        return None
    
    gold_file = output_dir / "gold.sql"
    predict_file = output_dir / "predict.sql"
    
    print(f"📁 Đọc kết quả từ:")
    print(f"   - Gold   : {gold_file}")
    print(f"   - Predict: {predict_file}")
    
    # Kiểm tra tồn tại
    missing = []
    if not Path(gold_file).exists():
        missing.append(str(gold_file))
    if not Path(predict_file).exists():
        missing.append(str(predict_file))
    
    if missing:
        print("❌ Thiếu file cần thiết:")
        for p in missing:
            print(f"   - {p}")
        print("💡 Hãy chạy pipeline đầy đủ trước (run_complete_nl2sql_pipeline.py)")
        return None
    
    # Chạy benchmark
    print("\n🔄 Đang chạy benchmark test-suite-sql-eval...")
    eval_metrics = full_pipeline.run_evaluation(gold_file, predict_file)
    
    if eval_metrics is None:
        print("❌ Benchmark thất bại (run_evaluation trả về None).")
        return None
    
    exec_rate = eval_metrics.get("execution_rate", 0.0)
    exact_rate = eval_metrics.get("exact_match_rate", 0.0)
    
    print(f"\n✅ Kết quả benchmark {pipeline_type}:")
    print(f"   - Execution Accuracy: {exec_rate:.2f}%")
    print(f"   - Exact Match       : {exact_rate:.2f}%")
    
    return {
        "pipeline": pipeline_type,
        "gold": str(gold_file),
        "predict": str(predict_file),
        "eval": eval_metrics,
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "So sánh benchmark 2 pipeline NL2SQL (4-step vs 6-step) "
            "dựa trên kết quả đã có sẵn (gold.sql & predict.sql). "
            "Không chạy lại pipeline, chỉ benchmark lại."
        )
    )
    args = parser.parse_args()
    
    print("=" * 90)
    print("🔍 SO SÁNH BENCHMARK 4-STEP vs 6-STEP")
    print("   (Dựa trên kết quả từ lần chạy pipeline cuối cùng)")
    print("=" * 90)
    
    # Benchmark cả 2 pipeline
    result_4 = benchmark_pipeline("4step")
    result_6 = benchmark_pipeline("6step")
    
    # In bảng so sánh
    print("\n" + "=" * 90)
    print("📊 TÓM TẮT SO SÁNH BENCHMARK")
    print("=" * 90)
    
    if result_4 and result_6:
        e4 = result_4["eval"] or {}
        e6 = result_6["eval"] or {}
        
        exec_4 = e4.get("execution_rate", 0.0)
        exact_4 = e4.get("exact_match_rate", 0.0)
        exec_6 = e6.get("execution_rate", 0.0)
        exact_6 = e6.get("exact_match_rate", 0.0)
        
        print("| Pipeline | Execution Accuracy | Exact Match | Cải thiện Exec | Cải thiện Exact |")
        print("|----------|-------------------|-------------|----------------|-----------------|")
        print(f"| 4-step   | {exec_4:17.2f}% | {exact_4:11.2f}% | {'-':14} | {'-':15} |")
        print(f"| 6-step   | {exec_6:17.2f}% | {exact_6:11.2f}% | {exec_6 - exec_4:+13.2f}% | {exact_6 - exact_4:+14.2f}% |")
        print("=" * 90)
        
        # Phân tích
        print("\n📈 PHÂN TÍCH:")
        if exec_6 > exec_4:
            print(f"   ✅ 6-step tốt hơn về Execution: +{exec_6 - exec_4:.2f}%")
        elif exec_6 < exec_4:
            print(f"   ⚠️  4-step tốt hơn về Execution: {exec_6 - exec_4:.2f}%")
        else:
            print("   ➡️  Execution Accuracy bằng nhau")
        
        if exact_6 > exact_4:
            print(f"   ✅ 6-step tốt hơn về Exact Match: +{exact_6 - exact_4:.2f}%")
        elif exact_6 < exact_4:
            print(f"   ⚠️  4-step tốt hơn về Exact Match: {exact_6 - exact_4:.2f}%")
        else:
            print("   ➡️  Exact Match bằng nhau")
        
        # Đánh giá tổng thể
        print("\n💡 ĐÁNH GIÁ:")
        avg_4 = (exec_4 + exact_4) / 2
        avg_6 = (exec_6 + exact_6) / 2
        
        if avg_6 > avg_4:
            print(f"   🎯 6-step có điểm trung bình cao hơn: {avg_6:.2f}% vs {avg_4:.2f}% (+{avg_6 - avg_4:.2f}%)")
        elif avg_6 < avg_4:
            print(f"   🎯 4-step có điểm trung bình cao hơn: {avg_4:.2f}% vs {avg_6:.2f}% ({avg_6 - avg_4:.2f}%)")
        else:
            print(f"   🎯 Cả hai có điểm trung bình bằng nhau: {avg_4:.2f}%")
        
        if exec_4 < 50 or exec_6 < 50:
            print("\n   ⚠️  CẢNH BÁO: Cả hai pipeline đều có Execution Accuracy < 50%")
            print("      Điều này cho thấy có nhiều SQL được generate không thực thi được")
            print("      hoặc kết quả không khớp với gold SQL.")
        
        if exact_4 < 30 or exact_6 < 30:
            print("\n   ⚠️  CẢNH BÁO: Exact Match < 30%")
            print("      Điều này cho thấy SQL được generate khác biệt đáng kể so với gold SQL.")
            print("      Cần kiểm tra lại prompts và logic của các agents.")
            
    elif result_4:
        print("⚠️  Chỉ có kết quả 4-step, không thể so sánh.")
    elif result_6:
        print("⚠️  Chỉ có kết quả 6-step, không thể so sánh.")
    else:
        print("❌ Không có kết quả nào để so sánh.")
        print("💡 Hãy chạy pipeline đầy đủ trước:")
        print("   python run_complete_nl2sql_pipeline.py --pipeline 4step --num_questions 20")
        print("   python run_complete_nl2sql_pipeline.py --pipeline 6step --num_questions 20")


if __name__ == "__main__":
    main()


