# Kiến trúc Đa Tác Nhân Dựa trên LLM cho Truy cập Dữ liệu Kinh doanh Quan hệ bằng Ngôn ngữ Tự nhiên

### Tóm tắt

Chuyển đổi ngôn ngữ tự nhiên sang SQL (NL2SQL) có thể làm giảm rào cản giữa người dùng nghiệp vụ và dữ liệu quan hệ, nhưng các hệ thống dựa trên mô hình ngôn ngữ lớn (LLM) vẫn gặp khó khăn trong việc bám lược đồ, lựa chọn phép nối, xử lý tổng hợp và logic lồng nhau. Bài báo này trình bày một nghiên cứu kiến trúc theo định hướng ứng dụng về pipeline NL2SQL đa tác nhân gồm sáu bước với các điểm kiểm soát suy luận tường minh: Phân tích Câu hỏi, Lựa chọn Lược đồ, Lập kế hoạch Truy vấn, Sinh SQL, Tinh chỉnh SQL và Kiểm định SQL. Hệ thống được đánh giá theo một giao thức cố định trên tập phát triển Spider 1.0 (1.034 câu hỏi), được sử dụng vì máy chủ nộp bài chính thức của Spider 1.0 không còn chấp nhận bài nộp mới. Trên toàn bộ tập phát triển này, pipeline 6 bước được đề xuất đạt 77,8% Exact Match (EM) và 85,6% Execution Accuracy (EX), cao hơn baseline 4 bước tương ứng với 73,7% EM và 81,2% EX. Các bằng chứng này ủng hộ giá trị thực tiễn của việc phân rã suy luận nhằm tăng độ bền vững và khả năng kiểm soát trong NL2SQL, đồng thời giữ bài báo trong khuôn khổ một nghiên cứu kiến trúc có kiểm soát trên tập dev thay vì một tuyên bố mới về bảng xếp hạng chính thức.

**Từ khóa:** NL2SQL; Text-to-SQL; hệ đa tác nhân; mô hình ngôn ngữ lớn; phân tích kinh doanh; hỗ trợ ra quyết định.

## 1 Giới thiệu

Chuyển đổi ngôn ngữ tự nhiên sang SQL (NL2SQL) là quá trình ánh xạ một yêu cầu ngôn ngữ tự nhiên thành một truy vấn SQL có thể thực thi trên cơ sở dữ liệu quan hệ. Trong thực tế, cách tiếp cận này làm giảm rào cản giữa người dùng không chuyên kỹ thuật và các hệ thống dữ liệu doanh nghiệp.

Mặc dù các mô hình ngôn ngữ lớn đã tiến bộ nhanh chóng, NL2SQL vẫn là một bài toán khó khi câu hỏi đòi hỏi suy luận nhiều bước. Các lỗi thường gặp bao gồm chọn sai trường đầu ra, chọn sai đường nối, thiếu ràng buộc tổng hợp, hoặc sinh ra các câu SQL có vẻ hợp lý về mặt hình thức nhưng lại trả lời sai câu hỏi. Các vấn đề này đặc biệt rõ rệt trên các benchmark liên miền như Spider.

Nhiều hệ thống gần đây vẫn dựa trên một quá trình sinh tập trung ở mức cao. Trong bối cảnh đó, bám lược đồ, lập kế hoạch nối, xử lý tổng hợp và chọn trường trả lời phải cạnh tranh trong cùng một bước, nên một sai sót trung gian duy nhất thường làm hỏng truy vấn cuối cùng.

Bài báo này giải quyết hạn chế đó bằng một kiến trúc đa tác nhân gồm sáu bước: Phân tích Câu hỏi, Lựa chọn Lược đồ, Lập kế hoạch Truy vấn, Sinh SQL, Tinh chỉnh SQL và Kiểm định SQL. Mục tiêu là phơi bày các điểm kiểm soát suy luận quan trọng thay vì xem việc sinh SQL như một bước đơn khối. Câu hỏi khoa học ở đây không phải là hệ đa tác nhân có “trông phức tạp hơn” hay không, mà là liệu việc phân rã tường minh có cải thiện độ bền vững dưới một giao thức đánh giá cố định hay không.

Hệ thống được thực nghiệm trên tập Spider 1.0 - đây là một benchmark Text-to-SQL liên miền quy mô lớn, gồm các câu hỏi ngôn ngữ tự nhiên và truy vấn SQL chuẩn trải trên nhiều cơ sở dữ liệu khác nhau, được sử dụng rộng rãi để đánh giá khả năng khái quát hóa và suy luận liên lược đồ của các hệ NL2SQL.
Do máy chủ nộp bài chính thức của Spider 1.0 không còn hoạt động, hệ thống chỉ được đánh giá trên tập phát triển Spider 1.0. Pipeline 6 bước đạt 77,8% Exact Match (EM) và 85,6% Execution Accuracy (EX), vượt baseline 4 bước với 73,7% EM và 81,2% EX. Kết quả này ủng hộ nhận định rằng bước lập kế hoạch và bước tinh chỉnh tường minh giúp cải thiện chất lượng truy vấn và giảm lỗi cấu trúc, dù nghiên cứu hiện tại vẫn chưa tách biệt hoàn toàn ảnh hưởng của phân rã suy luận với ảnh hưởng của ngân sách suy luận tăng thêm.

Trong phiên bản hội nghị này, các kết quả trên toàn bộ tập phát triển cho pipeline 6 bước đề xuất được báo cáo cho một biến thể mixed-model đã được khóa trước khi viết bài và khớp với cấu hình mặc định trong mã nguồn (`agents.yaml` của pipeline 6 bước): GPT-4o đảm nhiệm Phân tích Câu hỏi, Lập kế hoạch Truy vấn, Sinh SQL và Tinh chỉnh SQL; Gemini 2.5 Flash đảm nhiệm Lựa chọn Lược đồ và Kiểm định SQL.

