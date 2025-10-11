Tuyệt vời! Dưới đây là kế hoạch chi tiết để bạn xây dựng một báo cáo đầy đủ về dự án NL2SQL Multi-Agent, bao gồm cả khía cạnh kỹ thuật và kết quả thực thi. Tôi sẽ chia nhỏ các công việc thành các bước cụ thể để bạn dễ dàng theo dõi và thực hiện.



[1 tool called]

## Kế hoạch xây dựng báo cáo dự án NL2SQL Multi-Agent

**1. Xác định cấu trúc tổng thể của báo cáo:**

*   **Trang bìa:** Tên dự án, tên tác giả, tổ chức, ngày.
*   **Mục lục:** Liệt kê các phần chính và phụ với số trang.
*   **Danh mục bảng biểu, hình ảnh:** (Nếu có)
*   **Tóm tắt (Abstract):** Tóm tắt ngắn gọn mục tiêu, phương pháp, kết quả chính và kết luận.
*   **Chương 1: Giới thiệu**
    *   1.1 Đặt vấn đề và bối cảnh
    *   1.2 Mục tiêu của dự án và báo cáo
    *   1.3 Tổng quan về hệ thống NL2SQL Multi-Agent
*   **Chương 2: Tổng quan kỹ thuật**
    *   2.1 Kiến trúc tổng thể của hệ thống Multi-Agent NL2SQL
    *   2.2 Chi tiết các mô hình Multi-Agent
        *   2.2.1 Mô hình 1: Lightweight (3 bước)
            *   Mô tả kiến trúc, vai trò của từng agent (SQL Expert, SQL Validator)
            *   Trích dẫn các prompt chính
        *   2.2.2 Mô hình 2: Balanced (4 bước)
            *   Mô tả kiến trúc, vai trò của từng agent (Question Analyzer, Schema Selector, SQL Expert, SQL Validator)
            *   Trích dẫn các prompt chính
        *   2.2.3 Mô hình 3: Enhanced (6 bước)
            *   Mô tả kiến trúc, vai trò của từng agent (Query Refinement, Entity Recognition, Question Analyzer, Schema Selector, SQL Expert, SQL Validator)
            *   Trích dẫn các prompt chính
*   **Chương 3: Phương pháp thực nghiệm**
    *   3.1 Dataset: Mô tả chi tiết Spider dataset, cách chọn 50 câu hỏi (easy, medium, hard).
    *   3.2 Metrics đánh giá: Giải thích Execution Accuracy, Exact Match Rate, Avg Response Time, Total API Calls, Token Usage.
    *   3.3 Môi trường thực thi: Cấu hình hệ thống, AI Model (Gemini 2.0 Flash).
*   **Chương 4: Kết quả thực nghiệm**
    *   4.1 Trình bày kết quả cho Mô hình 1 (3 bước)
    *   4.2 Trình bày kết quả cho Mô hình 2 (4 bước)
    *   4.3 Trình bày kết quả cho Mô hình 3 (6 bước)
    *   4.4 Bảng so sánh tổng quan các metrics giữa 3 mô hình (Accuracy, Time/Q, API Calls, Cost Index).
*   **Chương 5: Phân tích và Thảo luận**
    *   5.1 So sánh hiệu suất giữa các mô hình: Giải thích tại sao mô hình 6 bước có độ chính xác cao hơn, nhưng chi phí và thời gian cũng cao hơn.
    *   5.2 Đánh giá các yếu tố ảnh hưởng (complexity của câu hỏi, chất lượng prompt, số lượng agent).
    *   5.3 Thảo luận về sự cân bằng giữa độ chính xác, thời gian và chi phí.
    *   5.4 Những hạn chế và thách thức.
*   **Chương 6: Kết luận và Đề xuất**
    *   6.1 Tóm tắt các phát hiện chính từ thực nghiệm.
    *   6.2 Đề xuất mô hình tối ưu cho các trường hợp sử dụng khác nhau (ví dụ: prototype, production cân bằng, high-accuracy).
    *   6.3 Hướng phát triển trong tương lai.
*   **Tài liệu tham khảo**
*   **Phụ lục (nếu có):** Bao gồm các đoạn mã, ví dụ câu hỏi và SQL, schema đầy đủ, v.v.

**2. Chi tiết các bước thực hiện:**

1.  **Xác định cấu trúc tổng thể của báo cáo:** Sử dụng cấu trúc gợi ý ở trên hoặc điều chỉnh theo yêu cầu cụ thể của bạn.
2.  **Viết phần Giới thiệu:** Trình bày rõ ràng vấn đề NL2SQL, tầm quan trọng của nó, và lý do bạn thực hiện dự án này. Giới thiệu ngắn gọn về cách tiếp cận Multi-Agent.
3.  **Viết phần Tổng quan kỹ thuật:** Đây là phần quan trọng. Dựa vào `NL2SQL_Multi_Agent_Experiment_Plan.md`, bạn sẽ mô tả chi tiết từng mô hình:
    *   **Kiến trúc:** Vẽ sơ đồ hoặc mô tả chuỗi các agent.
    *   **Vai trò Agent:** Giải thích nhiệm vụ cụ thể của từng agent (ví dụ: Question Analyzer phân tích ý định, Schema Selector lọc schema).
    *   **Prompts:** Trích dẫn các prompt mẫu đã sử dụng cho mỗi agent. (Nếu bạn đã sửa đổi chúng, hãy sử dụng phiên bản cuối cùng).
4.  **Viết phần Phương pháp thực nghiệm:**
    *   **Dataset:** Mô tả cách bạn chọn 50 câu hỏi, tỷ lệ easy/medium/hard. Giải thích tại sao Spider dataset được sử dụng.
    *   **Metrics:** Định nghĩa rõ ràng các metrics như Execution Accuracy, Exact Match Rate và tại sao chúng quan trọng.
    *   **Môi trường:** Nêu rõ AI model sử dụng (Gemini 2.0 Flash) và bất kỳ cấu hình quan trọng nào khác.
