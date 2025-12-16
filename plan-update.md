## Paper update plan (NL2SQL multi-agent)

- **1. Hoàn thiện đánh giá Spider**
  - Chạy Spider 1.0 **test** với official evaluator, lưu lại: phiên bản evaluator, seed, decoding (temperature, top_p, retries).
  - Báo cáo **EM/EX** dev và test, kèm **breakdown theo mức độ khó** (Easy/Medium/Hard/Extra Hard).
  - Bổ sung vào Section 4 (Experimental Setup & Results), cập nhật Abstract/Conclusion để bỏ các “TODO”.

- **2. Mở rộng baseline so sánh**
  - Thêm ít nhất các baseline sau trên Spider dev (+ test nếu khả thi):
    - **Single-agent LLM mạnh**: prompt tốt nhất cho GPT-4/Gemini/Qwen2.5-Coder.
    - **Constrained decoding**: PICARD hoặc biến thể tương đương (ít nhất dùng số liệu công bố nếu không tự chạy được).
    - **Schema-linking mạnh**: Lựa chọn 1 trong 2: (a) SchemaGraphSQL-style path enumeration; (b) RSL-SQL (dùng số liệu paper + thảo luận khác biệt setting).
    - **Multi-turn correction**: E-SQL hoặc SQL-of-Thought hoặc DeepEye-SQL (ít nhất so sánh bằng số liệu đã công bố).
  - Thêm bảng tổng hợp: 4-step (ours), 6-step (ours), + các baseline trên, ghi rõ split, evaluator, backbone.

- **3. Củng cố phân tích lỗi field selection (52.6%)**
  - Trình bày **ngắn gọn trong main text** (Methodology / Results), không chỉ để ở Appendix:
    - Kích thước mẫu (N=180, stratified theo độ khó).
    - Taxonomy lỗi (missing/wrong/extra/wrong order/wrong aggregation).
    - Cohen’s κ và tỉ lệ 52.6% field-selection.
  - Bổ sung bảng “trước vs sau” cho **field-selection**:
    - Column-set precision/recall/F1 và ordering accuracy cho 4-step vs 6-step.
    - Breakdown theo loại lỗi SELECT (missing, wrong, extra, order).

- **4. Single-pass vs multi-turn execution-feedback**
  - Mở rộng ablation §3.8/§4.0.8:
    - So sánh trên **toàn Spider dev** (không chỉ Hard/Extra Hard):  
      - 6-step single-pass (hiện tại).  
      - 6-step + 1 vòng exec-feedback (PICARD-like + execution-guided repair).  
    - Báo cáo EM/EX + cost/latency/tokens cho mỗi variant.
  - Viết rõ kết luận trong Discussion:
    - Multi-turn cho +ΔEX bao nhiêu % so với single-pass.  
    - Đổi lại cost/latency tăng bao nhiêu %.  
    - Lý do chọn single-pass là “sweet-spot” cho setting chi phí/latency.

- **5. Schema Selector vs schema-linking baselines**
  - Thêm 2–3 cấu hình linking:
    - LLM-based Schema Selector (hiện tại).
    - Deterministic path-enumeration (SchemaGraphSQL-style, high recall).
    - No filtering (full schema).
  - Đo:
    - **Recall/precision** tables/columns cho mỗi cấu hình.
    - EM/EX downstream tương ứng.
  - Phân tích: khi Selector bỏ sót bảng/cột → lỗi nào tăng; khi không lọc → EX giảm vì nhiễu context.

- **6. Làm rõ SQL Validator & deterministic checks**
  - Trong Methodology, mô tả gọn 3–4 loại **rule deterministic**:
    - JOIN key consistency (PK/FK).
    - GROUP BY completeness cho non-aggregated SELECT columns.
    - Set-op arity/type alignment với UNION/INTERSECT/EXCEPT.
    - COUNT vs COUNT(DISTINCT) cho thực thể vs record.
  - Nhấn mạnh bảng ablation 4.0.3 (No validator / Syntax-only / Syntax+constraints / Execution-guided).
  - Nếu khả thi, thử tích hợp PICARD đầy đủ hoặc ghi rõ mức độ tương thích hiện tại.

- **7. Đánh giá độ nhạy backbone & tăng reproducibility**
  - Chạy pipeline 4-step và 6-step với **ít nhất 1 backbone open-source** (Qwen2.5-Coder, DeepSeek-Coder, v.v.):
    - Có thể chỉ trên Spider dev (hoặc subset nếu chi phí hạn chế, ghi rõ).  
    - Báo cáo: EM/EX tuyệt đối + chênh lệch 4-step vs 6-step.
  - Chuẩn bị kế hoạch **công bố**:
    - Prompts chính cho 6 agent.  
    - Cấu hình CrewAI (YAML/JSON).  
    - Script chạy Spider official evaluator (dev + test).

- **8. Phân tích chi phí/độ trễ (4-step vs 6-step vs multi-turn)**
  - Chuẩn hóa bảng cost/latency:
    - ms/query, tokens/query, USD/1k queries cho: 4-step, 6-step, 6-step+exec-feedback, (nếu có) multi-turn baseline.  
  - Gắn kết quả này với kết luận về single-pass refinement trong Discussion/Conclusion.

- **9. Tinh chỉnh positioning & viết lại phần text**
  - Xóa/giảm các câu mang tính “novelty mạnh”, chuyển sang giọng điệu “engineering synthesis”:
    - Nhấn mạnh: đóng góp chính là **thiết kế multi-agent, field-selection-first + single-pass refinement** và **phân tích lỗi có hệ thống**.
  - Cập nhật Abstract/Conclusion để:
    - Báo cáo kết quả dev + test (không còn TODO).  
    - Nêu rõ giới hạn: chưa cover hết multi-turn SOTA, exec-RL như SQL-R1, v.v.

- **10. Chuẩn bị trả lời reviewer / camera-ready**
  - Soạn câu trả lời cho từng nhóm câu hỏi trong review (field-selection 52.6%, Validator, test-set, backbone, schema-linking, single-pass vs multi-pass, release code).  
  - Kiểm tra lại toàn bộ số liệu, bảng, ký hiệu trùng khớp (References, Appendix, Tables X/Y/W/V, v.v.).


