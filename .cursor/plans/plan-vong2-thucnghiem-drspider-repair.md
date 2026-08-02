# Plan Vòng 2: Thực nghiệm lại + Dr.Spider + Nâng cấp Section 3 (Paper.tex)

Mục tiêu: giải quyết 4 comment của thầy hướng dẫn, mọi thay đổi trong bài báo bôi đỏ bằng `\textcolor{red}{...}`.

| Comment của thầy | Giải pháp trong plan này |
|---|---|
| 4-step không dùng cùng model với 6-step | Giai đoạn 1: rerun 4-step chuẩn hóa model (GPT-4o Analyzer) |
| Sao không thử BIRD / Dr.Spider / Spider 2.0 | Giai đoạn 2: chạy Dr.Spider 340 câu; Giai đoạn 4: viết lý do loại BIRD/Spider 2.0 |
| Section 3 đơn giản quá | Giai đoạn 3+4: formalization, thuật toán, worked example |
| Hệ thống đơn giản, thêm gì cho thú vị | Giai đoạn 3: Validation-Triggered Repair (VTR) — đóng góp thuật toán mới |

---

## Giai đoạn 0 — Freeze & chuẩn bị (làm trước, ~0.5 ngày)

Mục đích: mọi kết quả vòng 2 phải tái lập được và không bị nghi ngờ "sửa prompt giữa chừng".

- [ ] **Freeze prompt**: commit toàn bộ `agents.yaml` + `tasks.yaml` của cả `src/nl2sql_6step` và `src/nl2sql_4step` vào git, tag `freeze-round2` (ví dụ `git tag freeze-round2`). Sau tag này KHÔNG sửa prompt nữa; nếu buộc phải sửa thì chạy lại từ đầu.
- [ ] **Chuẩn hóa model 4-step**: sửa `src/nl2sql_4step/.../agents.yaml`: Question Analyzer đổi Claude Sonnet 4 → **GPT-4o** (các stage khác giữ nguyên: Gemini 2.5 Flash cho Schema Selector + Validator, GPT-4o cho SQL Generator). Từ đây 4-step và 6-step chỉ khác nhau đúng 2 stage Planner/Refiner → confound backbone biến mất.
- [ ] **Cố định tham số**: `temperature=0`, `max_output_tokens=2048`, seed 42 ở mọi chỗ có random (sampling, shuffle). Ghi rõ model version/snapshot đang gọi (ví dụ `gpt-4o-2024-xx`, `gemini-2.5-flash`) vào file `experiments/round2/CONFIG.md` để đưa vào bảng reproducibility.
- [ ] **Bật logging token + latency per-call** (nếu chưa có) để bảng cost (`tab:cost`) lấy từ log run thật — plan cũ đã ghi nhận điểm yếu này.
- [ ] Tạo thư mục kết quả: `experiments/round2/{spider_dev,drspider,vtr}/`.

## Giai đoạn 1 — Rerun chuẩn trên Spider 1.0 dev (1.034 câu)

Cấu hình cần chạy (mỗi cấu hình 1 pass, temperature=0):

| # | Cấu hình | Ghi chú |
|---|---|---|
| 1 | **4-step chuẩn hóa** (GPT-4o Analyzer) | Bắt buộc — thay số cũ 73.7/81.2 trong mọi bảng |
| 2 | **6-step** (cấu hình khóa như Table 2 của paper) | Chạy lại để có log token/latency cùng đợt, cùng model snapshot |
| 3 | 5-step w/o Planner, 5-step w/o Refiner | Khuyến nghị chạy lại nếu ngân sách cho phép, vì ablation phải cùng snapshot với #1–#2 mới so được; nếu không, ghi chú rõ trong paper là số từ đợt trước |

- [ ] Chạy #1: `cd src/nl2sql_4step && crewai run` (hoặc script batch tương ứng) trên full `data/dev.json`.
- [ ] Chạy #2 tương tự với `src/nl2sql_6step`.
- [ ] Đánh giá: `cd experiments/test-suite-sql-eval && python evaluation.py --gold gold.sql --pred predict.sql --etype all` → lấy EM + EX + breakdown theo hardness.
- [ ] Lưu vào `experiments/round2/spider_dev/`: predictions, eval log, token/latency log.
- [ ] **Cập nhật paper**: thay số trong `tab:main`, `tab:difficulty`, `tab:errors`, `tab:cost`, `tab:lit` (2 dòng "This work"); xóa các đoạn thú nhận confound ở Section 4.2 và Limitations; cập nhật mô tả 4-step baseline (không còn Claude Sonnet 4). Tất cả bôi đỏ.
- [ ] Làm lại error analysis (đếm 5 pattern trong non-EM cases) trên kết quả mới — có thể tái dùng script/quy trình đếm cũ.

Ước lượng chi phí: ~1.034 × (4+6) = ~10.340 LLM calls cho #1+#2.

## Giai đoạn 2 — Dr.Spider 340 câu (20 câu × 17 loại perturbation)

### 2.1 Chuẩn bị dữ liệu

