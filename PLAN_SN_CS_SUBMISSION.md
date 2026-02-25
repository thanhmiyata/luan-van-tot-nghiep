# PLAN: Chuẩn bị bài báo cho SN Computer Science (Springer)

> **Tạo ngày:** 2026-02-25
> **Mục tiêu:** Update bài báo NL2SQL Multi-Agent từ bản hiện tại → đạt yêu cầu nộp SN Computer Science
> **Tạp chí:** SN Computer Science (Springer) — Q3 trong AI, Scopus indexed, APC=$0 nếu chọn subscription mode
> **Link nộp bài:** https://www.editorialmanager.com/sncs
> **Submission guidelines:** https://link.springer.com/journal/42979/submission-guidelines

---

## CONTEXT DỰ ÁN

### Bài báo hiện tại
- **File chính (tiếng Việt, ĐẦY ĐỦ NHẤT):** `complete_paper_combined_vi.md` (663 dòng)
- **File tiếng Anh (cần sync):** `complete_paper_combined.md` (813 dòng, chưa update hết)
- **File cũ (phiên bản conference, KHÔNG dùng):** `conference_paper_vn_22-25p.md`

### Kết quả chính
| Cấu hình | EM (%) | EX (%) |
|-----------|--------|--------|
| Gemini 2.0 Flash Zero-shot | 68.5 | 74.8 |
| Gemini 2.0 Flash CoT | 71.2 | 77.0 |
| 4-step (baseline) | 71.2 | 79.5 |
| DIN-SQL (reported) | 74.5 | 82.5 |
| GPT-4 Zero-shot (reported) | 72.0 | 80.1 |
| **6-step (ours)** | **76.8** | **84.0** |

### Kiến trúc
- 6 agents: Question Analyzer → Schema Selector → Query Planner → SQL Expert → SQL Refiner → SQL Validator
- Tất cả dùng Gemini 2.0 Flash (đồng nhất)
- Framework: CrewAI
- Benchmark: Spider 1.0 dev set (1.034 câu)

### Pipeline code
- `run_complete_nl2sql_pipeline.py` — script chạy pipeline + evaluation
- `src/nl2sql_6step/` — pipeline 6 bước
- `src/nl2sql_4step/` — pipeline 4 bước
- Evaluation: `experiments/test-suite-sql-eval/evaluation.py` (Spider test-suite, `--etype all` → output có difficulty breakdown)

---

## 5 PHASES CẦN THỰC HIỆN

---

### PHASE 1: Fix References [15][18][19] + Thêm DOI

**Mức ưu tiên:** CAO
**Ai làm:** AI (không cần chạy code)
**File cần sửa:** `complete_paper_combined_vi.md` (phần References, dòng 611-663)

#### Vấn đề
3 references hiện đang là placeholder/aggregate, không đạt chuẩn journal:
- `[15]` = "Nhiều tác giả, Multi-Agent Systems for Complex Task Solving, ICML/NeurIPS/ICLR, 2020–2024" → quá mơ hồ
- `[18]` = "Nhiều tác giả, Agentic RAG Frameworks, 2023–2024" → không có paper cụ thể
- `[19]` = "Nhiều tác giả, Tool Learning in LLM, 2023–2024" → không có paper cụ thể

#### Hành động
1. Thay `[15]` bằng paper cụ thể, ví dụ:
   - H. Qian et al., "ChatDev: Communicative Agents for Software Development," ACL 2024. https://doi.org/10.18653/v1/2024.acl-long.810
   - HOẶC: T. Wu et al., "AutoGen: Enabling Next-Gen LLM Applications via Multi-Agent Conversation," arXiv:2308.08155, 2023.
   - Lưu ý: [8] đã trích dẫn AutoGen rồi, nên chọn paper khác

2. Thay `[18]` bằng paper cụ thể về Agentic RAG:
   - A. Asai et al., "Self-RAG: Learning to Retrieve, Generate, and Critique through Self-Reflection," ICLR 2024. https://doi.org/10.48550/arXiv.2310.11511