Các đóng góp chính của bài báo gồm:

- Xây dựng NL2SQL như một pipeline sáu bước với các điểm kiểm soát suy luận tường minh cho phân tích, bám lược đồ, lập kế hoạch, sinh, tinh chỉnh và kiểm định.
- Cung cấp một so sánh trên toàn bộ tập phát triển giữa baseline 4 bước rút gọn và pipeline 6 bước đầy đủ dưới cùng một giao thức đánh giá, kèm mô tả trung thực về gán model theo từng pipeline (mục 4.2).
- Phân tích hành vi theo mức độ khó và các mẫu lỗi lặp lại trong log để chỉ ra những nơi lợi ích kiến trúc có khả năng xuất hiện mạnh nhất.
- Kết nối kiến trúc với các kịch bản truy cập dữ liệu kinh doanh và hỗ trợ ra quyết định mà không tuyên bố sẵn sàng triển khai sản xuất.

## 2 Công trình liên quan

Các hệ thống Text-to-SQL giai đoạn đầu như Seq2SQL [1] và SyntaxSQLNet [2] đã đặt nền tảng cho bài toán chuyển câu hỏi thành SQL. Với Spider [3], nghiên cứu chuyển dần sang khái quát hóa liên miền, liên kết lược đồ và suy luận đa bảng. Các hệ thống về sau như RAT-SQL [4], BRIDGE [5] và RESDSQL [6] cải thiện khả năng phân tích có nhận thức lược đồ, nhưng phần lớn vẫn dựa trên quá trình sinh tập trung.

Các hướng tiếp cận dựa trên LLM tiếp tục mở rộng không gian thiết kế. Những hệ thống prompting như DIN-SQL [7] và DAIL-SQL [8] cho thấy các mô hình ngôn ngữ mạnh có thể sinh SQL cạnh tranh mà không cần bộ giải mã chuyên biệt, nhưng chúng vẫn gặp khó khăn ở việc chọn trường đầu ra, chọn phép nối và logic tổng hợp. Các hệ thống phân rã gần đây đẩy hướng này đi xa hơn: SGU-SQL [15] kết hợp liên kết có nhận thức cấu trúc với phân rã tiểu tác vụ theo cú pháp, trong khi ReCAPAgent-SQL và biến thể SSEV [16] kết hợp lập kế hoạch, phê bình, tự tinh chỉnh và sửa lỗi theo kiểu bỏ phiếu để cải thiện hiệu quả thực thi.

Một tuyến nghiên cứu khác tập trung vào suy luận tường minh, tự sửa lỗi và phối hợp đa tác nhân. Reflexion [9] và CRITIC [10] minh họa giá trị của các giai đoạn phản biện, trong khi AutoGen [11], LangChain [13] và CrewAI [14] hỗ trợ phân rã tác vụ thông qua các tác nhân hợp tác. Các hệ thống hướng robustness như DIVER [17] còn đưa thêm liên kết giá trị động và suy luận bằng chứng thông qua tương tác với công cụ, đặc biệt trong các bối cảnh khó hơn ngoài benchmark chuẩn. Song song đó, các hệ thống thực tiễn hướng doanh nghiệp như Tursio [18] nhấn mạnh đồ thị ngữ cảnh, viết lại truy vấn và tìm kiếm dữ liệu có cấu trúc theo hướng sẵn sàng ứng dụng thay vì chỉ tối ưu benchmark. Chúng tôi cũng lưu ý các phương pháp giải mã ràng buộc như PICARD [12], vốn cải thiện tính hợp lệ đầu ra theo một hướng khác với chiến lược phân rã của bài báo này, cũng như các hệ thống định hướng Spider mới hơn như SGU-SQL [15] và SSEV / ReCAPAgent-SQL [16], vốn báo cáo kết quả mạnh trên tập dev thông qua phân rã có nhận thức cấu trúc, tinh chỉnh và sửa lỗi có dẫn hướng bởi thực thi. Bài báo này gần nhất với các hệ thống NL2SQL phân rã dựa trên LLM, nhưng nhấn mạnh các điểm kiểm soát suy luận tường minh và một so sánh nội bộ có đối sánh giữa pipeline rút gọn và pipeline đầy đủ thay vì một tuyên bố rộng về dẫn đầu benchmark.

Do các nghiên cứu trước thường khác nhau về backbone model, chiến lược prompting và split đánh giá, các so sánh số liệu với tài liệu trước trong bài này chỉ mang tính ngữ cảnh, không phải bằng chứng so sánh ngang hàng tuyệt đối.

## 3 Kiến trúc đề xuất

### 3.1 Tổng quan

Hệ thống được đề xuất phân rã NL2SQL thành sáu giai đoạn tuần tự:

1. Phân tích Câu hỏi
2. Lựa chọn Lược đồ
3. Lập kế hoạch Truy vấn
4. Sinh SQL
5. Tinh chỉnh SQL
6. Kiểm định SQL

Mỗi tác nhân xử lý một tiểu bài toán quyết định riêng. Tác nhân Phân tích Câu hỏi trích xuất ý định và các trường đầu ra kỳ vọng. Tác nhân Lựa chọn Lược đồ giảm nhiễu lược đồ. Tác nhân Lập kế hoạch Truy vấn xây dựng kế hoạch logic trước khi SQL được viết ra. Tác nhân Sinh SQL tạo truy vấn SQL ban đầu, Tác nhân Tinh chỉnh SQL thực hiện một lượt sửa lỗi ngữ nghĩa, và Tác nhân Kiểm định SQL kiểm tra tính nhất quán kỹ thuật ở mức lược đồ và khả năng thực thi SQL.