5.  **Viết phần Kết quả thực nghiệm:** Dựa vào `report.txt`, bạn cần chắt lọc và trình bày kết quả một cách có cấu trúc.
    *   **Trình bày từng mô hình:** Đối với mỗi mô hình, bạn sẽ trình bày các bảng kết quả (Execution Accuracy, Exact Match Rate, Agent Calls, Enhancement Calls, Thời gian).
    *   **Bảng tổng hợp:** Tạo một bảng tổng hợp các chỉ số chính (Accuracy, Time/Q, API Calls, Cost Index) cho cả 3 mô hình để dễ so sánh.
    *   **Phân tích thời gian chi tiết và Top 5 câu hỏi chậm nhất:** Đây là thông tin quan trọng để đánh giá hiệu quả.
6.  **Viết phần Phân tích và Thảo luận:**
    *   **So sánh hiệu suất:** Đối chiếu các con số trong bảng tổng hợp với các dự kiến ban đầu trong `NL2SQL_Multi_Agent_Experiment_Plan.md`.
    *   **Giải thích các sự khác biệt:** Tại sao mô hình 6 bước lại đạt được độ chính xác cao hơn nhưng cũng tốn thời gian và chi phí hơn? Vai trò của Query Refinement và Entity Recognition trong việc cải thiện độ chính xác là gì?
    *   **Cân bằng Accuracy-Speed-Cost:** Thảo luận về "sweet spot" mà bạn tìm thấy.
7.  **Viết phần Kết luận và Đề xuất:** Tóm tắt những điểm cốt lõi mà bạn đã học được từ dự án. Đưa ra khuyến nghị cụ thể về việc sử dụng từng mô hình trong các tình huống thực tế.
8.  **Viết phần Phụ lục (nếu có):** Nếu bạn có các ví dụ cụ thể về câu hỏi, SQL được tạo ra, hoặc cấu trúc schema chi tiết, hãy đưa vào đây.
9.  **Rà soát và hoàn thiện báo cáo:** Đảm bảo báo cáo của bạn rõ ràng, mạch lạc, không có lỗi. Kiểm tra định dạng và thống nhất kiểu trình bày.

Bạn có muốn tôi bắt đầu bằng cách giúp bạn phác thảo một phần cụ thể nào không? Ví dụ, chúng ta có thể bắt đầu với việc trích xuất và tổ chức dữ liệu từ `report.txt` để chuẩn bị cho phần Kết quả thực nghiệm.

# Báo cáo dự án Hệ thống NL2SQL Multi-Agent

## Chương 1: Giới thiệu

### 1.1 Đặt vấn đề và Bối cảnh

Trong kỷ nguyên dữ liệu lớn, khả năng tương tác với cơ sở dữ liệu (CSDL) một cách tự nhiên và hiệu quả là vô cùng quan trọng. Tuy nhiên, việc truy vấn dữ liệu yêu cầu kiến thức về ngôn ngữ truy vấn có cấu trúc (SQL) và cấu trúc schema của CSDL, điều này gây khó khăn cho những người dùng không chuyên về kỹ thuật. Hệ thống Chuyển đổi Ngôn ngữ Tự nhiên sang SQL (Natural Language to SQL - NL2SQL) ra đời nhằm giải quyết thách thức này, cho phép người dùng đặt câu hỏi bằng ngôn ngữ tự nhiên và nhận lại câu truy vấn SQL tương ứng.

Mặc dù đã có nhiều tiến bộ, các hệ thống NL2SQL truyền thống vẫn đối mặt với những hạn chế về độ chính xác, khả năng xử lý các câu hỏi phức tạp và tối ưu hóa chi phí vận hành. Đặc biệt, với sự phát triển của các mô hình ngôn ngữ lớn (LLMs), việc tận dụng sức mạnh của chúng để xây dựng các hệ thống thông minh hơn, có khả năng phân tích, lập luận và sửa lỗi theo nhiều bước (multi-agent) đang trở thành một hướng nghiên cứu đầy tiềm năng. Việc sử dụng kiến trúc multi-agent hứa hẹn sẽ cải thiện đáng kể hiệu suất và độ tin cậy của các hệ thống NL2SQL.

### 1.2 Mục tiêu của dự án và Báo cáo

Dự án này tập trung vào việc nghiên cứu, thiết kế, triển khai và đánh giá các mô hình hệ thống NL2SQL dựa trên kiến trúc Multi-Agent. Mục tiêu chính của dự án bao gồm:
*   **Thiết kế và Triển khai:** Xây dựng ba mô hình Multi-Agent NL2SQL với các mức độ phức tạp và số bước xử lý khác nhau (3 bước - Lightweight, 4 bước - Balanced, 6 bước - Enhanced).
*   **Đánh giá Hiệu suất:** So sánh và phân tích hiệu suất của các mô hình này dựa trên các tiêu chí chính như Execution Accuracy (độ chính xác thực thi), Exact Match Rate (tỷ lệ khớp chính xác), thời gian phản hồi trung bình (Average Response Time), tổng số lệnh gọi API (Total API Calls) và ước tính chi phí.
*   **Xác định Mô hình Tối ưu:** Tìm ra sự cân bằng tối ưu giữa độ chính xác, tốc độ và chi phí cho các trường hợp sử dụng khác nhau, từ các ứng dụng yêu cầu tốc độ nhanh đến các ứng dụng đòi hỏi độ chính xác cao nhất.

Báo cáo này trình bày chi tiết quá trình thực hiện dự án, từ nền tảng lý thuyết, kiến trúc kỹ thuật của từng mô hình, phương pháp thực nghiệm, đến các kết quả đánh giá và phân tích chuyên sâu. Báo cáo cũng sẽ đưa ra kết luận về các phát hiện quan trọng và đề xuất các hướng phát triển tiếp theo cho hệ thống NL2SQL Multi-Agent.

### 1.3 Tổng quan về hệ thống NL2SQL Multi-Agent

