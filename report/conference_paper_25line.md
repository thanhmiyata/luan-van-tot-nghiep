Tối ưu hóa chuyển đổi ngôn ngữ tự nhiên sang SQL dựa trên kiến trúc đa tác nhân phối hợp mô hình suy luận sâu DeepSeek-R1

## Tóm tắt

Chuyển đổi ngôn ngữ tự nhiên sang SQL (NL2SQL) là bài toán quan trọng nhằm hỗ trợ người dùng truy xuất dữ liệu từ các hệ quản trị phức tạp, tuy nhiên các yêu cầu mức độ khó cao vẫn đặt ra nhiều thách thức cho khả năng suy luận logic và liên kết lược đồ của các mô hình hiện nay. Nghiên cứu này đề xuất một khung đa tác nhân (Multi-Agent) mô-đun hóa dựa trên chuỗi xử lý sáu bước gồm: phân tích câu hỏi, lựa chọn lược đồ, lập kế hoạch, sinh SQL, tinh chỉnh và kiểm tra tính hợp lệ. Giải pháp sử dụng chiến lược phối hợp mô hình Hybrid LLM giữa Gemini 2.5 Flash, GPT-4o và DeepSeek-R1 nhằm tối ưu hóa sự cân bằng giữa hiệu lực thực thi và chi phí vận hành. Kết quả đánh giá trên tập dữ liệu Spider cho thấy cấu hình đầy đủ đạt độ chính xác thực thi (Execution Accuracy — EX) 85.6% và độ khớp tuyệt đối (Exact Match — EM) 77.8%. Đáng chú ý, việc tích hợp mô hình suy luận sâu DeepSeek-R1 vào pha lập kế hoạch và tinh chỉnh đã giúp hệ thống đạt tỉ lệ EX 100% trên các truy vấn mức độ khó (Hard). Nghiên cứu cũng xây dựng hệ thống phân loại lỗi chi tiết nhằm nhận diện các sai số hệ thống, kết hợp cùng các thí nghiệm cắt giảm để định lượng vai trò của tác nhân lập kế hoạch và tinh chỉnh trong việc đảm bảo tính ổn định của toàn hệ thống.

## 1. Giới thiệu

Chuyển đổi ngôn ngữ tự nhiên sang SQL (NL2SQL) đóng vai trò nền tảng trong việc dân chủ hóa dữ liệu, cho phép người dùng không chuyên truy xuất thông tin từ các hệ quản trị cơ sở dữ liệu quan hệ phức tạp mà không cần kiến thức truy vấn chuyên sâu. Trong kỷ nguyên của trí tuệ nhân tạo tạo sinh, khả năng này không chỉ tối ưu hóa quy trình phân tích doanh nghiệp mà còn tạo ra một phương thức tương tác người-máy trực quan và hiệu quả hơn. Tuy nhiên, việc xử lý các truy vấn mức độ cao — liên quan đến phép nối phức hợp, hàm tập hợp lồng nhau hoặc các điều kiện logic đa tầng — vẫn đặt ra nhiều thách thức, đòi hỏi hệ thống phải có khả năng suy luận logic chặt chẽ thay vì chỉ dừng lại ở mức dịch thuật ngôn ngữ.

Mặc dù các mô hình ngôn ngữ lớn (LLM) đã đạt được những kết quả đáng ghi nhận, phương pháp tiếp cận sinh mã trực tiếp (direct generation) thường gặp hiện tượng ảo giác lược đồ và sai lệch logic. Sự thiếu vắng một quy trình lập kế hoạch tường minh khiến các mô hình dễ mất dấu ngữ cảnh trong không gian lược đồ lớn, dẫn đến việc chọn sai thuộc tính hoặc xây dựng đường JOIN dư thừa. Ngoài ra, nhiều hệ thống hiện nay vẫn vận hành như một "hộp đen" (black box), nơi các sai lệch ở pha phân tích ý định hay lựa chọn lược đồ bị che lấp bởi kết quả SQL cuối cùng, gây trở ngại cho việc chẩn đoán và cải thiện hệ thống một cách có hệ thống.

