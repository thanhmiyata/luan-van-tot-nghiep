# Project Memory - Last Updated: 2026-04-16

## Trạng thái hiện tại

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