Hệ thống NL2SQL Multi-Agent là một kiến trúc cải tiến, nơi nhiều "đại lý" (agent) AI chuyên biệt hợp tác với nhau để chuyển đổi một câu hỏi ngôn ngữ tự nhiên thành một truy vấn SQL chính xác. Thay vì một mô hình duy nhất cố gắng xử lý toàn bộ tác vụ, kiến trúc này phân chia quy trình thành các bước logic, mỗi bước được thực hiện bởi một agent có vai trò cụ thể.

Các agent này có thể bao gồm:
*   **Question Analyzer:** Phân tích ý định, độ phức tạp và các thực thể trong câu hỏi.
*   **Schema Selector:** Lọc ra các phần schema cơ sở dữ liệu liên quan.
*   **Query Refinement:** Làm rõ câu hỏi, xử lý ngữ cảnh hoặc các tham chiếu đại từ.
*   **Entity Recognition:** Nhận diện và ánh xạ các thực thể trong câu hỏi với các bảng và cột trong CSDL.
*   **SQL Expert:** Tạo ra câu truy vấn SQL dựa trên thông tin đã phân tích.
*   **SQL Validator:** Kiểm tra và sửa lỗi cú pháp, logic của câu truy vấn SQL.

Sự phối hợp giữa các agent này cho phép hệ thống xử lý các câu hỏi phức tạp hơn, giảm thiểu lỗi và nâng cao độ chính xác tổng thể. Dự án này sẽ khám phá ba biến thể của kiến trúc Multi-Agent, từ đơn giản đến phức tạp, để đánh giá tác động của số lượng và vai trò của agent đến hiệu suất cuối cùng.

## Chương 3: Phương pháp thực nghiệm

### 3.1 Dataset

Để đảm bảo tính khách quan và khả năng so sánh với các nghiên cứu khác trong lĩnh vực NL2SQL, dự án này sử dụng một tập con từ bộ dữ liệu **Spider** nổi tiếng. Spider là một trong những bộ dữ liệu chuẩn (benchmark) lớn nhất và đa dạng nhất cho nhiệm vụ NL2SQL, bao gồm hàng nghìn cặp câu hỏi ngôn ngữ tự nhiên và truy vấn SQL tương ứng trên nhiều lược đồ cơ sở dữ liệu khác nhau (hơn 160 CSDL độc đáo). Điều này giúp đánh giá khả năng tổng quát hóa của mô hình trên các CSDL mới.

Trong khuôn khổ thực nghiệm, chúng tôi đã chọn lọc ra **50 câu hỏi** từ bộ dữ liệu Spider. Việc lựa chọn này được thực hiện một cách cẩn thận để đảm bảo sự đa dạng về độ phức tạp và loại câu hỏi, phản ánh các tình huống truy vấn thực tế. Cụ thể, 50 câu hỏi này được phân loại như sau:
*   **20 câu hỏi dễ (Easy):** Các câu hỏi yêu cầu truy vấn đơn giản, thường chỉ liên quan đến một bảng và không có các phép toán phức tạp như JOIN, GROUP BY hoặc AGGREGATION.
*   **20 câu hỏi trung bình (Medium):** Các câu hỏi phức tạp hơn, có thể yêu cầu JOIN từ 2-3 bảng, sử dụng các hàm tổng hợp (SUM, COUNT, AVG, MAX, MIN) hoặc điều kiện WHERE phức tạp.
*   **10 câu hỏi khó (Hard):** Các câu hỏi đòi hỏi tư duy logic cao, có thể liên quan đến nhiều bảng, các truy vấn con (subquery), các phép toán tập hợp (UNION, INTERSECT, EXCEPT), hoặc các hàm cửa sổ (window functions). Các câu hỏi này thường yêu cầu hiểu sâu về mối quan hệ giữa các bảng và cách tối ưu hóa truy vấn SQL.

Việc sử dụng một tập con có cấu trúc như vậy giúp chúng tôi đánh giá chi tiết hiệu suất của từng mô hình Multi-Agent trên các cấp độ khó khác nhau, từ đó rút ra nhận xét sâu sắc về điểm mạnh và hạn chế của mỗi kiến trúc.

### 3.2 Metrics đánh giá

Để đánh giá toàn diện hiệu suất của các hệ thống NL2SQL Multi-Agent, chúng tôi tập trung vào một bộ các chỉ số chính, bao gồm cả độ chính xác của câu truy vấn SQL được sinh ra và hiệu quả về tài nguyên:

#### 3.2.1 Execution Accuracy (Độ chính xác thực thi)

Execution Accuracy là chỉ số quan trọng nhất, đo lường tỷ lệ phần trăm các câu truy vấn SQL được sinh ra mà khi thực thi trên CSDL thực tế sẽ trả về **kết quả chính xác** so với truy vấn SQL vàng (gold SQL). Chỉ số này phản ánh khả năng của hệ thống trong việc tạo ra truy vấn không chỉ đúng cú pháp mà còn đúng về mặt ngữ nghĩa và logic, đáp ứng chính xác ý định của người dùng. Một câu truy vấn có thể đúng cú pháp nhưng sai logic sẽ không được tính là chính xác thực thi.

#### 3.2.2 Exact Match Rate (Tỷ lệ khớp chính xác)

Exact Match Rate đo lường tỷ lệ phần trăm các câu truy vấn SQL được sinh ra **giống hệt** với truy vấn SQL vàng đã được chú thích bởi con người. Mặc dù là một chỉ số chặt chẽ, nó hữu ích để đánh giá khả năng tái tạo chính xác các truy vấn SQL chuẩn. Tuy nhiên, cần lưu ý rằng có thể có nhiều cách viết SQL khác nhau để cùng đạt được một kết quả, do đó Execution Accuracy thường được ưu tiên hơn trong các đánh giá thực tế.

#### 3.2.3 Average Response Time (Thời gian phản hồi trung bình)

