# Chi tiết Kỹ thuật Hệ thống NL2SQL Multi-Agent (Dự án "multi-agent-sql")

## 📋 Tổng quan

Dự án "multi-agent-sql" là một nghiên cứu toàn diện nhằm thiết kế, triển khai và đánh giá ba kiến trúc Multi-Agent khác nhau cho việc chuyển đổi ngôn ngữ tự nhiên thành SQL (NL2SQL). Mục tiêu chính là tìm ra sự cân bằng tối ưu giữa **độ chính xác**, **thời gian thực thi** và **chi phí** trên bộ dữ liệu Spider. Dự án này cung cấp một framework có khả năng mở rộng để phát triển và so sánh các hệ thống NL2SQL Multi-Agent.

## 🏗️ Kiến trúc Hệ thống Multi-Agent

Hệ thống này được xây dựng dựa trên một kiến trúc module hóa, nơi các agent AI chuyên biệt cộng tác để xử lý câu hỏi ngôn ngữ tự nhiên và tạo ra truy vấn SQL. Các agent được định nghĩa rõ ràng về vai trò, mục tiêu và bối cảnh (prompt) để thực hiện nhiệm vụ của mình. Các mô hình khác nhau được xây dựng bằng cách kết hợp các agent này theo các luồng công việc (workflow) riêng biệt. Tất cả các agent đều sử dụng mô hình ngôn ngữ lớn **Gemini 2.0 Flash** để đảm bảo tính nhất quán và hiệu suất.

### 💡 Các Agent Chính và Vai trò của chúng

Dự án định nghĩa sáu loại agent chính, mỗi loại có một nhiệm vụ cụ thể trong quá trình chuyển đổi NL2SQL:

#### 1. Query Refinement Agent
*   **Vai trò:** Chuyên gia tinh chỉnh câu hỏi. 
*   **Mục tiêu:** Làm rõ câu hỏi ngôn ngữ tự nhiên, làm cho nó rõ ràng, đầy đủ và không mơ hồ, đồng thời bảo toàn ý định gốc.
*   **Nhiệm vụ:** Biến thông tin ngụ ý thành rõ ràng, giải quyết các tham chiếu mơ hồ, thêm ngữ cảnh còn thiếu, làm rõ định dạng đầu ra mong muốn. Đặc biệt hữu ích trong các kịch bản hội thoại hoặc khi câu hỏi ban đầu không đầy đủ.
*   **Sử dụng trong:** Mô hình 6 bước.

#### 2. Entity Recognition Agent
*   **Vai trò:** Chuyên gia nhận diện thực thể.
*   **Mục tiêu:** Xác định tất cả các thực thể cơ sở dữ liệu được đề cập hoặc ngụ ý trong câu hỏi ngôn ngữ tự nhiên.
*   **Nhiệm vụ:** Nhận diện tên bảng, tên cột, giá trị cụ thể (số, chuỗi, ngày tháng) và các mối quan hệ giữa các thực thể. Có khả năng xử lý các từ đồng nghĩa, biến thể chính tả và các thực thể ngụ ý cần thiết cho truy vấn SQL.
*   **Sử dụng trong:** Mô hình 6 bước.

#### 3. Question Analyzer Agent
*   **Vai trò:** Chuyên gia phân tích câu hỏi.
*   **Mục tiêu:** Phân tích câu hỏi ngôn ngữ tự nhiên để hiểu ý định truy vấn, mức độ phức tạp và các thực thể cơ sở dữ liệu cần thiết.
*   **Nhiệm vụ:** Xác định loại thao tác cần thiết (COUNT, LIST, MAX/MIN, AGGREGATION, COMPARISON, JOIN), mức độ khó (EASY, MEDIUM, HARD), các bảng, cột và giá trị liên quan. Trong các mô hình nâng cao, agent này còn sử dụng kết quả từ Query Refinement và Entity Recognition để phân tích sâu hơn.
*   **Sử dụng trong:** Mô hình 4 bước và 6 bước.

