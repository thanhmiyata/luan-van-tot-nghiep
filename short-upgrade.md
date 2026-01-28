# short-upgrade.md — Kế hoạch nâng cấp lên “10/10” cho mục tiêu Q3 (CNTT)

Tài liệu này mô tả **cụ thể và có thể hành động** những điểm cần cải thiện để bản thảo `conference_paper_vn_22-25p.md` đạt mức “đủ lực” nộp venue **Q3 (A2)** trong lĩnh vực CNTT.  
Mục tiêu là biến bài từ “draft đúng ý tưởng” thành “submission package” có **bằng chứng thực nghiệm + tái lập + câu chuyện khoa học** đủ thuyết phục reviewer.

---

## 1) Tiêu chí “10/10” (reviewer checklist thực tế)

Một bài Q3 thường đạt khi reviewer thấy rõ 5 điều:

- **(R1) Đóng góp rõ & mới**: novelty không chỉ là “dùng multi-agent”, mà là “thiết kế pipeline evaluation-ready + vai trò/tín hiệu trung gian rõ + đo được đóng góp từng khối”.
- **(R2) Thực nghiệm đủ & công bằng**: có baseline hợp lý, ablation đúng, và phân tích theo lát cắt (độ khó/pattern).
- **(R3) Tái lập**: mô tả đủ để người khác chạy lại (hoặc ít nhất hiểu chính xác giao thức), không có placeholder.
- **(R4) Phân tích lỗi có số liệu + case study**: không chỉ liệt kê taxonomy; phải có thống kê lỗi và liên hệ trực tiếp pipeline ↔ nhóm lỗi.
- **(R5) Viết “reviewer-safe”**: claim đúng mức, thống nhất số liệu, trích dẫn chuẩn, hình/bảng đúng format, không “hứa mà chưa làm”.

---

## 2) Nâng cấp THỰC NGHIỆM (phần quan trọng nhất)

### 2.1 Baseline bắt buộc (để reviewer chấp nhận so sánh)

Ít nhất cần các baseline sau (cùng dataset Spider dev, cùng evaluator):

- **Single-agent baseline (cùng LLM)**:
  - Zero-shot (đã có)
  - CoT / structured reasoning prompt (đã có)
  - (khuyến nghị) Single-agent + schema-filtering (để tách tác động của “lọc lược đồ” khỏi “multi-agent”)
- **Pipeline giản lược nhưng hợp lý**:
  - 4-step (đã có)
  - (khuyến nghị) 5-step: thêm Planner *hoặc* thêm Refiner (để thấy đóng góp từng khối, xem 2.2)

**Tối thiểu trong bài**: 1 bảng kết quả gồm 4-step, 6-step, zero-shot, CoT, (tuỳ) “single-agent + filtered schema”.

> Lưu ý Q3: “reported results” từ paper khác chỉ nên là **tham khảo**; nếu không chạy lại trong cùng điều kiện, hãy trình bày như “context” và ghi rõ không so sánh trực tiếp.

### 2.2 Ablation định lượng (điểm hay bị thiếu → dễ reject)

Hiện bài có giao thức 4.3 nhưng chưa có số. Để lên 10/10, cần **ít nhất 3 ablation có số liệu**:

- **–Planner** (bỏ Query Planner)
- **–Refiner** (bỏ SQL Refiner)
- **–SchemaSelector** (không lọc schema / full schema)

Khuyến nghị thêm:

- **–Validator** hoặc “Validator minimal” (chỉ cú pháp) để báo cáo **invalid SQL rate**.

**Báo cáo cho mỗi biến thể**:

- EM, EX
- Invalid SQL rate (%)
- Chi phí: tokens và/hoặc latency (trung bình)

### 2.3 Stratified evaluation (độ khó & pattern SQL)

Đây là phần “ăn điểm” Q3 vì reviewer thấy bạn hiểu bài toán:

- **Theo độ khó Spider**: easy/medium/hard/extra-hard (nếu có nhãn sẵn).
- **Theo pattern truy vấn**:
  - JOIN-heavy
  - aggregation/group-by/having
  - nested queries (IN/EXISTS/subquery)
  - set operators (UNION/INTERSECT/EXCEPT)

**Kết quả cần có**: 1–2 bảng (hoặc 1 bảng + 1 hình) cho thấy 6-step cải thiện rõ nhất ở nhóm nào.

### 2.4 Độ ổn định (stability) — rất hữu ích với LLM

Vì bạn dùng \(n=1\), reviewer có thể hỏi “có may rủi không?”.  
Bạn có thể làm 1 trong 2 cách:

- **Cách A (khuyến nghị nhẹ)**: chạy lại 3 seed/3 lần (temperature giữ nguyên hoặc 0.0) và báo cáo mean±std EX.
- **Cách B**: chuyển `temperature=0.0` để nhấn mạnh tính tất định và báo cáo “deterministic run”.

### 2.5 Chi phí suy luận (cost/latency)

Multi-agent bị hỏi “đắt không?”.

Tối thiểu cần:

- tokens input/output trung bình mỗi câu hỏi cho 4-step vs 6-step
- latency trung bình (hoặc ước lượng)  

Thêm “cost-quality trade-off plot” (EX vs tokens) là điểm cộng lớn.

---

## 3) Nâng cấp PHÂN TÍCH LỖI (từ “có taxonomy” → “có bằng chứng”)

### 3.1 Thống kê lỗi định lượng

