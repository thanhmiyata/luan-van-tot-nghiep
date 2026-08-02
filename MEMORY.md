# Project Memory - Last Updated: 2026-07-30

## Trạng thái hiện tại

- **2026-07-30 (ĐANG CHẠY — ablation 5-stage full 1034 API)**: Runner mới `scripts/run_ablation_full_seed4step.py` (seed bắt buộc từ 4-step, resume-safe, output `output/ablation_full_seed4step/`). GPT-4o primary + Claude fallback nếu hết credit. **Không** đụng locked 4/6-step.
  - **world_1 (120) DONE**:
    - `no_planner`: seed **100%**, EX=**75.0**, EM=**46.7** (~201s)
    - `no_refiner`: seed **100%**, EX=**73.3**, EM=**47.5** (~594s)
  - **car_1 (92) DONE**:
    - `no_planner`: seed **100%**, EX=**80.4**, EM=**35.9** (~261s) — vs locked 4-step 79.3 / 6-step 85.9
    - `no_refiner`: seed **100%**, EX=**78.3**, EM=**34.8** (~604s)
  - **2026-07-30 (smoke output2)**: `OUTPUT_BASE_DIR=output2`. Smoke `car_1` n=2 × 4 pipelines OK (exit 0): 4step EX0/EM0; without_planner EX100/EM0 (Planner skipped, no seed); without_refiner EX100/EM50 (Refiner skipped); 6step EX100/EM100. Logs: `output2/smoke_logs/`.

- **2026-07-30 (QUYẾT ĐỊNH — ablation 5-stage full 1034, chạy API thật)**: Bỏ hướng sample-50 / offline Antigravity role-play cho Table 3. **Phải chạy thật LLM API** 2 biến thể 5-stage trên **toàn bộ Spider Dev 1,034 câu**, theo DB từ đầu → cuối, resume được. Không dùng số ablation-50 để điền paper. 4-step / 6-step **giữ số đã khóa** (không cần rerun). Paper `tab:main` đang để `--` cho 5-stage.

- **Protocol ablation full**:
  1. `no_planner` / `no_refiner` với seed Analyzer+Schema+Direct từ `output/nl2sql_4step`
  2. Flags `NL2SQL_SKIP_PLANNER` / `NL2SQL_SKIP_REFINER`; thiếu seed → fail rõ
  3. Output: `output/ablation_full_seed4step/{no_planner,no_refiner}/`
  4. DB order: `world_1` → `car_1` → … (20 DB)
  5. Model: GPT-4o; hết credit → Claude; cả hai hết → dừng
  6. Paper note: 5-stage reuse 4-step early outputs để cô lập Planner/Refiner

- **ĐÃ LOẠI (không dùng cho paper)**:
  - Ablation-50: `output/ablation50_seed4step/` (EX~82–84, EM w/o Refiner thấp vì Planned thắng arbiter) — chỉ diagnostic
  - Offline Antigravity tự đóng vai agent — **rejected**
  - `prompt.md` offline role-play — superseded bởi quyết định full API 1034

- **2026-07-29 (ablation-50 seed 4-step, diagnostic only)**: n=50 seed42. w/o Planner EX=84.0 EM=58.0; w/o Refiner EX=82.0 EM=50.0; same50 4-step 84.0/60.0; 6-step 84.0/76.0. Script: `scripts/run_ablation50_seed4step.py`.

- **2026-07-27 (publish/ code-only)**: `publish/` (~1.5MB) code-only cho GitHub. Không raw/paper/MEMORY/`.env`.

- **2026-07-27 (raw↔predict sync)**: `raw_responses` 6-step `final_sql` khớp `per_db/predict.sql` (1034/1034). Summary: `output/nl2sql_6step/raw_predict_sync_summary.json`.

- **2026-07-27 (LOCKED rebenchmark Spider 1.0 full_dev)**: **6-step EX=89.0% / EM=75.0%**; **4-step EX=84.9% / EM=57.4%** (ΔEX **+4.1pp**, ΔEM **+17.6pp**). Protocol: sau R1–R4 hybrid fail-rerun, không phải fresh 1034 từ đầu. Backup: `output/nl2sql_6step/full_dev/_archive_before_rebenchmark_*`. `benchmark_progress.json` → `locked_full_dev`.

- **Số liệu khóa Spider**: 6-step **89.0/75.0**, 4-step **84.9/57.4** — không đổi khi chạy ablation 5-stage.

## Key paths (ablation full)