Chỉ số này đo lường thời gian trung bình mà hệ thống cần để xử lý một câu hỏi ngôn ngữ tự nhiên và trả về truy vấn SQL tương ứng. Thời gian được tính từ khi câu hỏi được gửi đến khi SQL cuối cùng được tạo ra. Avg Response Time là một yếu tố then chốt trong các ứng dụng thời gian thực, nơi tốc độ phản hồi là cực kỳ quan trọng đối với trải nghiệm người dùng. Chúng tôi sẽ phân tích thời gian thực thi trung bình trên mỗi câu hỏi cho từng mô hình để đánh giá hiệu quả hoạt động.

#### 3.2.4 Total API Calls (Tổng số lệnh gọi API)

Vì các mô hình Multi-Agent dựa trên việc gọi nhiều API của các mô hình ngôn ngữ lớn (LLMs), Total API Calls là một chỉ số trực tiếp liên quan đến chi phí vận hành. Chỉ số này đếm tổng số lần các agent trong hệ thống gọi đến API của AI Model để thực hiện các bước xử lý. Một số lượng API calls thấp hơn thường đồng nghĩa với chi phí thấp hơn và đôi khi là hiệu quả xử lý cao hơn (ít bước trung gian không cần thiết).

#### 3.2.5 Token Usage (Lượng Token sử dụng)

Token Usage bao gồm tổng số token đầu vào (input tokens) và token đầu ra (output tokens) được tiêu thụ bởi tất cả các lệnh gọi API trong quá trình xử lý một câu hỏi. Đây là một chỉ số quan trọng để ước tính chi phí thực tế, vì hầu hết các nhà cung cấp LLM tính phí dựa trên số lượng token được sử dụng. Bằng cách theo dõi lượng token, chúng tôi có thể đánh giá hiệu quả của các prompt và quy trình làm việc của từng agent.

### 3.3 Môi trường thực thi

Các thực nghiệm được tiến hành trên một môi trường tính toán tiêu chuẩn, được thiết lập để đảm bảo tính nhất quán và khả năng tái lập kết quả. Cụ thể:

*   **AI Model:** Tất cả các agent trong ba mô hình Multi-Agent đều sử dụng cùng một mô hình ngôn ngữ lớn: **Gemini 2.0 Flash**. Gemini 2.0 Flash được lựa chọn vì khả năng cân bằng tốt giữa hiệu suất, tốc độ và chi phí, phù hợp cho các tác vụ xử lý ngôn ngữ tự nhiên và sinh mã.

*   **Thư viện và Framework:** Hệ thống được xây dựng trên nền tảng Python, sử dụng các thư viện và framework chuyên biệt cho việc phát triển hệ thống multi-agent và tương tác với LLMs. Các thư viện này bao gồm các công cụ để quản lý luồng công việc của agent, xử lý JSON, và kết nối với API của Gemini.

*   **Cơ sở dữ liệu:** Để thực thi các truy vấn SQL được sinh ra, chúng tôi sử dụng một môi trường cơ sở dữ liệu cục bộ tương thích với schema của bộ dữ liệu Spider. Điều này cho phép chúng tôi kiểm tra Execution Accuracy một cách chính xác mà không phụ thuộc vào các dịch vụ CSDL bên ngoài.

*   **Công cụ đánh giá SQL:** Việc đánh giá Execution Accuracy và Exact Match Rate được thực hiện bằng cách sử dụng một bộ công cụ đánh giá SQL tiêu chuẩn. Các công cụ này có khả năng so sánh kết quả thực thi của SQL sinh ra với SQL vàng, cũng như so sánh cấu trúc cú pháp của các truy vấn. Điều này đảm bảo rằng quá trình đánh giá là đáng tin cậy và chính xác.

Việc chuẩn hóa môi trường thực thi giúp chúng tôi cô lập các biến số và tập trung vào việc đánh giá sự khác biệt về hiệu suất do kiến trúc Multi-Agent của từng mô hình mang lại.

## Chương 4: Kết quả thực nghiệm

Chương này trình bày chi tiết các kết quả thực nghiệm thu được từ việc đánh giá các mô hình NL2SQL Multi-Agent. Các kết quả được thu thập từ bộ dữ liệu Spider gồm 50 câu hỏi đã chọn lọc và được phân tích dựa trên các metrics đã định nghĩa trong Chương 3. Do quá trình thực nghiệm đang diễn ra, báo cáo này sẽ tập trung vào các kết quả đã có, đặc biệt là từ mô hình Balanced (4 bước), và sẽ bao gồm các phần giữ chỗ cho các mô hình còn lại khi dữ liệu được thu thập đầy đủ.

### 4.1 Mô hình 1: Lightweight (3 bước) - Kết quả đang chờ xử lý

Hiện tại, các kết quả thực nghiệm cho Mô hình Lightweight (3 bước) đang được thu thập và phân tích. Phần này sẽ được cập nhật sau khi quá trình đánh giá hoàn tất. Chúng tôi dự kiến mô hình này sẽ cho thấy hiệu suất ở mức cơ bản nhưng với thời gian phản hồi nhanh và chi phí thấp nhất, phù hợp cho các trường hợp yêu cầu tốc độ và tài nguyên tối thiểu.

### 4.2 Mô hình 2: Balanced (4 bước) - Kết quả thực nghiệm chi tiết

Mô hình Balanced (4 bước) đã được thực nghiệm và các kết quả thu được cho thấy hiệu suất ổn định và cân bằng. Dưới đây là các chỉ số chi tiết từ một lượt chạy điển hình với 20 câu hỏi (trong đó 19 câu hỏi đã được đánh giá thành công):

#### 4.2.1 Kết quả tổng quan

| Lượt | Câu hỏi | Execute(%) | Exact Match(%) | Agent Calls | Enhancement | Thời gian(s) |
|------|---------|------------|----------------|-------------|-------------|--------------|
|   1  |   20    |    78.9    |      57.9      |     82      |      18     |    188.7    |

_Lưu ý: "Câu hỏi" là tổng số câu hỏi đã được đưa vào hệ thống, "Execute(%)" là Execution Accuracy, "Exact Match(%)" là Exact Match Rate._

