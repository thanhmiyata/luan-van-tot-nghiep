# Kết quả Ablation Study - No Refiner (50 câu)

**Ngày chạy:** 2026-02-28  
**Model:** gemini-2.5-flash (5 agents: bỏ SQL Refiner)  
**Sample:** 50 câu stratified từ Spider dev (easy: 13, medium: 13, hard: 12, extra: 12)

---

## 1. Tổng quan

| Chỉ số | Giá trị |
|--------|---------|
| **Execution Accuracy (EX)** | **84.0%** |
| **Exact Match (EM)** | **62.0%** |
| SQL sinh thành công | 50/50 (100%) |
| Variant | 6-step pipeline **không có** SQL Refiner |

---

## 2. Kết quả theo độ khó (Difficulty Breakdown)

| Difficulty | Count | EX (%) | EM (%) |
|------------|-------|--------|--------|
| Easy       | 13    | 92.3   | 84.6   |
| Medium     | 13    | 100.0  | 61.5   |
| Hard       | 12    | 91.7   | 58.3   |
| Extra      | 12    | 50.0   | 41.7   |
| **All**    | **50**| **84.0**| **62.0** |

---

## 3. So sánh với Full 6-step

| Chỉ số | Full 6-step | No Refiner | Δ |
|--------|-------------|------------|---|
| **EX** | 90.0%       | 84.0%      | **-6.0** |
| **EM** | 68.0%       | 62.0%      | **-6.0** |

**Kết luận:** Bỏ SQL Refiner làm giảm EX 6 điểm và EM 6 điểm. Refiner hỗ trợ chuẩn hóa SQL (format, pattern fixes) trước khi Validator kiểm tra.

---

## 4. Partial Matching (Spider evaluation output)

### Execution Accuracy
```
                     easy     medium   hard     extra    all
count                13       13       12       12       50
execution            0.923    1.000    0.917    0.500    0.840
```

### Exact Match
```
exact match          0.846    0.615    0.583    0.417    0.620
```

---

## 5. Files liên quan

- `output/ablation/no_refiner/gold.sql` — Gold SQL
- `output/ablation/no_refiner/predict.sql` — Predicted SQL
- `data/ablation_no_refiner_20260228/` — Gold vs Predict để kiểm tra thủ công
