# Tổng hợp Ablation Study — Spider 50 câu (2026-02-28 ~ 03-01)

**Sample:** 50 câu stratified (easy: 13, medium: 13, hard: 12, extra: 12)  
**Model:** gemini-2.5-flash (tất cả agents)

---

## 1. Bảng tổng hợp variants

| Variant | Agents | EX (%) | EM (%) | Δ EX | Δ EM |
|---------|--------|--------|--------|------|------|
| **full_6step** | 6 (đầy đủ) | **90.0** | **68.0** | — | — |
| no_planner | 5 (bỏ Planner) | 86.0 | 58.0 | -4.0 | -10.0 |
| no_refiner | 5 (bỏ Refiner) | 84.0 | 62.0 | -6.0 | -6.0 |
| baseline_4step | 4 (bỏ cả 2) | 78.0 | 44.0 | -12.0 | -24.0 |

---

## 2. Kết quả theo độ khó

### Execution Accuracy (EX %)

| Difficulty | full_6step | no_planner | no_refiner | baseline_4step |
|------------|-----------|-----------|-----------|---------------|
| Easy (13)  | 92.3      | 92.3      | 92.3      | 92.3          |
| Medium (13)| 100.0     | 100.0     | 100.0     | 100.0         |
| Hard (12)  | 100.0     | 100.0     | 91.7      | 83.3          |
| Extra (12) | 66.7      | 50.0      | 50.0      | 33.3          |
| **All**    | **90.0**  | **86.0**  | **84.0**  | **78.0**      |

### Exact Match (EM %)

| Difficulty | full_6step | no_planner | no_refiner | baseline_4step |
|------------|-----------|-----------|-----------|---------------|
| Easy (13)  | 92.3      | 84.6      | 84.6      | 69.2          |
| Medium (13)| 69.2      | 53.8      | 61.5      | 46.2          |
| Hard (12)  | 66.7      | 66.7      | 58.3      | 41.7          |
| Extra (12) | 41.7      | 25.0      | 41.7      | 16.7          |
| **All**    | **68.0**  | **58.0**  | **62.0**  | **44.0**      |

---

## 3. Phân tích

### 3.1 Đóng góp của từng agent

| Agent bị loại | Δ EX | Δ EM | Nhận xét |
|---------------|------|------|----------|
| Query Planner | -4.0 | -10.0 | Tác động lớn nhất lên EM; giúp chuẩn hóa SQL formulation |
| SQL Refiner | -6.0 | -6.0 | Tác động đều cả EX và EM; sửa pattern trước Validator |
| Cả hai | -12.0 | -24.0 | Tổng > tổng riêng lẻ → Planner + Refiner có tác dụng cộng hưởng |

### 3.2 Nhận xét theo difficulty

- **Easy/Medium:** EX hầu như không đổi (92–100%); EM giảm dần khi bỏ agents
- **Hard:** Refiner quan trọng hơn Planner (EX giảm 8.3 vs 0; EM giảm 8.4 vs 0)
- **Extra:** Cả hai agents đều quan trọng; baseline chỉ đạt EX 33.3%, EM 16.7%
- **Hiệu ứng cộng hưởng:** Baseline_4step (Δ -24 EM) > no_planner (-10) + no_refiner (-6) = -16. Planner và Refiner bổ trợ lẫn nhau.

### 3.3 Kết luận cho bài báo

> Kết quả ablation trên 50 câu stratified cho thấy pipeline 6 bước đạt EX 90% và EM 68%, vượt trội so với baseline 4 bước (EX 78%, EM 44%). Query Planner đóng vai trò chính trong chuẩn hóa SQL (EM -10 khi bỏ), trong khi SQL Refiner cải thiện cả tính đúng lẫn format (EX -6, EM -6). Hiệu ứng cộng hưởng giữa hai agent (Δ EM tổng hợp -24 > -16) chứng minh thiết kế 6 bước không chỉ thêm bước mà còn tạo sự tương tác tích cực giữa các agent.

---

## 4. Files tham chiếu

| Variant | Báo cáo | Data |
|---------|---------|------|
| full_6step | ABLATION_RESULTS_FULL6STEP_20260228.md | data/ablation_full6step_20260228/ |
| no_planner | ABLATION_RESULTS_NO_PLANNER_20260228.md | data/ablation_no_planner_20260228/ |
| no_refiner | ABLATION_RESULTS_NO_REFINER_20260228.md | data/ablation_no_refiner_20260228/ |
| baseline_4step | ABLATION_RESULTS_BASELINE_4STEP_20260301.md | data/ablation_baseline_4step_20260301/ |

---

## 5. Lưu ý

- Kết quả trên mẫu 50 câu stratified; ablation trên 1034 câu là công việc tương lai.
- Tất cả variants dùng cùng model (gemini-2.5-flash) để đảm bảo fair comparison.
- Pipeline gốc (1034 câu) dùng multi-model (Claude + GPT-4o + Gemini); ablation dùng single-model.