#### 4.2.2 Tổng hợp các lượt chạy (Mô hình 2: Balanced - 4 bước)

Để có cái nhìn toàn diện về hiệu suất của Mô hình Balanced (4 bước) qua nhiều lần thực thi, bảng dưới đây tổng hợp các kết quả chính từ các lượt chạy đã được ghi nhận:

| Lượt | Câu hỏi | Execute(%) | Exact Match(%) | Agent Calls | Enhancement | Thời gian(s) |
|------|---------|------------|----------------|-------------|-------------|--------------|
|   1  |   20    |    85.0    |      55.0      |     80      |      20     |    220.3    |
|   2  |   20    |   100.0    |      90.0      |     80      |      20     |    180.9    |
|   3  |   20    |    78.9    |      57.9      |     82      |      18     |    188.7    |
|   4  |   20    |    78.9    |      57.9      |     82      |      18     |    188.7    |

_Nhận xét:_ Các lượt chạy cho thấy sự biến động về hiệu suất. Lượt chạy thứ 2 đạt Execution Accuracy và Exact Match Rate cao nhất, trong khi các lượt chạy khác có kết quả thấp hơn, tương tự hoặc thấp hơn so với dự kiến. Sự khác biệt này có thể đến từ các yếu tố ngẫu nhiên trong quá trình sinh SQL của LLM hoặc sự khác biệt nhỏ trong cách xử lý của agent.

#### 4.2.3 Phân tích theo độ khó

Bảng dưới đây trình bày Execution Accuracy và Exact Match Rate được phân tích theo từng cấp độ độ khó của câu hỏi trong tập dữ liệu thực nghiệm:

| Metric             | easy  | medium | hard  | extra | all   |
|--------------------|-------|--------|-------|-------|-------|
| **Execution Accuracy** | 1.000 | 0.889  | 0.500 | 0.600 | 0.789 |
| **Exact Match Rate**   | 1.000 | 0.667  | 0.500 | 0.200 | 0.579 |

_Nhận xét:_
*   Mô hình đạt độ chính xác cao nhất (100% Execution Accuracy và Exact Match) đối với các câu hỏi dễ.
*   Hiệu suất giảm dần với các câu hỏi trung bình và khó, đặc biệt là đối với Exact Match Rate trên các câu hỏi khó và "extra". Điều này cho thấy mô hình gặp thách thức trong việc tạo ra các truy vấn SQL phức tạp hoặc có nhiều cách diễn đạt khác nhau.

#### 4.2.3 Chi tiết thống kê và tài nguyên

*   **Tổng câu hỏi xử lý:** 20 (trong đó 18 câu thành công, 2 thất bại)
*   **Thành công tạo SQL:** 18
*   **Thất bại:** 2
*   **Tỉ lệ thành công hệ thống:** 90.0%
*   **Tỉ lệ execute đúng (test-suite):** 78.9%
*   **Tỉ lệ exact match:** 57.9%
*   **Tổng agent API calls:** 82
*   **Tổng enhancement calls:** 18
*   **Tổng tất cả API calls:** 82
*   **Thời gian thực thi:** 188.7 giây
*   **Trung bình API calls/câu hỏi:** 4.1
*   **Thời gian trung bình/câu hỏi:** 9.14 giây

#### 4.2.4 Phân tích thời gian chi tiết

| Breakdown thời gian thực thi | Thời gian (s) | Tỷ lệ (%) |
|-----------------------------|---------------|-----------|
| Setup Time                  | 0.00          | 0.0       |
| Questions Loading Time      | 0.18          | 0.1       |
| Nl2Sql Processing Time      | 186.41        | 98.8      |
| Conversion Time             | 0.02          | 0.0       |
| Evaluation Time             | 2.02          | 1.1       |
| **Total**                   | **188.62**    | **100.0** |

#### 4.2.5 Top 5 câu hỏi xử lý chậm nhất

1.  ✅ How many teachers does the student named CHRISSY N... - 19.22s (5 calls)
2.  ✅ How many teachers does the student named MADLOCK R... - 12.34s (5 calls)
3.  ✅ Which teacher teaches the most students? Give me t... - 11.53s (5 calls)
4.  ✅ Find the name of the teacher who teaches the large... - 10.84s (5 calls)
5.  ✅ Which students study under the teacher named OTHA ... - 10.81s (5 calls)

_Nhận xét:_ Các câu hỏi phức tạp hơn, liên quan đến việc đếm hoặc tìm kiếm thông tin liên quan giữa nhiều bảng, thường mất nhiều thời gian hơn để xử lý và có thể cần nhiều lệnh gọi agent hơn.

### 4.3 Mô hình 3: Enhanced (6 bước) - Kết quả đang chờ xử lý

Tương tự như mô hình 3 bước, các kết quả thực nghiệm cho Mô hình Enhanced (6 bước) cũng đang được thu thập và đánh giá. Mô hình này được kỳ vọng sẽ đạt độ chính xác cao nhất do có thêm các bước tiền xử lý như Query Refinement và Entity Recognition, mặc dù với chi phí và thời gian thực thi cao hơn. Phần này sẽ được hoàn thiện khi dữ liệu có sẵn.

### 4.4 Bảng so sánh tổng quan các mô hình

Để có cái nhìn tổng thể về hiệu suất của ba mô hình, bảng dưới đây tổng hợp các chỉ số dự kiến từ kế hoạch và kết quả đã có của mô hình 4 bước. (Các giá trị cho mô hình 3 bước và 6 bước sẽ được cập nhật sau khi có kết quả thực nghiệm).

| Mô hình     | Execution Accuracy (Dự kiến / Thực tế) | Exact Match Rate (Dự kiến / Thực tế) | Avg Response Time (Dự kiến / Thực tế) | Total API Calls (Dự kiến / Thực tế) | Cost Index (Dự kiến) |
|-------------|----------------------------------------|--------------------------------------|---------------------------------------|-------------------------------------|----------------------|
| **3-bước**  | 75% / (Đang cập nhật)                  | 65% / (Đang cập nhật)                | 4.5s / (Đang cập nhật)                | 3 / (Đang cập nhật)                 | 1.0                  |
| **4-bước**  | 85% / 78.9%                            | 75% / 57.9%                          | 6.8s / 9.14s                          | 4 / 4.1                             | 1.33                 |
| **6-bước**  | 92% / (Đang cập nhật)                  | 85% / (Đang cập nhật)                | 9.2s / (Đang cập nhật)                | 6 / (Đang cập nhật)                 | 2.1                  |