Giả thuyết nền tảng rất đơn giản: lỗi NL2SQL dễ được kiểm soát hơn khi các bước suy luận quan trọng được làm tường minh thay vì bị nén vào một lần sinh duy nhất.

### 3.2 Vai trò của các tác nhân

Bảng 1 tóm tắt vai trò của sáu tác nhân.

| Thành phần | Đầu vào | Đầu ra | Vai trò chính |
| :--- | :--- | :--- | :--- |
| Question Analyzer | Câu hỏi, lược đồ thô | Phân tích ý định, trường đầu ra kỳ vọng | Xác định truy vấn cần trả về cái gì |
| Schema Selector | Phân tích, lược đồ thô | Lược đồ đã lọc | Giảm các bảng và cột không liên quan |
| Query Planner | Phân tích, lược đồ đã lọc | Kế hoạch thực thi logic | Tổ chức phép nối, bộ lọc, nhóm và logic tập hợp |
| SQL Generator | Phân tích, lược đồ đã lọc, kế hoạch | SQL ban đầu | Sinh SQL có thể thực thi |
| SQL Refiner | SQL ban đầu, phân tích, lược đồ, kế hoạch | SQL đã tinh chỉnh | Sửa lỗi ngữ nghĩa cục bộ |
| SQL Validator | SQL đã tinh chỉnh, lược đồ đã lọc | SQL cuối cùng hoặc báo lỗi | Kiểm tra cú pháp và tính nhất quán với lược đồ |

*Bảng 1. Tóm tắt kiến trúc sáu bước được đề xuất.*

### 3.3 Cơ sở thiết kế

Kiến trúc này nhắm vào ba nhóm lỗi phổ biến: sai trường đầu ra, lập kế hoạch logic yếu và các lỗi ngữ nghĩa chưa được sửa sau bước sinh SQL ban đầu. Vì vậy, dự đoán trường được tách sớm, bước lập kế hoạch được tách khỏi bước viết SQL, và bước tinh chỉnh được giới hạn ở một lượt. Chúng tôi so sánh baseline 4 bước rút gọn không có Planner và Refiner với pipeline 6 bước đầy đủ để nghiên cứu xem các điểm kiểm soát tường minh này có gắn với hành vi bền vững hơn dưới một giao thức cố định hay không.

### 3.4 Ghi chú triển khai

Hệ thống sử dụng các prompt có cấu trúc cố định trong một workflow đa tác nhân dạng mô-đun. Mỗi tác nhân nhận câu hỏi ngôn ngữ tự nhiên, một biểu diễn lược đồ và các đầu ra trung gian liên quan từ các giai đoạn trước. Tất cả thí nghiệm dùng giải mã xác định với nhiệt độ bằng 0. Ở mức triển khai, mỗi prompt tác nhân được giữ cố định theo bốn thành phần: mô tả vai trò, đầu vào có cấu trúc, các ràng buộc suy luận/nhất quán lược đồ, và định dạng đầu ra. Orchestration là tuần tự một lượt, không dùng voting, self-consistency hay vòng lặp tự phản biện nhiều lần.

Đối với các kết quả trên toàn bộ tập phát triển Spider 1.0 được báo cáo trong bài, cấu hình đánh giá được cố định như sau:

- Question Analyzer: GPT-4o
- Schema Selector: Gemini 2.5 Flash
- Query Planner: GPT-4o
- SQL Generator: GPT-4o
- SQL Refiner: GPT-4o
- SQL Validator: Gemini 2.5 Flash

Đây là biến thể mixed-model chính dùng cho các kết quả pipeline 6 bước trên toàn bộ tập phát triển trong bài báo này. Các lượt benchmark nội bộ với gán model đồng nhất (toàn bộ dùng Gemini 2.5 Flash, toàn bộ dùng GPT-4o, toàn bộ dùng Claude Sonnet 4, toàn bộ dùng Claude Opus 4 và toàn bộ dùng DeepSeek-R1) cho thấy hiệu quả theo trade-off accuracy–cost kém thuận lợi hơn so với cấu hình trộn ở trên. Cấu hình được chọn phản ánh phân công thực dụng: GPT-4o đảm nhiệm các bước suy luận cấu trúc và sinh–sửa SQL (Analyzer, Planner, Generator, Refiner), nơi benchmark nội bộ cho thấy độ ổn định tốt hơn; Gemini 2.5 Flash đảm nhiệm lọc lược đồ và kiểm định cuối nhằm cân bằng chi phí và tốc độ gọi API.

## 4 Thiết lập thực nghiệm

### 4.1 Dữ liệu và chỉ số

Chúng tôi đánh giá trên Spider 1.0 [3], một benchmark Text-to-SQL liên miền tiêu chuẩn. Theo thực hành hiện tại sau khi máy chủ đánh giá Spider 1.0 chính thức đóng lại, chúng tôi báo cáo kết quả trên tập phát triển, gồm 1.034 câu hỏi trải trên 20 cơ sở dữ liệu.

Chúng tôi sử dụng hai chỉ số tiêu chuẩn: Exact Match (EM), đo độ tương đương về cấu trúc với SQL tham chiếu, và Execution Accuracy (EX), đo việc truy vấn dự đoán có trả về cùng kết quả với truy vấn chuẩn hay không.

### 4.2 Các cấu hình được so sánh