| Item | Path |
|------|------|
| Seed 4-step raw | `output/nl2sql_4step/raw_responses/<db>/qXXXX.json` |
| Skip flags | `NL2SQL_SKIP_PLANNER`, `NL2SQL_SKIP_REFINER` in `src/nl2sql_6step/nl2sql_flow/main.py` |
| Seed helper | `load_four_step_seed_file`, `map_four_step_seed_to_six_steps` |
| Starter script | `scripts/run_ablation50_seed4step.py` |
| DB order | `output/nl2sql_6step/benchmark_progress.json` → `db_order` |
| Eval | `experiments/test-suite-sql-eval/evaluation.py --etype all --plug_value` |
| Paper gap | `Springer_Nature_LaTeX_Template/Paper.tex` Table `tab:main` rows 5-stage = `--` |

## Locked Spider difficulty (official, N=1034)

| | 4-step EM/EX | 6-step EM/EX |
|--|---|---|
| Easy | 72.2 / 91.1 | 87.9 / 95.2 |
| Medium | 62.1 / 88.1 | 83.0 / 90.6 |
| Hard | 54.6 / 82.2 | 60.9 / 89.7 |
| Extra | 25.3 / 69.9 | 48.8 / 74.7 |
| All | 57.4 / 84.9 | 75.0 / 89.0 |

---

## Lịch sử (rút gọn — chi tiết bên dưới vẫn giữ)

- **2026-07-27 (Spider R4)**: Finetune repair deterministic (`SUM(Population)` cho “people live…”, `ORDER BY count(*)` thay alias bịa) + prompt Analyzer/Expert; offline +4; hybrid GPT-4o `dog_kennels`+`tvshow`. **dog_kennels 81.7→85.4** (+3); **tvshow 79.0→88.7** (+6 offline+LLM); **world_1 →80.0** (+1 offline). Tổng R4 ≈ **+10 câu** (target +15, thiếu ~5). Overall ước **~89.0%**. Summary: `r4_hybrid_arbiter_summary.json`, `r4_offline_repair_summary.json`.

- **2026-07-27 (Spider R3 hybrid)**: `student_transcripts_tracking` **EX 75.6→83.3** (fix 7/24; vs4 78.2 → vượt target 80%). Protocol: GPT-4o + seed Analyzer/Schema/Direct. Summary: `r3_hybrid_arbiter_summary.json`. R1–R3 ước overall **~87.5%+** — nên `--aggregate` để khóa full 1034.

- **2026-07-27 (Spider R2b rate-limit recovery)**: R2 bị Gemini **429** → 26 câu `world_1` thành `SELECT 1`. Rerun `--select1-only --gpt4o --include-direct --restore-bak`: **world_1 EX → 79.2%** (vs4 73.3, vượt target 75%); **car_1 giữ 85.9%**. Summary: `r2b_hybrid_arbiter_summary.json`.

- **2026-07-27 (Spider R2 hybrid fail-rerun)**: **car_1 78.3→85.9**; **world_1 70.8→73.3** rồi bị 429 (xem R2b). R1+R2+R2b ước overall **~87%+** — cần `--aggregate` khóa.

- **2026-07-26 (Spider R1 arbiter + hybrid fail-rerun)**: Siết step 3–5 arbiter: skip Refiner → Direct; Direct-anchor join-bloat/set-op/agg; `choose_best` phạt JOIN thừa. Env `NL2SQL_SEED_INCLUDE_DIRECT=0`. Script: `scripts/rerun_spider_r1_fail_hybrid.py`. **wta_1 82.3→91.9**; **pets_1 90.5→97.6**.

- **2026-07-26 (hybrid 4→6 smoke-34)**: Mode `--seed-from-4step`: reuse Analyzer/Schema/Direct từ raw 4-step; gọi LLM Planner/Planned/Refiner/Validator. Smoke seed42 n=34 (`output/drspider_smoke34_hybrid4to6/`): EX=**31/34=91.2%**.


- **2026-07-25 (Dr.Spider-340 full)**: Xong cả 4-step + 6-step trên **340/340** (`output/drspider340/`, script `scripts/smoke_test_drspider30.py --all`, seed raw từ smoke-30). EX (`exec_eval`): **4-step 268/340 = 78.8%** (DB 76.7 / NLQ 79.4 / SQL 79.0); **6-step 262/340 = 77.1%** (DB 71.7 / NLQ 78.9 / SQL 77.0). Official parser: 4-step EX~82.9/EM~61.4; 6-step EX~81.4/EM~60.0. Trên subset này 4-step nhỉnh hơn 6-step (~+1.7 EX). So leaderboard post-EX Dr.Spider (Picard ~65.9, Codex ~64.4): số tuyệt đối cao hơn nhưng chỉ là diagnostic subset 20×17, không claim full leaderboard.

