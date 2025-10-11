# Chi tiết Kỹ thuật Hệ thống NL2SQL Multi-Agent (Mô hình 4 bước - CrewAI)

## 📋 Tổng quan

Dự án `experiment3_multi_agent_crewai` triển khai một hệ thống Chuyển đổi Ngôn ngữ Tự nhiên sang SQL (NL2SQL) sử dụng kiến trúc Multi-Agent với thư viện CrewAI. Hệ thống này được thiết kế để nhận các câu hỏi bằng ngôn ngữ tự nhiên và lược đồ cơ sở dữ liệu, sau đó tạo ra các truy vấn SQL tương ứng. Hệ thống tập trung vào việc xử lý các câu hỏi từ bộ dữ liệu Spider, một tập dữ liệu chuẩn lớn cho nhiệm vụ Text-to-SQL.

Đáng chú ý, mặc dù tài liệu README có thể gợi ý về một số lượng agent khác, phân tích cấu hình (`agents.yaml` và `tasks.yaml`) cho thấy đây là một triển khai của mô hình **4 bước (Balanced)** đã được đề cập trong kế hoạch thực nghiệm, bao gồm bốn agent chuyên biệt hợp tác với nhau.

## 🏗️ Kiến trúc Hệ thống (Mô hình 4 bước)

Hệ thống NL2SQL Multi-Agent này hoạt động theo một quy trình tuần tự gồm bốn bước chính, mỗi bước được thực hiện bởi một agent AI chuyên biệt, tất cả đều được hỗ trợ bởi mô hình ngôn ngữ lớn **Gemini 2.0 Flash**. Kiến trúc này đảm bảo tính nhất quán về hiệu suất và tối ưu hóa chi phí.

```
Natural Language Question & Raw Schema → Question Analyzer → Filtered Schema → SQL Expert → Validated SQL → SQL Validator → Final SQL
```

### 💡 Chi tiết các Agent và Nhiệm vụ

Mỗi agent trong hệ thống được định nghĩa với một vai trò (role) cụ thể, mục tiêu (goal) rõ ràng và một bối cảnh (backstory) cung cấp các hướng dẫn chi tiết và quy tắc nghiệp vụ để thực hiện nhiệm vụ của mình. Tất cả các agent đều sử dụng cùng một mô hình ngôn ngữ lớn là `gemini/gemini-2.0-flash`.

#### 1. Question Analyzer Agent
*   **Vai trò:** Question Analysis Expert with Field Selection Focus
*   **Mục tiêu:** Phân tích câu hỏi để xác định ý định, độ phức tạp và **ĐẶC BIỆT QUAN TRỌNG:** xác định chính xác các trường (fields) nên được trả về trong truy vấn SQL.
*   **Bối cảnh:** Agent này là một chuyên gia phân tích câu hỏi, với nhiệm vụ chính là xác định các trường đầu ra, ý định truy vấn (COUNT, LIST, MAX_MIN, AGGREGATION), độ khó (EASY, MEDIUM, HARD) và các thực thể liên quan (bảng, cột, giá trị, và quan trọng nhất là các trường trong mệnh đề SELECT).
*   **Input:** Câu hỏi ngôn ngữ tự nhiên, lược đồ CSDL thô.
*   **Output:** Một đối tượng JSON chứa phân tích câu hỏi, bao gồm ý định, độ phức tạp, các trường đầu ra mong muốn (`expected_output_fields`), các bảng/cột/giá trị liên quan và điểm tin cậy.
*   **Ví dụ quy tắc:** Nếu câu hỏi là "Find courses", agent sẽ xác định trường trả về là `course_id` (chứ không phải `title` trừ khi được yêu cầu rõ ràng).

#### 2. Schema Selector Agent
*   **Vai trò:** Database Schema Filter Expert
*   **Mục tiêu:** Lọc và chỉ giữ lại các bảng và cột cần thiết từ lược đồ cơ sở dữ liệu để trả lời câu hỏi.
*   **Bối cảnh:** Agent này là một chuyên gia phân tích lược đồ CSDL, có nhiệm vụ hiểu câu hỏi, xác định các bảng và cột cần thiết, giữ lại các khóa chính và khóa ngoại để nối bảng (JOIN), và loại bỏ các thành phần không liên quan.
*   **Input:** Câu hỏi ngôn ngữ tự nhiên, lược đồ CSDL gốc, và kết quả phân tích từ `Question Analyzer`.
*   **Output:** Một đối tượng JSON chứa lược đồ CSDL đã được lọc, giữ nguyên định dạng của lược đồ gốc nhưng chỉ bao gồm các thành phần liên quan.
*   **Ví dụ quy tắc:** Nếu phân tích câu hỏi chỉ ra các bảng `student` và `instructor` là cần thiết, agent sẽ loại bỏ các bảng khác khỏi lược đồ.

