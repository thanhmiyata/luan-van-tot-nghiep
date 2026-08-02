# Hướng dẫn chạy benchmark Dr.Spider

Tài liệu này hướng dẫn chạy và so sánh pipeline NL2SQL 4 bước với 6 bước
trên Dr.Spider bằng terminal tích hợp trong Cursor.

> **Lưu ý chi phí:** Smoke test và full benchmark gọi API trả phí. Hãy chạy
> kiểm thử offline và model preflight trước, sau đó thử 34 câu trước khi chạy
> toàn bộ 340 câu. Preflight chỉ gọi endpoint danh sách model, không chạy inference.

## 1. Mở dự án trong Cursor

Mở thư mục:

```text
/Users/Krizpham/Thac si/Luận văn tốt nghiệp
```

Trong Cursor, chọn **Terminal → New Terminal**, sau đó chạy:

```bash
cd "/Users/Krizpham/Thac si/Luận văn tốt nghiệp"
source venv/bin/activate
```

Kiểm tra Python đang sử dụng:

```bash
which python
python --version
```

Đường dẫn Python cần trỏ vào thư mục `venv` của dự án.

## 2. Kiểm tra root `.env`

Hệ thống tự động đọc file `.env` ở root:

```text
/Users/Krizpham/Thac si/Luận văn tốt nghiệp/.env
```

File cần có các API key sau:

```dotenv
OPENAI_API_KEY=...
GEMINI_API_KEY=...
ANTHROPIC_API_KEY=...
DEEPSEEK_API_KEY=...
```

Không cần tạo `.env` trong `src/nl2sql_4step` hoặc `src/nl2sql_6step`.
Không commit hoặc gửi nội dung API key lên Git.

Có thể kiểm tra tên biến đã được khai báo mà không in giá trị:

```bash
python -c "import os; from dotenv import load_dotenv; load_dotenv('.env'); print({k: bool(os.getenv(k)) for k in ['OPENAI_API_KEY','GEMINI_API_KEY','ANTHROPIC_API_KEY','DEEPSEEK_API_KEY']})"
```

Kết quả mong đợi:

```text
{'OPENAI_API_KEY': True, 'GEMINI_API_KEY': True, 'ANTHROPIC_API_KEY': True, 'DEEPSEEK_API_KEY': True}
```

## 3. Chạy kiểm thử offline

Bước này không gọi API và không tốn chi phí:

```bash
python -m pytest -q test
```

Kết quả mong đợi:

```text
... passed
```

Nếu bước này thất bại, không nên chạy benchmark trả phí trước khi sửa lỗi.

## 4. Chạy smoke test 34 câu

Lần chạy đầu tiên nên dùng 34 câu để kiểm tra pipeline, trace và chi phí:

```bash
python scripts/smoke_test_drspider30.py \
  --pipeline both \
  --num_questions 34 \
  --output-dir output/drspider_smoke34_guarded_v2 \
  --fresh
```

Ý nghĩa tham số:

- `--pipeline both`: chạy cả 4 bước và 6 bước trong hai process độc lập.
- `--num_questions 34`: lấy mẫu 34 câu từ Dr.Spider.
- `--output-dir`: thư mục mới để giữ nguyên kết quả benchmark cũ.
- `--fresh`: xóa output cũ trong đúng thư mục trên và chạy lại từ đầu.

Trước khi chạy câu đầu tiên, runner kiểm tra model Refiner có thực sự khả dụng
với API key hiện tại. Nếu model sai hoặc key không có quyền, chương trình dừng
trước khi tốn inference token.

Không đóng terminal khi chương trình đang chạy. Trong trace, pipeline 6 bước
phải có đủ các phase logic sau:

```text
question_analysis
schema_selector
query_planning
generate_sql_direct
generate_sql_planned
refine_sql
validate_sql
```

`query_planning`, `generate_sql_planned`, `refine_sql` hoặc `validate_sql` có thể
được đánh dấu `skipped`. Đây là adaptive routing bình thường:

- Câu đơn giản dùng nhánh direct.
- Câu cấu trúc khó dùng thêm Planner và planned candidate độc lập.
- Refiner chỉ chạy khi hai candidate bất đồng hoặc audit phát hiện vi phạm.
- Validator chỉ chạy khi candidate được chọn chưa đạt audit.

