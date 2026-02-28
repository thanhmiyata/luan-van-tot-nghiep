# Kết quả Ablation Study - No Planner (50 câu)

**Ngày chạy:** 2026-02-28  
**Model:** gemini-2.5-flash (5 agents: bỏ Query Planner)  
**Sample:** 50 câu stratified từ Spider dev (easy: 13, medium: 13, hard: 12, extra: 12)

---

## 1. Tổng quan

| Chỉ số | Giá trị |
|--------|---------|
| **Execution Accuracy (EX)** | **86.0%** |
| **Exact Match (EM)** | **58.0%** |
| SQL sinh thành công | 50/50 (100%) |
| Variant | 6-step pipeline **không có** Query Planner |

---

## 2. Kết quả theo độ khó (Difficulty Breakdown)

| Difficulty | Count | EX (%) | EM (%) |
|------------|-------|--------|--------|
| Easy       | 13    | 92.3   | 84.6   |
| Medium     | 13    | 100.0  | 53.8   |
| Hard       | 12    | 100.0  | 66.7   |
| Extra      | 12    | 50.0   | 25.0   |
| **All**    | **50**| **86.0**| **58.0** |

---

## 3. So sánh với Full 6-step

| Chỉ số | Full 6-step | No Planner | Δ |
|--------|-------------|------------|---|
| **EX** | 90.0%       | 86.0%      | **-4.0** |
| **EM** | 68.0%       | 58.0%      | **-10.0** |

**Kết luận:** Bỏ Query Planner làm giảm EX 4 điểm và EM 10 điểm. Planner có tác động rõ rệt lên độ chính xác, đặc biệt EM (formulation chuẩn).

---

## 4. Partial Matching (Spider evaluation output)

### Execution Accuracy
```
                     easy     medium   hard     extra    all
count                13       13       12       12       50
execution            0.923    1.000    1.000    0.500    0.860
```

### Exact Match
```
exact match          0.846    0.538    0.667    0.250    0.580
```

---

## 5. Files liên quan

- `output/ablation/no_planner/gold.sql` — Gold SQL
- `output/ablation/no_planner/predict.sql` — Predicted SQL
- `output/ablation/no_planner/nl2sql_ablation_no_planner_20260228190406.csv` — Chi tiết từng câu
- `data/ablation_no_planner_20260228/` — Gold vs Predict để kiểm tra thủ công