3. Thay `[19]` bằng paper cụ thể về Tool Learning:
   - T. Schick et al., "Toolformer: Language Models Can Teach Themselves to Use Tools," NeurIPS 2023. https://doi.org/10.48550/arXiv.2302.04761

4. Thêm DOI cho tất cả references [1]-[20] (search trên doi.org hoặc dblp.org)

5. Đảm bảo format reference theo Springer:
   ```
   Smith JJ. The world of science. Am J Sci. 1999;36:234–5. https://doi.org/xxx
   ```

6. Cũng fix trong bản tiếng Anh `complete_paper_combined.md` (phần References tương ứng)

7. Update Phụ lục A & B (Citation Mapping) cho phù hợp

---

### PHASE 2: Ablation Study (50 câu × 4 variants)

**Mức ưu tiên:** CAO
**Ai làm:** USER chạy pipeline + AI phân tích kết quả
**Thời gian ước tính:** ~2-4 giờ chạy

#### Mục tiêu
Chuyển ablation từ "qualitative" → "quantitative" bằng cách chạy thực nghiệm trên 50 câu.

#### Thiết kế thí nghiệm
Chạy 4 variants trên CÙNG 50 câu hỏi (sample đều từ 4 difficulty levels):

| Variant | Agents | Mô tả |
|---------|--------|-------|
| Full 6-step | All 6 | Đã có kết quả (84.0% trên 1034 câu) |
| −Planner (5-step) | Bỏ Query Planner | Đánh giá tác động của planning |
| −Refiner (5-step) | Bỏ SQL Refiner | Đánh giá tác động của refinement |
| Baseline 4-step | Bỏ cả Planner & Refiner | Đã có kết quả (79.5% trên 1034 câu) |

#### Cách sample 50 câu
Cần sample đều từ Spider dev set theo difficulty:
- ~13 câu Easy
- ~13 câu Medium
- ~12 câu Hard
- ~12 câu Extra-hard

Dùng file `data/spider_data/dev.json` → mỗi entry có field `"hardness"` hoặc dùng Spider eval script để phân loại.

#### Cách chạy
1. Tạo file `ablation_questions.json` chứa 50 câu đã sample
2. Chỉnh `run_complete_nl2sql_pipeline.py` hoặc tạo script mới để:
   - Load 50 câu cố định
   - Chạy lần lượt 4 variants
   - Lưu kết quả riêng cho mỗi variant
3. Chạy evaluation cho mỗi variant
4. Tổng hợp kết quả thành bảng

#### Kết quả mong đợi (thêm vào bài báo)
Bảng mới (thay thế Section 4.3):

| Variant | EM (%) | EX (%) | Δ vs Full |
|---------|--------|--------|-----------|
| Full 6-step | ? | ? | baseline |
| −Planner | ? | ? | ? |
| −Refiner | ? | ? | ? |
| 4-step | ? | ? | ? |

**Lưu ý:** 50 câu là sample nhỏ, cần ghi rõ disclaimer: "Results on a stratified sample of 50 questions; full-scale ablation is left for future work."

#### Vị trí trong bài báo
- Thay thế toàn bộ nội dung Section 4.3 (hiện là qualitative)
- Viết lại thành quantitative ablation với bảng kết quả
- Giữ phần qualitative analysis nhưng bổ sung bằng số liệu

---

### PHASE 3: Thêm Difficulty Breakdown

**Mức ưu tiên:** TRUNG BÌNH
**Ai làm:** USER cung cấp log / AI parse kết quả

#### Mục tiêu
Thêm bảng kết quả theo difficulty level (Easy/Medium/Hard/Extra-hard).

#### Nguồn dữ liệu
Spider evaluation script (`--etype all`) output format:
```
                     easy                 medium               hard                 extra                all
count                248                  446                  174                  166                  1034
execution            0.xxx                0.xxx                0.xxx                0.xxx                0.840
exact match          0.xxx                0.xxx                0.xxx                0.xxx                0.768
```

#### Cách lấy data
**Option A:** Nếu còn log từ lần chạy trước → grep output