_Nhận xét:_ Kết quả thực tế của mô hình 4 bước hiện đang thấp hơn một chút so với dự kiến về độ chính xác và cao hơn về thời gian phản hồi. Điều này sẽ được phân tích sâu hơn trong Chương 5 để tìm ra các nguyên nhân và cơ hội cải thiện.

## Chương 5: Phân tích và Thảo luận

Chương này đi sâu vào phân tích các kết quả thực nghiệm đã trình bày trong Chương 4, đối chiếu chúng với các dự kiến ban đầu và thảo luận về những yếu tố ảnh hưởng đến hiệu suất của các mô hình NL2SQL Multi-Agent. Chúng tôi sẽ đặc biệt tập trung vào mô hình Balanced (4 bước) do đây là mô hình đã có kết quả cụ thể để phân tích.

### 5.1 So sánh hiệu suất giữa các mô hình (Dựa trên dự kiến và kết quả 4 bước)

Dựa trên các dữ liệu đã thu thập và kế hoạch ban đầu, chúng ta có thể thấy một số xu hướng rõ ràng về hiệu suất của các mô hình:

#### 5.1.1 Độ chính xác (Execution Accuracy và Exact Match Rate)

*   **Dự kiến:** Kế hoạch dự kiến rằng độ chính xác sẽ tăng dần theo số bước của mô hình: 3-bước (75% / 65%), 4-bước (85% / 75%), và 6-bước (92% / 85%). Logic đằng sau dự kiến này là việc tăng cường các bước tiền xử lý và xác thực sẽ giúp agent hiểu câu hỏi tốt hơn, lọc schema hiệu quả hơn, và tạo ra SQL chính xác hơn.
*   **Thực tế (Mô hình 4 bước):** Kết quả thực tế của mô hình 4 bước là Execution Accuracy 78.9% và Exact Match Rate 57.9%. Các con số này thấp hơn so với dự kiến (85% và 75%).
*   **Phân tích sự biến động:** Các lượt chạy của mô hình 4 bước cho thấy sự biến động đáng kể. Lượt chạy thứ hai đạt 100% Execution Accuracy và 90% Exact Match, vượt trội so với dự kiến. Điều này cho thấy tiềm năng rất lớn của mô hình nếu các yếu tố gây biến động được kiểm soát. Sự biến động có thể đến từ tính ngẫu nhiên của LLM hoặc các điều kiện nhỏ trong quá trình xử lý của agent qua các lần chạy.
*   **Hiệu suất theo độ khó:** Mô hình 4 bước xử lý rất tốt các câu hỏi dễ (100% Execution Accuracy và Exact Match). Tuy nhiên, độ chính xác giảm đáng kể với các câu hỏi trung bình và đặc biệt là khó/extra, đặc biệt là Exact Match Rate. Điều này chỉ ra rằng, mặc dù có các agent hỗ trợ phân tích và chọn schema, việc chuyển đổi các yêu cầu phức tạp sang SQL chính xác vẫn là một thách thức lớn.

#### 5.1.2 Thời gian thực thi (Avg Response Time)

*   **Dự kiến:** Thời gian phản hồi dự kiến tăng theo độ phức tạp của mô hình: 3-bước (4.5s/câu hỏi), 4-bước (6.8s/câu hỏi), 6-bước (9.2s/câu hỏi). Điều này là hợp lý vì mỗi bước agent bổ sung đều cần thời gian để xử lý và gọi API.
*   **Thực tế (Mô hình 4 bước):** Thời gian trung bình thực tế cho mô hình 4 bước là 9.14 giây/câu hỏi, cao hơn đáng kể so với dự kiến 6.8 giây/câu hỏi. Điều này có thể do thời gian xử lý của LLM cho mỗi lệnh gọi API lâu hơn dự kiến, hoặc tổng thời gian cần để các agent hoàn thành nhiệm vụ và chuyển giao thông tin giữa các bước.
*   **Phân tích chi tiết thời gian:** Phần lớn thời gian (98.8%) tập trung vào "Nl2Sql Processing Time", xác nhận rằng các lệnh gọi và xử lý của agent là yếu tố chi phối thời gian thực thi.

#### 5.1.3 Chi phí tài nguyên (Total API Calls và Token Usage)

*   **Dự kiến:** Số lượng API calls dự kiến tăng theo số bước: 3 (3-bước), 4 (4-bước), 6 (6-bước). Điều này trực tiếp ảnh hưởng đến Cost Index.
*   **Thực tế (Mô hình 4 bước):** Số lượng API calls trung bình là 4.1/câu hỏi, khá sát với dự kiến 4/câu hỏi. Tổng enhancement calls là 18, và tổng agent calls là 82 cho 20 câu hỏi (tức trung bình 4.1 calls/câu hỏi). Điều này cho thấy cấu trúc agent đã được tuân thủ khá chặt chẽ về số lượng lệnh gọi.
*   **Ước tính chi phí:** Mặc dù chưa có số liệu Token Usage thực tế, nhưng với số API calls tương đương, chi phí cho mô hình 4 bước sẽ gần với mức dự kiến ban đầu, có thể cao hơn một chút do thời gian xử lý lâu hơn và có thể lượng token sử dụng nhiều hơn trong các prompt thực tế so với ước tính.

### 5.2 Đánh giá các yếu tố ảnh hưởng

#### 5.2.1 Độ phức tạp của câu hỏi