#### 4. Schema Selector Agent
*   **Vai trò:** Chuyên gia lọc lược đồ cơ sở dữ liệu.
*   **Mục tiêu:** Lọc lược đồ cơ sở dữ liệu để chỉ bao gồm các bảng và cột thực sự cần thiết để trả lời câu hỏi.
*   **Nhiệm vụ:** Dựa trên phân tích câu hỏi và nhận diện thực thể, agent này loại bỏ các thành phần lược đồ không liên quan, giữ lại các khóa chính và khóa ngoại cần thiết cho các phép nối, từ đó giảm độ phức tạp của lược đồ đầu vào cho agent sinh SQL.
*   **Sử dụng trong:** Mô hình 4 bước và 6 bước.

#### 5. SQL Expert Agent
*   **Vai trò:** Chuyên gia tạo truy vấn SQL.
*   **Mục tiêu:** Tạo ra truy vấn SQL chính xác, đầy đủ và có thể thực thi từ câu hỏi và lược đồ cơ sở dữ liệu.
*   **Nhiệm vụ:** Tổng hợp thông tin từ các agent trước đó (câu hỏi gốc/tinh chỉnh, lược đồ đã lọc, phân tích câu hỏi, thực thể đã nhận diện) để xây dựng truy vấn SQL. Agent này được trang bị các quy tắc chi tiết để chọn trường, thực hiện JOIN, GROUP BY, COUNT, và đảm bảo định dạng SQL là một dòng duy nhất và hoàn chỉnh. Các quy tắc này được tối ưu hóa dựa trên phân tích lỗi phổ biến.
*   **Sử dụng trong:** Tất cả các mô hình (3, 4, 6 bước).

#### 6. SQL Validator Agent
*   **Vai trò:** Chuyên gia xác thực và sửa lỗi SQL.
*   **Mục tiêu:** Kiểm tra và sửa lỗi truy vấn SQL được tạo ra để đảm bảo nó đúng cú pháp, logic và có thể thực thi.
*   **Nhiệm vụ:** Thực hiện kiểm tra toàn diện bao gồm cú pháp, sự tồn tại của bảng/cột trong schema, tính đúng đắn của logic (JOIN, WHERE, AGGREGATION), và khả năng thực thi. Nếu phát hiện lỗi, agent sẽ cố gắng sửa chữa dựa trên các quy tắc được định sẵn (ví dụ: sửa lỗi chọn trường, đơn giản hóa JOIN, sửa lỗi `UNION` vs `OR`, định dạng SQL). Nếu không thể sửa, nó sẽ cung cấp thông báo lỗi.
*   **Sử dụng trong:** Tất cả các mô hình (3, 4, 6 bước).

### ⚙️ Các Mô hình Multi-Agent đã triển khai

Dự án triển khai ba mô hình Multi-Agent chính, mỗi mô hình là một sự kết hợp khác nhau của các agent trên, đại diện cho các mức độ phức tạp và hiệu suất khác nhau:

#### 1. Mô hình 3 bước: Lightweight
*   **Luồng công việc:** `Natural Language Question & Full Schema → SQL Expert → SQL Validator → Final SQL`
*   **Mô tả:** Đây là mô hình đơn giản nhất, tập trung vào tốc độ và chi phí thấp. SQL Expert trực tiếp nhận câu hỏi và toàn bộ schema để tạo SQL, sau đó SQL Validator thực hiện kiểm tra và sửa lỗi cơ bản.
*   **Agent sử dụng:** `SQL Expert`, `SQL Validator`.
*   **Đặc điểm:** Nhanh nhất, chi phí thấp nhất, độ chính xác cơ bản, phù hợp cho các trường hợp thử nghiệm nhanh hoặc ứng dụng đơn giản.