**Option B:** Chạy lại evaluation (không cần chạy lại pipeline, chỉ cần gold.sql và predict.sql):
```bash
cd experiments/test-suite-sql-eval
python evaluation.py \
  --gold ../../output/nl2sql_6step/gold.sql \
  --pred ../../output/nl2sql_6step/predict.sql \
  --db database/ \
  --table tables.json \
  --etype all \
  --plug_value
```

**Option C:** Chạy cho cả 4-step nữa để so sánh:
```bash
python evaluation.py \
  --gold ../../output/nl2sql_4step/gold.sql \
  --pred ../../output/nl2sql_4step/predict.sql \
  --db database/ --table tables.json --etype all --plug_value
```

#### Kết quả mong đợi (thêm vào bài báo)
Bảng mới trong Section 4.2:

| Difficulty | Count | 4-step EM | 4-step EX | 6-step EM | 6-step EX | Δ EX |
|------------|-------|-----------|-----------|-----------|-----------|------|
| Easy       | 248   | ?         | ?         | ?         | ?         | ?    |
| Medium     | 446   | ?         | ?         | ?         | ?         | ?    |
| Hard       | 174   | ?         | ?         | ?         | ?         | ?    |
| Extra-hard | 166   | ?         | ?         | ?         | ?         | ?    |
| **All**    | 1034  | 71.2      | 79.5      | 76.8      | 84.0      | +4.5 |

---

### PHASE 4: Dịch & Sync bản tiếng Anh

**Mức ưu tiên:** CAO
**Ai làm:** AI
**File nguồn:** `complete_paper_combined_vi.md`
**File đích:** `complete_paper_combined.md`

#### Hành động
1. Lấy nội dung từ bản VN (đầy đủ nhất)
2. Dịch sang tiếng Anh học thuật
3. Sync vào file EN, đảm bảo cấu trúc section giống nhau
4. Tích hợp kết quả mới từ Phase 2 (ablation) và Phase 3 (difficulty)
5. Kiểm tra thuật ngữ nhất quán:
   - "Phân tích Câu hỏi" → "Question Analyzer"
   - "Chọn Lược đồ" → "Schema Selector"
   - "Lập kế hoạch Truy vấn" → "Query Planner"
   - "Chuyên gia SQL" → "SQL Expert"
   - "Tinh chỉnh SQL" → "SQL Refiner"
   - "Kiểm tra SQL" → "SQL Validator"
   - "Tỷ trọng Lỗi Chọn trường" → "Field Selection Error Distribution (FSED)"
   - "tinh chỉnh một lần" → "single-pass refinement"
   - "chuỗi xử lý" → "pipeline"

---

### PHASE 5: Format theo yêu cầu SN Computer Science

**Mức ưu tiên:** TRUNG BÌNH (làm cuối cùng)
**Ai làm:** AI

#### 5.1 Structured Abstract (150-250 từ)
Viết lại abstract theo cấu trúc Springer khuyến nghị:
- **Background/Purpose:** 1-2 câu về vấn đề
- **Methods:** 2-3 câu về multi-agent approach
- **Results:** 2-3 câu về kết quả (EM, EX, ablation)
- **Conclusion:** 1-2 câu

#### 5.2 Keywords
Đã có: NL2SQL, multi-agent systems, CrewAI, Gemini 2.0 Flash, Spider 1.0
→ Cần thêm 1: "single-pass refinement" hoặc "text-to-SQL"
→ Tổng 4-6 keywords

#### 5.3 Declarations Section (bắt buộc cho SN CS)
Thêm trước References:

```
## Declarations

### Funding
[Ghi nguồn tài trợ nếu có, hoặc: "This research received no external funding."]

### Competing Interests
The authors declare that they have no competing interests.

### Data Availability
The Spider 1.0 dataset used in this study is publicly available at https://yale-lily.github.io/spider. Source code for the multi-agent pipeline will be made available upon publication.

### Author Contributions
[Ghi đóng góp theo CRediT taxonomy]

### Ethics Approval
Not applicable.
```

#### 5.4 Figures
Hiện tại dùng Mermaid diagrams (Fig 1, 2, 3, 5) → Springer KHÔNG render Mermaid.
- Cần convert sang ảnh PNG/EPS
- Render mermaid online tại https://mermaid.live/ → export PNG
- Đặt tên: Fig1.png, Fig2.png, Fig3.png, Fig5.png
- Caption format: **Fig. 1** System architecture (bold "Fig. 1", no period after number)