- **2026-07-25 (Dr.Spider smoke-30)**: Sample stratified **30/340** (seed `42`). Artifacts: `output/smoke_drspider30/`. Pilot EX: 4-step 93.3%; 6-step 86.7%.

- **2026-07-25 (Dr.Spider-340)**: Đã tạo tập chẩn đoán tái lập gồm **340 mẫu hậu nhiễu = 20 mẫu × 17 loại perturbation**, seed `42`, với **340 Spider-dev q_id khác nhau** và phân tầng theo độ khó Spider (`easy=73`, `medium=150`, `hard=58`, `extra=59`). Hai artifact căn hàng bằng `sample_id`: `experiments/round2/drspider/drspider_340_questions.json` (không chứa SQL) và `drspider_340_gold_sql.json`; script tái tạo: `sample_drspider.py`. Nguồn được khóa tại commit `c64694a...`, SHA-256 archive `d0f47e...`; 70 SQLite được tham chiếu đã lưu tại `data/drspider/`. Đã xác minh 340/340 câu và gold khớp nguồn, 340/340 gold SQL lập được query plan trên đúng DB, và chạy lại cho byte-identical output.

- **2026-07-25 (tối)**: Xong `world_1` (120) — DB cuối (0 failed cả hai). Full Spider 1.0 dev 20/20 DB hoàn tất; số liệu khóa xem mục đầu.

- **2026-07-25 (tối)**: Sửa `normalize_sql_for_spider` — chỉ strip `) AS alias` khi alias không được tham chiếu outer (`_strip_unreferenced_as_aliases`). Rebuild 6-step `car_1` predict từ raw + official eval: **EX=78.3 / EM=30.4** (trước rebuild alias-broken: 75.0/34.8; EX↑ nhờ q107/141/142; EM↓ vì giữ alias làm lệch exact-match). Backup predict cũ: `output/nl2sql_6step/per_db/car_1_before_alias_fix/`. Siết Refiner/Validator 6-step: skip LLM khi constraint report `valid=true`; `select_audited_result` bỏ rewrite khi previous đã valid; NO-OP RULE trong `tasks.yaml`. 4-step Validator cũng có guard tương tự.

- **2026-07-25 (chiều)**: Ghi đè benchmark 4-step `car_1` bằng prompt mới (smoke→official): **EX=79.3 / EM=42.4** (cũ 56.5/32.6). 6-step `car_1` chạy lại (trước fix alias): **EX=75.0 / EM=34.8**. Backup cũ: `output/backup_car1_4step_before_prompt_new/`. Tích lũy lúc đó ~86.4/58.4 (4-step), ~86.4/60.0 (6-step).

- **2026-07-25**: Xong `cre_Doc_Template_Mgt` + `real_estate_properties`. cre 83.3/56.0 vs 88.1/53.6; real_estate 50/25 vs 50/50.

- **2026-07-25**: Xong `dog_kennels` (82): 4-step 81.7/58.5 (2 failed validator-error); 6-step 81.7/56.1. `flight_2` 88.7/71.3 vs 87.5/71.3. `student_transcripts` 78.2/47.4 vs 75.6/47.4.

- **2026-07-24 (đêm)**: Xong `wta_1` (62). 4-step EX=88.7/EM=74.2; 6-step EX=82.3/EM=64.5.