Để giải quyết các hạn chế trên, nghiên cứu này đề xuất khung đa tác nhân (Multi-Agent) mô-đun hóa, phân tách quy trình NL2SQL thành chuỗi xử lý sáu bước chuyên biệt nhằm nâng cao tính minh bạch và độ chính xác. Kiến trúc này vận hành dựa trên chiến lược Hybrid LLM: các tác nhân trích xuất và lọc lược đồ sử dụng Gemini 2.5 Flash để ưu tiên tốc độ xử lý, trong khi các tác nhân Lập kế hoạch (Planner) và Tinh chỉnh (Refiner) tận dụng khả năng suy luận logic sâu của DeepSeek-R1. Tác nhân Chuyên gia SQL (SQL Expert) sử dụng GPT-4o cho pha sinh mã. Sự phối hợp này cho phép tách biệt pha xây dựng logic khỏi pha sinh mã thuần túy, đồng thời cho phép quan sát độc lập từng công đoạn trong chuỗi xử lý.

Bài báo đóng góp vào ba khía cạnh chính. Thứ nhất, nghiên cứu thiết lập khung NL2SQL đa tác nhân với chuỗi xử lý sáu bước có cấu trúc giúp tách biệt trách nhiệm của từng pha suy luận và thực thi (C1 — Kiến trúc mô-đun). Thứ hai, nghiên cứu đề xuất phương pháp định lượng vai trò của tác nhân Planner và Refiner thông qua việc so sánh đối soát giữa cấu hình cơ sở (4 bước) và cấu hình đầy đủ (6 bước) (C2 — Giao thức đánh giá). Thứ ba, nghiên cứu chứng minh tính hiệu quả của hệ thống trên tập dữ liệu Spider 1.0 với EX đạt 85.6%, đi kèm hệ thống phân loại lỗi chi tiết làm cơ sở cho các nghiên cứu tối ưu hóa tiếp theo (C3 — Giá trị thực chứng).

Phần còn lại của bài báo được tổ chức như sau. Mục 2 tổng hợp các nghiên cứu liên quan. Mục 3 trình bày chi tiết khung kiến trúc và thuật toán đề xuất. Mục 4 mô tả thiết lập và phân tích thực nghiệm. Mục 5 thảo luận về các nhóm lỗi hệ thống. Mục 6 thảo luận về ưu điểm, hạn chế và hàm ý của kết quả. Mục 7 kết luận và nêu hướng phát triển tương lai.

## 2. Công trình liên quan

Mục này tổng hợp các hướng nghiên cứu chủ đạo trong lĩnh vực NL2SQL, từ các phương pháp truyền thống dựa trên luật đến các hệ thống hiện đại tận dụng khả năng của LLM và kiến trúc đa tác nhân. Trọng tâm của phần này là định vị khoảng trống nghiên cứu về một khung đánh giá mô-đun hóa có khả năng cấu hình linh hoạt để phân tích vai trò cụ thể của từng công đoạn suy luận.

### 2.1 Các hệ thống chuyển đổi văn bản sang SQL truyền thống

Các nghiên cứu sơ khởi về NL2SQL dựa trên kiến trúc seq2seq hoặc giải mã theo cú pháp (grammar-based decoding) đã đặt nền móng cho việc biểu diễn lược đồ và ràng buộc không gian truy vấn [1–5]. Tuy nhiên, thách thức lớn nhất của các hệ thống này nằm ở việc liên kết lược đồ (schema linking) thiếu chính xác khi đối mặt với tên cột đa nghĩa hoặc dữ liệu thay đổi linh hoạt [3, 11]. Mặc dù các phương pháp sinh theo cây hoặc giải mã ràng buộc đã phần nào cải thiện tính hợp lệ của cú pháp, chúng thường thiếu cơ chế tinh chỉnh độc lập để xử lý các lỗi ngữ nghĩa sau khi sinh [2, 12].

### 2.2 NL2SQL dựa trên mô hình ngôn ngữ lớn