#### 3. SQL Expert Agent
*   **Vai trò:** SQL Query Generator Expert
*   **Mục tiêu:** Tạo ra truy vấn SQL chính xác, đầy đủ và có thể thực thi từ câu hỏi và lược đồ cơ sở dữ liệu. Luôn trả về SQL một dòng duy nhất không có ngắt dòng.
*   **Bối cảnh:** Là một chuyên gia viết truy vấn SQL, agent này được cung cấp một bộ quy tắc rất chi tiết (dựa trên phân tích lỗi) để đảm bảo chất lượng SQL. Các quy tắc này bao gồm:
    *   **Chọn trường:** Cực kỳ ưu tiên các trường đầu ra được xác định bởi `Question Analyzer`, duy trì đúng thứ tự.
    *   **Đơn giản hóa:** Tránh các phép nối không cần thiết, ưu tiên truy cập trực tiếp bảng nếu tất cả các cột cần thiết nằm trong một bảng.
    *   **Logic UNION vs OR:** Hướng dẫn sử dụng `UNION` cho các tập kết quả khác nhau từ cùng một bảng và `OR` cho các điều kiện lọc trong một bảng.
    *   **Logic COUNT:** Quy tắc về `COUNT(*)` và `COUNT(DISTINCT)`.
    *   **Định dạng SQL:** Luôn trả về truy vấn SQL hoàn chỉnh, có thể thực thi và là một dòng duy nhất.
*   **Input:** Câu hỏi ngôn ngữ tự nhiên, lược đồ CSDL đã lọc, và kết quả phân tích từ `Question Analyzer`.
*   **Output:** Một đối tượng JSON chứa truy vấn SQL được sinh ra (`sql` field).

#### 4. SQL Validator Agent
*   **Vai trò:** SQL Validator and Fixer
*   **Mục tiêu:** Kiểm tra và sửa lỗi truy vấn SQL để đảm bảo nó có thể được thực thi. Từ chối các đoạn SQL không hoàn chỉnh và sửa các vấn đề về định dạng.
*   **Bối cảnh:** Là một chuyên gia kiểm tra và sửa lỗi SQL, agent này có các nhiệm vụ sau:
    *   **Xác thực chọn trường:** Đảm bảo các trường trong mệnh đề SELECT khớp với phân tích ban đầu.
    *   **Kiểm tra cú pháp:** Xác định và sửa lỗi cú pháp SQL.
    *   **Kiểm tra tên bảng/cột:** Đảm bảo các tên bảng và cột tồn tại trong lược đồ.
    *   **Kiểm tra logic:** Đảm bảo logic JOIN và điều kiện WHERE là chính xác.
    *   **Khả năng thực thi:** Đảm bảo truy vấn có thể chạy trên CSDL.
    *   **Sửa lỗi:** Bao gồm sửa lỗi chọn trường, tên bảng/cột, JOIN, logic COUNT, định dạng, và đơn giản hóa truy vấn.
    *   **Từ chối các đoạn SQL không hoàn chỉnh:** Không chấp nhận các truy vấn không đầy đủ.
*   **Input:** Truy vấn SQL đã sinh ra từ `SQL Expert`, câu hỏi ngôn ngữ tự nhiên, và lược đồ CSDL đã lọc.
*   **Output:** Một đối tượng JSON chứa truy vấn SQL đã được xác thực/sửa (`sql` field), giải thích về truy vấn (`explain` field), và thông báo lỗi nếu không thể sửa được (`error` field).

## 🛠️ Luồng công việc (Workflow)

1.  **Khởi tạo:** Hệ thống nhận câu hỏi ngôn ngữ tự nhiên và lược đồ cơ sở dữ liệu đầy đủ.
2.  **Phân tích câu hỏi:** `Question Analyzer` xử lý câu hỏi và lược đồ, tạo ra một bản phân tích chi tiết.
3.  **Chọn lọc Schema:** `Schema Selector` sử dụng bản phân tích để tạo ra một lược đồ cơ sở dữ liệu đã lọc, chỉ chứa các thông tin liên quan.
4.  **Sinh SQL:** `SQL Expert` nhận câu hỏi và lược đồ đã lọc, cùng với phân tích câu hỏi, để tạo ra một truy vấn SQL ban đầu.
5.  **Xác thực và Sửa lỗi:** `SQL Validator` kiểm tra truy vấn SQL được tạo ra. Nếu phát hiện lỗi hoặc các vấn đề về định dạng, nó sẽ cố gắng sửa chữa. Nếu không thể sửa, nó sẽ trả về thông báo lỗi.
6.  **Kết quả cuối cùng:** Truy vấn SQL cuối cùng (đã được xác thực hoặc sửa lỗi) được trả về làm đầu ra của hệ thống.

## 🌟 Lợi ích của Kiến trúc này

*   **Tăng cường độ chính xác:** Việc phân chia tác vụ thành các bước nhỏ hơn cho phép mỗi agent tập trung vào một khía cạnh cụ thể, giảm độ phức tạp tổng thể của nhiệm vụ và cải thiện chất lượng của SQL cuối cùng.
*   **Khả năng giải thích (Explainability):** Luồng làm việc rõ ràng của các agent giúp dễ dàng theo dõi quá trình suy luận và xác định bước nào gây ra lỗi nếu có.
*   **Dễ bảo trì và mở rộng:** Mỗi agent có thể được tinh chỉnh hoặc thay thế độc lập, giúp dễ dàng bảo trì và mở rộng hệ thống trong tương lai.
*   **Hiệu quả với Gemini 2.0 Flash:** Việc sử dụng một mô hình LLM duy nhất (`Gemini 2.0 Flash`) cho tất cả các agent giúp đảm bảo tính nhất quán về hiệu suất, giảm độ trễ và tối ưu hóa chi phí vận hành.