- **2026-07-24 (vòng thực nghiệm round-2, prompt v3)**: Sau phân tích lỗi world_1/car_1/tvshow, đã sửa: (1) `rebuild_filtered_schema` — build lại schema lọc deterministic trong code (fix bug LLM sinh index/FK hỏng); (2) fallback khi Validator trả SQL rỗng; (3) value grounding — `column_sample_values` (4 giá trị mẫu/cột text) truyền vào mọi agent; (4) bộ rule prompt v3 trong `agents.yaml`+`tasks.yaml` cả 2 pipeline: COUNT(*) mặc định, cấm ORDER BY theo alias bịa, phủ định → NOT IN/EXCEPT (cấm `!=` trên join), "X and Y" cùng cột → INTERSECT, cấm bịa literal placeholder, condition scoping "either X or Y <cond>", output fields không chứa cột sort/filter, ORDER BY mặc định ASC. 4-step Question Analyzer đã đổi sang GPT-4o (đồng nhất backbone với 6-step). Backup chạy cũ: `output/backup_run_20260724/`. Runner: `run_complete_nl2sql_pipeline.py --pipeline {4step,6step} --next/--status/--run-db/--aggregate`. LƯU Ý: kết quả cũ trong paper (85.6/77.8) không tái lập được; số liệu paper lấy từ vòng chạy trung thực này.
- **2026-07-23**: Tạo thư mục `publish/` sẵn sàng đẩy GitHub (code 4/6-step + eval Spider + output full đã dọn, không kèm `.env`/bak/MEMORY/paper). Dùng `publish/` làm **repo root riêng** (`cd publish && git init`), không commit từ repo cha (parent `.gitignore` đang ignore mọi `data/`).
- **Mới (bài hội nghị Việt)**: `report/conference-ready-12_vi.md` đã đồng bộ mixed-model với `src/nl2sql_6step/.../agents.yaml` (GPT-4o: Analyzer/Planner/Generator/Refiner; Gemini 2.5 Flash: Schema/Validator), nêu trung thực baseline 4 bước (Claude Sonnet 4 cho Question Analyzer), và sửa Bảng 2 (dòng căn cột `| :--- | :--- |`, bỏ hàng “Lý do” trùng lặp).
- **Vừa hoàn thành**: Tích hợp và đánh giá thành công **DeepSeek-R1 (Reasoner)** vào Pipeline 6 bước.
- **Kết quả tổng hợp**: Toàn bộ kết quả thực nghiệm và kế hoạch nộp bài được hợp nhất tại `ReadMe.md`.
- **Đang thực hiện**: (1) Chạy thực nghiệm bổ sung và điền số vào `report/experimental_tables_draft.md`; (2) Hoàn thiện bản thảo `report/complete_paper_combined.md` (bỏ placeholder, baseline ngoài, ablation có số). **Kế hoạch công bố song song**: tạp chí **SN Computer Science (Springer)** / hội nghị **SEKE 2026** (đã có trong kế hoạch cũ) **và** hướng tạp chí **Q3–Q4** hoặc **MDPI *Informatics*** sau khi có đủ bảng thực nghiệm — xem mục **Nghiên cứu tạp chí & hội nghị** bên dưới.
- **Mới cập nhật (bài báo)**: Chuẩn hóa `report/complete_paper_combined_vi.md` thành bản **thuần Việt** (bỏ tiêu đề song ngữ, đồng bộ hình/bảng/chú thích); bản EN `report/complete_paper_combined.md` giữ làm bản nộp quốc tế.
- **Mới cập nhật**: Tái cấu trúc `report/complete_paper_combined_vi.md` theo hướng reviewer-friendly cho paper NLP/AI conference: viết lại `Abstract`, tăng cường `Introduction`, mở rộng `Related Work`, bổ sung mô tả pipeline 6 bước bằng bảng và ASCII diagram, tổ chức lại khung mục thành `4. Thiết lập thực nghiệm` đến `10. Kết luận`, và đồng bộ lại định nghĩa **FSED**.
- **Mới cập nhật thêm**: Bổ sung `3.4 Implementation Details` trong phần phương pháp, thêm mô tả `Spider Dev Set` trên 20 databases, nêu rõ `official Spider evaluation script`, thay bảng baseline prompting theo định dạng `Single Prompt / Chain-of-Thought / 4-Step / 6-Step`, thêm `5.3 Error Analysis`, và đồng bộ `temperature = 0`.
- **Mới cập nhật thêm**: Sửa reviewer-sensitive issues trong bản thảo: chuẩn hóa thứ tự tác nhân thành `Analyzer → Schema → Planner → Generator → Refiner → Validator`, rút gọn mô tả `Refiner` theo hướng reasoning-based, làm rõ cách phát hiện lỗi cho chỉ số **FSED**, bổ sung `Spider 1.0 Dev Set`, thêm `4.4 Implementation`, và bổ sung thông tin tái lập như `model version`, `max_output_tokens`, `context window`, `prompt format`, `average schema size`.
- **Mới cập nhật thêm**: Đã dịch toàn bộ `report/complete_paper_combined_vi.md` sang tiếng Anh học thuật và ghi vào `report/complete_paper_combined.md`, giữ nguyên cấu trúc, bảng, trích dẫn, kết quả thực nghiệm và các placeholder.
- **Mới chốt (venue strategy)**: Dùng **một bản gốc Springer-format** cho đường hội nghị. **Ưu tiên nộp UCBICBIT 2026**. **AAU 2026** chỉ giữ làm phương án dự phòng nếu đến khoảng `29–30/03/2026` bản thảo đã gần hoàn tất; không chờ email phản hồi từ AAU mới bắt đầu format.
- **Mới chốt (journal fallback)**: Nếu đường hội nghị thất bại, **Applied Computer Science** là **cửa journal chính** trong ngân sách khoảng `$500`; **JCS&T** là **cửa tiết kiệm** với APC `$0`.