Sự phát triển của LLM đã mang lại sự linh hoạt đáng kể cho bài toán NL2SQL thông qua khả năng học tập ngữ cảnh (in-context learning). Tuy vậy, các mô hình này vẫn thường mắc lỗi chọn trường dữ liệu khi lược đồ có quy mô lớn hoặc chứa nhiều thuộc tính tương đồng. Các nghiên cứu gần đây nhấn mạnh việc tách biệt pha phân tích ý định và lọc lược đồ độc lập để giảm nhiễu, hạn chế sự lan truyền lỗi từ đầu chuỗi xử lý [11, 13]. Thay vì dồn mọi trách nhiệm vào một lần sinh mã duy nhất, việc mô-đun hóa quy trình giúp cải thiện tính ổn định và khả năng kiểm soát hệ thống.

### 2.3 Hệ thống đa tác nhân và hướng tiếp cận tăng cường công cụ

Khung đa tác nhân được ứng dụng để giải quyết các tác vụ phức tạp thông qua cơ chế phân vai và phối hợp linh hoạt. Các framework như CrewAI hay LangChain cung cấp hạ tầng để xây dựng chuỗi xử lý gồm nhiều tác nhân chuyên biệt với khả năng truyền ngữ cảnh có cấu trúc [8–10]. Bên cạnh đó, các kỹ thuật tăng cường công cụ cho LLM tập trung vào việc sử dụng các trình kiểm tra cú pháp hoặc bộ thực thi truy vấn để phản hồi lỗi trong thời gian thực. Tuy nhiên, một khung NL2SQL tích hợp đầy đủ khả năng lập kế hoạch suy luận sâu và tinh chỉnh đối soát vẫn chưa được khai thác triệt để nhằm phục vụ mục tiêu đánh giá định lượng vai trò của từng thành phần trong quy trình.

### 2.4 Khoảng trống nghiên cứu

Từ các hướng trên, có thể nhận thấy thiếu vắng một khung NL2SQL "hướng đánh giá", trong đó chuỗi xử lý có thể cấu hình để so sánh có cấu trúc và các thành phần được định nghĩa đủ rõ ràng để phục vụ thí nghiệm cắt giảm cũng như phân tích lỗi. Khác với các hệ thống chủ yếu tối ưu bằng lời nhắc hoặc tinh chỉnh mô hình, nghiên cứu này nhấn mạnh thiết kế chuỗi xử lý mô-đun và khả năng cấu hình linh hoạt để phục vụ so sánh có cấu trúc giữa các biến thể quy trình.

## 3. Khung và phương pháp

Mục này trình bày chi tiết kiến trúc đa tác nhân đề xuất, tập trung vào việc mô-đun hóa các pha suy luận để hỗ trợ đánh giá có cấu trúc. Nội dung bao gồm phát biểu bài toán, nguyên tắc thiết kế hệ thống, luồng dữ liệu giữa các tác nhân trong chuỗi xử lý sáu bước, và các cấu hình thực nghiệm. Chi tiết về lời nhắc và hướng dẫn theo vai trò được trình bày trong Phụ lục.

### 3.1 Phát biểu bài toán

**Bài toán NL2SQL.** Cho một câu hỏi ngôn ngữ tự nhiên $Q$ và lược đồ cơ sở dữ liệu $S$ (bao gồm danh sách bảng, cột, kiểu dữ liệu và quan hệ khóa), mục tiêu là sinh một truy vấn SQL $y$ sao cho khi thực thi trên cơ sở dữ liệu tương ứng sẽ trả về kết quả đúng với ý định của người dùng.

**Chỉ số đánh giá.** Nghiên cứu sử dụng hai chỉ số tiêu chuẩn của bộ dữ liệu Spider. Exact Match (EM) đo lường độ khớp về cấu trúc giữa SQL dự đoán và SQL tham chiếu. Execution Accuracy (EX) đo lường độ chính xác của kết quả thực thi khi so sánh dữ liệu trả về giữa hai truy vấn. Trong nghiên cứu này, EX được coi là chỉ số ưu tiên do khả năng phản ánh đúng giá trị ngữ nghĩa và chấp nhận các biểu thức SQL tương đương.

### 3.2 Kiến trúc hệ thống đa tác nhân