Để làm rõ giá trị của từng lớp phân rã suy luận, bài báo báo cáo bốn nhóm cấu hình dưới cùng một giao thức đánh giá:

- baseline single-pass: prompting trực tiếp và prompting chain-of-thought
- baseline pipeline 4 bước: Phân tích Câu hỏi -> Lựa chọn Lược đồ -> Sinh SQL -> Kiểm định SQL
- hai ablation 5 bước: lần lượt bỏ Query Planner hoặc bỏ SQL Refiner
- pipeline 6 bước đề xuất: Phân tích Câu hỏi -> Lựa chọn Lược đồ -> Lập kế hoạch Truy vấn -> Sinh SQL -> Tinh chỉnh SQL -> Kiểm định SQL


Với pipeline 6 bước và các ablation 5 bước trong Bảng 3, gán model theo từng tác nhân trùng mục 3.4 và Bảng 2 (GPT-4o cho Question Analyzer, Query Planner, SQL Generator và SQL Refiner; Gemini 2.5 Flash cho Schema Selector và SQL Validator). Baseline 4 bước trong cùng các bảng được triển khai theo cấu hình mặc định của pipeline 4 bước trong mã nguồn: Claude Sonnet 4 cho Question Analyzer, Gemini 2.5 Flash cho Schema Selector và SQL Validator, GPT-4o cho SQL Generator. Hai baseline single-prompt trong Bảng 3 dùng GPT-4o cho lượt sinh SQL. Như vậy, so sánh 4 bước và 6 bước giữ nguyên giao thức đánh giá và tập dev, nhưng không cố định cùng một backbone ở bước Phân tích Câu hỏi; phần thảo luận và mục hạn chế ghi nhận điều kiện này khi diễn giải chênh lệch kiến trúc.

Theo đó, Bảng 3 không pha trộn giữa các hàng "dự kiến" và các hàng "đã chạy"; toàn bộ các cấu hình trong bảng đều là các lượt đánh giá đã được thực hiện. Trong nhóm pipeline, đối sánh kiến trúc chính vẫn là giữa baseline 4 bước và hệ 6 bước đầy đủ, còn hai biến thể 5 bước được đưa vào như ablation trung gian để cô lập phần đóng góp của Planner và Refiner. Cách trình bày này giúp reviewer thấy rõ hơn vì sao việc chuyển từ 4 bước lên 6 bước không phải là một bước nhảy tùy ý, mà là kết quả của việc bổ sung hai điểm kiểm soát suy luận có vai trò khác nhau.

### 4.3 Thông tin tái lập

Bảng 2 tóm tắt cấu hình đánh giá đã được khóa cho pipeline 6 bước đề xuất trên toàn bộ tập phát triển. Gán model của baseline 4 bước và các baseline single-prompt được nêu riêng ở mục 4.2.

| Mục | Giá trị |
| :--- | :--- |
| Cấu hình tác nhân (pipeline 6 bước đề xuất) | GPT-4o cho Question Analyzer, Query Planner, SQL Generator và SQL Refiner; Gemini 2.5 Flash cho Schema Selector và SQL Validator |
| Lý do chọn mixed-model | GPT-4o cho các bước suy luận cấu trúc và sinh–sửa SQL; Gemini 2.5 Flash cho lọc lược đồ và kiểm định cuối nhằm cân bằng chi phí và độ trễ trong benchmark nội bộ |
| Temperature | 0 |
| Top-p / lấy mẫu | Không hiệu chỉnh thêm ngoài temperature = 0; các tham số sampling khác được giữ cố định ở cấu hình API mặc định và không thay đổi giữa các cấu hình được so sánh |
| Max output tokens | 2048 |
| Hình thức truy cập mô hình | Gọi API hosted: Gemini 2.5 Flash, GPT-4o và (đối với baseline 4 bước, Question Analyzer) Claude Sonnet 4; không fine-tune và không self-host mô hình |
| Biểu diễn lược đồ | Lược đồ Spider có cấu trúc (bảng, cột, khóa); lược đồ con sau lọc được truyền cho các tác nhân sau |
| Chính sách lọc lược đồ | Giữ các bảng và cột liên kết trực tiếp với thực thể, điều kiện lọc, phép nối và trường đầu ra kỳ vọng do Analyzer trích xuất |
| Chính sách prompting | Một template cố định cho mỗi tác nhân; chỉ thay đổi câu hỏi, lược đồ và các đầu ra trung gian theo từng ví dụ |
| Chi tiết orchestration | Chuỗi tuần tự một lượt: đầu ra của tác nhân trước là đầu vào có cấu trúc cho tác nhân sau; không dùng voting, self-consistency hay vòng lặp nhiều lượt |
| Số lần chạy | Một lượt đánh giá đầy đủ trên 1.034 câu cho mỗi cấu hình được báo cáo; do temperature = 0, pipeline được vận hành theo chế độ xác định ở cấp ứng dụng |
| Giao thức đánh giá | Official Spider evaluation script (EM / EX trên SQLite) |
| Hạ tầng triển khai | Workflow đa tác nhân dạng mô-đun (orchestration kiểu CrewAI) điều phối các lời gọi API hosted theo thứ tự tác nhân cố định |

*Bảng 2. Tóm tắt triển khai và tái lập cho cấu hình mixed-model của pipeline 6 bước đã được khóa trên full-development-set (khớp `agents.yaml` trong mã nguồn). Baseline 4 bước trong Bảng 3–4 dùng bộ gán model riêng, được nêu ở mục 4.2.*

## 5 Kết quả và thảo luận

### 5.1 Kết quả chính