## Nghiên cứu tạp chí & hội nghị (tổng hợp phiên làm việc 2026-03)

### Đánh giá bản thảo tiếng Anh (`report/complete_paper_combined.md`) vs mục tiêu Q3

- **Kết luận**: Cấu trúc và chủ đề **phù hợp** tạp chí/hội nghị tầng trung (ứng dụng CS, IS) **sau khi** hoàn thiện thực nghiệm.
- **Chưa đủ điều kiện nộp ngay**: Còn placeholder (Table 5–7, 9; tham số model/API); thiếu baseline **bên ngoài** và **single/CoT cùng backbone** trên cùng Spider dev; ablation chưa có số; FSED chưa báo cáo giá trị số trong kết quả.
- **Đóng góp cần diễn đạt**: Tránh lạm dụng “Key Innovation” cho bước prompt; ưu tiên *design rationale + empirical findings*.
- **Kết quả số trong bài (Spider dev, pipeline Gemini Flash trong bản thảo)**: 6-step **EX 85,6% / EM 77,8%** vs 4-step **81,2% / 73,7%** — mang tính **nội bộ** kiến trúc; cần bổ sung so sánh literature để reviewer chấp nhận.

### Bảng thực nghiệm đề xuất (template điền sau)

- **File**: `report/experimental_tables_draft.md`
- **Nội dung**: E0 checklist tái lập; E1–E2 main + prompting baselines; E3 baseline literature; E4 ablation; E5 theo độ khó; E6 phân bố lỗi; E7 FSED; E8 token/latency; E9–E11 (oracle / benchmark thứ hai / robustness — tùy chọn); E12 ví dụ định tính; mapping sang các mục trong bài báo.

### Tạp chí Q3 / Q4 (5 tên đã rà soát nhanh Scopus/Scimago — **cần tra lại quartile năm nộp**)

| Tạp chí | Ghi chú ngắn |
|---------|----------------|
| **International Journal of Advanced Computer Science and Applications (IJACSA)** | Scopus/CiteScore thường **Q3**; có nguồn ghi acceptance ~**15%** → không kỳ vọng “dễ đậu” dù có thể ra số hàng tháng. |
| **Applied Computer Science** (Ba Lan) | SJR thường **Q3** (CS Applications / IS); AI category có thể **Q4**; phù hợp bài hệ thống + benchmark. |
| **Journal of Universal Computer Science (JUCS)** | SJR thường **Q3**; OA; xử bản thường tương đối linh hoạt. |
| **International Journal of Computational Intelligence Systems (IJCIS)** | JCR hay **Q3** (*Interdisciplinary Applications*); Scimago đôi khi **Q2** — đối chiếu đúng category. |
| **International Arab Journal of Information Technology (IAJIT)** | SJR gần đây **Q3** (*CS miscellaneous*). |
| **Thay thế sát CSDL (thường Q2)**: **Computer Science and Information Systems (COMSIS)** — scope IS/Text-to-SQL rất khớp nhưng **khó hơn** thuần Q3. |

### Tốc độ nộp / phản hồi (trong nhóm 5 tạp chí trên)

- **Cân bằng “không quá chậm + scope khớp”**: ưu tiên **Applied Computer Science** → **JUCS**.
- **Không kỳ vọng “dễ + nhanh”**: **IJACSA** (tỉ lệ chấp nhận thấp theo số liệu công bố); **IJCIS** (Springer, vòng tháng là bình thường); **IAJIT** (6 số/năm → có thể chờ gom số).

### Quyết định venue hiện tại (chốt 2026-03-25)

#### Hội nghị chính vs dự phòng

- **Hội nghị chính**: **UCBICBIT 2026**.
- **Hội nghị dự phòng**: **AAU 2026 / ICSMGEE 2026**.
- **Nguyên tắc vận hành**: chuẩn bị **một bản gốc Springer Word format** để tái sử dụng giữa các venue cùng họ template.
- **Nguyên tắc ra quyết định**: không dừng tiến độ để chờ email xác nhận từ AAU; chỉ nộp thêm AAU nếu bản thảo gần xong trước `29–30/03/2026`.

