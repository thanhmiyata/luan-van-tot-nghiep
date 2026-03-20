# Project Memory - Last Updated: 2026-03-02

## Trạng thái hiện tại

- **Vừa hoàn thành**: Tích hợp và đánh giá thành công **DeepSeek-R1 (Reasoner)** vào Pipeline 6 bước.
- **Kết quả tổng hợp**: Toàn bộ kết quả thực nghiệm và kế hoạch nộp bài được hợp nhất tại `ReadMe.md`.
- **Đang thực hiện**: Chuẩn bị bản thảo cho tạp chí **SN Computer Science (Springer)** và hội nghị **SEKE 2026**.
- **Mới cập nhật**: Tái cấu trúc `report/complete_paper_combined_vi.md` theo hướng reviewer-friendly cho paper NLP/AI conference: viết lại `Abstract`, tăng cường `Introduction`, mở rộng `Related Work`, bổ sung mô tả pipeline 6 bước bằng bảng và ASCII diagram, tổ chức lại khung mục thành `4. Thiết lập thực nghiệm` đến `10. Kết luận`, và đồng bộ lại định nghĩa **FSED**.
- **Mới cập nhật thêm**: Bổ sung `3.4 Implementation Details` trong phần phương pháp, thêm mô tả `Spider Dev Set` trên 20 databases, nêu rõ `official Spider evaluation script`, thay bảng baseline prompting theo định dạng `Single Prompt / Chain-of-Thought / 4-Step / 6-Step`, thêm `5.3 Error Analysis`, và đồng bộ `temperature = 0`.
- **Mới cập nhật thêm**: Sửa reviewer-sensitive issues trong bản thảo: chuẩn hóa thứ tự tác nhân thành `Analyzer → Schema → Planner → Generator → Refiner → Validator`, rút gọn mô tả `Refiner` theo hướng reasoning-based, làm rõ cách phát hiện lỗi cho chỉ số **FSED**, bổ sung `Spider 1.0 Dev Set`, thêm `4.4 Implementation`, và bổ sung thông tin tái lập như `model version`, `max_output_tokens`, `context window`, `prompt format`, `average schema size`.
- **Mới cập nhật thêm**: Đã dịch toàn bộ `report/complete_paper_combined_vi.md` sang tiếng Anh học thuật và ghi vào `report/complete_paper_combined.md`, giữ nguyên cấu trúc, bảng, trích dẫn, kết quả thực nghiệm và các placeholder.

## Tóm tắt Kết quả Chính (DeepSeek-R1 Upgrade)

### Thử nghiệm trên 50 câu (Stratified - 02/03/2026)
| Cấu hình | Executive Accuracy (EX) | Exact Match (EM) | Đặc điểm |
|----------|:----------------------:|:----------------:|----------|
| **6 bước (DeepSeek-R1)** | **85.0%** | **40.0%** | Suy luận cực mạnh, xử lý câu Hard xuất sắc. |
| **6 bước (Sonet 4.0)** | 90.0% | 68.0% | Ổn định, EM cao, tốc độ nhanh. |
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

- **2026-03-14**: Tái cấu trúc Mục 4 của bài báo theo chuẩn conference; thêm giải thích dùng Spider Dev Set, bảng baseline/ablation/model comparison/error analysis với placeholder rõ ràng, và chuẩn hóa FSED.
- **2026-03-14**: Tái cấu trúc toàn bộ bản thảo theo yêu cầu reviewer: viết lại Abstract/Introduction/Related Work/Conclusion, thêm bảng mô tả pipeline 6 bước, thêm baseline comparison với placeholder, chuyển ablation sang full dev set (placeholder), thêm implementation details và efficiency analysis.
- **2026-03-14**: Bổ sung vòng chỉnh sửa thứ hai theo reviewer: thêm subsection `3.4 Implementation Details`, thêm dataset/evaluation protocol chi tiết, thêm bảng `Comparison with prompting baselines`, thêm `5.3 Error Analysis`, và sửa mọi chỗ còn ghi `temperature = 0.3` thành `0`.
- **2026-03-14**: Bổ sung vòng chỉnh sửa thứ ba theo reviewer: sửa thứ tự Refiner/Validator, giảm tính rule-based ở phần Refiner, thêm mô tả phát hiện field error cho FSED, thêm PICARD vào Related Work, đổi wording thành "giảm gánh nặng nhận thức lên một mô hình đơn lẻ", và thêm các chi tiết reproducibility còn thiếu.
- **2026-03-14**: Dịch hoàn chỉnh bản thảo tiếng Việt sang tiếng Anh và lưu thành `report/complete_paper_combined.md`.
- **2026-03-02**: Tích hợp DeepSeek-R1; EX 85%; EM 40%. Hợp nhất báo cáo vào `ReadMe.md`.
- **2026-03-01**: Ablation baseline_4step xong (EX 78%, EM 44%); 4/4 variants hoàn tất.
- **2026-02-28**: Ablation no_refiner/no_planner hoàn tất.
- **2026-01-20**: Cập nhật kết quả Spider 1.0 (EX: 84.1%, EM: 76.8%).