#### 2. Mô hình 4 bước: Balanced
*   **Luồng công việc:** `Natural Language Question & Full Schema → Question Analyzer → Filtered Schema → SQL Expert → Validated SQL → SQL Validator → Final SQL`
*   **Mô tả:** Mô hình này bổ sung các bước phân tích câu hỏi và lọc schema để cải thiện độ chính xác. `Question Analyzer` hiểu ý định, và `Schema Selector` giảm tải thông tin không cần thiết cho `SQL Expert`.
*   **Agent sử dụng:** `Question Analyzer`, `Schema Selector`, `SQL Expert`, `SQL Validator`.
*   **Đặc điểm:** Cân bằng tốt giữa độ chính xác, thời gian và chi phí. Được xem là lựa chọn tối ưu cho các hệ thống NL2SQL trong môi trường production tiêu chuẩn.

#### 3. Mô hình 6 bước: Enhanced
*   **Luồng công việc:** `Natural Language Question & Full Schema → Query Refinement → Entity Recognition → Question Analyzer → Filtered Schema → SQL Expert → Validated SQL → SQL Validator → Final SQL`
*   **Mô tả:** Mô hình phức tạp nhất, được thiết kế để đạt độ chính xác cao nhất. Nó thêm các bước tiền xử lý như `Query Refinement` để làm rõ câu hỏi và `Entity Recognition` để nhận diện chính xác các thực thể, cung cấp ngữ cảnh phong phú hơn cho các agent sau. 
*   **Agent sử dụng:** `Query Refinement`, `Entity Recognition`, `Question Analyzer`, `Schema Selector`, `SQL Expert`, `SQL Validator`.
*   **Đặc điểm:** Độ chính xác cao nhất, nhưng đi kèm với thời gian phản hồi lâu hơn và chi phí cao hơn do số lượng bước và lệnh gọi API tăng lên. Phù hợp cho các ứng dụng đòi hỏi độ chính xác tuyệt đối.

## 🛠️ Quy trình thực nghiệm và Đánh giá

Dự án này bao gồm một quy trình benchmark tự động để đánh giá và so sánh hiệu suất của ba mô hình. Quy trình này được thiết kế để đảm bảo tính nhất quán và khách quan:

1.  **Chuẩn bị dữ liệu:** Tải 50 câu hỏi từ bộ dữ liệu Spider (được phân loại Easy, Medium, Hard) từ một database nhất quán.
2.  **Chạy từng mô hình độc lập:** Mỗi mô hình được chạy riêng biệt trên cùng một tập 50 câu hỏi. Các metrics như thời gian thực thi, số lệnh gọi API và kết quả SQL được thu thập cho mỗi câu hỏi.
3.  **Xác thực SQL với `test-suite-sql-eval`:** Các truy vấn SQL được tạo ra từ mỗi mô hình được so sánh với các truy vấn SQL vàng (ground truth) bằng cách sử dụng công cụ đánh giá `test-suite-sql-eval`. Công cụ này cung cấp các chỉ số quan trọng như Execution Accuracy và Exact Match Rate.
4.  **Thu thập và so sánh metrics:** Các metrics từ mỗi mô hình và từ quá trình đánh giá được tổng hợp. Dự án cung cấp các script để so sánh và tạo báo cáo chi tiết về hiệu suất của các mô hình trên các tiêu chí độ chính xác, thời gian và chi phí.

## 🌟 Lợi ích của Framework này

*   **Tính module hóa cao:** Cho phép dễ dàng thêm, bớt hoặc thay thế các agent và mô hình mà không ảnh hưởng đến toàn bộ hệ thống.
*   **Khả năng so sánh:** Cung cấp một framework chuẩn hóa để so sánh hiệu suất của các kiến trúc Multi-Agent khác nhau một cách khách quan.
*   **Tính linh hoạt:** Có thể mở rộng để tích hợp các LLM khác hoặc các công cụ bổ sung cho từng agent.
*   **Tối ưu hóa:** Hỗ trợ việc tinh chỉnh prompt và logic của agent để cải thiện hiệu suất trên các tác vụ NL2SQL cụ thể.

Dự án "multi-agent-sql" đóng vai trò là một nền tảng mạnh mẽ để nghiên cứu và phát triển các hệ thống NL2SQL tiên tiến, tận dụng tối đa sức mạnh của các mô hình ngôn ngữ lớn thông qua kiến trúc Multi-Agent.
