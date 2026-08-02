# Plan bổ sung thí nghiệm (full Spider-dev 1.034 câu)

Mục tiêu: bổ sung số liệu còn thiếu sau đánh giá chuyên gia, để hoàn thiện bảng ablation model-assignment và giảm confound backbone 4-step vs 6-step trong `Springer_Nature_LaTeX_Template/Paper.tex`.

**Protocol chung (bắt buộc giữ giống run locked hiện tại):**
- Dataset: Spider 1.0 development set, **đủ 1.034 câu**
- `temperature = 0`
- Đánh giá: official Spider script (`EM` / `EX` trên SQLite)
- Không scale từ subset 50 câu; chỉ báo số đo trực tiếp trên full-dev

**Đã có sẵn — không cần chạy lại:**
- Mixed 6-step: EM 77.8% / EX 85.6%
- 4-step baseline (Analyzer = Claude Sonnet 4): EM 73.7% / EX 81.2%

---

## A. Task 1 — Homogeneous model assignment (6-step)

Toàn bộ dùng **pipeline 6-step**; chỉ đổi model assignment (mọi agent cùng một model).

| ID | Cấu hình | Assignment | Mục đích |
|----|----------|------------|----------|
| A1 | all Gemini 2.5 Flash | 6 agent = Gemini 2.5 Flash | Ablation homogeneous |
| A2 | all GPT-4o | 6 agent = GPT-4o | Ablation + hỗ trợ bounding confound |
| A3 | all Claude Sonnet 4 | 6 agent = Claude Sonnet 4 | Ablation homogeneous |
| A4 | all Claude Opus 4 | 6 agent = Claude Opus 4 | Ablation homogeneous |

Kết quả dùng cho bảng `tab:modelablation` (EM / EX / latency; cost chỉ nếu có token log).

---

## B. Task 2 — Confound backbone (4-step)

| ID | Cấu hình | Assignment | Mục đích |
|----|----------|------------|----------|
| B1 | 4-step + GPT-4o Analyzer | Analyzer = **GPT-4o**; Schema Selector & Validator = Gemini 2.5 Flash; Generator = GPT-4o | Cô lập hiệu ứng Planner/Refiner (cùng backbone Analyzer với 6-step) |

Chỉ đổi Analyzer từ Claude Sonnet 4 → GPT-4o; các bước còn lại giữ như baseline 4-step hiện tại trong codebase.

---

## C. Logging bắt buộc kèm mỗi run

Với mỗi run A1–A4 và B1, ghi lại:
- EM (%), EX (%)
- Latency: p50 / p90 (hoặc thời gian trung bình / câu)
- Token count / câu (hoặc tổng input+output) nếu API trả về

Không có log token/latency thì **không** viết trong paper rằng số `tab:cost` được lấy từ các run 1.034 câu.

---

## D. Thứ tự ưu tiên nếu thiếu thời gian / chi phí

1. **A2** (all GPT-4o 6-step) + **B1** (4-step GPT-4o Analyzer) — ưu tiên cao nhất
2. **A1** (all Gemini Flash)
3. **A3** (all Sonnet 4), **A4** (all Opus 4)

Tối thiểu đầy đủ claim trong draft hiện tại: **5 run** = A1 + A2 + A3 + A4 + B1.

---

## E. Sau khi có số liệu

1. Thêm bảng `tab:modelablation` vào paper; sửa đoạn “homogeneous were less favorable” thành trỏ vào bảng số.
2. Nếu có B1: thêm dòng vào `tab:main` / thảo luận; cập nhật Limitations (bỏ hoặc thu hẹp “Priority follow-up experiment”).
3. Nếu không có A1–A4 đầy đủ: **không** bịa/scale từ 50 câu; hạ claim định tính trong paper.
4. Tiếp tục các mục không phụ thuộc số liệu trong plan khắc phục tồn đọng: provenance `tab:cost`, giải thích Extra Hard, dọn preamble.

Tham chiếu: [khắc_phục_tồn_đọng_đánh_giá_1f3c5e1e.plan.md](khắc_phục_tồn_đọng_đánh_giá_1f3c5e1e.plan.md)