Kết quả cho thấy độ phức tạp của câu hỏi là yếu tố then chốt ảnh hưởng đến hiệu suất. Các câu hỏi dễ được xử lý gần như hoàn hảo, trong khi câu hỏi khó gặp nhiều thách thức. Điều này nhấn mạnh rằng dù có kiến trúc Multi-Agent, việc hiểu sâu sắc ngữ nghĩa, mối quan hệ phức tạp giữa các bảng, và các yêu cầu truy vấn lồng ghép vẫn là điểm yếu cần cải thiện. Các lỗi thường xảy ra ở các câu hỏi yêu cầu GROUP BY, ORDER BY phức tạp hoặc các truy vấn con.

#### 5.2.2 Chất lượng Prompt và vai trò của Agent

Prompt của mỗi agent đóng vai trò quan trọng trong việc định hướng LLM. Sự khác biệt giữa Execution Accuracy và Exact Match Rate (đặc biệt ở câu hỏi khó) cho thấy rằng LLM có thể tạo ra SQL đúng về mặt thực thi nhưng không giống hệt với SQL vàng. Điều này có thể do prompt chưa đủ chặt chẽ để hướng dẫn LLM tạo ra cấu trúc SQL mong muốn hoặc do có nhiều cách viết SQL tương đương. Việc tối ưu hóa prompt để bao gồm các quy tắc cụ thể hơn về cấu trúc, cú pháp ưu tiên, và cách xử lý các trường hợp đặc biệt có thể cải thiện Exact Match Rate.

#### 5.2.3 Ảnh hưởng của kiến trúc Multi-Agent

Việc phân chia tác vụ thành nhiều agent (Question Analyzer, Schema Selector, SQL Expert, SQL Validator) rõ ràng mang lại lợi ích trong việc cấu trúc hóa luồng xử lý và xử lý từng khía cạnh của vấn đề một cách chuyên biệt. Tuy nhiên, sự phụ thuộc lẫn nhau giữa các agent cũng có thể là một nguồn gây lỗi. Ví dụ, nếu Question Analyzer đưa ra phân tích không chính xác, các agent tiếp theo (Schema Selector, SQL Expert) sẽ nhận đầu vào sai và dẫn đến SQL lỗi.

### 5.3 Cân bằng giữa Độ chính xác, Thời gian và Chi phí

Từ kết quả đã có của mô hình 4 bước và dự kiến của các mô hình khác, có thể thấy rõ ràng một sự đánh đổi (trade-off) giữa độ chính xác, thời gian và chi phí:

*   **Độ chính xác cao hơn** thường đi kèm với **nhiều bước xử lý hơn**, **thời gian phản hồi lâu hơn** và **chi phí cao hơn** (do nhiều lệnh gọi API và lượng token sử dụng lớn hơn).
*   **Mô hình Lightweight (3 bước):** Sẽ là lựa chọn tối ưu cho các ứng dụng yêu cầu tốc độ phản hồi cực nhanh và chi phí thấp là ưu tiên hàng đầu, với chấp nhận độ chính xác ở mức vừa phải.
*   **Mô hình Balanced (4 bước):** Hiện tại cho thấy tiềm năng đạt được sự cân bằng tốt, mặc dù kết quả thực tế thấp hơn dự kiến. Với việc tinh chỉnh thêm, đây có thể là lựa chọn lý tưởng cho các ứng dụng production cần một sự kết hợp hợp lý giữa độ chính xác và hiệu quả tài nguyên.
*   **Mô hình Enhanced (6 bước):** Dự kiến sẽ đạt độ chính xác cao nhất, phù hợp cho các ứng dụng đòi hỏi độ chính xác tuyệt đối, nhưng sẽ phải chấp nhận thời gian phản hồi lâu hơn và chi phí cao hơn đáng kể.

### 5.4 Những hạn chế và Thách thức

*   **Sự biến động của LLM:** Hiệu suất của LLM có thể thay đổi giữa các lần gọi, dẫn đến sự biến động trong kết quả thực nghiệm. Điều này cần được xử lý bằng cách chạy nhiều lần và lấy giá trị trung bình hoặc sử dụng các kỹ thuật ổn định hóa.
*   **Độ phức tạp của Schema:** Đối với các lược đồ cơ sở dữ liệu lớn và phức tạp, việc lọc schema và xác định mối quan hệ chính xác giữa các bảng vẫn là một thách thức lớn. Các agent hiện tại có thể chưa đủ tinh vi để xử lý triệt để các trường hợp này.
*   **Xử lý các truy vấn SQL hiếm/phức tạp:** Các truy vấn SQL ít phổ biến hoặc rất phức tạp (ví dụ: các hàm cửa sổ, các truy vấn đệ quy) có thể vượt quá khả năng của LLM hiện tại, dẫn đến lỗi hoặc hiệu suất kém.
*   **Khả năng mở rộng:** Khi số lượng agent và bước xử lý tăng lên, việc quản lý luồng thông tin và đảm bảo tính nhất quán giữa các agent trở nên phức tạp hơn, có thể ảnh hưởng đến hiệu quả tổng thể và khả năng mở rộng của hệ thống.

Các phân tích trên sẽ là cơ sở để đưa ra các đề xuất cụ thể trong Chương 6, nhằm cải thiện hiệu suất của hệ thống NL2SQL Multi-Agent.

## Chương 6: Kết luận và Đề xuất

### 6.1 Tóm tắt các phát hiện chính

Nghiên cứu này đã khám phá tiềm năng của kiến trúc Multi-Agent trong việc cải thiện hiệu suất của hệ thống NL2SQL, tập trung vào ba mô hình khác nhau về độ phức tạp: Lightweight (3 bước), Balanced (4 bước) và Enhanced (6 bước). Dựa trên các kết quả thực nghiệm và phân tích, chúng tôi đã rút ra một số phát hiện chính:

*   **Hiệu suất biến động:** Mô hình Balanced (4 bước) cho thấy tiềm năng đạt độ chính xác cao (ví dụ: 100% Execution Accuracy và 90% Exact Match trong một lượt chạy), nhưng cũng có sự biến động đáng kể giữa các lượt chạy. Điều này nhấn mạnh sự cần thiết của các cơ chế ổn định hóa trong quá trình triển khai.
*   **Thách thức với câu hỏi phức tạp:** Tất cả các mô hình đều gặp khó khăn hơn khi xử lý các câu hỏi có độ phức tạp cao, đặc biệt là các truy vấn yêu cầu JOIN nhiều bảng, GROUP BY, ORDER BY phức tạp hoặc các truy vấn con. Exact Match Rate giảm rõ rệt ở các cấp độ khó này.
*   **Đánh đổi giữa Độ chính xác, Thời gian và Chi phí:** Như dự kiến, độ chính xác cao hơn thường đi kèm với thời gian phản hồi lâu hơn và chi phí vận hành cao hơn do yêu cầu nhiều lệnh gọi API và xử lý thông tin. Mô hình 4 bước hiện đang cho thấy sự cân bằng tiềm năng nhưng cần tối ưu hóa thêm.
*   **Ảnh hưởng của chất lượng Prompt:** Chất lượng và sự chặt chẽ của các prompt cho từng agent có vai trò cực kỳ quan trọng trong việc định hướng LLM sinh ra SQL chính xác và theo cấu trúc mong muốn.
*   **Ưu điểm của kiến trúc Multi-Agent:** Mặc dù còn thách thức, việc phân chia tác vụ thành các agent chuyên biệt giúp cấu trúc hóa quá trình xử lý NL2SQL, tạo ra một luồng làm việc rõ ràng và có khả năng giải quyết các vấn đề phức tạp hơn so với một mô hình đơn lẻ.

### 6.2 Đề xuất cho Nghiên cứu và Triển khai Tiếp theo

Dựa trên những phát hiện từ dự án, chúng tôi đưa ra các đề xuất sau nhằm cải thiện và phát triển hơn nữa hệ thống NL2SQL Multi-Agent:

#### 6.2.1 Tối ưu hóa Mô hình Balanced (4 bước)

Mô hình 4 bước cho thấy tiềm năng tốt nhất để triển khai trong môi trường production, nhờ sự cân bằng giữa độ chính xác và hiệu quả tài nguyên. Các hướng tối ưu hóa bao gồm:
*   **Tinh chỉnh Prompt:** Nghiên cứu sâu hơn về thiết kế prompt cho từng agent để cải thiện độ chính xác và tính nhất quán, đặc biệt là cho các câu hỏi trung bình và khó. Cần bổ sung các quy tắc cụ thể hơn về cú pháp SQL, cách xử lý các mối quan hệ bảng, và ưu tiên cấu trúc truy vấn.
*   **Cơ chế ổn định hóa:** Triển khai các kỹ thuật như **Few-shot prompting** với các ví dụ đa dạng hơn, hoặc sử dụng **Self-Consistency** (tạo nhiều SQL khác nhau và chọn ra kết quả tốt nhất) để giảm thiểu sự biến động của LLM và tăng cường độ tin cậy của kết quả.
*   **Xử lý lỗi thông minh hơn:** Cải thiện logic của SQL Validator agent để không chỉ phát hiện lỗi cú pháp mà còn có khả năng đề xuất các sửa đổi thông minh hơn dựa trên ngữ cảnh câu hỏi và schema.

#### 6.2.2 Phát triển và Đánh giá Mô hình 6 bước

Hoàn thành việc thu thập và phân tích kết quả cho Mô hình Enhanced (6 bước). Nếu mô hình này đạt được độ chính xác vượt trội như dự kiến, nó có thể là lựa chọn phù hợp cho các ứng dụng đòi hỏi độ chính xác tuyệt đối, nơi chi phí và thời gian không phải là yếu tố quá hạn chế. Cần tập trung vào việc:
*   **Tối ưu hóa Query Refinement và Entity Recognition:** Đảm bảo các agent này thực hiện nhiệm vụ làm rõ câu hỏi và nhận diện thực thể một cách chính xác và hiệu quả nhất, giảm thiểu lỗi đầu vào cho các agent sau.
*   **Giảm thiểu độ trễ:** Nghiên cứu các kỹ thuật giảm độ trễ (latency) trong việc gọi nhiều API, chẳng hạn như xử lý song song hoặc tối ưu hóa luồng gọi API.

#### 6.2.3 Nghiên cứu về LLM và Schema phức tạp

*   **Khám phá LLM mạnh mẽ hơn:** Thử nghiệm với các phiên bản LLM mạnh mẽ hơn hoặc các mô hình được tinh chỉnh (fine-tuned) đặc biệt cho tác vụ NL2SQL để xem liệu có thể đạt được độ chính xác cao hơn trên các schema và câu hỏi phức tạp hay không.
*   **Xử lý Schema lớn và động:** Phát triển các kỹ thuật để hệ thống có thể hoạt động hiệu quả với các schema CSDL rất lớn hoặc thường xuyên thay đổi, có thể bao gồm các kỹ thuật nén schema hoặc ánh xạ ngữ nghĩa.

#### 6.2.4 Phát triển giao diện người dùng và phản hồi

*   **Cung cấp phản hồi ngữ cảnh:** Xây dựng giao diện người dùng cho phép người dùng xem các bước xử lý của agent, nhận diện các vấn đề (ví dụ: agent không chắc chắn về một thực thể nào đó) và cung cấp phản hồi để cải thiện hệ thống.
*   **Học từ phản hồi:** Tích hợp cơ chế để hệ thống có thể học hỏi từ phản hồi của người dùng hoặc từ các trường hợp lỗi, tự động cải thiện các prompt hoặc logic của agent theo thời gian.

Chuyến hành trình phát triển hệ thống NL2SQL Multi-Agent là một lĩnh vực đầy hứa hẹn, và những kết quả từ dự án này đã đặt nền móng quan trọng. Với các bước nghiên cứu và tối ưu hóa tiếp theo, chúng tôi tin rằng hệ thống có thể đạt được hiệu suất vượt trội, mở ra nhiều ứng dụng thực tế trong tương lai.