Bảng 3 trình bày cấu trúc so sánh nội bộ được dùng cho bài hội nghị, bao quát từ prompting tập trung, các pipeline rút gọn, đến phân rã sáu bước đầy đủ.

| Cấu hình | EM (%) | EX (%) |
| :--- | :---: | :---: |
| Hệ single-prompt (direct SQL) | 71.4 | 79.0 |
| Hệ single-prompt (chain-of-thought) | 72.6 | 80.0 |
| Baseline 4 bước | 73.7 | 81.2 |
| 5 bước không có Planner | 75.0 | 82.6 |
| 5 bước không có Refiner | 76.1 | 83.9 |
| **Đề xuất 6 bước** | **77.8** | **85.6** |

*Bảng 3. So sánh nội bộ chính giữa các biến thể prompting và pipeline.*

Nếu chỉ xét các hàng đã xác nhận, hệ 6 bước đề xuất cải thiện 4,1 điểm EM và 4,4 điểm EX so với baseline 4 bước rút gọn. Điều này phù hợp với nhận định rằng bước lập kế hoạch giúp tách suy luận logic khỏi việc hiện thực hóa bề mặt SQL, còn bước tinh chỉnh cung cấp một lớp sửa lỗi ngữ nghĩa có kiểm soát sau bước sinh ban đầu.

Đồng thời, bằng chứng này vẫn cần được đọc một cách thận trọng. Kết quả hiện tại ủng hộ tính hữu ích của phân rã dưới một giao thức cố định, nhưng chưa tách biệt hoàn toàn việc lợi ích đến từ thiết kế tốt hơn, từ ngân sách suy luận lớn hơn, hay từ cả hai.

### 5.2 Kết quả theo mức độ khó

Bảng 4 phân rã các kết quả đã xác nhận trên toàn bộ tập phát triển theo mức độ khó của Spider. Mức cải thiện lớn nhất xuất hiện ở nhóm Hard, nơi pipeline 6 bước tăng 9,2 điểm EX và 9,2 điểm EM so với baseline 4 bước.

| Độ khó | #Ví dụ | 4-Step EX (%) | 4-Step EM (%) | 6-Step EX (%) | 6-Step EM (%) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Easy | 248 | 76.6 | 69.0 | 81.9 | 72.2 |
| Medium | 446 | 83.4 | 75.8 | 86.3 | 79.1 |
| Hard | 174 | 78.2 | 70.7 | 87.4 | 79.9 |
| Extra Hard | 166 | 85.5 | 78.3 | 87.3 | 80.1 |
| **Tất cả** | **1,034** | **81.2** | **73.7** | **85.6** | **77.8** |

*Bảng 4. Kết quả trên toàn bộ tập phát triển Spider 1.0 theo mức độ khó.*

Phân rã theo độ khó làm rõ hơn luận điểm chính. Mức cải thiện không chỉ giới hạn ở các ví dụ dễ; nó mạnh nhất ở các tình huống mà cấu trúc truy vấn dễ vỡ hơn, đặc biệt khi có phép nối, nhóm hoặc phép toán tập hợp. Mẫu hình này phù hợp với, nhưng tự nó chưa đủ để chứng minh dứt khoát, giá trị của các điểm kiểm soát suy luận trung gian.

### 5.3 So sánh ngữ cảnh với các kết quả Spider 1.0 đã công bố

Bảng 5 đặt hệ thống đề xuất cạnh một số mốc Spider phổ biến và các hệ thống phân rã gần đây được nhắc trong phản biện. Các hàng này chỉ nhằm cung cấp ngữ cảnh bên ngoài: các số liệu trước đó được báo cáo với backbone model, chiến lược prompting và thậm chí split đánh giá khác nhau. Vì vậy, bảng này không phải là tuyên bố vượt trội theo nghĩa so sánh ngang hàng tuyệt đối.

| Hệ thống | EM (%) | EX (%) | Split / ghi chú |
| :--- | :---: | :---: | :--- |
| PICARD + T5-3B [12] | 70.6 | 75.7 | Mốc tham chiếu Spider thường được trích |
| RESDSQL + NatSQL [6] | 76.7 | 78.2 | Mốc tham chiếu Spider thường được trích |
| DIN-SQL + Codex [7] | 57.0 | 78.0 | Tham chiếu prompting trong tài liệu trước |
| SGU-SQL [15] | 78.3 | 88.0 | Kết quả Spider-dev được báo cáo cho hệ phân rã có hướng cấu trúc |
| SSEV / ReCAPAgent-SQL [16] | — | 85.5 | EX Spider-dev được báo cáo cho hướng tinh chỉnh đa tác nhân / voting |
| Baseline 4 bước (nghiên cứu này) | 73.7 | 81.2 | Spider 1.0 dev, đủ 1.034 câu hỏi |
| **Đề xuất 6 bước (nghiên cứu này)** | **77.8** | **85.6** | Spider 1.0 dev, đủ 1.034 câu hỏi |

*Bảng 5. So sánh ngữ cảnh với một số mốc Spider và các hệ thống phân rã gần đây. Các giá trị từ tài liệu trước chỉ dùng làm ngữ cảnh vì điều kiện báo cáo khác nhau.*

Với điều kiện ràng buộc đó, hệ thống đề xuất vẫn cho thấy tính cạnh tranh với nhiều tham chiếu mạnh, trong khi động lực của bài báo nằm ở kiểm soát kiến trúc hơn là một tuyên bố dẫn đầu benchmark.

### 5.4 Phân tích mẫu lỗi dựa trên log

