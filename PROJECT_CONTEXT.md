# PROJECT CONTEXT - NL2SQL Multi-Agent System

> **Mục đích**: File này chứa toàn bộ thông tin cần thiết để AI có thể hiểu nhanh dự án mà không cần scan lại toàn bộ.
> **Cập nhật lần cuối**: 2026-02-17

---

## 1. Tổng quan Dự án

### 1.1 Mục tiêu
Nghiên cứu và phát triển hệ thống **NL2SQL đa tác nhân (Multi-Agent)** để chuyển đổi câu hỏi ngôn ngữ tự nhiên thành truy vấn SQL. Tập trung vào việc so sánh và đánh giá vai trò của từng thành phần trong pipeline thông qua thiết kế mô-đun hóa.

### 1.2 Kết quả chính
- **Cấu hình 6 bước**: EX=84.0%, EM=76.8% trên Spider 1.0 (1.034 câu hỏi)
- **Cấu hình 4 bước (baseline)**: EX=79.5%, EM=71.2%
- **Cải thiện**: +4.5% EX, +5.6% EM nhờ thêm bước Lập kế hoạch và Tinh chỉnh

### 1.3 Đóng góp khoa học
- **C1 (Khung)**: Khung NL2SQL đa tác nhân mô-đun hóa 3 pha
- **C2 (Đánh giá)**: So sánh cấu hình 4-bước vs 6-bước
- **C3 (Thực nghiệm)**: Bằng chứng thực nghiệm + phân loại lỗi chi tiết

---

## 2. Kiến trúc Hệ thống

### 2.1 Pipeline 6 bước (Cấu hình đầy đủ)

```
Pha 1: Phân tích & Liên kết lược đồ
  ├── [1] Question Analyzer (Claude 3.7 Sonnet)
  │       └── Trích xuất intent, expected_output_fields, constraints
  └── [2] Schema Selector (Gemini 2.0 Flash)
          └── Lọc bảng/cột, giữ PK/FK cần thiết

Pha 2: Lập kế hoạch & Sinh SQL  
  ├── [3] Query Planner (Claude 3.7 Sonnet)
  │       └── Tạo kế hoạch logic, xác định join path
  └── [4] SQL Expert (GPT-4o)
          └── Sinh SQL sơ bộ từ kế hoạch

Pha 3: Tinh chỉnh & Kiểm tra
  ├── [5] SQL Refiner (Claude 3.7 Sonnet)
  │       └── Đối soát SELECT với expected_output_fields
  └── [6] SQL Validator (Gemini 2.0 Flash)
          └── Kiểm tra cú pháp và tính hợp lệ kỹ thuật
```

### 2.2 Pipeline 4 bước (Cấu hình cơ sở)
Bỏ bước [3] Query Planner và [5] SQL Refiner

### 2.3 Hybrid LLM Strategy
| Agent | Model | Lý do |
|-------|-------|-------|
| Question Analyzer | Claude 3.7 Sonnet | Suy luận logic phức tạp |
| Schema Selector | Gemini 2.0 Flash | Trích xuất thông tin nhanh |
| Query Planner | Claude 3.7 Sonnet | Lập kế hoạch đa bước |
| SQL Expert | GPT-4o | Sinh code chính xác |
| SQL Refiner | Claude 3.7 Sonnet | Sửa lỗi logic |
| SQL Validator | Gemini 2.0 Flash | Kiểm tra kỹ thuật nhanh |

---

## 3. Cấu trúc Thư mục

```
/
├── src/
│   ├── nl2sql_6step/                    # Pipeline 6 bước (main)
│   │   ├── nl2sql_flow/
│   │   │   ├── main.py                  # Entry point + Flow definition
│   │   │   ├── crews/nl2sql_crew/
│   │   │   │   ├── config/
│   │   │   │   │   ├── agents.yaml      # ⭐ Định nghĩa agents + LLM
│   │   │   │   │   └── tasks.yaml       # ⭐ Định nghĩa tasks + prompts
│   │   │   │   └── nl2sql_crew.py       # Crew orchestration
│   │   │   └── tools/custom_tool.py
│   │   └── pyproject.toml
│   └── nl2sql_4step/                    # Pipeline 4 bước (baseline)
│       └── (cấu trúc tương tự)
│
├── experiments/
│   └── test-suite-sql-eval/             # Spider evaluation toolkit
│       ├── evaluation.py                # Script đánh giá
│       └── database/                    # SQLite databases
│
├── evaluation_logs/
│   ├── failure_analysis_spider1.csv     # Phân tích lỗi chi tiết
│   └── pattern_recognition_evaluation_report.md
│
├── output/
│   └── nl2sql_6step/
│       ├── predict.sql                  # SQL dự đoán
│       └── gold.sql                     # SQL chuẩn
│
├── Document/                            # Tài liệu nghiên cứu
│
├── conference_paper_vn_22-25p.md        # ⭐ Bài báo hội nghị (đang làm)
├── MEMORY.md                            # Trạng thái làm việc
├── CLAUDE.md                            # Quy tắc cho AI
├── PROJECT_CONTEXT.md                   # File này
└── run_complete_nl2sql_pipeline.py      # Script chạy pipeline
```