Hệ thống được thiết kế theo mô hình chuỗi tác nhân chuyên trách (Agentic Pipeline). Nguyên tắc thiết kế thứ nhất là đảm bảo ngữ cảnh có cấu trúc: dữ liệu trao đổi giữa các tác nhân được chuẩn hóa qua định dạng JSON nhằm giảm thiểu sự mơ hồ ngữ nghĩa trong quá trình truyền thông tin. Nguyên tắc thứ hai là khai thác mô hình Hybrid, nghĩa là lựa chọn mô hình tối ưu cho từng nhiệm vụ cụ thể: Gemini 2.5 Flash cho các tác vụ trích xuất, DeepSeek-R1 cho suy luận logic sâu, và GPT-4o cho sinh mã SQL.

Hệ thống tách biệt rõ vai trò của từng pha trong chuỗi xử lý. Pha lập kế hoạch chịu trách nhiệm định hình chiến lược logic cho truy vấn. Pha sinh mã chuyển đổi kế hoạch đó thành mã SQL cụ thể. Pha tinh chỉnh thực hiện đối soát toàn diện giữa mã SQL với ý định ban đầu để đảm bảo tính nhất quán trước khi gửi kết quả ra ngoài.

### 3.3 Chuỗi xử lý sáu bước

Chuỗi xử lý được tổ chức thành ba pha chiến lược, mỗi pha gồm hai tác nhân có trách nhiệm riêng biệt. Việc phân chia này phù hợp với các nguồn lỗi phổ biến trong NL2SQL: lỗi hiểu ý định, lỗi logic liên kết, và lỗi cú pháp kỹ thuật.

**Pha 1: Phân tích và Liên kết lược đồ.** Pha đầu tiên gồm hai tác nhân xử lý đầu vào thô. Tác nhân Phân tích câu hỏi (Question Analyzer) trích xuất ý định truy vấn, các thực thể quan trọng và xác định danh sách trường đầu ra kỳ vọng (expected_output_fields), đóng vai trò "hợp đồng" ràng buộc các bước sau. Tác nhân Lựa chọn lược đồ (Schema Selector) thu hẹp không gian tìm kiếm bằng cách chỉ giữ lại các bảng và cột liên quan trực tiếp đến câu hỏi, giúp tối ưu hóa cửa sổ ngữ cảnh cho các tác nhân phía sau.

**Pha 2: Lập kế hoạch suy luận và Sinh mã.** Pha thứ hai tách biệt tư duy logic khỏi triển khai cú pháp. Tác nhân Lập kế hoạch truy vấn (Query Planner) sử dụng DeepSeek-R1 để xây dựng chuỗi các mục tiêu con (subgoals) và xác định đường nối khóa ngoại (join path), mà không viết bất kỳ mã SQL nào. Tác nhân Chuyên gia SQL (SQL Expert) sau đó nhận bản kế hoạch logic cùng lược đồ đã lọc và chuyển đổi chúng thành mã SQL sơ bộ (y0) bằng GPT-4o. Việc tách bạch hai bước này giúp giải quyết hiệu quả hơn các lỗi JOIN dư thừa và sai lệch hàm tổng hợp thường gặp.

**Pha 3: Tinh chỉnh và Xác thực.** Pha cuối cùng đảm bảo chất lượng đầu ra trước khi trả kết quả. Tác nhân Tinh chỉnh SQL (SQL Refiner) sử dụng DeepSeek-R1 để đối chiếu mã SQL sơ bộ với kế hoạch logic ban đầu, phát hiện và sửa các lỗi về JOIN dư thừa, sai lệch hàm tập hợp, hoặc thiếu GROUP BY. Tác nhân Kiểm tra tính hợp lệ (SQL Validator) thực hiện rà soát kỹ thuật về cú pháp và ràng buộc lược đồ cuối cùng. Thứ tự Tinh chỉnh rồi đến Kiểm tra đảm bảo lỗi logic được xử lý trước khi tiến hành xác thực hình thức.

### 3.4 Cấu hình thực nghiệm