- [ ] Tải Dr.Spider từ repo chính thức `awslabs/diagnostic-robustness-text-to-sql` (data zip ~2GB). Giải nén vào `data/drspider/`.
- [ ] Cấu trúc: 17 test set = **3 nhóm DB** (schema-synonym, schema-abbreviation, DBcontent-equivalence) + **9 nhóm NLQ** + **5 nhóm SQL**. Mỗi nhóm có `questions_post_perturbation.json`, gold SQL, và **database riêng** (nhóm DB perturbation dùng database đã bị sửa — pipeline phải đọc schema từ database của từng nhóm, không dùng `tables.json` của Spider gốc).

### 2.2 Sampling (seed 42, công bố ID)

- [ ] Viết script `experiments/round2/drspider/sample_drspider.py`:
  - Với mỗi nhóm trong 17 nhóm: load danh sách câu post-perturbation, `random.Random(42).sample(range(n), 20)`.
  - Xuất `sampled_ids.json`: `{perturbation_type: [list 20 index/question_id]}` + câu hỏi + gold SQL + db_id.
  - File này commit vào repo và nêu trong paper (footnote "sampled question IDs are released with the code").
- [ ] Kiểm tra sanity: đủ 340 câu, không trùng, mỗi nhóm đúng 20.

### 2.3 Chạy & đánh giá

- [ ] Chạy **cùng 340 câu** qua cả 4-step chuẩn hóa và 6-step (prompt đã freeze ở Giai đoạn 0). ~340 × 10 = 3.400 LLM calls.
- [ ] Đánh giá EX bằng script eval trên database của từng nhóm perturbation (EM ít ý nghĩa trên Dr.Spider vì gold SQL có thể đổi cấu trúc; báo EX là chính, EM phụ nếu tính được).
- [ ] Tổng hợp bảng: EX theo 3 nhóm lớn (DB / NLQ / SQL perturbation) + trung bình 17 loại, cho 4-step vs 6-step.

### 2.4 Đưa vào paper (bôi đỏ)

- [ ] Thêm subsection mới trong Section 5 (Results): *"Robustness Evaluation on Dr.Spider"* — 1 bảng + 2–3 đoạn phân tích (kỳ vọng: 6-step chịu perturbation tốt hơn nhờ Schema Selection và Planning tách riêng; nếu kết quả ngược lại thì báo cáo trung thực và phân tích).
- [ ] Cập nhật Section 4.1 (Evaluation Protocol): mô tả protocol lấy mẫu 340 câu, seed 42, prompt freeze, công bố ID.
- [ ] Cập nhật Abstract + Introduction + Conclusion: thêm 1 câu về robustness check trên Dr.Spider.

## Giai đoạn 3 — Validation-Triggered Repair (VTR): đóng góp mới cho Section 3

Ý tưởng (gộp ý 3 + 4 đã thống nhất): biến SQL Validator từ chỗ chỉ báo pass/fail thành thành phần **kích hoạt một vòng sửa lỗi có giới hạn**, đồng thời dùng chính nó làm chất liệu để viết dày Section 3 (formalization + pseudocode + worked example).

### 3.1 Thiết kế

- Validator hiện kiểm tra: syntax, schema consistency, executability. Khi **fail**, thay vì dừng:
  1. Validator xuất **structured error report**: `{error_type ∈ {syntax, schema_mismatch, execution_error}, error_message, offending_fragment}`.
  2. Error report + SQL lỗi + query plan + filtered schema được đưa ngược về **SQL Refiner** để sinh SQL sửa.
  3. SQL sửa được validate lại. Giới hạn **tối đa k = 1 vòng lặp** (bounded repair) → vẫn giữ tính chất "gần single-pass", deterministic, chi phí tăng không đáng kể (chỉ tốn thêm call khi validation fail — thiểu số câu).
- Điểm bán cho reviewer: đây là **cơ chế error-containment có kiểm soát**, khác iterative self-refinement không giới hạn của Reflexion/MAC-SQL; chi phí bổ sung được đo và báo cáo.

### 3.2 Hiện thực & thực nghiệm

- [ ] Sửa orchestration trong `src/nl2sql_6step/nl2sql_flow/main.py` (+ prompt Refiner nhận thêm trường `validation_feedback` trong `tasks.yaml` — lưu ý: đây là prompt mới cho biến thể VTR, tách file/branch riêng để không phá freeze của cấu hình gốc).
- [ ] Log: số câu trigger repair, số câu repair thành công, token phát sinh.
- [ ] Chạy thử 50 câu stratified trước để smoke test, sau đó full 1.034 câu → dòng mới trong `tab:main`: **"6-stage + VTR"**. (~thêm tối đa 2 call cho mỗi câu fail validation.)
- [ ] Nếu kết quả VTR ≥ 6-step thường: đưa thành cấu hình đề xuất chính. Nếu chỉ bằng: vẫn báo cáo như một phân tích ("validation failures là hiếm và phần lớn lỗi là semantic, không bị validator bắt") — vẫn là một finding.

### 3.3 Viết lại Section 3 (bôi đỏ toàn bộ phần mới)