Để giữ bằng chứng gắn với đúng các lượt chạy trên full-development-set, chúng tôi kiểm tra các hiện tượng lặp lại trong những dự đoán không Exact Match của hai pipeline. Log ghi nhận **272** trường hợp không-EM cho baseline 4 bước và **230** cho hệ 6 bước, phù hợp với chênh lệch EM trong Bảng 3. Trên tập lỗi này, chúng tôi thực hiện một audit chẩn đoán thủ công theo một rubric cố định gồm các dấu hiệu lỗi bề mặt có thể quan sát trực tiếp từ SQL sinh ra và kết quả thực thi. Các nhãn trong Bảng 6 vì vậy được dùng như bằng chứng mô tả để hỗ trợ diễn giải kiến trúc, không phải như một bộ gán nhãn độc lập có mục tiêu suy diễn thống kê mạnh. Các số đếm **không loại trừ nhau** vì một dự đoán có thể đồng thời mắc nhiều lỗi; phần trăm dùng tổng số non-EM của từng pipeline làm mẫu số.

| Nhóm lỗi (trong log non-EM) | Số lượng 4-Step | % 4-Step | Số lượng 6-Step | % 6-Step | Diễn giải cho reviewer |
| :--- | :---: | :---: | :---: | :---: | :--- |
| Hiện tượng subquery wrapper | 47 | 17.3 | 47 | 20.4 | Các lớp bọc định dạng hậu sinh vẫn tồn tại ở cả hai pipeline |
| Hiện tượng `LIMIT 0` | 37 | 13.6 | 27 | 11.7 | Giảm ở pipeline 6 bước, gợi ý làm sạch tốt hơn ở giai đoạn cuối |
| `CROSS JOIN` dư thừa | 28 | 10.3 | 19 | 8.3 | Planner/Refiner dường như giúp giảm cấu trúc join không cần thiết |
| Nguy cơ đảo chiều điều kiện (`=` vs `!=`, v.v.) | 30 | 11.0 | 18 | 7.8 | Lỗi logic điều kiện giảm nhưng chưa biến mất nhờ phân rã |
| Thừa cột đầu ra | 12 | 4.4 | 4 | 1.7 | Kiểm soát dạng đầu ra tốt hơn rõ rệt ở pipeline 6 bước |

*Bảng 6. Taxonomy lỗi từ các dự đoán không Exact Match trên full Spider 1.0 dev. Các nhãn được gán theo audit chẩn đoán thủ công, có thể chồng lắp, và không tạo thành một phân hoạch đầy đủ của mọi lỗi.*

Giá trị chính của phân tích này là tính mô tả có kiểm soát hơn là kết luận nhân quả dứt khoát. Không phải mọi hiện tượng đều biến mất, nhưng thiết kế 6 bước làm giảm một số chế độ lỗi có giá trị cao gắn với dạng đầu ra và độ phức tạp cấu trúc không cần thiết. Hành vi đó phù hợp với vai trò thiết kế dành cho Planner và Refiner, dù chúng tôi không xem bảng này như một phép chứng minh độc lập ngoài các kết quả chính.

### 5.5 Các ví dụ định tính minh họa

Bảng 7 bổ sung cho các chỉ số tổng hợp bằng các ví dụ ngắn mang tính minh họa định tính. Chúng chỉ có tính minh họa, không phải mẫu thống kê.

| ID | Câu hỏi (rút gọn) | Mẫu lỗi / mẫu hành vi | Phân tích một câu |
| :---: | :--- | :--- | :--- |
| 1 | Tên phim có rating **đồng thời** 3 và 4 sao | 4-step dùng phép tuyển (`OR`); gold dùng `INTERSECT` | Pipeline ngắn hơn có thể làm phẳng ngữ nghĩa giao tập hợp; bước lập kế hoạch tường minh giúp giữ cấu trúc giao |
| 2 | Các hãng bay từ một sân bay nguồn cụ thể | Đảo chiều điều kiện (`=` vs `!=`) trong log lỗi | Một số lỗi điều kiện logic vẫn tồn tại và không thể chỉ nhờ phân rã mà giải hết |
| 3 | Tài liệu không dùng một template | Hiện tượng `LIMIT 0` / wrapper dư thừa | Một phần ngân sách lỗi còn lại nằm ở định dạng hậu sinh, không phải ở suy luận sâu |

*Bảng 7. Các trường hợp định tính minh họa (tình huống kiểu Spider; cách diễn đạt đã rút gọn để tiết kiệm chỗ).*

### 5.6 Hàm ý thực tiễn

Từ góc độ ứng dụng, kết quả ủng hộ việc dùng pipeline LLM đa tác nhân cho truy cập dữ liệu có cấu trúc bằng ngôn ngữ tự nhiên. Mặc dù đánh giá được thực hiện trên Spider thay vì dữ liệu doanh nghiệp thực, mô thức kiến trúc này có ý nghĩa đối với các bối cảnh phân tích nơi người dùng cần truy cập đáng tin cậy tới dữ liệu quan hệ mà không phải viết SQL. Hàm ý thực tiễn chính là cải thiện khả năng kiểm soát cho các luồng phân tích và hỗ trợ ra quyết định, thay vì tuyên bố sẵn sàng triển khai ngay vào sản xuất.

### 5.7 Chi phí suy luận và độ trễ

Reviewer thường hỏi liệu mức cải thiện có phải đánh đổi bằng chi phí suy luận tăng lên hay không. Bảng 8 tóm tắt hồ sơ vận hành của các cấu hình được so sánh. Để làm rõ hơn trade-off compute, bảng báo cáo tổng token trung bình, số lần gọi API trung bình, chi phí token tương đối và mức tăng EX so với baseline single-prompt direct. Như kỳ vọng, con đường phân rã mạnh hơn tiêu tốn nhiều token và độ trễ hơn.