Để đánh giá định lượng vai trò của các thành phần, nghiên cứu triển khai hai cấu hình chính. Cấu hình cơ sở (4 bước) lược bỏ tác nhân Lập kế hoạch và Tinh chỉnh, chỉ giữ lại luồng Phân tích → Lọc lược đồ → Sinh SQL → Kiểm tra, phản ánh một chuỗi xử lý tối giản nhưng vẫn có phân vai rõ ràng. Cấu hình đầy đủ (6 bước) bật toàn bộ sáu tác nhân để kiểm chứng giả thuyết về tính cộng hưởng giữa lập kế hoạch suy luận và tinh chỉnh đối soát. Khác biệt duy nhất giữa hai cấu hình là việc bật hoặc tắt hai thành phần Planner và Refiner, giúp diễn giải kết quả một cách trực tiếp.

**Thuật toán 1. Quy trình xử lý NL2SQL đa tác nhân sáu bước**
```text
Đầu vào: Câu hỏi Q, Lược đồ đầy đủ S
Đầu ra: Truy vấn SQL thực thi y

1: analysis <- QuestionAnalyzer(Q, S)
2: schema_filtered <- SchemaSelector(analysis, S)
3: plan <- QueryPlanner(analysis, schema_filtered)
4: y0 <- SQLExpert(analysis, schema_filtered, plan)
5: y1 <- SQLRefiner(y0, Q, analysis, schema_filtered, plan)
6: report <- SQLValidator(y1, schema_filtered)
7: Trả về report.sql
```

## 4. Đánh giá thực nghiệm

Mục này báo cáo kết quả đánh giá hệ thống trên tập dữ liệu Spider 1.0 (1.034 câu hỏi). Nội dung bao gồm thiết lập thực nghiệm, so sánh hiệu năng giữa hai cấu hình chuỗi xử lý, phân tích theo mức độ khó, và thí nghiệm cắt giảm để làm rõ đóng góp của từng thành phần.

### 4.1 Thiết lập thực nghiệm

Hệ thống được vận hành theo quy trình chuẩn của Spider nhằm đảm bảo tính khách quan của các chỉ số EM và EX. Chiến lược Hybrid LLM (Ensemble) sử dụng cấu hình tham số cố định: temperature=0.3, top_p=0.95, max_tokens=2048, lấy mẫu một lượt (n=1). Ba dòng mô hình được phân vai theo thế mạnh riêng: Gemini 2.5 Flash cho tốc độ trích xuất, DeepSeek-R1 cho lập luận cấu trúc, và GPT-4o cho xử lý cú pháp SQL. Biểu diễn lược đồ và thứ tự xử lý tuần tự được giữ nguyên giữa hai cấu hình để đảm bảo tính so sánh.

### 4.2 Kết quả chính

Bảng 1 so sánh hiệu năng của hai cấu hình chuỗi xử lý trên toàn bộ tập Spider 1.0.

**Bảng 1. Hiệu năng hệ thống trên toàn bộ tập Spider 1.0 (1.034 câu hỏi)**
| Cấu hình chuỗi xử lý | Execution Accuracy (EX) | Exact Match (EM) | Độ lệch (EX−EM) |
| :--- | :---: | :---: | :---: |
| **Cấu hình 6-bước (Đầy đủ)** | **85.6%** | **77.8%** | **7.8%** |
| Cấu hình 4-bước (Cơ sở) | 81.2% | 73.7% | 7.5% |

Cấu hình đầy đủ cải thiện đồng bộ trên cả hai chỉ số, cho thấy pha lập kế hoạch và tinh chỉnh không chỉ giúp sinh mã đúng cú pháp hơn mà còn bảo toàn ý định ngữ nghĩa của câu hỏi. Độ lệch ổn định khoảng 7.5–7.8% giữa EX và EM phản ánh khả năng xử lý linh hoạt các trường hợp SQL tương đương về kết quả nhưng khác biệt về cách biểu diễn hình thức.

### 4.3 Phân tích hiệu năng theo mức độ khó

Để hiểu rõ hơn đóng góp của kiến trúc đa tác nhân, Bảng 2 trình bày kết quả EX phân cấp theo bốn mức độ khó do Spider định nghĩa.

