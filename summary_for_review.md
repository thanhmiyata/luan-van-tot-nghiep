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
### **4. hệ thống thực nghiệm (experimental system)**
nghiên cứu thực hiện so sánh và đánh giá hiệu quả giữa hai cấu hình quy trình:

#### **4.1 quy trình 4 bước (baseline model)**
quy trình rút gọn tập trung vào các bước cốt lõi từ phân tích đến xác thực kỹ thuật.
*   **luồng thực hiện:** question analyzer → schema selector → sql expert → sql validator.
*   **mục tiêu:** thiết lập điểm chuẩn (benchmark) để đánh giá giá trị biên của các bước lập kế hoạch và tinh chỉnh.

#### **4.2 quy trình 6 bước (proposed model)**
quy trình đầy đủ tích hợp thêm khâu lập kế hoạch logic và tinh chỉnh hành vi.
*   **luồng thực hiện:** question analyzer → schema selector → **query planner** → sql expert → **sql refiner** → sql validator.
*   **mục tiêu:** tối ưu hóa độ chính xác cho các câu hỏi phức tạp thông qua việc phân rã bài toán và hậu kiểm ngữ nghĩa.

#### **4.3 cấu hình hybrid multi-agent (experimental configuration)**
trong các thử nghiệm tối ưu chuyên sâu, hệ thống sử dụng sự kết hợp linh hoạt giữa các dòng llm để tận dụng ưu thế riêng của từng mô hình:

*   **multi agent: kiến trúc 3 agent cốt lõi:**
    *   **schema selector agent (claude 3.5 haiku):**
        *   nhiệm vụ: phân tích câu hỏi và lọc lược đồ cơ sở dữ liệu liên quan.
        *   logic: loại bỏ bảng, cột không cần thiết để tối ưu hóa cửa sổ ngữ cảnh.
        *   output: schema json đã lọc chỉ chứa thành phần liên quan.
    *   **sql expert agent (gemini 2.0 flash):**
        *   nhiệm vụ: sinh câu truy vấn sql dựa trên câu hỏi và schema đã lọc.
        *   logic: xử lý logic phức tạp và tối ưu hóa query.
        *   output: câu truy vấn sql hoàn chỉnh.
    *   **sql validator agent (openai o3-mini):**
        *   nhiệm vụ: kiểm tra cú pháp, logic và cấu trúc sql.
        *   logic: tự động sửa lỗi nếu phát hiện và cung cấp giải thích về chức năng của query.
        *   output: sql đã validate + explanation + error handling.

