# Project Memory - Last Updated: 2026-02-28

## Trạng thái hiện tại

- **Vừa hoàn thành**: Ablation study 4 variants hoàn tất
- **Đang thực hiện**: Chuẩn bị bài báo SN Computer Science (PLAN_SN_CS_SUBMISSION.md)
- **Kết quả tổng hợp**: ABLATION_SUMMARY_20260228.md

## Tóm tắt Kết quả Chính

### Spider 1.0 full (1.034 câu)
| Cấu hình | Exact Match | Execution Accuracy |
|----------|-------------|-------------------|
| 4 bước (baseline) | 71.2% | 79.5% |
| 6 bước (đầy đủ) | 76.8% | 84.0% |

### Ablation Study (50 câu stratified, gemini-2.5-flash)
| Variant | EX | EM | Δ EX | Δ EM |
|---------|-----|-----|------|------|
| full_6step | 90.0% | 68.0% | — | — |
| no_planner | 86.0% | 58.0% | -4.0 | -10.0 |
| no_refiner | 84.0% | 62.0% | -6.0 | -6.0 |
| baseline_4step | 78.0% | 44.0% | -12.0 | -24.0 |

## Kiến trúc Đã Xác nhận

### Pipeline 6 bước
1. **Question Analyzer** (Claude 4.0 Sonnet) → Intent, expected_output_fields
2. **Schema Selector** (Gemini 2.5 Flash) → Lọc schema
3. **Query Planner** (Claude 4.0 Sonnet) → Kế hoạch logic
4. **SQL Expert** (GPT-4o) → Sinh SQL sơ bộ
5. **SQL Refiner** (Claude 4.0 Sonnet) → Tinh chỉnh
6. **SQL Validator** (Gemini 2.5 Flash) → Kiểm tra

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

- **2026-03-01**: Ablation baseline_4step xong (EX 78%, EM 44%); 4/4 variants hoàn tất
- **2026-02-28**: Ablation no_refiner xong (EX 84%, EM 62%); tạo ABLATION_SUMMARY_20260228.md
- **2026-02-28**: Ablation no_planner xong (EX 86%, EM 58%); tạo ABLATION_RESULTS_NO_PLANNER_20260228.md, data/ablation_no_planner_20260228/
- **2026-02-28**: Ablation full_6step xong (EX 90%, EM 68%)
- **2026-02-17**: Implement NL2SQL-Bench Framework hoàn chỉnh (24 files, 5 phases)
- **2026-02-17**: Scan và tổ chức lại thông tin dự án, tạo PROJECT_CONTEXT.md
- **2026-01-20**: Cập nhật kết quả Spider 1.0 (EX: 84.1%, EM: 76.8%)
- **2025-12-24**: Báo cáo Pattern Recognition trên hospital_1
