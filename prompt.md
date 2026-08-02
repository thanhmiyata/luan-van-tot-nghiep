# Bootstrap — phiên mới: ablation 5-stage FULL 1034 (API thật)

Copy khối dưới vào chat mới với Cursor agent.

---

## Prompt mở phiên (copy từ đây)

```text
Đọc MEMORY.md trước (mục đầu — quyết định 2026-07-30).

Nhiệm vụ: chạy THẬT LLM API ablation 5-stage trên toàn bộ Spider Dev 1034 câu, theo từng DB từ đầu → cuối, resume được. Không offline Antigravity, không chỉ sample-50.

QUAN TRỌNG — tiết kiệm chi phí/thời gian:
- TÁI SỬ DỤNG kết quả 4-step đã có (raw_responses), KHÔNG chạy lại Analyzer / Schema Selector / Direct SQL.
- Seed 3 bước đầu từ output/nl2sql_4step; CHỈ gọi LLM các bước còn thiếu của từng biến thể 5-stage.
- 4-step và 6-step overall đã khóa — KHÔNG rerun 1034 cho hai pipeline đó.

Giữ nguyên số khóa (không rerun):
- 4-step: EX=84.9 EM=57.4
- 6-step: EX=89.0 EM=75.0
Mục tiêu điền 2 hàng Table tab:main trong Paper.tex:
- 5-stage without Planner
- 5-stage without Refiner

Protocol (hybrid seed 4→5):
1) BẮT BUỘC seed Analyzer+Schema+Direct từ output/nl2sql_4step/raw_responses
   (NL2SQL_SEED_FROM_4STEP, NL2SQL_SEED_INCLUDE_DIRECT=1). Thiếu seed → báo lỗi, đừng silent full-rerun 6 bước.
2) no_planner: NL2SQL_SKIP_PLANNER=1 → chỉ LLM Refiner(nếu cần)+Validator
3) no_refiner: NL2SQL_SKIP_REFINER=1 → chỉ LLM Planner+Planned+Validator;
   khi skip Refiner ưu tiên giữ Direct nếu Direct pass audit
4) Output RIÊNG: output/ablation_full_seed4step/{no_planner,no_refiner}/
   — KHÔNG ghi đè output/nl2sql_{4,6}step
5) DB order = output/nl2sql_6step/benchmark_progress.json → db_order
   Bắt đầu world_1, rồi car_1, … hết 20 DB
6) Flags đã có trong src/nl2sql_6step/nl2sql_flow/main.py
   Script nền: scripts/run_ablation50_seed4step.py → mở rộng --db-id / runner full
7) Gemini 429/prepaid hết hoặc GPT-4o hết thì chuyển sang dùng model claude. Nếu claude cũng hết thì dừng và báo tôi
8) Sau mỗi DB: gold.sql + predict.sql + official eval; cuối aggregate 1034
9) Paper/caption nên ghi: 5-stage ablations reuse 4-step early-stage outputs (Analyzer/Schema/Direct) to isolate Planner/Refiner cost.

Việc ngay: (1) kiểm tra .env/credit (2) viết/chốt runner --db-id world_1
(3) chạy no_planner rồi no_refiner cho world_1, resume-safe, báo tiến độ + % câu seed thành công.
Trả lời tiếng Việt, ngắn.
```

---

## Checklist nhanh trước khi chạy

- [ ] `.env` có key; Gemini prepaid OK hoặc sẵn sàng GPT-4o override
- [ ] `venv` activate
- [ ] Không đụng predict đã khóa của 4/6-step
- [ ] Folder output ablation riêng