---

## 4. Các File Quan trọng

### 4.1 Code chính
- `src/nl2sql_6step/nl2sql_flow/crews/nl2sql_crew/config/agents.yaml`: Định nghĩa 6 agents với role, goal, backstory và LLM assignment
- `src/nl2sql_6step/nl2sql_flow/crews/nl2sql_crew/config/tasks.yaml`: Prompts chi tiết cho từng task với pattern recognition rules
- `src/nl2sql_6step/nl2sql_flow/main.py`: CrewAI Flow orchestration với Pydantic models

### 4.2 Tài liệu
- `conference_paper_vn_22-25p.md`: Bài báo hội nghị tiếng Việt (22-25 trang)
- `NL2SQL_Multi_Agent_Experiment_Plan.md`: Kế hoạch thực nghiệm chi tiết

### 4.3 Dữ liệu & Kết quả
- `output/nl2sql_6step/*.csv`: Kết quả chạy pipeline
- `evaluation_logs/failure_analysis_spider1.csv`: Phân tích từng câu lỗi

---

## 5. Các Vấn đề Đã Xác định

### 5.1 Lỗi thường gặp (từ báo cáo phân tích)
1. **JOIN thừa**: Thêm bảng không cần thiết vào truy vấn
2. **GROUP BY sai cột**: Nhóm theo Name thay vì ID/PK
3. **COUNT vs COUNT(DISTINCT)**: Dùng sai aggregation
4. **IN vs OR pattern**: Chưa nhận diện đúng khi nào dùng IN, khi nào dùng OR

### 5.2 Pattern Recognition Issues
- INTERSECT vs OR: "both 3 and 4" → INTERSECT, không phải OR
- Self-join detection: "directors with >1 movie" cần self-join
- NULL handling: String "null" vs SQL NULL

---

## 6. Lệnh Thường dùng

```bash
# Kích hoạt môi trường
source venv/bin/activate

# Chạy pipeline đầy đủ
python run_complete_nl2sql_pipeline.py

# Chạy CrewAI flow (từ thư mục nl2sql_6step)
cd src/nl2sql_6step && crewai run

# Đánh giá kết quả
cd experiments/test-suite-sql-eval
python evaluation.py --gold gold.sql --pred predict.sql --etype exec --db database/ --table tables.json

# Chạy tests
pytest test/
```

---

## 7. Công nghệ & Dependencies

### 7.1 Framework
- **CrewAI**: Multi-agent orchestration framework
- **Pydantic**: Data validation & state management
- **Spider Dataset**: Benchmark dataset (1.034 câu hỏi dev)

### 7.2 LLM APIs
- Google Gemini 2.0 Flash
- Anthropic Claude 3.7 Sonnet  
- OpenAI GPT-4o

### 7.3 Evaluation
- Spider test-suite-sql-eval (semantic evaluation)
- Metrics: Exact Match (EM), Execution Accuracy (EX)

---

## 8. Quy ước Code & Viết

### 8.1 Ngôn ngữ
- **Code/Comments**: Tiếng Anh
- **Tài liệu/Bài báo**: Tiếng Việt học thuật
- **Logs/Messages**: Có thể tiếng Việt

### 8.2 Văn phong học thuật
- Sử dụng ngôi thứ ba: "Nghiên cứu này đề xuất..." 
- Thuật ngữ: NL2SQL, Agent/Tác nhân, Pipeline/Chuỗi xử lý
- Tránh từ thừa: "có thể thấy rằng", "một cách rõ ràng"

### 8.3 Git Workflow
- Branch hiện tại: `option2`
- Commit message: Tiếng Việt hoặc Anh, súc tích

---

## 9. Trạng thái Hiện tại

Xem chi tiết trong `MEMORY.md`

---

## 10. Liên hệ & References

- Spider Dataset: https://yale-lily.github.io/spider
- CrewAI Docs: https://docs.crewai.com/
- Bài báo tham khảo: DIN-SQL, C3/DAIL-SQL, RAT-SQL