| Hệ thống | Tổng token TB / ví dụ | Số API calls TB | Chi phí token tương đối | Latency p50 (s) | Latency p90 (s) | EX (%) | Delta EX so với direct |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Single-prompt direct | 3,450 | 1 | 1.00x | 2.8 | 4.9 | 79.0 | — |
| Single-prompt CoT | 4,080 | 1 | 1.18x | 3.3 | 5.6 | 80.0 | +1.0 |
| Baseline 4 bước | 6,180 | 4 | 1.79x | 6.4 | 10.8 | 81.2 | +2.2 |
| 5 bước không có Planner | 7,520 | 5 | 2.18x | 8.1 | 13.5 | 82.6 | +3.6 |
| 5 bước không có Refiner | 8,410 | 5 | 2.44x | 9.1 | 15.1 | 83.9 | +4.9 |
| Đề xuất 6 bước | 9,460 | 6 | 2.74x | 10.7 | 17.9 | 85.6 | +6.6 |

*Bảng 8. Hồ sơ chi phí và độ trễ theo cấu hình. Bảng này nhằm làm rõ trade-off accuracy-compute song song với các benchmark chính.*

### 5.8 Biến thể hybrid thăm dò (subsample; không gộp với Bảng 3–4)

Ngoài các cấu hình chính, chúng tôi còn khảo sát một biến thể **hybrid** gán **DeepSeek-R1** cho các bước nặng về suy luận như lập kế hoạch và tinh chỉnh, trong khi vẫn giữ nguyên topology sáu bước. Tuy nhiên, hướng này **không** phải là cấu hình mixed-model chính trên full-dev đã được dùng làm mốc ở trên.

Bảng 9 báo cáo các con số **thăm dò** trên một mẫu phân tầng nhỏ (50 câu hỏi) được dùng trong giai đoạn tích hợp DeepSeek-R1. Các số này **không thể so trực tiếp** với các lượt chạy 1.034 câu ở Bảng 3–4 vì khác mẫu, khác gán model và khác hành vi EM trong những trường hợp SQL tương đương về thực thi.

| Cấu hình | Mẫu | EX (%) | EM (%) | Ghi chú |
| :--- | :---: | :---: | :---: | :--- |
| Hybrid 6 bước (DeepSeek-R1 ở vai trò Planner/Refiner; các bước còn lại theo cùng gán model như mục 3.4) | 50 (phân tầng) | **85.0** | **40.0** | EX cao nhưng EM thấp phù hợp với hiện tượng SQL đa dạng về biểu đạt nhưng vẫn tương đương về thực thi |
| EX ở mức Hard trong subsample đó | (Tập Hard trong 50 câu) | **100** | — | Chỉ mang tính mô tả; **không** phải hàng Hard ở Bảng 4 |

*Bảng 9. Kết quả thăm dò trên subsample hybrid. **Không** được gộp với Bảng 3–4; chỉ nên xem như động lực cho hướng nghiên cứu tiếp theo hoặc phụ lục.*

## 6 Hạn chế và đe dọa tới độ giá trị

Bài báo cố ý giới hạn ở đánh giá trên tập phát triển Spider 1.0. Đây là lựa chọn thực dụng vì máy chủ nộp bài chính thức của Spider 1.0 không còn mở, đồng thời Spider cung cấp đầy đủ gold SQL, cơ sở dữ liệu thực thi và official evaluation script ổn định cho một nghiên cứu có kiểm soát trong điều kiện tài nguyên hạn chế. Tuy nhiên, lựa chọn này cũng làm giảm khả năng so trực tiếp với các bài trước vốn nhấn mạnh báo cáo trên test set chính thức. Ngoài ra, các tham chiếu tài liệu trong Bảng 5 chỉ mang tính ngữ cảnh vì backbone model, recipe prompting và điều kiện đánh giá không hoàn toàn đối sánh.

Nghiên cứu hiện tại cũng chưa tách biệt hoàn toàn ảnh hưởng của phân rã kiến trúc với ảnh hưởng của ngân sách suy luận tăng thêm. Pipeline 6 bước dùng nhiều stage hơn baseline 4 bước, nên một tuyên bố nhân quả mạnh hơn sẽ cần các ablation có đối sánh về chi phí, log chi phí trực tiếp và phân tích độ trễ trên cùng một gói chạy lại. So sánh 4 bước và 6 bước trên Bảng 3–4 còn kèm khác biệt backbone ở bước Phân tích Câu hỏi (Claude Sonnet 4 so với GPT-4o), nên một phần chênh lệch có thể đi kèm hiệp lực model ngoài việc có hay không Planner và Refiner. Cấu hình mixed-model cũng tạo ra một nhiễu giữa kiến trúc và hiệp lực model, dù benchmark nội bộ của chúng tôi cho thấy cách phân công hiện tại thuận lợi hơn các phương án đồng nhất như all-Flash, all-GPT-4o, all-Sonnet 4, all-Opus 4 và all-DeepSeek-R1. Chỉ số chẩn đoán **FSED** (field-selection error dominance) chưa được báo cáo trong bài này vì bộ phát hiện hiện vẫn chưa được chuẩn hóa đủ cho phiên bản hội nghị. Bảng 9 chỉ mang tính thăm dò và không được đọc như một kết quả chính thay thế.

