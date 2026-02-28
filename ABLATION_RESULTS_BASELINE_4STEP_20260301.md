# Kết quả Ablation Study - Baseline 4-step (50 câu)

**Ngày chạy:** 2026-03-01  
**Model:** gemini-2.5-flash (4 agents: bỏ Planner + Refiner)  
**Sample:** 50 câu stratified từ Spider dev (easy: 13, medium: 13, hard: 12, extra: 12)

---

## 1. Tổng quan

| Chỉ số | Giá trị |
|--------|---------|
| **Execution Accuracy (EX)** | **78.0%** |
| **Exact Match (EM)** | **44.0%** |
| SQL sinh thành công | 50/50 (100%) |
| Variant | 4-step pipeline (bỏ Query Planner + SQL Refiner) |

---

## 2. Kết quả theo độ khó (Difficulty Breakdown)

| Difficulty | Count | EX (%) | EM (%) |
|------------|-------|--------|--------|
| Easy       | 13    | 92.3   | 69.2   |
| Medium     | 13    | 100.0  | 46.2   |
| Hard       | 12    | 83.3   | 41.7   |
| Extra      | 12    | 33.3   | 16.7   |
| **All**    | **50**| **78.0**| **44.0** |

---

## 3. So sánh với Full 6-step

| Chỉ số | Full 6-step | Baseline 4-step | Δ |
|--------|-------------|-----------------|---|
| **EX** | 90.0%       | 78.0%           | **-12.0** |
| **EM** | 68.0%       | 44.0%           | **-24.0** |

**Kết luận:** Bỏ cả Planner và Refiner giảm EX 12 điểm, EM 24 điểm. Pipeline đầy đủ 6-step vượt trội rõ rệt so với baseline 4-step.

---

## 4. Files liên quan

- `output/ablation/baseline_4step/gold.sql` — Gold SQL
- `output/ablation/baseline_4step/predict.sql` — Predicted SQL
- `data/ablation_baseline_4step_20260301/` — Gold vs Predict để kiểm tra thủ công