#### 5.5 Heading Levels
SN CS cho phép max 3 levels. Hiện tại có 4 levels (e.g., 3.3.1, 4.4.2).
- Cần flatten: `#### 3.3.1 Question Analyzer` → `### Question Analyzer Agent` (dưới Section 3.3)
- Hoặc giữ 3.3.1 nhưng không dùng ##### (level 5)

#### 5.6 Reference Format (Springer numbered style)
```
1. Zhong V, Xiong C, Socher R. Seq2SQL: generating structured queries from natural language using reinforcement learning. In: Proc ACL. 2017. https://doi.org/10.18653/v1/P17-1167
```

#### 5.7 File Format
- Tạo file .docx HOẶC dùng Springer Nature LaTeX template
- LaTeX template: https://www.overleaf.com/latex/templates/springer-nature-latex-template/myxmhdsbzkyd
- Hoặc dùng Word template: download từ Springer

#### 5.8 LLM Usage Disclosure
Nếu dùng AI hỗ trợ viết bài → ghi trong Methods:
```
"Large language model assistance was used for manuscript preparation (translation, editing). 
All content was reviewed and validated by the authors."
```

---

## THỨ TỰ THỰC HIỆN

```
Phase 1 (Fix refs)          ← AI làm ngay, không cần chờ
    ↓
Phase 2 (Ablation)          ← USER chạy pipeline (2-4h)
Phase 3 (Difficulty)        ← USER cung cấp log hoặc re-run eval
    ↓
Phase 4 (Dịch EN)           ← AI làm, tích hợp kết quả P2+P3
    ↓
Phase 5 (Format Springer)   ← AI làm cuối cùng
    ↓
REVIEW & SUBMIT             ← Nộp qua https://www.editorialmanager.com/sncs
```

**Ước tính timeline:**
- Phase 1: 1 session AI
- Phase 2: 1 ngày (user chạy) + 1 session AI (phân tích)
- Phase 3: 30 phút (re-run eval) + 1 session AI
- Phase 4: 1-2 sessions AI (bài dài)
- Phase 5: 1 session AI
- **Tổng: ~3-5 ngày làm việc**

---

## CHECKLIST TRƯỚC KHI NỘP

- [ ] Abstract: structured, 150-250 từ, tiếng Anh
- [ ] Keywords: 4-6 từ
- [ ] Title page: tên, affiliation, ORCID, email
- [ ] References: tất cả có DOI, không có placeholder
- [ ] Figures: PNG/EPS (không phải Mermaid)
- [ ] Declarations: Funding, Competing interests, Data availability, Author contributions
- [ ] Heading levels: max 3
- [ ] File format: .docx hoặc LaTeX
- [ ] Ablation results: bảng định lượng
- [ ] Difficulty breakdown: bảng Easy/Medium/Hard/Extra-hard
- [ ] LLM usage disclosure (nếu có)
- [ ] ORCID iD đã đăng ký
- [ ] Tài khoản Editorial Manager đã tạo

---

## GHI CHÚ KỸ THUẬT

### SN CS Submission Info
- **Hệ thống nộp:** Editorial Manager (https://www.editorialmanager.com/sncs)
- **Review:** Single-blind, min 2 reviewers
- **Median time to first decision:** 41 ngày
- **Publishing model:** Hybrid → chọn Subscription = APC $0
- **Article type:** Original Research
- **File format:** .docx hoặc LaTeX

### Cách chọn Subscription (không mất tiền)
Sau khi bài được accept, Springer gửi email hỏi chọn:
1. Open Access → APC $3,290 (KHÔNG chọn)
2. **Subscription → $0** ← CHỌN CÁI NÀY
- Bạn vẫn có SharedIt link để share cho thầy/đồng nghiệp đọc miễn phí
- Thầy có thể đọc qua thư viện trường nếu trường có đăng ký Springer
- Bạn có thể đăng preprint trên arXiv (Springer cho phép)
