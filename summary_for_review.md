# tóm tắt kết quả nghiên cứu: hệ thống đa tác nhân trong nl2sql

**đề tài:** tối ưu hóa chuyển đổi ngôn ngữ tự nhiên sang sql (nl2sql) thông qua kiến trúc multi-agent chuyên biệt và cơ chế tinh chỉnh một lần (single-pass refinement).

---

### **1. công nghệ và phương pháp luận (technology stack)**
*   **kiến trúc hệ thống:** xây dựng trên framework **crewai**, điều phối quy trình tuần tự gồm **6 tác nhân (ai agents)** chuyên biệt:
    1.  *question analyzer:* phân tích ý định và xác định tập trường dữ liệu (expected fields) – trọng tâm giải quyết lỗi chọn trường.
    2.  *schema selector:* lọc lược đồ (schema linking) để giảm nhiễu ngữ cảnh.
    3.  *query planner:* xây dựng kế hoạch thực thi logic (không phụ thuộc cú pháp).
    4.  *sql expert:* sinh mã sql từ kế hoạch logic.
    5.  **sql refiner (điểm mới):** thực hiện cơ chế **single-pass refinement** dựa trên đối sánh ngược với phân tích ban đầu.
    6.  *sql validator:* kiểm tra cú pháp và ngữ nghĩa cuối cùng.
*   **mô hình ngôn ngữ (llm):** sử dụng **gemini 2.0 flash** (temperature 0.3) làm đại não cho các tác nhân.
*   **tập dữ liệu thử nghiệm:** **spider 1.0 (dev set)** với 1.034 câu hỏi đa lĩnh vực, độ phức tạp cao.

### **2. thành tựu chính (key achievements)**
*   **hiệu năng thực thi (execution accuracy):** đạt **84,1%** trên toàn bộ tập spider dev set.
*   **cải tiến so với quy trình cơ sở:**
    *   tăng **4,6%** so với quy trình 4 bước truyền thống (79,5%).
    *   vượt trội hơn phương pháp zero-shot thuần túy (74,8%) và kỹ thuật chain-of-thought (77,0%).
*   **giải quyết lỗi hệ thống:** giảm thiểu đáng kể lỗi **chọn trường (field selection)** – loại lỗi chiếm tới **52,6%** nguyên nhân thất bại của các hệ thống đơn tác nhân, nhờ vào việc tách riêng bước phân tích trường và cơ chế tinh chỉnh đối soát.

### **3. so sánh với các nghiên cứu hiện có (comparative analysis)**
*   **so với single-agent (resdsql, rat-sql):** các hệ thống cũ tập trung vào việc mã hóa quan hệ (relation-aware) trong một lượt duy nhất. nghiên cứu này thay đổi tư duy sang hướng **phân rã trách nhiệm (decoupled responsibilities)**, giúp giảm tải nhận thức (cognitive load) cho mô hình ở mỗi bước.
*   **so với các hệ thống dựa trên llm (din-sql, dail-sql):**
    *   mặc dù **din-sql** cũng sử dụng phân rã bài toán, nhưng nghiên cứu này khác biệt ở cơ chế **single-pass refinement** trong môi trường đa tác nhân có "backstory" và "knowledge" chuyên biệt cho từng vai trò.
    *   nghiên cứu nhấn mạnh vào việc **xác định trường mục tiêu sớm (early field identification)**, thay vì để llm tự suy luận tập trường cùng lúc với việc viết logic sql phức tạp.
*   **tính mới:** đề xuất một cấu trúc 6 bước có tính hệ thống cao, kết hợp giữa lập kế hoạch logic (logical planning) và kiểm soát chất lượng (standardized validation), cung cấp một framework có khả năng mở rộng tốt cho các hệ quản trị cơ sở dữ liệu thực tế.