#### UCBICBIT 2026 — hồ sơ thực dụng

- **Vai trò trong chiến lược**: venue **ưu tiên số 1** cho đường hội nghị.
- **Deadline nộp bài**: `22/04/2026`.
- **Notification**: `25/04/2026`.
- **Conference dates**: `20–21/05/2026`.
- **Hình thức**: `Virtual + In-person`.
- **Chi phí**: `Virtual + Publication = $300`; `Physical + Publication = $500`; `Virtual without publication = $140`; `Physical without publication = $250`.
- **Template**: có `Springer camera-ready Word template` công khai trên website.
- **Độ khớp đề tài**: tốt cho framing kiểu `Multi-Agent LLM for Natural Language Access to Relational Business Data`, `AI-enabled decision support`, `NLP + business analytics`.
- **Điểm cộng chính**: còn đủ thời gian để chỉnh bài; thông tin virtual slot, template và submission flow rõ; hợp với hướng `business data access`.
- **Điểm cần lưu ý**: wording publication vẫn có độ mơ hồ (`Springer/Emerald`), nên cần thận trọng khi diễn giải với giảng viên/reviewer.

#### AAU 2026 / ICSMGEE 2026 — hồ sơ thực dụng

- **Vai trò trong chiến lược**: venue **dự phòng** cho đường hội nghị.
- **Deadline nộp bài**: `31/03/2026`.
- **Notification**: `16/04/2026`.
- **Conference dates**: `28–29/04/2026`.
- **Hình thức**: có `Online participation`; Doctoral Colloquium ghi rõ `onsite + online parallel`.
- **Chi phí**: `Online + English publication = $300`; `Physical + English publication = $500`.
- **Template**: có `Springer camera-ready Word template` cho English; có thêm `Arabic template`.
- **Độ khớp đề tài**: khá tốt ở Track 1 (`AI / ML / NLP / decision-support systems`), nhưng framing business/technology hơi rộng và deadline rất gấp.
- **Rủi ro chính**: email hỏi format / online presentation / proceedings series **chưa được phản hồi**; publication wording mơ hồ hơn UCBICBIT.
- **Quy tắc sử dụng**: chỉ nộp nếu bản thảo gần hoàn thiện trước `29–30/03/2026`.

### Journal fallback đã chốt (2026-03-25)

#### Applied Computer Science — cửa chính

- **Vai trò trong chiến lược**: **journal fallback chính** nếu đường hội nghị thất bại.
- **Ngân sách**: phù hợp mức khoảng `$500`.
- **APC / publication fee**: website có chỗ ghi `2,000 PLN / 500 EUR`; có chỗ ghi `230 EUR (950 PLN)` → cần **xác nhận lại trước khi nộp**, nhưng vẫn nằm trong vùng ngân sách thấp hơn nhiều so với MDPI.
- **Quartile dự kiến**: thường được xem là vùng `Q3`, một số category có thể rơi `Q4`; **cần tra lại năm nộp**.
- **Review type**: `single-blind`.
- **Tần suất xuất bản**: `quarterly`.
- **Scope phù hợp**: `applied computing`, `information systems`, `machine learning`, `data processing`, `data analysis`, `user interfaces`, IT solutions for `economy and management`.
- **Lý do chọn**: cân bằng tốt nhất giữa `chi phí`, `độ fit`, và `khả năng đóng gói bài NL2SQL như một AI system paper ứng dụng`.
- **Cách frame bài**: `schema-aware multi-agent AI system`, `natural language access to structured data`, `applied information systems / business data access`.

#### JCS&T — cửa tiết kiệm

- **Vai trò trong chiến lược**: **journal fallback tiết kiệm**.
- **APC**: `$0`.
- **Review stats**: `Mean Time to First Response = 89 days`; `Mean Time to Acceptance = 114 days`.
- **Review type**: `single-blind`.
- **Tần suất**: `semiannual`.
- **Scope phù hợp**: `Artificial Intelligence`, `Databases`, `Data Mining`, `Data Science`, `Intelligent Systems`, `HCI`, `Information Systems`.
- **Template / format**: journal có `LaTeX template`; submission yêu cầu PDF và có cover letter.
- **Lý do giữ lại**: không mất APC, scope vẫn đủ hợp với NL2SQL/AI system paper.
- **Điểm yếu chính**: chậm hơn các option nhanh; cần thêm yêu cầu riêng như `Spanish title/abstract/keywords`, `Authors' contributions`, `Competing interests`, `Citation box`.

