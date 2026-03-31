# Project: Luận văn Tốt nghiệp - NL2SQL Multi-Agent System

## Quick Start (AI Agent)

**QUAN TRỌNG**: Trước khi bắt đầu bất kỳ task nào:
1. Đọc `MEMORY.md` để biết trạng thái hiện tại
2. Đọc `PROJECT_CONTEXT.md` để hiểu chi tiết dự án (nếu cần context sâu hơn)

---

## Overview

Dự án nghiên cứu hệ thống **NL2SQL đa tác nhân (Multi-Agent)** sử dụng CrewAI. Với bản conference hiện tại, các mốc chính đã khóa là:
- **6 bước (main conference variant: Flash/GPT-4o)**: EX=85.6%, EM=77.8% (Spider 1.0 dev, full 1,034 câu)
- **4 bước (baseline)**: EX=81.2%, EM=73.7% (Spider 1.0 dev, full 1,034 câu)
- **Biến thể DeepSeek-R1**: chỉ giữ như thử nghiệm thăm dò, không phải cấu hình chính để viết paper

Benchmark: Spider 1.0 dev set (1.034 câu hỏi)

---

## Project Structure

```
src/
├── nl2sql_6step/          # Pipeline 6 bước (MAIN)
│   └── nl2sql_flow/
│       ├── main.py        # Entry point
│       └── crews/nl2sql_crew/config/
│           ├── agents.yaml  # ⭐ Agent definitions
│           └── tasks.yaml   # ⭐ Task prompts
└── nl2sql_4step/          # Pipeline 4 bước (baseline)

ReadMe.md                      # ⭐ Báo cáo & Kế hoạch chính (MAIN)
PROJECT_CONTEXT.md             # Chi tiết dự án
MEMORY.md                      # Trạng thái làm việc
```

---

## Key Files

| File | Mục đích |
|------|----------|
| `ReadMe.md` | Báo cáo tổng hợp & Kế hoạch công bố |
| `complete_paper_combined_vi.md` | Bản thảo bài báo chính (Việt) |
| `src/nl2sql_6step/.../agents.yaml` | Định nghĩa 6 agents với LLM |
| `src/nl2sql_6step/.../tasks.yaml` | Prompts và pattern rules |

---

## LLM Configuration

| Agent | Model | Role |
|-------|-------|------|
| Question Analyzer | Gemini 2.5 Flash | Phân tích ý định |
| Schema Selector | Gemini 2.5 Flash | Lọc schema |
| Query Planner | Gemini 2.5 Flash | Lập kế hoạch |
| SQL Expert | GPT-4o | Sinh SQL |
| SQL Refiner | Gemini 2.5 Flash | Tinh chỉnh |
| SQL Validator | Gemini 2.5 Flash | Kiểm tra |

---

## Guidelines

### Ngôn ngữ
- **Code/Comments**: Tiếng Anh
- **Tài liệu/Bài báo**: Tiếng Việt học thuật
- **Giao tiếp với user**: Tiếng Việt

### Văn phong Học thuật
- Ngôi thứ ba: "Nghiên cứu này đề xuất..."
- Thuật ngữ: NL2SQL, Agent/Tác nhân, Pipeline/Chuỗi xử lý
- Tránh: "có thể thấy rằng", "một cách rõ ràng"

### Vibe Coding
- Ưu tiên hiệu quả, súc tích
- Tránh giải thích thừa thãi
- Đi thẳng vào vấn đề

---

## Essential Commands

```bash
# Kích hoạt môi trường
source venv/bin/activate

# Chạy pipeline
python run_complete_nl2sql_pipeline.py

# CrewAI (từ nl2sql_6step)
cd src/nl2sql_6step && crewai run

# Đánh giá
cd experiments/test-suite-sql-eval
python evaluation.py --gold gold.sql --pred predict.sql --etype exec

# Test
pytest test/
```

---

## Known Issues (Cần khắc phục)

1. **JOIN thừa**: Thêm bảng không cần thiết
2. **GROUP BY sai**: Nhóm theo Name thay vì ID
3. **COUNT vs COUNT(DISTINCT)**: Dùng sai
4. **IN vs OR**: Pattern recognition chưa tốt

---

## Memory Protocol

- **Bắt đầu session**: Đọc `MEMORY.md` trước
- **Sau task lớn**: Cập nhật `MEMORY.md`
- **Quyết định quan trọng**: Ghi chú ngay vào `MEMORY.md`