Benchmark luôn bật strict mode. Nếu một bước bắt buộc lỗi, runner lưu
`qNNNN.error.json` rồi dừng; không ghi `SELECT 1` làm sai lệch EX.

## 5. Đọc kết quả smoke test

Kết quả so sánh tổng hợp:

```text
output/drspider_smoke34_guarded_v2/smoke_summary_all.json
```

Kết quả riêng của từng pipeline:

```text
output/drspider_smoke34_guarded_v2/4step/smoke_summary.json
output/drspider_smoke34_guarded_v2/6step/smoke_summary.json
```

Raw response và trace từng câu:

```text
output/drspider_smoke34_guarded_v2/4step/raw_responses/
output/drspider_smoke34_guarded_v2/6step/raw_responses/
```

Có thể xem nhanh file tổng hợp trong terminal:

```bash
python -m json.tool output/drspider_smoke34_guarded_v2/smoke_summary_all.json
```

Các chỉ số cần so sánh:

- EX overall của 6-step và 4-step.
- EX của nhóm `DB`, `NLQ` và `SQL`.
- EX theo `easy`, `medium`, `hard`, `extra`.
- `paired.six_step_only` so với `paired.four_step_only`.
- `paired.six_minus_four_ex_points` và `paired.mcnemar_exact_p`.
- Số API call, retry, timeout và lỗi parse.
- Những câu 4-step đúng nhưng 6-step sai để phân tích hồi quy.

Không kết luận từ EM đã chỉnh tay; giai đoạn này ưu tiên EX của Dr.Spider.

## 6. Tiếp tục smoke test nếu bị gián đoạn

Giữ nguyên output directory và dùng `--no-fresh`:

```bash
python scripts/smoke_test_drspider30.py \
  --pipeline both \
  --num_questions 34 \
  --output-dir output/drspider_smoke34_guarded_v2 \
  --no-fresh
```

Cache chỉ được tái sử dụng khi câu hỏi, code, prompt và cấu hình model có cùng
chữ ký. Nếu code hoặc prompt đã thay đổi, runner sẽ tự bỏ qua cache không tương thích.

## 7. Chạy toàn bộ Dr.Spider-340

Chỉ chạy bước này sau khi smoke test 34 câu hoàn thành ổn định:

```bash
python scripts/smoke_test_drspider30.py \
  --pipeline both \
  --all \
  --output-dir output/drspider340_guarded_v2 \
  --fresh
```

Nếu bị gián đoạn:

```bash
python scripts/smoke_test_drspider30.py \
  --pipeline both \
  --all \
  --output-dir output/drspider340_guarded_v2 \
  --no-fresh
```

Kết quả tổng hợp:

```text
output/drspider340_guarded_v2/smoke_summary_all.json
```

## 8. Chạy riêng một pipeline

Chỉ chạy 6 bước:

```bash
python scripts/smoke_test_drspider30.py \
  --pipeline 6step \
  --num_questions 34 \
  --output-dir output/drspider_smoke34_6step \
  --fresh
```

Chỉ chạy 4 bước:

```bash
python scripts/smoke_test_drspider30.py \
  --pipeline 4step \
  --num_questions 34 \
  --output-dir output/drspider_smoke34_4step \
  --fresh
```

Để so sánh chính thức, nên dùng `--pipeline both` vì hai pipeline sẽ dùng cùng
sample manifest.

## 9. Cấu hình model mặc định

Pipeline 6 bước hiện dùng (budget: không Opus / GPT-5.x):

| Agent | Model mặc định | Chính sách gọi |
|---|---|---|
| Question Analyzer | GPT-4o | Bắt buộc; fallback Gemini Flash |
| Schema Selector | Gemini 2.5 Flash | Bắt buộc |
| Query Planner | Gemini 2.5 Flash | Extended route (rủi ro cấu trúc/lexical) |
| Direct SQL Expert | GPT-4o | Bắt buộc |
| Planned SQL Expert | Gemini 2.5 Flash | Extended route |
| SQL Refiner | Gemini 2.5 Flash | Khi candidate bất đồng / audit-risk |
| SQL Validator | Gemini 2.5 Flash | Khi audit/risk còn lại |

Chỉ thêm các biến sau vào root `.env` khi muốn override:

```dotenv
NL2SQL_QUESTION_ANALYZER_MODEL=openai/gpt-4o
NL2SQL_SCHEMA_SELECTOR_MODEL=gemini/gemini-flash-latest
NL2SQL_QUERY_PLANNER_MODEL=gemini/gemini-flash-latest
NL2SQL_SQL_EXPERT_MODEL=openai/gpt-4o
NL2SQL_DIRECT_SQL_MODEL=openai/gpt-4o
NL2SQL_PLANNED_SQL_MODEL=gemini/gemini-flash-latest
NL2SQL_SQL_REFINER_MODEL=gemini/gemini-flash-latest
NL2SQL_SQL_VALIDATOR_MODEL=gemini/gemini-flash-latest

NL2SQL_ENABLE_MODEL_FALLBACKS=false
NL2SQL_QUESTION_ANALYZER_FALLBACK_MODEL=gemini/gemini-flash-latest
NL2SQL_QUERY_PLANNER_FALLBACK_MODEL=gemini/gemini-flash-latest
NL2SQL_PLANNED_SQL_FALLBACK_MODEL=gemini/gemini-flash-latest
NL2SQL_SQL_REFINER_FALLBACK_MODEL=gemini/gemini-flash-latest
NL2SQL_REFINER_ON_RISK_ONLY=false
NL2SQL_SCHEMA_FILTER_MODE=safe_superset
```

Không cần khai báo các biến model trên nếu muốn dùng cấu hình mặc định trong code.
Các fallback của Flow được ghi thành API attempt riêng trong trace. Giữ
`NL2SQL_ENABLE_MODEL_FALLBACKS=false` để không tạo fallback lồng ẩn và không
làm sai thống kê số request/model thực tế.

Có thể chạy riêng preflight, không inference:

```bash
python -c "import run_complete_nl2sql_pipeline as p; p.configure_pipeline('6step'); p.preflight_configured_refiner()"
```

## 10. Xử lý lỗi thường gặp

### Thiếu package

```bash
python -m pip install -r requirements.txt
```

### API key không được nhận

Kiểm tra đang chạy lệnh từ root dự án và `.env` nằm đúng root. Sau khi sửa
`.env`, dừng tiến trình cũ rồi chạy lại lệnh benchmark.

### HTTP 401 hoặc authentication error

API key của provider tương ứng không hợp lệ, hết hạn hoặc không có credit.

### HTTP 429

Provider giới hạn tốc độ hoặc tài khoản hết quota. Chờ rồi chạy lại bằng
`--no-fresh` để tiếp tục từ cache hợp lệ.

### Model preflight thất bại

Kiểm tra `ANTHROPIC_API_KEY` và `NL2SQL_SQL_REFINER_MODEL`. Không dùng lại ID cũ
`claude-sonnet-4-20250514`. Chỉ đặt biến dưới đây khi dùng gateway tương thích
không hỗ trợ endpoint `/v1/models`:

```dotenv
NL2SQL_SKIP_MODEL_PREFLIGHT=true
```

Không nên tắt preflight khi benchmark trực tiếp qua Anthropic.

### Timeout

Có thể tăng trong root `.env`:

```dotenv
NL2SQL_STEP_MAX_RETRIES=1
NL2SQL_QUESTION_ANALYZER_TIMEOUT_SECONDS=35
NL2SQL_QUERY_PLANNER_TIMEOUT_SECONDS=30
NL2SQL_SQL_EXPERT_TIMEOUT_SECONDS=25
NL2SQL_SQL_REFINER_TIMEOUT_SECONDS=35
NL2SQL_SQL_VALIDATOR_TIMEOUT_SECONDS=25
```

Timeout được áp dụng trực tiếp tại provider; hệ thống không dùng thread timeout
vì không thể hủy request HTTP đang chạy. Giữ một attempt để tránh nhân đôi chi
phí. Analyzer/Planner/Planned SQL/Refiner đã có fallback model riêng và được ghi
trace. Sau khi thay đổi timeout, chạy lại bằng `--no-fresh`;
chữ ký cấu hình thay đổi nên cache không tương thích sẽ được chạy lại.

### Muốn chạy lại hoàn toàn

Dùng `--fresh` với một output directory cụ thể. Không xóa toàn bộ thư mục
`output` của dự án.

## 11. Trình tự khuyến nghị

```text
Offline tests
    ↓
Dr.Spider 34 câu
    ↓
Kiểm tra summary + raw traces
    ↓
Dr.Spider-340
    ↓
Chỉ khi kết quả ổn định mới mở rộng lên khoảng 1.500 câu
```