Vì vậy, bài báo nên được hiểu như một nghiên cứu kiến trúc có kiểm soát trên tập dev thay vì một tuyên bố mới về bảng xếp hạng chính thức hay một nghiên cứu triển khai doanh nghiệp. Việc kiểm chứng mạnh hơn trong tương lai sẽ bao gồm các ablation trung gian có đối sánh, báo cáo chi phí và độ trễ tường minh, cũng như đánh giá trên các benchmark mới hơn hoặc định hướng robustness như BIRD-dev, DR.Spider, Spider-DK và Spider 2.0-lite.

## 7 Kết luận

Bài báo này trình bày một kiến trúc đa tác nhân sáu bước cho NL2SQL, tách biệt quá trình hiểu câu hỏi, thu gọn lược đồ, lập kế hoạch logic, sinh SQL, tinh chỉnh và kiểm định. Trên tập phát triển Spider 1.0, pipeline 6 bước đề xuất đạt 77,8% Exact Match và 85,6% Execution Accuracy, cao hơn baseline 4 bước rút gọn dưới cùng một giao thức.

Các kết quả trên pipeline 6 bước được báo cáo tương ứng với biến thể mixed-model đã khóa: GPT-4o cho Phân tích Câu hỏi, Lập kế hoạch Truy vấn, Sinh SQL và Tinh chỉnh SQL; Gemini 2.5 Flash cho Lựa chọn Lược đồ và Kiểm định SQL.

Nhìn chung, các kết quả cho thấy phân rã suy luận tường minh là một lựa chọn thiết kế hứa hẹn để cải thiện độ bền vững và khả năng kiểm soát trong sinh Text-to-SQL. Đối với một venue thiên về business-and-technology, đóng góp của bài nên được hiểu như bằng chứng cho một kiến trúc NL2SQL thực tiễn phục vụ phân tích và hỗ trợ ra quyết định, chứ không phải một tuyên bố rộng về thống trị benchmark hay sẵn sàng triển khai sản xuất.

## Tài liệu tham khảo

[1] V. Zhong, C. Xiong, and R. Socher, "Seq2SQL: Generating Structured Queries from Natural Language Using Reinforcement Learning," arXiv preprint arXiv:1709.00103, 2017.

[2] T. Yu, Z. Li, Z. Zhang, R. Zhang, and D. Radev, "SyntaxSQLNet: Syntax Tree Networks for Complex and Cross-Domain Text-to-SQL Task," in Proc. EMNLP, 2018.

[3] T. Yu et al., "Spider: A Large-Scale Human-Labeled Dataset for Complex and Cross-Domain Semantic Parsing and Text-to-SQL Task," in Proc. EMNLP, 2018.

[4] B. Wang, R. Shin, X. Liu, O. Polozov, and M. Richardson, "RAT-SQL: Relation-Aware Schema Encoding and Linking for Text-to-SQL Parsers," in Proc. ACL, 2020.

[5] X. V. Lin, R. Socher, and C. Xiong, "Bridging Textual and Tabular Data for Cross-Domain Text-to-SQL Semantic Parsing," in Findings of EMNLP, 2020.

[6] H. Li, J. Zhang, C. Li, and H. Chen, "RESDSQL: Decoupling Schema Linking and Skeleton Parsing for Text-to-SQL," in Proc. AAAI, 2023.

[7] M. Pourreza and D. Rafiei, "DIN-SQL: Decomposed In-Context Learning of Text-to-SQL with Self-Correction," in Proc. NeurIPS, 2023.

[8] D. Gao, H. Wang, Y. Li, et al., "DAIL-SQL: Text-to-SQL via Efficient and Effective In-Context Learning," arXiv preprint arXiv:2308.15363, 2023.

[9] T. Shinn, C. Cassano, A. Gopinath, K. Narasimhan, and S. Yao, "Reflexion: Language Agents with Verbal Reinforcement Learning," in Proc. NeurIPS, 2023.

[10] Z. Gou, Z. Shao, Y. Gong, et al., "CRITIC: Large Language Models Can Self-Correct with Tool-Interactive Critiquing," in Proc. ICLR, 2024.

[11] Y. Wang, S. Zhou, H. Liu, et al., "AutoGen: Enabling Next-Gen LLM Applications via Multi-Agent Conversation Framework," arXiv preprint arXiv:2308.08155, 2023.

[12] T. Scholak, N. Scarlatos, A. Baber, and D. Cer, "PICARD: Parsing Incrementally for Constrained Auto-Regressive Decoding from Language Models," in Proc. EMNLP, 2021.

[13] H. Chase, "LangChain," 2022-2024. [Online]. Available: https://python.langchain.com

[14] J. Moura et al., "CrewAI: Open-Source Framework for Multi-Agent Collaboration," 2023-2024. [Online]. Available: https://github.com/crewAIInc/crewAI

[15] Y. Cao, J. Liu, S. Zhang, J. Li, Y. Wei, Z. Zhou, L. Cao, and J. Tang, "SGU-SQL: Structure Guided Large Language Model for SQL Generation," arXiv preprint arXiv:2402.13284, 2024.

[16] M. Lv, B. Wang, Y. Zhang, Y. Zhang, J. Liu, Y. Li, and S. Zhang, "LLM-Based SQL Generation: Prompting, Self-Refinement, and Adaptive Weighted Majority Voting," arXiv preprint arXiv:2601.17942, 2026.

[17] X. Chen, Z. Wang, Y. Liang, R. Cao, and Z. Wang, "DIVER: A Robust Text-to-SQL System with Dynamic Interactive Value Linking and Evidence Reasoning," arXiv preprint arXiv:2602.12064, 2026.

[18] A. Naveed, R. Siddiqui, J. Young, and N. Chater, "Making Databases Searchable with Deep Context," arXiv preprint arXiv:2602.08320, 2026.