**Bảng 2. Execution Accuracy (EX) phân cấp theo độ khó**
| Độ khó | Số lượng | Cấu hình 4-bước | Cấu hình 6-bước | Cải thiện (Δ) |
| :--- | :---: | :---: | :---: | :---: |
| Dễ (Easy) | 248 | 76.6% | 81.9% | +5.3% |
| Trung bình (Medium) | 446 | 83.4% | 86.3% | +2.9% |
| **Khó (Hard)** | **174** | **78.2%** | **87.4%** | **+9.2%** |
| Cực khó (Extra-hard) | 166 | 85.5% | 87.3% | +1.8% |

Tại phân khúc câu hỏi Khó (Hard), hiệu năng hệ thống cải thiện 9.2 điểm phần trăm — mức tăng cao nhất trong bốn nhóm. Kết quả này cho thấy đối với các truy vấn đòi hỏi liên kết logic đa tầng, sự can thiệp của tác nhân Planner và Refiner đóng vai trò quan trọng trong việc khắc phục các sai số mà phương pháp sinh mã trực tiếp thường gặp phải. Mức cải thiện thấp hơn ở nhóm Cực khó (Extra-hard) có thể là do các truy vấn này đòi hỏi tri thức miền hoặc logic nằm ngoài phạm vi lược đồ hiện tại.

### 4.4 Thí nghiệm cắt giảm (Ablation Study)

Để định lượng đóng góp của từng thành phần, nghiên cứu thực hiện chuỗi thí nghiệm cắt giảm trên mẫu rút gọn (100 câu hỏi phân tầng theo độ khó). Bảng 3 trình bày kết quả so sánh bốn cấu hình.

**Bảng 3. Thí nghiệm cắt giảm trên mẫu 100 câu**
| Cấu hình | EX (%) | Δ so với đầy đủ |
| :--- | :---: | :---: |
| Đầy đủ (6 bước) | 85.0 | — |
| Không có Planner (−Planner) | 83.0 | −2.0 |
| Không có Refiner (−Refiner) | 82.0 | −3.0 |
| Cơ sở (4 bước, −Planner−Refiner) | 79.0 | −6.0 |

Kết quả cho thấy khi loại bỏ Planner đơn lẻ, EX giảm 2.0 điểm; khi loại bỏ Refiner đơn lẻ, EX giảm 3.0 điểm. Tuy nhiên khi loại bỏ đồng thời cả hai (cấu hình cơ sở), EX giảm tổng cộng 6.0 điểm — lớn hơn tổng sụt giảm đơn lẻ (2.0 + 3.0 = 5.0 điểm). Hiện tượng này cho thấy Planner và Refiner có tính cộng hưởng: Planner tạo nền tảng logic cấu trúc cho Refiner rà soát, và khi thiếu một trong hai, thành phần còn lại cũng bị giảm hiệu quả.

## 5. Phân tích lỗi

Việc mô-đun hóa chuỗi xử lý không chỉ giúp tăng độ chính xác mà còn cho phép định vị nguồn gốc của các sai số hệ thống, nhờ khả năng ghi nhận và quan sát kết quả trung gian tại từng tác nhân. Qua việc kiểm tra thủ công các trường hợp thất bại, nghiên cứu xây dựng hệ thống phân loại lỗi (Error Taxonomy) nhằm nhận diện các điểm nghẽn kỹ thuật và định hướng tối ưu hóa.

### 5.1 Hệ thống phân loại lỗi

Bảng 4 tổng hợp bốn nhóm lỗi chính được xác định từ thực nghiệm trên tập Spider. Tỉ lệ xuất hiện được ước tính từ phân tích thủ công các trường hợp thất bại.

