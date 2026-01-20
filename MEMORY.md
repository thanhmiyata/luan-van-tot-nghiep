# Project Memory - Last Updated: 2026-01-20

## Trạng thái hiện tại
- Đang thực hiện: Tinh chỉnh bài báo hội nghị (`conference_paper_vn_22-25p.md`).
- Đã hoàn thành quét dự án:
    - Xác nhận cấu trúc `src/nl2sql_4step` và `src/nl2sql_6step` sử dụng CrewAI Flows.
    - Xác nhận hệ thống LLM hybrid: Gemini 2.0 Flash (Validator/Schema), Claude 3.7 Sonnet (Analyzer/Planner/Refiner), GPT-4o (Expert).
    - Đã đọc báo cáo đánh giá Pattern Recognition trên `hospital_1` (EX: 75%, EM: 45%).
    - Đã nắm rõ kết quả chính thức trên Spider 1.0 (EX: 84.1%, EM: 76.8%).

## Bối cảnh quan trọng
- **Cấu trúc 6 bước:** Analysis -> Schema Selection -> Planning -> Generation -> Refinement -> Validation.
- **Vấn đề tồn tại (từ báo cáo lỗi):** 
    1. JOIN thừa (redundant joins).
    2. GROUP BY trên display column (Name) thay vì PK (ID).
    3. Nhầm lẫn giữa COUNT(*) và COUNT(DISTINCT).
    4. Pattern IN vs OR chưa ổn định.
- **Tiêu chuẩn dữ liệu:** Sử dụng bộ Spider 1.0 (1.034 câu hỏi). Gemini 2.0 Flash là model nền cho các tác nhân kiểm tra.

## Kế hoạch tiếp theo
1. Tập trung vào mục 5 (Phân tích lỗi) trong bài báo: Sử dụng các lỗi thực tế từ `evaluation_logs/failure_analysis_spider1.csv` hoặc `pattern_recognition_evaluation_report.md` để minh họa.
2. Đề xuất cải thiện cho Agent "SQL Refiner" và "SQL Validator" để giải quyết vấn đề JOIN thừa và GROUP BY sai cột.
3. Rà soát lại bảng 1 và bảng 6 trong bài báo để đảm bảo khớp hoàn toàn với kết quả thực nghiệm mới nhất.

## Các vấn đề cần lưu ý
- Ưu tiên sử dụng `Claude 3.7 Sonnet` cho các task suy luận logic về SQL và `Gemini 2.0 Flash` cho việc trích xuất thông tin/kiểm tra.
- Luôn giữ văn phong học thuật Tiếng Việt huyên sâu.

