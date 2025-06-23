# Kế hoạch thực hiện đề tài: Sinh truy vấn SQL từ ngôn ngữ tự nhiên

# **1\. Các bước thực hiện**

| Tháng | Giai đoạn | Nội dung công việc | Kết quả / Ghi chú |
| ----- | ----- | ----- | ----- |
| Tháng 1 | Khảo sát | Tìm hiểu nghiên cứu hiện tại về Text-to-SQL, Multi-Agent LLM, tập benchmark | Tổng hợp 5–10 bài báo liên quan, có bảng so sánh mô hình, phương pháp |
| Tháng 2 | Chuẩn bị dữ liệu | Phân tích lựa chọn schema benchmark (Spider) và schema thực tế (dvdrental); phân loại các dạng truy vấn SQL | Danh sách truy vấn phân tầng độ khó; sơ đồ quan hệ bảng |
| Tháng 3 | Xây baseline | Triển khai mô hình LLM đơn (Single-Agent) dùng GPT để xử lý đầu vào → SQL | Có pipeline đầu vào → SQL chạy được, test sơ bộ |
| Tháng 3 | Xây hệ thống Multi-Agent | Tách agent: hiểu yêu cầu, ánh xạ schema, sinh SQL, phản biện; phối hợp agent bằng rule hoặc prompt | Hệ thống phối hợp hoàn chỉnh (rule-based hoặc tự động) |
| Tháng 4 | Thực nghiệm 1 | Chạy test trên benchmark (Spider); so sánh Single vs Multi Agent | Log kết quả, đánh giá theo từng loại truy vấn (SELECT, JOIN, GROUP...) |
| Tháng 4 | Thực nghiệm 2 | Chạy test trên schema thực tế (dvdrental); mô phỏng tình huống thực tế | So sánh performance của các agent và các mô hình GPT/Gemini/... |
| Tháng 5 | Đánh giá & tổng hợp | Tổng hợp kết quả, tạo bảng so sánh, biểu đồ, viết phần phân tích | Có kết quả để viết báo \+ làm luận văn |
| Tháng 5 | Viết bài báo | Viết bài báo khoa học dựa trên thực nghiệm; nộp hội nghị (KSE, VLSP,...) | Bài báo hoàn chỉnh |
| Tháng 6 | Viết luận văn & fine tune | Viết báo cáo luận văn, hoàn thiện hệ thống demo, slide thuyết trình | Sản phẩm cuối |

#  **2\. Thực nghiệm**

Thực nghiệm theo 1 trong 2 hướng:

### **Hướng 1 – Benchmark-based Evaluation**

* Sử dụng tập dữ liệu **Spider** – một benchmark phổ biến cho bài toán chuyển ngôn ngữ tự nhiên thành SQL.

* Các truy vấn được **phân loại theo độ phức tạp**:

  * `SELECT` đơn giản

  * `WHERE`, `ORDER BY`

  * `JOIN` nhiều bảng

  * `GROUP BY`, `HAVING`

  * `NESTED SELECT`, `AGGREGATE`

* Thử nghiệm trên cả:

  * **Single-agent**: 1 LLM xử lý toàn bộ quy trình

  * **Multi-agent**: các LLM thực hiện riêng từng vai trò và phối hợp

### **Hướng 2 – Task-based Evaluation (Ứng dụng thực tế)**

* Dùng một schema thực tế.

* Các câu hỏi được tạo ra bằng:

  * GPT hỗ trợ sinh dữ liệu đầu vào (NL → SQL)

  * Mô phỏng câu hỏi thật từ phía người dùng cuối

* Mục tiêu: kiểm tra **tính thực tiễn** khi hệ thống ứng dụng vào ngữ cảnh nghiệp vụ thật (như chatbot dữ liệu).

### **Đa dạng mô hình (LLM)**

* Thử nghiệm mỗi agent bằng **nhiều LLM khác nhau**: GPT-4, Claude, Gemini, DeepSeek...

* Có thể kết hợp:

  * Tất cả agent dùng cùng một LLM

  * Mỗi agent dùng một LLM khác nhau → so sánh hiệu quả đa mô hình

\=\>\>Có thể thực nghiệm Multi-agent chỉ thuộc về 1 trong các LLM như GPT, Gemini, Grok, ..

# **3\. Đánh giá – So sánh**

| Tiêu chí | Giải thích | Cách đo |
| ----- | ----- | ----- |
| Độ chính xác (Accuracy) | Truy vấn SQL sinh ra có đúng logic như yêu cầu không? | So sánh với SQL chuẩn hoặc kết quả thực thi (result set) |
| Thời gian phản hồi (Latency) | Tốc độ từ lúc nhận câu hỏi đến khi trả truy vấn | Đo bằng time.time() trong thực nghiệm |
| Độ đúng cú pháp | Truy vấn có lỗi cú pháp hay không | Thực thi câu SQL bằng PostgreSQL hoặc trình giả lập |
| Giải thích truy vấn (Explainability) | Hệ thống có diễn giải được câu SQL dễ hiểu không | So với mô tả mong muốn của người dùng |
| Hiệu quả phối hợp agent | So sánh giữa Single-agent và Multi-agent | Tỷ lệ đúng, số lỗi giảm, thời gian xử lý |
| Độ phù hợp thực tế | Hệ thống dùng được trong tình huống nghiệp vụ không? | Đánh giá thủ công khi chạy trên schema như dvdrental |