#### Các lựa chọn đã cân nhắc nhưng không chốt

- **MDPI Informatics**: nhanh (`33 ngày` đến first decision), JCR `Q3`, fit đề tài tốt, nhưng APC `CHF 1800` vượt xa ngân sách hiện tại.
- **J.UCS**: APC `$0`, first decision khoảng `68–75 ngày`, nhưng acceptance rate `<16%`, nên không xem là cửa “dễ accept”.
- **IAJIT**: fit đề tài tốt (`AI`, `Database Systems`, `NLP`, `ML`) và thường ở vùng `Q3`, nhưng APC `$600`, vượt nhẹ ngân sách mục tiêu `$500`.

### MDPI — bối cảnh & đề xuất đích danh

- **Bối cảnh**: MDPI là OA lớn, COPE member, nhiều tạp chí Scopus/WoS; **tranh luận 2024–2025**: ví dụ **Phần Lan JUFO** hạ hạng hàng loạt tạp chí (gồm nhiều MDPI/Frontiers) vì lo ngại tốc độ vs chất lượng đánh giá; một số trường EU khảo sát **thiên hướng hạn chế** MDPI. **Việt Nam**: bắt buộc kiểm tra **danh mục CQĐT/trường** trước khi nộp.
- **Tạp chí đề xuất một mục tiêu (scope + tốc độ kiểu MDPI)**: ***Informatics*** (MDPI), **ISSN 2227-9709** — scope gồm **AI, ML, LLM**, big data analytics; trang: https://www.mdpi.com/journal/informatics · nộp: hệ thống SUSY · hướng dẫn: `/journal/informatics/instructions`.
- **Kết quả đi kèm (lời khuyên nội dung/format cho *Informatics*)**:
  - Cấu trúc **Article**: Introduction → **Materials and Methods** → Results → Discussion → (Conclusions); đổi tên/merge mục hiện tại cho khớp IMRaD.
  - Abstract **~200 từ**, một đoạn (bối cảnh → phương pháp → kết quả chính → kết luận ngắn); **Keywords 3–10**.
  - **Cover letter** bắt buộc (significance + fit scope + không trùng nộp + tất cả tác giả đồng ý).
  - **Khai báo GenAI/LLM** trong Materials and Methods (bài này dùng LLM làm cốt lõi pipeline — không chỉ “sửa chính tả”).
  - **Data availability**, **Author Contributions**, **Funding**, **COI**; khuyến khích **graphical abstract** (pipeline 6 bước); template Word/LaTeX MDPI hoặc Free Format rồi chỉnh theo revision.

### Hội nghị (giữ từ kế hoạch cũ trong repo)

- **SEKE 2026**: đã ghi deadline **01/05/2026** trong kế hoạch submission — cần đối chiếu lại CFP chính thức khi sát hạn.

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
- **Thống nhất bài báo vs code**: Kiến trúc thực tế là hybrid (DeepSeek-R1 / Gemini / GPT-4o theo agent); cần đảm bảo bản thảo `report/complete_paper_combined*.md` mô tả **đúng** cấu hình đã chạy số liệu (hoặc ghi rõ “variant” nếu có nhiều cấu hình).

## Kế hoạch Tiếp theo (Submission Pipeline)

1. [ ] **Ưu tiên hoàn thiện bản Springer-format** để nộp **UCBICBIT 2026** trước deadline `22/04/2026`.
2. [ ] Theo dõi mốc `29–30/03/2026`: nếu bản thảo gần xong, nộp thêm **AAU 2026** như phương án dự phòng.
3. [ ] **Điền thực nghiệm** vào `report/experimental_tables_draft.md` → merge vào `report/complete_paper_combined.md` (và bản VI nếu cần).
4. [ ] Nếu đường hội nghị thất bại: chuyển bài sang **Applied Computer Science**; nếu cần tiết kiệm tối đa thì chuyển sang **JCS&T**.
5. [ ] Trước khi nộp journal, đối chiếu lại **quartile năm nộp** và **APC thực tế** của **Applied Computer Science**.
6. [ ] Chuyển đổi toàn bộ Mermaid Diagrams sang định dạng hình ảnh PNG/EPS (cho bản camera-ready).

## Files Đã Tạo/Cập nhật Gần đây