- [ ] **3.x Formalization**: mỗi stage là hàm \(s_i\), pipeline là composition \(P = s_6 \circ s_5 \circ \dots \circ s_1\); đặc tả intermediate representation (question analysis, filtered schema, query plan là structured object với các trường cụ thể lấy từ `tasks.yaml`).
- [ ] **3.x Algorithm**: pseudocode `Algorithm 1: Six-Stage NL2SQL with Validation-Triggered Repair` dùng package `algorithm`/`algpseudocode` (đã có sẵn trong preamble), gồm vòng repair k=1.
- [ ] **3.x Worked example**: dẫn 1 câu hỏi (dùng Case 1 — INTERSECT — trong Table 6) đi qua 6 stage, in intermediate output rút gọn ở mỗi bước, chỉ ra chỗ Planner cứu lỗi OR/INTERSECT. Xóa comment tím dòng ~255 sau khi thay bằng nội dung này.
- [ ] Cập nhật Figure pipeline6: thêm mũi tên feedback Validator → Refiner (dashed, chú thích "at most one repair round").
- [ ] Cập nhật Design Motivation: bổ sung lập luận error-containment (lỗi stage k được phát hiện ở stage k+1 thay vì trộn trong một lần sinh).

## Giai đoạn 4 — Biện luận benchmark + hoàn thiện paper

- [ ] **Đoạn biện luận benchmark** (Section 4.1 + Limitations, bôi đỏ):
  - **Spider 2.0**: đo bài toán enterprise workflow khác hẳn (multi-dialect, context cực dài, câu hỏi đa bước; SOTA ~20–30% EX) — đánh giá năng lực agentic tổng thể, không phù hợp để cô lập biến kiến trúc của một controlled study. Cite Spider 2.0 paper.
  - **BIRD**: yêu cầu external knowledge evidence đi kèm mỗi câu hỏi — thêm một biến gây nhiễu (năng lực khai thác evidence) vào so sánh kiến trúc; kiến trúc hiện tại không có thành phần xử lý evidence nên so sánh sẽ không fair với các hệ được thiết kế cho BIRD. Định vị là future work.
  - **Dr.Spider**: ĐÃ dùng làm robustness check (trỏ tới subsection mới) → chuyển câu hỏi của thầy thành điểm cộng.
- [ ] **Dọn hình thức** (kế thừa plan cũ `khắc_phục_tồn_đọng_đánh_giá`): xóa package trùng (`graphicx`, `multirow`, `algorithm` nạp 2 lần), xóa `\usepackage[cp1251]{inputenc}`, bổ sung "Hanoi University of Science and Technology" vào `\institute`, xóa các khối comment lỗi thời (kể cả khối `\begin{comment}` dài giữa file).
- [ ] Giải thích bất thường Extra Hard > Hard sau `tab:difficulty` (nếu pattern còn xuất hiện với số mới).
- [ ] Rà nhất quán: mọi số giữa `tab:main` / `tab:difficulty` / `tab:errors` / `tab:cost` / `tab:lit` / Abstract / Intro / Conclusion phải cùng một đợt run; cite key ↔ `sn-bibliography.bib`.
- [ ] Kiểm tra toàn bộ thay đổi đã bôi đỏ `\textcolor{red}{...}`; compile PDF sạch lỗi.
- [ ] Cập nhật `MEMORY.md` sau khi xong.

## Thứ tự thực hiện & ước lượng

```
Giai đoạn 0 (freeze)          → 0.5 ngày, không tốn API
Giai đoạn 1 (rerun Spider)    → ~10.3k calls, 1–2 ngày chạy + eval
Giai đoạn 3.1–3.2 (code VTR)  → 1 ngày code + smoke test 50 câu, song song lúc GĐ1 đang chạy
Giai đoạn 2 (Dr.Spider)       → tải data + script sampling 0.5 ngày; ~3.4k calls
Giai đoạn 3 full run VTR      → ~6–7k calls (1.034 câu)
Giai đoạn 4 (viết paper)      → 2–3 ngày, làm dần khi có số
```

Tổng API ước tính: ~20–22k LLM calls. Nếu cần cắt: bỏ rerun 5-step ablations (giữ số cũ + ghi chú), và/hoặc chạy VTR chỉ trên Dr.Spider 340 câu + subset Spider dev.

## Rủi ro cần lưu ý

1. **Kết quả 4-step chuẩn hóa có thể TĂNG** (GPT-4o Analyzer tốt hơn Sonnet 4 ở stage này) → gap 4 vs 6 hẹp lại. Vẫn phải báo trung thực; khi đó VTR + Dr.Spider chính là phần gánh độ "thú vị" cho bài.
2. **Dr.Spider nhóm DB perturbation**: schema phải đọc từ database đã perturbed của từng nhóm — sai chỗ này là toàn bộ nhóm DB sai. Test 2–3 câu thủ công trước khi chạy batch.
3. **Model snapshot drift**: chạy toàn bộ các cấu hình trong cùng khoảng thời gian ngắn, ghi model version vào CONFIG.md.
4. **VTR phá freeze**: prompt VTR là biến thể mới — quản lý bằng branch/config riêng, cấu hình 6-step gốc giữ nguyên tag `freeze-round2`.
