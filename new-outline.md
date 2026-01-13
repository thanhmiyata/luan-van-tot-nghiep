# OUTLINE CUỐI CÙNG – BÀI HỘI NGHỊ NL2SQL (22–25 TRANG)

## Title (KHÔNG overclaim – an toàn cho reviewer)

**A Modular Multi-Agent Framework for Evaluating and Refining Text-to-SQL Generation**

> *Tránh các từ:* “enhancing accuracy”, “significantly improves”, “state-of-the-art”

---

## Abstract (≈ 180–220 từ)

* Bối cảnh: NL2SQL với LLM còn gặp lỗi ở truy vấn phức tạp (schema linking, planning).
* Vấn đề: Các hệ hiện tại thiếu **framework đánh giá có cấu trúc** để phân tích vai trò từng thành phần.
* Giải pháp:

  * Đề xuất **framework NL2SQL đa tác nhân, cấu hình được pipeline**.
  * Hỗ trợ **đánh giá và ablation có hệ thống** thông qua các cấu hình pipeline khác nhau.
* Thực nghiệm:

  * Đánh giá trên Spider 1.0.
  * So sánh cấu hình base (4 bước) và full (6 bước).
* Kết quả:

  * Cấu hình 6 bước đạt Execution Accuracy 84.1%, cao hơn cấu hình base.
* Đóng góp:

  * Framework + ablation + phân tích lỗi.

👉 *Không đưa FSED, không so SOTA trong abstract.*

---

## 1. Introduction (1 – 1.5 trang)

### 1.1 Problem Context

* NL2SQL là bài toán trung tâm trong giao diện ngôn ngữ tự nhiên cho CSDL.
* LLM đạt tiến bộ, nhưng vẫn gặp lỗi:

  * chọn trường (field selection),
  * lập kế hoạch truy vấn,
  * truy vấn nhiều bảng.

### 1.2 Motivation

* Phần lớn nghiên cứu tập trung:

  * cải thiện prompt hoặc model,
  * nhưng **thiếu framework** để:

    * cấu hình pipeline,
    * phân tích vai trò từng bước,
    * thực hiện ablation có hệ thống.

### 1.3 Our Approach (high-level)

* Đề xuất **framework đa tác nhân** cho NL2SQL:

  * Cho phép cấu hình pipeline theo số bước.
  * Hỗ trợ đánh giá và ablation.

### 1.4 Contributions (RẤT QUAN TRỌNG – viết rõ)

* **C1:** Đề xuất **framework NL2SQL đa tác nhân có cấu hình pipeline**, tách rõ các pha phân tích, lập kế hoạch và tinh chỉnh.
* **C2:** Thiết kế **quy trình đánh giá và ablation** cho NL2SQL dựa trên Execution Accuracy và Exact Match.
* **C3:** Thực nghiệm trên Spider 1.0 cho thấy vai trò của các thành phần trong pipeline mở rộng (6 bước).

> ⚠️ Không nói “SOTA”, không nói “significant improvement”.

---

## 2. Related Work (1.5 – 2 trang)

### 2.1 Text-to-SQL Systems

* Truyền thống: seq2seq, schema linking.
* Gần đây: LLM-based (C3, DIN-SQL, DAIL-SQL).

### 2.2 Multi-Agent and Tool-Augmented LLMs

* Multi-agent reasoning, decomposition.
* Thiếu ứng dụng có **framework đánh giá chuyên biệt cho NL2SQL**.

### 2.3 Gap Analysis

* Các công trình trước:

  * tập trung kết quả cuối,
  * ít phân tích vai trò từng thành phần.
* **Khoảng trống:** thiếu framework hỗ trợ ablation & error analysis.

---

## 3. Framework and Methodology (6 – 7 trang)

*(PHẦN CỐT LÕI – ĐỪNG CẮT)*

### 3.1 Problem Definition

* Định nghĩa NL2SQL.
* Đầu vào, đầu ra.
* Metrics: EM, Execution Accuracy (định nghĩa ngắn).

### 3.2 Framework Overview

* **Hình 1:** Kiến trúc tổng thể framework.
* Pipeline gồm nhiều agent, xử lý tuần tự.

### 3.3 Modular Pipeline Design

#### 3.3.1 Phase 1: Analysis & Schema Linking

* Question Analyzer
* Schema Selector

#### 3.3.2 Phase 2: Planning & SQL Generation

* Query Planner
* SQL Generator (Expert)

#### 3.3.3 Phase 3: Refinement & Validation

* SQL Refiner
* SQL Validator (chỉ kiểm tra, không sửa logic)

### 3.4 Pipeline Configurations

* **Base configuration (4-step):**

  * bỏ Phase Planning & Refinement.
* **Full configuration (6-step):**

  * đầy đủ các agent.

⚠️ **KHÔNG gọi 4-step là baseline.**

### 3.5 Algorithm

* Giữ **Algorithm 1 (Pseudo-code)**:

  * pipeline execution
  * agent invocation
  * output aggregation

---

## 4. Experimental Evaluation (6 – 7 trang)

### 4.1 Experimental Setup

* Dataset: Spider 1.0 (1034 câu).
* Model settings.
* Evaluation protocol.

### 4.2 Main Results

* **Bảng 1:** Base (4-step) vs Full (6-step).
* Nhận xét: full configuration ổn định hơn với truy vấn phức tạp.

### 4.3 Ablation Study (BẮT BUỘC – ĐÚNG Ý THẦY)

* Full (6-step) làm mốc.
* Loại bỏ từng thành phần:

  * –Planner
  * –Refiner
  * –Validator
* Phân tích mức suy giảm hiệu năng.
* Kết luận: thành phần nào là cần thiết.

---

## 5. Error Analysis (2 – 3 trang)

### 5.1 Error Taxonomy

* Field selection
* Join path
* Aggregation
* Value grounding

### 5.2 Observations

* Lỗi field selection chiếm tỷ lệ lớn trong cấu hình base.
* Refiner giúp giảm lỗi này.

> **FSED xuất hiện lần đầu ở đây**, nếu cần.

---

## 6. Discussion (1 – 1.5 trang)

* Trade-off:

  * hiệu năng vs chi phí/tokens.
* Tính tổng quát của framework.
* Ứng dụng cho các hệ NL2SQL khác.

---

## 7. Conclusion & Future Work (≈ 1 trang)

* Tóm tắt đóng góp.
* Framework hướng tới:

  * benchmark,
  * nghiên cứu ablation,
  * mở rộng dataset.

---

## Appendix / Supplementary (KHÔNG TÍNH TRANG)

* Prompt templates.
* Cấu hình YAML.
* Ví dụ SQL dài.
* Link GitHub framework.

---

# 📌 TỔNG KẾT CHO ANH

* Outline này:

  * ✔ đúng **100% ý thầy**
  * ✔ reviewer-safe
  * ✔ viết xong là gửi hội nghị được
* Anh chỉ cần:

  * Viết theo outline này,
  * **KHÔNG thêm nội dung ngoài khung**.