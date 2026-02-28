# Kết quả Ablation Study - Full 6-step (50 câu)

**Ngày chạy:** 2026-02-28  
**Model:** gemini-2.5-flash (tất cả 6 agents)  
**Sample:** 50 câu stratified từ Spider dev (easy: 13, medium: 13, hard: 12, extra: 12)

---

## 1. Tổng quan

| Chỉ số | Giá trị |
|--------|---------|
| **Execution Accuracy (EX)** | **90.0%** |
| **Exact Match (EM)** | **68.0%** |
| SQL sinh thành công | 50/50 (100%) |
| Thời gian chạy | 2849s (~47.5 phút) |
| Trung bình thời gian/câu | ~57s |
| Agent API calls | 300 (6/câu) |

---

## 2. Kết quả theo độ khó (Difficulty Breakdown)

| Difficulty | Count | EX (%) | EM (%) |
|------------|-------|--------|--------|
| Easy       | 13    | 92.3   | 92.3   |
| Medium     | 13    | 100.0  | 69.2   |
| Hard       | 12    | 100.0  | 66.7   |
| Extra      | 12    | 66.7   | 41.7   |
| **All**    | **50**| **90.0**| **68.0** |

---

## 3. Partial Matching (Spider evaluation output)

### Execution Accuracy
```
                     easy     medium   hard     extra    all
count                13       13       12       12       50
execution            0.923    1.000    1.000    0.667    0.900
```

### Exact Match
```
exact match          0.923    0.692    0.667    0.417    0.680
```

---

## 4. Ghi chú cho báo cáo tạp chí

- **Disclaimer:** Kết quả trên mẫu 50 câu stratified; ablation đầy đủ trên 1034 câu là công việc tương lai.
- **So sánh:** Full Spider 1034 câu (trước): EX=84.0%, EM=76.8%. Mẫu 50 câu: EX cao hơn (90%), EM thấp hơn (68%) — có thể do khác biệt sample và format SQL.
- **Nhận xét:** Extra-hard là nhóm cần cải thiện nhất (EM 41.7%).

---

## 5. Files liên quan

- `output/ablation/full_6step/gold.sql` — Gold SQL
- `output/ablation/full_6step/predict.sql` — Predicted SQL
- `data/ablation_full6step_20260228/` — Gold vs Predict để kiểm tra thủ công