Bạn nên báo cáo đồng thời:

- **Error distribution trên tập thất bại** (ví dụ pie chart theo % trong các câu sai)
- **Absolute error rate trên toàn bộ dev** (ví dụ bảng % lỗi JOIN, nested, grouping, field selection…)

Nếu bạn dùng FSED (Field Selection Error Distribution):

- Ghi rõ FSED tính trên **tập con các câu baseline sai** (để tránh hiểu nhầm).
- Thêm chỉ số “field selection error absolute rate” cho hệ 6-step để chứng minh “đã giảm đáng kể”.

### 3.2 Case study: 2–3 ví dụ, có log trung gian

Một ví dụ movie_1 là tốt, nhưng Q3 thường thích 2–3 case:

- 1 case **set operator** (đã có)
- 1 case **JOIN path** (n-n bảng trung gian)
- 1 case **aggregation** (COUNT vs COUNT(DISTINCT) hoặc GROUP BY/HAVING)

Mỗi case nên có:

- Q, db_id
- gold SQL
- pred 4-step vs 6-step
- giải thích “điểm rẽ” ở artifact nào: `analysis` / `plan` / `y0` / `y1`

---

## 4) Nâng cấp TÁI LẬP (reproducibility) — bắt buộc để “10/10”

### 4.1 Bỏ toàn bộ placeholder

Không để:

- `<PROVIDER>`, `<MODEL_NAME>`
- “sẽ bổ sung sau” ở phần cốt lõi

Bạn có thể ghi:

- “Code will be released upon acceptance” (nếu venue cho phép)
- nhưng **mọi thông tin chạy** phải mô tả đủ.

### 4.2 Mô tả rõ giao thức chạy

Trong bài hoặc appendix, cần:

- dataset split: Spider 1.0 dev (1,034)
- evaluator: script nào (repo + cách gọi)
- database engine (SQLite)
- policy invalid SQL (count as wrong)
- schema serialization format (những trường nào đưa vào: tables/columns/types/FKs)
- prompt style (zero-shot; no-CoT in output)
- decoding params (temperature, top_p, max_tokens), n=1

### 4.3 Logging & artifact format

Để chứng minh “evaluation-ready framework”:

- liệt kê bạn log gì: `analysis`, `schema_filtered`, `plan`, `y0`, `y1`, `report`
- nêu format (JSON) và ví dụ ngắn (1–2 dòng) trong appendix

---

## 5) Nâng cấp “CÂU CHUYỆN KHOA HỌC” (novelty & claims)

### 5.1 Chốt thông điệp đóng góp

Reviewer Q3 dễ dị ứng với claim “multi-agent improves”.  
Bạn nên nhấn mạnh:

- **evaluation-ready modular pipeline**
- **explicit contracts** (`expected_output_fields`, plan schema)
- **controlled refinement** (Refiner được phép sửa logic, Validator không)

### 5.2 Giới hạn & scope: viết chủ động, không phòng thủ

Thay vì “chúng tôi không overclaim…”, hãy nói rõ:

- scope: Spider dev + Gemini 2.0 Flash + n=1
- limitation: cost, ambiguity, schema mismatch…
- why acceptable: mục tiêu paper là “framework + evidence” và có ablation/analysis

---

## 6) Nâng cấp TRÌNH BÀY & ĐÓNG GÓI SUBMISSION

### 6.1 Ngôn ngữ

Nếu mục tiêu là venue quốc tế Q3: cần **100% tiếng Anh** (title/abstract/body/figures/refs).  
Bản tiếng Việt phù hợp cho thầy duyệt; khi chốt nộp thật thì dịch.

### 6.2 Hình & bảng

- đảm bảo không có “broken figure”
- figure nên là vector (PDF/SVG) khi camera-ready
- bảng cần caption chuẩn, thống nhất đơn vị (%), thống nhất “dev set”

### 6.3 Tài liệu tham khảo

- tất cả citation trong bài phải có trong refs
- format theo template venue (IEEE/Springer/ACM…)

---

## 7) Lộ trình thực dụng để lên 10/10 (khuyến nghị)

### 7.1 Gói nâng cấp tối thiểu (để đạt “đủ nộp Q3”)

- Thêm baseline (zero-shot, CoT, 4-step, 6-step, + optional single-agent filtered schema)
- Thêm ablation số liệu: –Planner, –Refiner, –SchemaSelector
- Thêm stratified eval theo độ khó hoặc pattern
- Thêm cost (tokens/latency)
- Thêm thống kê lỗi (distribution + absolute)
- Dọn sạch reproducibility (không placeholder)

### 7.2 Gói nâng cấp mạnh (để reviewer “khó bắt bẻ”)

- stability (mean±std)
- 2–3 case study có log artifact
- figure: EX vs tokens (trade-off)

---

## 8) Định nghĩa “10/10” trong 1 câu

Bài đạt “10/10 Q3” khi bạn có thể trả lời chắc chắn 3 câu hỏi reviewer hay hỏi nhất:

- **(Q1) Vì sao pipeline này mới/đáng publish, khác gì so với “prompting + self-correction” thông thường?**
- **(Q2) Thành phần nào giúp thật (Planner hay Refiner hay SchemaSelector), bằng chứng định lượng đâu?**
- **(Q3) Có tái lập không, chi phí tăng bao nhiêu, và cải thiện xảy ra ở nhóm truy vấn nào?**

