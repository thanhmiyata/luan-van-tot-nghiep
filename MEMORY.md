# Project Memory - Last Updated: 2026-02-17

## Trạng thái hiện tại

- **Vừa hoàn thành**: NL2SQL-Bench Framework đã được implement hoàn chỉnh
- **Đang thực hiện**: Tinh chỉnh bài báo hội nghị (`conference_paper_vn_22-25p.md`)
- **Phiên làm việc gần nhất**: Implement NL2SQL-Bench evaluation framework

## Tóm tắt Kết quả Chính

| Cấu hình | Exact Match | Execution Accuracy |
|----------|-------------|-------------------|
| 4 bước (baseline) | 71.2% | 79.5% |
| 6 bước (đầy đủ) | 76.8% | 84.0% |

Benchmark: Spider 1.0 dev set (1.034 câu hỏi)

## Kiến trúc Đã Xác nhận

### Pipeline 6 bước
1. **Question Analyzer** (Claude 3.7 Sonnet) → Intent, expected_output_fields
2. **Schema Selector** (Gemini 2.0 Flash) → Lọc schema
3. **Query Planner** (Claude 3.7 Sonnet) → Kế hoạch logic
4. **SQL Expert** (GPT-4o) → Sinh SQL sơ bộ
5. **SQL Refiner** (Claude 3.7 Sonnet) → Tinh chỉnh
6. **SQL Validator** (Gemini 2.0 Flash) → Kiểm tra

### Pipeline 4 bước (baseline)
Bỏ bước 3 (Planner) và 5 (Refiner)

## Vấn đề Tồn tại

Từ `evaluation_logs/pattern_recognition_evaluation_report.md`:
1. **JOIN thừa** - Agent thêm bảng không cần thiết (7/20 lỗi)
2. **GROUP BY sai cột** - Nhóm theo Name thay vì ID (4/20 lỗi)
3. **COUNT vs COUNT(DISTINCT)** - Chọn sai aggregation (2/20 lỗi)
4. **IN vs OR pattern** - Chưa nhận diện đúng (1/20 lỗi)

## Kế hoạch Tiếp theo

1. [ ] Hoàn thiện Mục 5 (Phân tích lỗi) trong bài báo
2. [ ] Cải thiện Agent "SQL Refiner" để xử lý JOIN thừa
3. [ ] Cải thiện Agent "SQL Validator" để phát hiện GROUP BY sai
4. [ ] Rà soát Bảng 1 và Bảng 6 trong bài báo

## Ghi chú Quan trọng

- File pattern recognition đã cập nhật trong `tasks.yaml`
- `expected_output_fields` đóng vai trò "hợp đồng" giữa các agents
- Ưu tiên: Claude cho suy luận, Gemini cho trích xuất/kiểm tra

## Files Đã Tạo/Cập nhật Gần đây

### NL2SQL-Bench Framework (MỚI - 2026-02-17)
Đường dẫn: `nl2sql-bench/`

```
nl2sql-bench/
├── nl2sql_bench/
│   ├── core/base.py           # NL2SQLSystem, Input, Output interfaces
│   ├── core/evaluator.py      # Evaluator class với EM/EX metrics
│   ├── datasets/spider.py     # Spider dataset loader
│   ├── metrics/exact_match.py # Exact Match implementation
│   ├── metrics/execution.py   # Execution Accuracy implementation
│   ├── analysis/error_taxonomy.py  # Error classification (11 categories)
│   ├── analysis/reporter.py   # JSON/CLI/Markdown report generators
│   ├── baselines/multi_agent_6step.py  # Wrapper cho pipeline 6 bước
│   └── cli.py                 # Command-line interface
├── examples/
│   ├── simple_llm_system.py   # Ví dụ hệ thống đơn giản
│   └── evaluate_baseline.py   # Đánh giá baseline
├── tests/test_evaluator.py    # Unit tests (~30 test cases)
├── .github/workflows/         # CI/CD cho PyPI publishing
├── pyproject.toml, README.md, LICENSE
```

### Project Documentation (trước đó)
- `PROJECT_CONTEXT.md` - Chi tiết toàn diện về dự án (210+ dòng)
- `CLAUDE.md` - Cập nhật với thông tin mới và súc tích hơn
- `.cursor/rules/` - Cursor AI rules:
  - `project-context.mdc` - Core context (alwaysApply)
  - `academic-writing.mdc` - Văn phong học thuật (*.md)
  - `crewai-agents.mdc` - Agent config patterns (agents.yaml, tasks.yaml)
  - `python-crewai.mdc` - Python coding standards (*.py)

## Thay đổi Lịch sử

- **2026-02-17**: Implement NL2SQL-Bench Framework hoàn chỉnh (24 files, 5 phases)
- **2026-02-17**: Scan và tổ chức lại thông tin dự án, tạo PROJECT_CONTEXT.md
- **2026-01-20**: Cập nhật kết quả Spider 1.0 (EX: 84.1%, EM: 76.8%)
- **2025-12-24**: Báo cáo Pattern Recognition trên hospital_1
