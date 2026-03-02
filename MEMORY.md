# Project Memory - Last Updated: 2026-03-02

## Trạng thái hiện tại

- **Vừa hoàn thành**: Tích hợp và đánh giá thành công **DeepSeek-R1 (Reasoner)** vào Pipeline 6 bước.
- **Kết quả tổng hợp**: Toàn bộ kết quả thực nghiệm và kế hoạch nộp bài được hợp nhất tại `ReadMe.md`.
- **Đang thực hiện**: Chuẩn bị bản thảo cho tạp chí **SN Computer Science (Springer)** và hội nghị **SEKE 2026**.

## Tóm tắt Kết quả Chính (DeepSeek-R1 Upgrade)

### Thử nghiệm trên 50 câu (Stratified - 02/03/2026)
| Cấu hình | Executive Accuracy (EX) | Exact Match (EM) | Đặc điểm |
|----------|:----------------------:|:----------------:|----------|
| **6 bước (DeepSeek-R1)** | **85.0%** | **40.0%** | Suy luận cực mạnh, xử lý câu Hard xuất sắc. |
| **6 bước (Gemini Flash)** | 90.0% | 68.0% | Ổn định, EM cao, tốc độ nhanh. |
| **4 bước (Baseline)** | 78.0% | 44.0% | Yếu ở các câu hỏi phức tạp. |

> [!IMPORTANT]
> **Điểm đột phá**: DeepSeek-R1 đạt tỉ lệ **EX 100% cho các câu hỏi mức độ Hard**. Tuy nhiên, tỉ lệ Exact Match thấp hơn do model có xu hướng viết SQL linh hoạt (khác cấu trúc đáp án mẫu).

## Kiến trúc Đã Xác nhận (Cập nhật 2026-03-02)

### Hybrid Reasoning Strategy
1. **Question Analyzer** (DeepSeek-R1) → Semantic parsing & Expected Fields.
2. **Schema Selector** (Gemini 2.5 Flash) → Lọc schema tối giản.
3. **Query Planner** (DeepSeek-R1) → Lập kế hoạch logic (Thought chain).
4. **SQL Expert** (GPT-4o) → Viết SQL từ kế hoạch.
5. **SQL Refiner** (DeepSeek-R1) → Đối soát và sửa lỗi logic.
6. **SQL Validator** (Gemini 2.5 Flash) → Kiểm tra cú pháp kỹ thuật.

## Vấn đề Mới Phát hiện
- **Lỗi Parse JSON (DeepSeek-R1)**: Do model sinh ra các tag `<thought>` hoặc đoạn giải thích dài dòng làm hỏng cấu trúc JSON trả về. Cần hậu xử lý bằng Regex hoặc Prompting nghiêm ngặt hơn.

## Kế hoạch Tiếp theo (Submission Pipeline)

1. [ ] **SEKE 2026**: Deadline 01/05/2026 (Hội nghị Q2/Q3).
2. [ ] **SN Computer Science**: Tạp chí Q3 (Springer), APC $0.
3. [ ] Chuyển đổi toàn bộ Mermaid Diagrams sang định dạng hình ảnh PNG/EPS.

## Files Đã Tạo/Cập nhật Gần đây

- `ReadMe.md` - **Entry point chính**, chứa báo cáo tổng hợp và kế hoạch nộp bài.
- `complete_paper_combined_vi.md` - Bản thảo bài báo tiếng Việt hoàn chỉnh.
- `PROJECT_CONTEXT.md` - Cập nhật kiến trúc DeepSeek-R1.

## Thay đổi Lịch sử

- **2026-03-02**: Tích hợp DeepSeek-R1; EX 85%; EM 40%. Hợp nhất báo cáo vào `ReadMe.md`.
- **2026-03-01**: Ablation baseline_4step xong (EX 78%, EM 44%); 4/4 variants hoàn tất.
- **2026-02-28**: Ablation no_refiner/no_planner hoàn tất.
- **2026-01-20**: Cập nhật kết quả Spider 1.0 (EX: 84.1%, EM: 76.8%).