- `ReadMe.md` — **Entry point chính**, báo cáo tổng hợp và kế hoạch nộp bài.
- `report/complete_paper_combined.md` — Bản thảo bài báo tiếng Anh (nộp quốc tế).
- `report/complete_paper_combined_vi.md` — Bản thảo tiếng Việt thuần (đối chiếu / luận văn).
- `report/experimental_tables_draft.md` — Template bảng thực nghiệm (E0–E12) trước khi merge vào bài báo.
- `PROJECT_CONTEXT.md` — Ngữ cảnh dự án, kiến trúc (kể cả hybrid DeepSeek-R1).

## Thay đổi Lịch sử

- **2026-07-26**: Tăng cường pipeline 6 bước cho Dr.Spider theo cấu hình tiết kiệm. Sửa lỗi `--pipeline both` có thể tái sử dụng module `nl2sql_flow` của 4 bước cho lượt 6 bước; hai pipeline nay chạy ở process riêng, kiểm tra đúng đường dẫn module, trace đủ sáu pha và cache có chữ ký code/prompt/model. Pipeline 6 bước nhận cả semantic schema names và executable `*_original`, dùng schema safe-superset, structured Pydantic outputs, sinh hai SQL candidates (direct/planned), audit bằng SQLite + `sqlglot`, và chỉ gọi Sonnet Refiner/Gemini Validator khi có rủi ro hoặc vi phạm. Budget profile mặc định: DeepSeek V4 Flash cho Analyzer/Planner, Gemini 2.5 Flash cho Schema/Validator, GPT-4o cho Generator, Claude Sonnet 4 cho Refiner. Thêm `test/test_drspider_process_guards.py`; kiểm thử offline đạt `4 passed`. Chưa chạy paid smoke/full benchmark sau thay đổi; số EX mới phải được đo lại trước khi đưa vào bài.
- **2026-03-25**: Chốt chiến lược venue: `UCBICBIT 2026` là hội nghị chính, `AAU 2026` là dự phòng; dùng một bản gốc `Springer-format`; chốt journal fallback gồm `Applied Computer Science` (cửa chính trong ngân sách ~$500) và `JCS&T` (cửa tiết kiệm APC $0); bổ sung hồ sơ deadline/chi phí/template/rủi ro cho từng lựa chọn.
- **2026-03-22**: Cập nhật `MEMORY.md`: mục **Nghiên cứu tạp chí & hội nghị** (đánh giá bản EN vs Q3, 5 tạp chí Q3–Q4, COMSIS, tốc độ vs dễ đậu, MDPI/JUFO, đích danh *Informatics* + lời khuyên format/nội dung), `experimental_tables_draft.md`, đồng bộ kế hoạch submission và danh sách file trong `report/`.
- **2026-03-14**: Tái cấu trúc Mục 4 của bài báo theo chuẩn conference; thêm giải thích dùng Spider Dev Set, bảng baseline/ablation/model comparison/error analysis với placeholder rõ ràng, và chuẩn hóa FSED.
- **2026-03-14**: Tái cấu trúc toàn bộ bản thảo theo yêu cầu reviewer: viết lại Abstract/Introduction/Related Work/Conclusion, thêm bảng mô tả pipeline 6 bước, thêm baseline comparison với placeholder, chuyển ablation sang full dev set (placeholder), thêm implementation details và efficiency analysis.
- **2026-03-14**: Bổ sung vòng chỉnh sửa thứ hai theo reviewer: thêm subsection `3.4 Implementation Details`, thêm dataset/evaluation protocol chi tiết, thêm bảng `Comparison with prompting baselines`, thêm `5.3 Error Analysis`, và sửa mọi chỗ còn ghi `temperature = 0.3` thành `0`.
- **2026-03-14**: Bổ sung vòng chỉnh sửa thứ ba theo reviewer: sửa thứ tự Refiner/Validator, giảm tính rule-based ở phần Refiner, thêm mô tả phát hiện field error cho FSED, thêm PICARD vào Related Work, đổi wording thành "giảm gánh nặng nhận thức lên một mô hình đơn lẻ", và thêm các chi tiết reproducibility còn thiếu.
- **2026-03-14**: Dịch hoàn chỉnh bản thảo tiếng Việt sang tiếng Anh và lưu thành `report/complete_paper_combined.md`.
- **2026-03-02**: Tích hợp DeepSeek-R1; EX 85%; EM 40%. Hợp nhất báo cáo vào `ReadMe.md`.
- **2026-03-01**: Ablation baseline_4step xong (EX 78%, EM 44%); 4/4 variants hoàn tất.
- **2026-02-28**: Ablation no_refiner/no_planner hoàn tất.
- **2026-01-20**: Cập nhật kết quả Spider 1.0 (EX: 84.1%, EM: 76.8%).