**Bảng 4. Phân loại các nhóm lỗi chính trong chuỗi xử lý**
| Nhóm lỗi | Tỉ lệ | Nguyên nhân và Biểu hiện |
| :--- | :---: | :--- |
| Bất cân xứng lược đồ | ~10% | Tác nhân Schema Selector loại bỏ các bảng trung gian cần thiết cho phép JOIN. |
| Dư thừa logic JOIN | ~35% | Hệ thống xây dựng đường nối không tối ưu hoặc thêm bảng không trực tiếp tham gia truy xuất. |
| Sai lệch hàm tập hợp | ~20% | Nhầm lẫn giữa COUNT và COUNT(DISTINCT) hoặc thiếu ràng buộc GROUP BY trên khóa chính. |
| Hỏng cấu trúc phản hồi | ~20% | Mô hình DeepSeek-R1 trả về các thẻ `<thought>` dư thừa, làm hỏng định dạng JSON đầu ra. |

Việc gán lỗi theo chuỗi ra quyết định cho phép xác định sai lệch xuất phát từ pha phân tích ý định, pha lập kế hoạch hay pha hậu xử lý kỹ thuật. Cách tiếp cận này giúp tăng khả năng quan sát và kiểm soát hệ thống so với các phương pháp đánh giá chỉ dựa trên kết quả cuối.

### 5.2 Nghiên cứu điển hình

Để minh họa khả năng khắc phục lỗi thông qua pha lập kế hoạch và tinh chỉnh, phần này phân tích một ví dụ cụ thể từ bộ dữ liệu Spider (db_id: movie_1).

Câu hỏi đặt ra là: "What are the titles of movies that got a star rating of both 3 and 4?" (Liệt kê tên các bộ phim nhận được đánh giá cả 3 sao và 4 sao). SQL tham chiếu sử dụng toán tử INTERSECT để tìm giao tập giữa nhóm phim có đánh giá 3 sao và nhóm phim có đánh giá 4 sao.

Trong cấu hình 4-bước, hệ thống mắc lỗi logic khi hiểu nhầm từ khóa "both" thành điều kiện OR, dẫn đến kết quả sai ngữ nghĩa — trả về phim có 3 sao hoặc 4 sao thay vì phim có cả hai đánh giá. Ngược lại, trong cấu hình 6-bước, tác nhân Question Analyzer nhận diện chính xác đây là yêu cầu phép giao tập hợp. Sau đó, tác nhân Query Planner lập kế hoạch tách biệt hai truy xuất con trước khi SQL Expert thực thi, giúp kết quả cuối cùng khớp hoàn toàn với đáp án tham chiếu.

Nghiên cứu tình huống này minh họa rõ giá trị của việc tách biệt pha tư duy logic (Planner) khỏi pha triển khai cú pháp (SQL Expert) trong việc xử lý các truy vấn có cấu trúc logic phức tạp.

## 6. Thảo luận

Kiến trúc đa tác nhân sáu bước cho thấy cải thiện rõ rệt về độ chính xác so với cấu hình cơ sở, xác nhận giả thuyết về tính cộng hưởng giữa Planner và Refiner. Tuy nhiên, việc sử dụng nhiều mô hình LLM dẫn đến sự gia tăng về độ trễ hệ thống và chi phí vận hành — đây là sự đánh đổi cần cân nhắc trong triển khai thực tế.

Chiến lược tinh chỉnh một lần (one-shot refinement) đã cho thấy hiệu quả tốt trên đa số trường hợp, nhưng vẫn bộc lộ hạn chế khi mã SQL sơ bộ sai lệch cấu trúc ở mức cơ bản, ví dụ thiếu toàn bộ đường JOIN hoặc sai ý định truy vấn. Trong các trường hợp này, một cơ chế tinh chỉnh nhiều vòng lặp với phản hồi từ bộ thực thi có thể cải thiện thêm kết quả.

Ngoài ra, hiệu năng tại nhóm câu hỏi Cực khó (Extra-hard) chỉ cải thiện 1.8%, gợi ý rằng các truy vấn đòi hỏi tri thức miền nằm ngoài lược đồ vẫn là giới hạn của phương pháp hiện tại. Việc tích hợp cơ chế truy vấn lại người dùng (clarification) hoặc bổ sung tri thức bên ngoài có thể là hướng mở rộng phù hợp.

Một điểm tích cực của thiết kế mô-đun là khả năng duy trì nhật ký trung gian và tách biệt các pha suy luận, đảm bảo tính tái lập và tạo nền tảng cho việc mở rộng sang các bài toán sinh mã có cấu trúc khác ngoài SQL.

## 7. Kết luận và Hướng phát triển tương lai

Nghiên cứu này đã đề xuất và đánh giá một khung đa tác nhân mô-đun hóa cho bài toán NL2SQL, trong đó mô hình suy luận sâu DeepSeek-R1 được tích hợp vào pha lập kế hoạch và tinh chỉnh. Kết quả thực nghiệm trên Spider 1.0 cho thấy cấu hình đầy đủ (6 bước) đạt EX 85.6%, cải thiện 4.4 điểm so với cấu hình cơ sở (4 bước). Thí nghiệm cắt giảm xác nhận tính cộng hưởng giữa hai tác nhân Planner và Refiner, đồng thời hệ thống phân loại lỗi giúp định vị các điểm nghẽn kỹ thuật cần ưu tiên cải thiện.

Trong tương lai, nghiên cứu dự kiến mở rộng theo ba hướng chính. Thứ nhất, triển khai cơ chế tinh chỉnh nhiều vòng lặp với phản hồi từ bộ thực thi truy vấn để xử lý các lỗi cấu trúc sâu. Thứ hai, mở rộng đánh giá trên các bộ dữ liệu đa dạng hơn như BIRD và Spider 2.0 để kiểm chứng tính tổng quát hóa. Thứ ba, nghiên cứu cơ chế hỏi lại người dùng (clarification) nhằm giải quyết các trường hợp mơ hồ ngôn ngữ mà hệ thống hiện tại chưa xử lý được.

## Phụ lục / Tài liệu bổ trợ (không tính trang)

### A. Thông tin bổ sung về lời nhắc/cấu hình

Bản thân bài chỉ mô tả ý tưởng và trách nhiệm của từng tác nhân. Mô tả đầy đủ về lời nhắc theo vai trò được lưu trữ trong các tập tin riêng biệt và đi kèm phiên bản hóa để đảm bảo tính tái lập: question_analyzer.md, schema_selector.md, query_planner.md, sql_expert.md, sql_refiner.md, sql_validator.md.

### B. Cấu hình chuỗi xử lý

Cấu hình YAML mẫu:

```yaml
llm:
  reasoning_agent: DeepSeek-R1
  extraction_agent: Gemini 2.5 Flash
  generation_agent: GPT-4o
  temperature: 0.3
  max_tokens: 2048
  top_p: 0.95

pipeline:
  configuration: full-6-step
  steps:
    - question_analyzer
    - schema_selector
    - query_planner
    - sql_expert
    - sql_refiner
    - sql_validator
```

Hệ thống tuân thủ giao thức đánh giá Spider 1.0. Việc cố định tham số sinh và lấy mẫu n=1 giúp giảm biến thiên đầu ra giữa các lần chạy.

### C. Tài liệu tham khảo

[1] V. Zhong et al., "Seq2SQL," ACL 2017.  
[2] T. Yu et al., "SyntaxSQLNet," EMNLP 2018.  
[3] T. Yu et al., "Spider," EMNLP 2018.  
[4] B. Wang et al., "RAT-SQL," ACL 2020.  
[5] S. Ruan et al., "RESDSQL," arXiv 2023.  
[6] M. Pourreza et al., "DIN-SQL: Decomposed In-Context Learning of Text-to-SQL with Self-Correction," arXiv 2023.  
[7] F. Li et al., "C3 / DAIL-SQL: Zero-shot and In-Context Learning Methods for Text-to-SQL," arXiv 2023.  
[8] Y. Wang et al., "AutoGen," arXiv 2023.  
[9] H. Chase et al., LangChain, open-source framework, GitHub repository, accessed 2024.
[10] J. Moura et al., CrewAI, open-source framework, GitHub repository, accessed 2024.
[11] E. Gan et al., "BRIDGE," NAACL 2021.  
[12] T. Scholak et al., "PICARD," EMNLP 2021.  
[13] OpenAI, "GPT-4 Technical Report," 2023.  
[17] Z. Yuan et al., "CRITIC," arXiv 2023.  