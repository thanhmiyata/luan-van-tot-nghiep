Khung đa tác nhân mô-đun cho đánh giá và tinh chỉnh sinh NL2SQL

## Tóm tắt

Chuyển đổi ngôn ngữ tự nhiên sang SQL (NL2SQL) giúp người dùng truy vấn cơ sở dữ liệu bằng câu hỏi tự nhiên, nhưng vẫn dễ sai khi truy vấn phức tạp đòi hỏi liên kết lược đồ, lập kế hoạch nhiều bước, hoặc lựa chọn đúng trường đầu ra. Trong khi nhiều nghiên cứu tập trung tối ưu lời nhắc và mô hình, vẫn thiếu một khung có chuỗi xử lý cấu hình được để đánh giá có cấu trúc vai trò của từng thành phần trong quy trình NL2SQL.

Bài báo này đề xuất một khung NL2SQL đa tác nhân theo chuỗi xử lý tuần tự gồm: phân tích câu hỏi, lọc lược đồ, lập kế hoạch logic, sinh SQL, tinh chỉnh một lần và kiểm tra kỹ thuật. Khung hỗ trợ hai cấu hình để đánh giá: cấu hình cơ sở (4-step) và cấu hình đầy đủ (6-step). Trên Spider 1.0 (1.034 câu hỏi), cấu hình đầy đủ đạt Exact Match (EM) 76.8% và Execution Accuracy (EX) 84.1%, trong khi cấu hình cơ sở đạt EM 71.2% và EX 79.5%. Ngoài kết quả chính, chúng tôi mô tả giao thức thí nghiệm cắt giảm dự kiến và phân loại lỗi kèm một ví dụ định tính để hỗ trợ phân tích theo thành phần.

## 1. Giới thiệu

NL2SQL cho phép người dùng đặt câu hỏi bằng ngôn ngữ tự nhiên và hệ thống trả về truy vấn SQL để trích xuất câu trả lời từ cơ sở dữ liệu. Bài toán này xuất hiện trong nhiều ngữ cảnh: phân tích dữ liệu doanh nghiệp, trợ lý dữ liệu, và các công cụ phân tích tự phục vụ. Trong thực tế, câu hỏi hiếm khi chỉ là lọc đơn giản trên một bảng; người dùng thường yêu cầu phép nối nhiều bảng (JOIN), tổng hợp (COUNT/GROUP BY), truy vấn con, hoặc phép toán tập hợp. Các yêu cầu này khiến NL2SQL không chỉ là “dịch câu sang SQL”, mà là một quy trình suy luận có cấu trúc.

Trong vài năm gần đây, việc dùng mô hình ngôn ngữ lớn (LLM) cho NL2SQL trở nên phổ biến nhờ khả năng suy luận và tạo mã linh hoạt. Tuy nhiên, cách tiếp cận “một lượt sinh SQL” vẫn dễ mắc lỗi hệ thống. Hai dạng khó khăn thường gặp là (i) liên kết lược đồ không ổn định khi lược đồ lớn, nhiều cột tên gần giống; và (ii) lựa chọn trường đầu ra sai, dù hệ thống có thể nắm đúng ý định logic ở mức tổng quan. Thực tế này cho thấy cần một quy trình có phân vai rõ ràng: bước nào chịu trách nhiệm phân tích ý định, bước nào chịu trách nhiệm lọc lược đồ, bước nào lập kế hoạch logic, và bước nào được phép sửa lỗi ngữ nghĩa.


Một vấn đề phương pháp luận là nhiều hệ NL2SQL vẫn được đánh giá như một khối đen. Khi thay đổi lời nhắc hoặc quy trình, ta khó truy nguyên vai trò của từng bước: lỗi giảm là do phân tích tốt hơn, do lập kế hoạch tốt hơn, hay do tinh chỉnh/kiểm tra tốt hơn. Với NL2SQL, điều này đặc biệt quan trọng vì nhiều lỗi có tính hệ thống và lặp lại theo mẫu (ví dụ nhầm cột gần nghĩa, hoặc dùng COUNT thay vì COUNT(DISTINCT)).

Chúng tôi đề xuất một khung NL2SQL đa tác nhân theo hướng mô-đun hóa chuỗi xử lý. Thay vì xem NL2SQL là một lần gọi LLM, khung tách chuỗi xử lý thành các tác nhân với vai trò riêng, chạy theo thứ tự cố định và trao đổi ngữ cảnh có cấu trúc. Cách thiết kế này có hai mục tiêu: (i) tạo ra một quy trình sinh SQL dễ quan sát và dễ gỡ lỗi hơn; và (ii) quan trọng không kém, cho phép cấu hình chuỗi xử lý để đánh giá có cấu trúc (ví dụ bật/tắt các thành phần lập kế hoạch hoặc tinh chỉnh).

Trong bài báo này, chúng tôi tập trung so sánh hai cấu hình của chuỗi xử lý:

- **Cấu hình cơ sở (4-step)**: Phân tích câu hỏi → Chọn lược đồ → Chuyên gia SQL → Kiểm tra SQL.
- **Cấu hình đầy đủ (6-step)**: Phân tích câu hỏi → Chọn lược đồ → Lập kế hoạch truy vấn → Chuyên gia SQL → Tinh chỉnh SQL → Kiểm tra SQL.

Trên Spider 1.0 (1.034 câu hỏi), cấu hình đầy đủ đạt **EM 76.8% / EX 84.1%**, trong khi cấu hình cơ sở đạt **EM 71.2% / EX 79.5%**. Chúng tôi diễn giải kết quả theo góc nhìn chuỗi xử lý: việc thêm lập kế hoạch và tinh chỉnh một lần tạo ra một quy trình có kiểm soát tốt hơn đối với các truy vấn nhiều bước. Đồng thời, để tránh diễn giải quá mức, chúng tôi coi các con số này là bằng chứng trong bối cảnh triển khai và giao thức đánh giá của nghiên cứu này, không phải là kết luận “tối ưu toàn cục”.

**Đóng góp chính** của bài báo gồm:

- **C1 (Khung)**: Đề xuất một khung NL2SQL đa tác nhân với chuỗi xử lý cấu hình được, tách rõ ba pha: phân tích & liên kết lược đồ, lập kế hoạch & sinh SQL, tinh chỉnh & kiểm tra.
- **C2 (Thiết kế hướng đánh giá)**: Thiết kế hai cấu hình chuỗi xử lý (cấu hình cơ sở 4-step và cấu hình đầy đủ 6-step) để phục vụ đánh giá có cấu trúc, dễ mở rộng sang thí nghiệm cắt giảm theo thành phần.
- **C3 (Bằng chứng và phân tích thực nghiệm)**: Báo cáo kết quả trên Spider 1.0 với hai chỉ số chuẩn (EM, EX) và cung cấp phân tích lỗi định tính + giao thức thí nghiệm cắt giảm dự kiến nhằm hỗ trợ nghiên cứu tiếp theo.

Phần còn lại của bài báo được tổ chức như sau. Mục 2 điểm qua các hướng nghiên cứu liên quan về NL2SQL, LLM cho chuyển đổi văn bản sang SQL, và hệ thống đa tác nhân. Mục 3 mô tả khung và phương pháp, bao gồm kiến trúc tổng thể, thiết kế chuỗi xử lý mô-đun, các cấu hình chuỗi xử lý, và Thuật toán 1. Mục 4 trình bày thực nghiệm, bao gồm thiết lập, kết quả chính (Bảng 1), và kế hoạch thí nghiệm cắt giảm (Mục 4.3). Mục 5 phân tích lỗi theo phân loại và đưa một ví dụ minh họa. Mục 6 thảo luận các đánh đổi và tính tổng quát. Mục 7 kết luận và nêu hướng tương lai. Phần Phụ lục cung cấp chỗ giữ chỗ cho cấu hình/lời nhắc và liên kết mã nguồn.

## 2. Công trình liên quan

Mục này tập trung vào ba nhóm công trình: (i) hệ thống NL2SQL truyền thống và các mô hình có cấu trúc, (ii) NL2SQL dựa trên LLM, và (iii) các khung đa tác nhân và LLM tăng cường công cụ. Mục tiêu của chúng tôi không phải là so sánh theo “thành tích”, mà là định vị khoảng trống về thiết kế chuỗi xử lý có thể cấu hình để đánh giá vai trò từng bước.

### 2.1 Các hệ thống chuyển đổi văn bản sang SQL

Các hệ NL2SQL truyền thống thường dựa trên mô hình seq2seq hoặc các kiến trúc sinh SQL theo cấu trúc cú pháp. Dòng công trình này đóng góp hai ý tưởng nền tảng: (i) biểu diễn câu hỏi và lược đồ theo cách có thể học được, và (ii) tạo SQL theo một không gian có cấu trúc thay vì chỉ sinh chuỗi ký tự thuần [1–5]. Trên các bộ dữ liệu phức tạp và đa miền như Spider, một thách thức trọng tâm là **liên kết lược đồ**: hệ thống phải ánh xạ các cụm từ trong câu hỏi tới đúng bảng/cột, trong khi tên cột có thể dài, viết tắt, hoặc đa nghĩa [3, 11]. Các mô hình nhận thức quan hệ và các mô-đun tách biệt liên kết–mã hóa lược đồ là những lựa chọn phổ biến nhằm giảm nhầm lẫn giữa các phần tử lược đồ gần nghĩa [4, 5].

Một vấn đề khác của NL2SQL truyền thống là **độ phức tạp của không gian truy vấn**: khi truy vấn có nhiều JOIN, truy vấn lồng, và tổng hợp, việc sinh “đúng cấu trúc” quan trọng không kém việc sinh “đúng từ khóa”. Do đó, nhiều hệ nhấn mạnh sinh theo cây cú pháp, theo các vị trí trường, hoặc theo các bước tạo cấu trúc trung gian để giảm lỗi cú pháp và giúp mô hình tập trung vào quyết định cấu trúc (ví dụ có cần GROUP BY hay không) [2]. Tuy nhiên, phần lớn các hệ vẫn mang tính “một lượt”: khi truy vấn ban đầu sai, cơ chế sửa thường nằm trong giải mã hoặc trong huấn luyện, chứ không phải một bước tinh chỉnh có thể tách ra để đánh giá vai trò.

Trong bối cảnh bài toán phức tạp (nhiều JOIN, truy vấn lồng, tổng hợp), việc tách bạch các nhiệm vụ con trở nên quan trọng. Một số phương pháp nhấn mạnh ràng buộc cú pháp trong quá trình sinh (giải mã có ràng buộc) hoặc kiểm tra hợp lệ [12]. Tuy nhiên, kiểm tra kỹ thuật không tự động giải quyết được lỗi ngữ nghĩa như chọn sai cột trong SELECT, nhầm điều kiện JOIN, hay lựa chọn sai kiểu tổng hợp. Điều này gợi ý cần các thành phần chuyên trách cho suy luận logic (lập kế hoạch) và cho tinh chỉnh có mục tiêu.

Từ góc nhìn bài báo này, điều quan trọng là: các công trình truyền thống đã cung cấp nhiều cơ chế “đưa lược đồ vào mô hình” và “ràng buộc cú pháp”, nhưng **không trực tiếp cung cấp một khung với chuỗi xử lý cấu hình được** để tách riêng các vai trò phân tích–lập kế hoạch–tinh chỉnh theo nghĩa hệ thống. Khoảng trống này trở nên rõ hơn khi chuyển sang các hệ dựa trên LLM, nơi “vai trò tác nhân” và “giao thức truyền ngữ cảnh” có thể được xem như một dạng mô-đun hóa ở mức triển khai.

### 2.2 Chuyển đổi văn bản sang SQL dựa trên LLM

LLM giúp đơn giản hóa triển khai NL2SQL nhờ khả năng học theo ngữ cảnh và sinh mã. Với một lời nhắc phù hợp, LLM có thể tạo SQL mà không cần tinh chỉnh mô hình. Tuy vậy, trong các bài toán nhiều bước và khi lược đồ lớn, hệ thống vẫn có thể thất bại theo những mẫu lỗi lặp lại.

Trong các lần chạy trên Spider của chúng tôi, một dạng thất bại lặp lại là **chọn trường**: mô hình thường nắm được ý định tổng thể nhưng lại chọn một cột đầu ra có vẻ hợp lý về ngữ nghĩa song không đúng, đặc biệt khi lược đồ có các trường gần đồng nghĩa. Quan sát này thúc đẩy thiết kế “hợp đồng” `expected_output_fields` do tác nhân Phân tích câu hỏi tạo ra và tác nhân tinh chỉnh một lần theo ràng buộc để căn chỉnh mệnh đề SELECT cuối cùng với ý định đã phân tích.

Khi dùng LLM, người phát triển thường đối mặt với hai loại quyết định: (i) **quyết định lời nhắc/ngữ cảnh** (đưa gì vào đầu vào: lược đồ đầy đủ, lược đồ rút gọn, có ví dụ minh họa hay không, hay tập quy tắc), và (ii) **quyết định quy trình** (sinh một lần hay nhiều lần; có kiểm tra/đánh giá/ghi nhận lỗi hay không). Ở mức hệ thống, lỗi NL2SQL thường xuất phát từ việc LLM phải “gánh” quá nhiều trách nhiệm trong một lượt: vừa hiểu câu hỏi, vừa chọn bảng/cột, vừa suy luận đường JOIN, vừa đảm bảo cú pháp. Khi không có phân vai, một sai lệch nhỏ ở bước chọn cột có thể lan sang cấu trúc truy vấn.

Một số hướng gần đây khai thác phân rã nhiệm vụ hoặc tự sửa lỗi. Dưới góc nhìn thiết kế hệ thống, điểm chung của các hướng này là thừa nhận rằng NL2SQL cần nhiều hơn một lần sinh: hoặc cần phân rã, hoặc cần kiểm tra, hoặc cần sửa. Tuy nhiên, nhiều hệ vẫn giữ logic trong một tác nhân lớn, khiến việc đánh giá vai trò từng phần trở nên khó khăn: khi thay đổi lời nhắc, ta không biết thành phần nào thực sự tạo lợi ích.

Ngoài ra, đối với chuyển đổi văn bản sang SQL, một khó khăn đặc thù là **sự không ổn định do lược đồ**: cùng một câu hỏi, khi lược đồ thay đổi (tên cột khác, bảng trung gian khác), LLM có thể sinh truy vấn khác đáng kể. Vì vậy, nhiều triển khai thực tế cố gắng **giảm nhiễu lược đồ** bằng cách rút gọn lược đồ trước khi đưa vào lời nhắc, hoặc bằng cách giới hạn lựa chọn bảng/cột. Điều này gợi ý rằng một mô-đun “Chọn lược đồ” là hữu ích và có thể được đánh giá độc lập với mô-đun “Chuyên gia SQL”.

### 2.3 LLM đa tác nhân và tăng cường công cụ

Khung đa tác nhân được dùng để giải quyết tác vụ phức tạp bằng cách phân vai và phối hợp. Các khung như CrewAI, LangChain Agents, hoặc các khung hội thoại đa tác nhân cung cấp “cơ sở hạ tầng” để xây dựng chuỗi xử lý gồm nhiều tác nhân và cơ chế truyền ngữ cảnh [8–10]. Ngoài ra, các hướng tăng cường công cụ cho LLM nhấn mạnh việc dùng công cụ để kiểm tra/đánh giá đầu ra (ví dụ kiểm tra cú pháp, chạy thử, hoặc đối soát), còn RAG tác nhân nhấn mạnh truy xuất thông tin theo nhu cầu.

Trong hệ thống tăng cường công cụ, một ý tưởng quan trọng là tách bạch giữa “sinh” và “kiểm tra”. Ở bài toán chuyển đổi văn bản sang SQL, kiểm tra có thể bao gồm: (i) đối soát tên bảng/cột với lược đồ, (ii) kiểm tra cú pháp, và (iii) kiểm tra các ràng buộc hình thức. Tuy nhiên, kiểm tra không tương đương với sửa. Nếu hệ thống muốn sửa các lỗi ngữ nghĩa (như chọn sai trường), nó cần một cơ chế có quyền sửa logic—đây là động lực để đặt tác nhân tinh chỉnh như một tác nhân riêng, thay vì ép tác nhân kiểm tra vừa kiểm tra vừa sửa.

Đối với mô hình đa tác nhân, thách thức không nằm ở việc “có nhiều tác nhân”, mà nằm ở **định nghĩa vai trò và giao diện thông tin**. Nếu các tác nhân chia sẻ cùng một mục tiêu nhưng không có ranh giới trách nhiệm, hệ thống dễ bị vòng lặp sửa–phá hoặc tạo ra các quyết định mâu thuẫn. Vì vậy, khung của chúng tôi coi “giao diện I/O” là một phần của phương pháp luận: mỗi tác nhân nhận một đầu vào có cấu trúc và trả về đầu ra có cấu trúc, giúp chuỗi xử lý có thể quan sát và có thể phục vụ thí nghiệm cắt giảm.

Điểm quan trọng đối với NL2SQL là: đa tác nhân không tự động tốt hơn nếu các vai trò không được định nghĩa rõ và nếu trách nhiệm bị chồng lấn (ví dụ vừa sinh vừa sửa trong cùng một tác nhân). Do đó, để tránh diễn giải quá mức, chúng tôi coi đa tác nhân như một lựa chọn kiến trúc giúp tăng khả năng quan sát, giúp mô-đun hóa, và giúp thiết kế đánh giá có cấu trúc. Khung của chúng tôi tập trung vào ba quyết định thiết kế:

- **Phân vai theo lỗi hệ thống**: tạo một bước riêng cho phân tích câu hỏi và trường đầu ra, thay vì trộn vào bước sinh SQL.
- **Tách lập kế hoạch khỏi sinh SQL**: lập kế hoạch logic (không viết SQL) trước khi sinh SQL.
- **Tinh chỉnh một lần, có kiểm soát**: cho phép sửa lỗi ngữ nghĩa ở đúng nơi (tác nhân tinh chỉnh), trong khi tác nhân kiểm tra chỉ làm kiểm tra kỹ thuật và không thay đổi logic.

### 2.4 Phân tích khoảng trống

Từ các hướng trên, chúng tôi thấy khoảng trống thực tiễn: thiếu một khung NL2SQL “hướng đánh giá”, trong đó chuỗi xử lý có thể cấu hình để so sánh có cấu trúc, và các thành phần được định nghĩa đủ rõ để phục vụ thí nghiệm cắt giảm và phân tích lỗi. Bài báo này đề xuất một thiết kế như vậy và báo cáo kết quả so sánh giữa cấu hình cơ sở và cấu hình đầy đủ trên Spider 1.0.

## 3. Khung và phương pháp

Mục này mô tả khung đa tác nhân và các quyết định thiết kế để hỗ trợ đánh giá có cấu trúc. Trọng tâm là mô tả chuỗi xử lý mô-đun, luồng dữ liệu giữa các tác nhân, và các cấu hình của chuỗi xử lý. Toàn bộ mô tả chi tiết về lời nhắc/hướng dẫn theo vai trò được đưa sang Phụ lục để tránh làm nặng phần thân bài.

### 3.1 Phát biểu bài toán

**Bài toán NL2SQL.** Cho một câu hỏi ngôn ngữ tự nhiên \(Q\) và lược đồ cơ sở dữ liệu \(S\) (bao gồm danh sách bảng, cột, kiểu dữ liệu, và quan hệ khóa ngoại), mục tiêu là sinh một truy vấn SQL \(y\) sao cho khi thực thi \(y\) trên cơ sở dữ liệu \(D\) sẽ trả về kết quả đúng với ý định câu hỏi.

**Chỉ số đánh giá.** Chúng tôi sử dụng hai chỉ số chuẩn cho chuyển đổi văn bản sang SQL:

- **Exact Match (EM)**: đo mức khớp giữa SQL dự đoán và SQL tham chiếu theo tiêu chí tương đương (phụ thuộc giao thức đánh giá của bộ dữ liệu).
- **Execution Accuracy (EX)**: đo mức đúng khi thực thi: kết quả truy vấn dự đoán trùng với kết quả của truy vấn tham chiếu trên cơ sở dữ liệu.

Trong bài báo, EX được coi là chỉ số chính vì phản ánh đúng-ngữ-nghĩa và khoan dung với các biểu thức SQL tương đương.

### 3.2 Tổng quan khung

Khung của chúng tôi mô hình hóa NL2SQL như một chuỗi xử lý tuần tự gồm nhiều tác nhân. Mỗi tác nhân thực hiện đúng một vai trò và xuất ra một dạng ngữ cảnh có cấu trúc để tác nhân sau sử dụng. Thiết kế này hướng tới hai lợi ích: (i) giảm “gánh nặng nhận thức” cho mỗi tác nhân, và (ii) làm rõ đường đi của thông tin để phục vụ phân tích.

Để khung có thể “đánh giá được”, chúng tôi chú trọng vào hai nguyên tắc triển khai:

- **Ngữ cảnh có cấu trúc**: thay vì truyền tự do giữa các tác nhân, mỗi tác nhân tạo ra một đầu ra có các trường rõ ràng (ví dụ danh sách trường cần SELECT, danh sách bảng/cột được chọn, hoặc kế hoạch logic theo bước). Điều này giúp giảm mơ hồ khi các tác nhân sau đọc lại ngữ cảnh.
- **Trách nhiệm không chồng lấn**: mỗi tác nhân chỉ chịu trách nhiệm cho một lớp quyết định. Ví dụ, tác nhân kiểm tra kiểm tra kỹ thuật và báo cáo; tác nhân tinh chỉnh mới được phép sửa logic. Cách phân vai này giúp dễ thẩm định và giúp thí nghiệm cắt giảm theo thành phần “sạch” hơn.

**Hình 1** mô tả kiến trúc tổng thể. Do bài viết được trình bày dưới dạng văn bản, chúng tôi dùng sơ đồ ký tự (có thể thay bằng hình trong bản nộp cuối).

**Hình 1. Kiến trúc tổng thể của khung đa tác nhân cho NL2SQL**

```
Natural-language Question Q + Full Schema S
                |
                v
      +--------------------+
      | Question Analyzer  |  -> analysis (intent, constraints, expected_output_fields, ...)
      +--------------------+
                |
                v
      +--------------------+
      | Schema Selector    |  -> filtered_schema (tables/columns/keys relevant to Q)
      +--------------------+
                |
                v
      +--------------------+        +--------------------+
      | Query Planner      |  ->    | SQL Expert         |  -> initial_sql
      | (logic plan only)  |        | (generate SQL)     |
      +--------------------+        +--------------------+
                |                              |
                v                              v
      +--------------------+        +--------------------+
      | SQL Refiner        |  ->    | SQL Validator      |  -> final_sql (+ diagnostics)
      | (single-pass fix)  |        | (check only)       |
      +--------------------+        +--------------------+
```

Trong khung này, tác nhân **tinh chỉnh** là tác nhân duy nhất được phép sửa logic ngữ nghĩa dựa trên phân tích và kế hoạch; tác nhân **kiểm tra** chỉ kiểm tra kỹ thuật và báo cáo lỗi, không “sáng tác lại” logic để tránh chồng lấn trách nhiệm.

Để làm rõ giao diện thông tin, Bảng dưới đây (không phải bảng kết quả) liệt kê ngắn gọn đầu vào/đầu ra của từng tác nhân trong cấu hình đầy đủ.

| Tác nhân | Đầu vào chính | Đầu ra (dạng cấu trúc) | Vai trò chính |
| :--- | :--- | :--- | :--- |
| Phân tích câu hỏi | \(Q\), \(S\) | `analysis` (intent, constraints, expected_output_fields, …) | Trích xuất ý định và trường cần trả về |
| Chọn lược đồ | `analysis`, \(S\) | `schema_filtered` (tables/columns/keys) | Lọc lược đồ liên quan, giảm nhiễu |
| Lập kế hoạch truy vấn | `analysis`, `schema_filtered` | `plan` (mục tiêu con, đường JOIN, tổng hợp, phép toán tập hợp, …) | Lập kế hoạch logic (không viết SQL) |
| Chuyên gia SQL | `analysis`, `schema_filtered`, `plan` | `y0` (initial SQL) | Sinh SQL từ kế hoạch và lược đồ |
| Tinh chỉnh SQL | `y0`, \(Q\), `analysis`, `schema_filtered`, `plan` | `y1` (refined SQL + note) | Tinh chỉnh một lần, sửa sai lệch ngữ nghĩa |
| Kiểm tra SQL | `y1`, `schema_filtered` | `report` (hợp lệ/lỗi + chẩn đoán) | Kiểm tra kỹ thuật, đối soát lược đồ |

**Triển khai như một khung nghiên cứu có thể cấu hình.** Vượt ra ngoài một chuỗi xử lý ở mức khái niệm, chúng tôi triển khai hệ thống đề xuất dưới dạng một khung nghiên cứu mô-đun gồm: (i) các tệp lời nhắc/cấu hình theo từng tác nhân, (ii) một bộ quản lý chuỗi xử lý có thể chuyển giữa cấu hình 4-step và 6-step bằng một cờ duy nhất, và (iii) một trình chạy đánh giá thống nhất cho Spider. Để phục vụ tái lập và phân tích, khung này ghi lại các tư liệu trung gian cho mỗi mẫu: `analysis`, `schema_filtered`, `plan` (nếu bật), SQL ban đầu `y0`, SQL sau tinh chỉnh `y1` (nếu bật), và báo cáo của tác nhân kiểm tra `report`. Thiết kế này cho phép thí nghiệm cắt giảm theo thành phần và phân tích lỗi có hệ thống mà không thay đổi giao thức đánh giá.

### 3.3 Thiết kế chuỗi xử lý mô-đun (3 pha)

Chúng tôi chia chuỗi xử lý thành ba pha, phù hợp với các nguồn lỗi phổ biến trong NL2SQL.

#### Pha 1: Phân tích & liên kết lược đồ

**Mục tiêu.** Làm rõ ý định câu hỏi và giảm không gian tìm kiếm lược đồ trước khi sinh SQL.

- **Phân tích câu hỏi**: trích xuất ý định, thực thể liên quan, ràng buộc (lọc, sắp xếp, tổng hợp), và đặc biệt là danh sách trường cần xuất ra (các trường đầu ra kỳ vọng) theo đúng yêu cầu của câu hỏi.
- **Chọn lược đồ**: lọc lược đồ đầy đủ để giữ các bảng/cột liên quan, cùng các khóa chính/ngoại cần thiết cho JOIN.

**Lý do thiết kế.** Nếu sinh SQL khi vẫn dùng lược đồ đầy đủ, LLM có thể bị “nhiễu” bởi các cột không liên quan. Đồng thời, chọn trường sai thường xuất hiện sớm và kéo theo các sai lệch logic về sau. Do đó, khung tách rõ hai tác vụ này thành Pha 1.

**Đầu ra ví dụ (rút gọn).** Để tránh đưa lời nhắc dài vào thân bài, chúng tôi chỉ minh họa cấu trúc đầu ra ở mức tối thiểu:

```json
{
  "intent": "retrieve",
  "expected_output_fields": ["<TABLE>.<COLUMN>"],
  "constraints": {
    "filters": [
      {
        "column": "<TABLE>.<COLUMN>",
        "op": "=",
        "value_hint": "<VALUE>"
      }
    ],
    "aggregation": null,
    "order_by": null
  },
  "field_order_critical": true
}
```

Các ký hiệu giữ chỗ (<TABLE>, <COLUMN>, <VALUE>) biểu thị các thành phần phụ thuộc lược đồ và chỉ được dùng ở đây để minh họa giao diện đầu ra có cấu trúc, không phải một trường hợp cụ thể của bộ dữ liệu.

Trong ví dụ trên, `expected_output_fields` đóng vai trò như một “hợp đồng” giữa tác nhân Phân tích câu hỏi và các bước sau: Chuyên gia SQL và Tinh chỉnh SQL cần tôn trọng danh sách trường này, thay vì tự suy đoán.

#### Pha 2: Lập kế hoạch & sinh SQL

**Mục tiêu.** Tạo một cấu trúc suy luận trước khi viết SQL và sinh truy vấn theo cấu trúc đó.

- **Lập kế hoạch truy vấn**: tạo kế hoạch logic từng bước (mục tiêu con), xác định bảng tham gia, đường JOIN, kiểu tổng hợp, và phép toán tập hợp nếu cần. Bước lập kế hoạch **không viết SQL**, chỉ viết kế hoạch.
- **Chuyên gia SQL**: chuyển kế hoạch + phân tích + lược đồ đã lọc thành SQL ban đầu.

**Lý do thiết kế.** Nhiều lỗi JOIN và tổng hợp bắt nguồn từ việc “nhảy thẳng” vào cú pháp SQL mà chưa làm rõ logic. Bước lập kế hoạch giúp diễn đạt logic ở mức khái niệm, còn Chuyên gia SQL tập trung vào tính đúng cú pháp và ánh xạ sang lược đồ.

**Kế hoạch logic (rút gọn).** Một kế hoạch có thể được biểu diễn như danh sách bước. Mục tiêu của cấu trúc này là làm rõ thứ tự suy luận (ví dụ xác định bảng nào trước, join theo khóa nào, tổng hợp ở đâu), không phải là mô tả SQL chi tiết.

```json
{
  "subgoals": [
    {"step": 1, "action": "select_table", "tables": ["<TABLE_A>", "<TABLE_B>"]},
    {"step": 2, "action": "filter", "column": "<TABLE_A>.<COLUMN>", "value_hint": "<VALUE>"},
    {"step": 3, "action": "project", "columns": ["<TABLE_A>.<COLUMN>"]}
  ],
  "join_path": [
    {"from": "<TABLE_A>", "to": "<TABLE_B>", "on": "<FK_RELATION>"}
  ],
  "aggregation": null,
  "set_operator": null
}
```

Biểu diễn kế hoạch ở mức trừu tượng này tránh “gắn” ví dụ vào một cơ sở dữ liệu Spider cụ thể, đồng thời vẫn giữ được cấu trúc logic mà bước lập kế hoạch cung cấp.

Với các câu hỏi phức tạp hơn, `join_path` và `aggregation` đóng vai trò như các “điểm neo” để Chuyên gia SQL không tự ý chọn đường JOIN hoặc kiểu tổng hợp.

#### Pha 3: Tinh chỉnh & kiểm tra

**Mục tiêu.** Bắt các lỗi còn sót lại và đảm bảo truy vấn cuối cùng hợp lệ.

- **Tinh chỉnh SQL**: thực hiện tinh chỉnh một lần trên SQL ban đầu. Tác nhân tinh chỉnh đối chiếu SELECT với `expected_output_fields`, đối chiếu cấu trúc với `plan`, và sửa các sai lệch điển hình (ví dụ chọn sai cột, dùng COUNT thay vì COUNT(DISTINCT), hoặc join dư).
- **Kiểm tra SQL**: kiểm tra kỹ thuật (tên bảng/cột, cú pháp, và các ràng buộc lược đồ), tạo chẩn đoán. Tác nhân kiểm tra không thay đổi logic; nếu cần sửa logic thì phải quay lại tác nhân tinh chỉnh trong các biến thể tương lai (không dùng trong bài này).

**Lý do thiết kế.** Tinh chỉnh một lần là thỏa hiệp giữa chất lượng và chi phí: nó cho phép “bắt lỗi gần đúng” mà không xây dựng vòng lặp tự sửa nhiều lượt.

**Nguyên tắc “Tinh chỉnh rồi kiểm tra”.** Thứ tự tinh chỉnh → kiểm tra được chọn để giữ ranh giới trách nhiệm: tác nhân tinh chỉnh dùng phân tích/kế hoạch để sửa logic, còn tác nhân kiểm tra chỉ quyết định truy vấn có hợp lệ về mặt kỹ thuật và phù hợp lược đồ hay không. Cách này cũng giảm nguy cơ tác nhân kiểm tra “tự sửa” theo kiểu khó kiểm soát.

**Các loại chỉnh sửa mà tác nhân tinh chỉnh được phép thực hiện (ví dụ).**

- Sửa cột trong SELECT để khớp `expected_output_fields`.
- Thay đổi COUNT/COUNT(DISTINCT) khi `plan` yêu cầu “thực thể duy nhất”.
- Loại JOIN dư nếu plan không cần bảng đó và mọi cột đều có thể lấy từ bảng còn lại.
- Thêm GROUP BY khi SELECT chứa cột không tổng hợp và plan yêu cầu tổng hợp.

Ngược lại, tác nhân tinh chỉnh không được phép thay đổi mục tiêu truy vấn nếu điều đó mâu thuẫn với `intent`/`constraints` từ bước phân tích.

### 3.4 Các cấu hình chuỗi xử lý

Khung hỗ trợ cấu hình chuỗi xử lý theo số bước. Trong bài báo, chúng tôi định nghĩa hai cấu hình chính để phục vụ đánh giá.

#### Cấu hình cơ sở (4-step)

Cấu hình cơ sở bỏ qua lập kế hoạch và tinh chỉnh, và thực thi theo chuỗi:

1. Phân tích câu hỏi
2. Chọn lược đồ
3. Chuyên gia SQL
4. Kiểm tra SQL

Cấu hình này phản ánh một chuỗi xử lý tối giản nhưng vẫn giữ tinh thần “phân vai”: có phân tích, có lọc lược đồ, có sinh SQL, và có kiểm tra kỹ thuật.

#### Cấu hình đầy đủ (6-step)

Cấu hình đầy đủ bật đầy đủ các thành phần:

1. Phân tích câu hỏi
2. Chọn lược đồ
3. Lập kế hoạch truy vấn
4. Chuyên gia SQL
5. Tinh chỉnh SQL
6. Kiểm tra SQL

So với cấu hình cơ sở, cấu hình đầy đủ bổ sung hai điểm kiểm soát quan trọng: (i) bước lập kế hoạch giúp ràng buộc logic trước khi viết SQL, và (ii) bước tinh chỉnh cho phép sửa các sai lệch có hệ thống trước khi vào bước kiểm tra cuối.

### 3.5 Thuật toán 1 (giả mã)

Thuật toán 1 mô tả luồng thực thi của cấu hình đầy đủ (6-step). Cấu hình cơ sở là trường hợp rút gọn, bỏ bước 3 (lập kế hoạch) và bước 5 (tinh chỉnh).

**Thuật toán 1. Chuỗi xử lý NL2SQL đa tác nhân với tinh chỉnh một lần**

```
Input: natural language question Q, full database schema S
Output: executable SQL query y

1: analysis        <- QuestionAnalyzer(Q, S)
2: schema_filtered <- SchemaSelector(analysis, S)
3: plan            <- QueryPlanner(analysis, schema_filtered)
4: y0              <- SQLExpert(analysis, schema_filtered, plan)
5: y1              <- SQLRefiner(y0, Q, analysis, schema_filtered, plan)
6: report          <- SQLValidator(y1, schema_filtered)
7: return report.sql
```

Ghi chú: tác nhân kiểm tra trả về `report` bao gồm `sql` (nếu hợp lệ) và các chẩn đoán kỹ thuật. Trong nghiên cứu này, chúng tôi không triển khai vòng lặp lặp lại dựa trên `report`; bước tinh chỉnh chỉ chạy một lần theo thiết kế.

## 4. Đánh giá thực nghiệm

Mục này mô tả thiết lập và kết quả chính của hai cấu hình chuỗi xử lý. Tất cả số liệu kết quả trong bài chỉ bao gồm: kích thước tập Spider 1.0 (1.034 câu hỏi), và EM/EX cho cấu hình cơ sở (4-step) và cấu hình đầy đủ (6-step).

### 4.1 Thiết lập

**Tập dữ liệu.** Chúng tôi đánh giá trên Spider 1.0, sử dụng tập gồm **1.034 câu hỏi** theo giao thức của nghiên cứu (Spider dev). Spider là một bộ dữ liệu chuyển đổi văn bản sang SQL đa miền, đa cơ sở dữ liệu, với truy vấn có nhiều mức độ phức tạp [3]. Chúng tôi tập trung vào Spider vì nó là chuẩn phổ biến để kiểm tra khả năng xử lý truy vấn phức tạp và liên kết lược đồ.

**Đầu vào của hệ thống.** Mỗi mẫu gồm:

- câu hỏi ngôn ngữ tự nhiên \(Q\),
- lược đồ cơ sở dữ liệu \(S\) (tên bảng/cột/kiểu dữ liệu và quan hệ khóa).

**Mô hình nền và cấu hình sinh.** Các tác nhân sử dụng cùng một mô hình LLM để đảm bảo tính nhất quán và tránh đưa thêm biến số (khác biệt mô hình theo tác nhân) vào so sánh cấu hình chuỗi xử lý. Chúng tôi cố định các tham số sinh trong toàn bộ thực nghiệm. Các tham số này phản ánh lựa chọn thiết kế theo hướng ổn định và hạn chế “ngẫu nhiên” trong đầu ra:

- `temperature = 0.3`
- `max_tokens = 2048`
- `top_p = 0.95`

Trong thực tế, chất lượng NL2SQL có thể nhạy với tham số sinh và cách thiết kế lời nhắc. Tuy nhiên, để bài báo tập trung vào **so sánh cấu hình chuỗi xử lý**, chúng tôi giữ các tham số này cố định và xem việc tinh chỉnh lời nhắc/siêu tham số là hướng mở.

**Chuẩn hóa đầu vào lược đồ.** Khi đưa lược đồ vào chuỗi xử lý, chúng tôi giữ các thông tin cần thiết để đối soát tên bảng/cột và xây dựng JOIN (tên bảng, tên cột, quan hệ khóa). Tác nhân Chọn lược đồ chỉ lọc tập con liên quan, nhưng không thay đổi tên gốc, nhằm đảm bảo SQL sinh ra vẫn phù hợp với cơ sở dữ liệu khi thực thi.

**Thực thi truy vấn.** EX yêu cầu chạy truy vấn trên cơ sở dữ liệu. Chúng tôi tuân theo quy trình đánh giá của Spider: thực thi SQL dự đoán trên cơ sở dữ liệu tương ứng và so sánh kết quả với truy vấn chuẩn [3]. Trong trường hợp SQL không hợp lệ (lỗi cú pháp hoặc tham chiếu bảng/cột không tồn tại), mẫu được tính là thất bại cho EX.

**Giao thức đánh giá.** Chúng tôi báo cáo:

- **Exact Match (EM)**: tỷ lệ mẫu có SQL dự đoán khớp chuẩn theo tiêu chí đánh giá của Spider.
- **Execution Accuracy (EX)**: tỷ lệ mẫu có kết quả thực thi trùng với truy vấn chuẩn.

Trong cả hai cấu hình, đầu ra cuối cùng là SQL sau bước kiểm tra. Nếu tác nhân kiểm tra phát hiện lỗi cú pháp hoặc không khớp lược đồ không thể sửa theo quy tắc kỹ thuật, hệ thống coi đó là thất bại trong đánh giá.

**Kiểm soát biến số trong so sánh.** Để so sánh cấu hình cơ sở và cấu hình đầy đủ một cách tập trung, chúng tôi giữ cố định:

- mô hình nền và tham số sinh,
- cách biểu diễn lược đồ đầu vào,
- giao thức đánh giá EM/EX,
- và thứ tự thực thi chuỗi xử lý (tuần tự, không song song).

Khác biệt duy nhất giữa hai cấu hình là việc bật/tắt hai thành phần lập kế hoạch và tinh chỉnh. Điều này giúp diễn giải kết quả ở Bảng 1 theo đúng mục tiêu của bài: đánh giá vai trò của lập kế hoạch và tinh chỉnh trong một khung đa tác nhân.

**LLM và lời nhắc.** Tất cả các tác nhân trong cả hai cấu hình đều dùng cùng một LLM nền để cô lập tác động của thiết kế chuỗi xử lý. Mô hình sử dụng là **Google Gemini 2.0 Flash** (Google). Chúng tôi dùng thiết lập **không có ví dụ minh họa** và **không hiển thị chuỗi suy nghĩ**. Mỗi tác nhân nhận chỉ dẫn vai trò rõ ràng và tạo **đầu ra có cấu trúc** (các trường dạng JSON) để giảm mơ hồ giữa các bước. Chúng tôi cố định tham số sinh cho mọi lần chạy (`temperature=0.3`, `top_p=0.95`, `max_tokens=2048`) và lấy mẫu **n=1** cho mỗi câu hỏi. Chúng tôi không dùng bỏ phiếu theo tự nhất quán.  
**Truy cập LLM và môi trường thực thi.** Chúng tôi truy cập Gemini 2.0 Flash thông qua Google Vertex AI API. Các truy vấn SQL được thực thi theo thiết lập đánh giá chính thức của Spider với các cơ sở dữ liệu SQLite đi kèm. Chúng tôi áp dụng giới hạn thời gian thực thi cho mỗi truy vấn là [TODO: giây, ví dụ 5s]; các trường hợp vượt thời gian hoặc lỗi khi chạy được tính là sai cho Execution Accuracy (EX). Không thiết lập hạt giống ngẫu nhiên; tính tất định được xấp xỉ bằng việc cố định tham số sinh và sinh một mẫu duy nhất (n=1).  
**Chính sách với SQL không hợp lệ.** Nếu SQL sinh ra không hợp lệ (lỗi cú pháp hoặc tham chiếu bảng/cột không tồn tại), chúng tôi ghi nhận là thất bại cho EM/EX. Chúng tôi **không** thực hiện thử lại tự động hoặc sửa nhiều lượt ngoài bước tinh chỉnh một lần trong cấu hình 6-step.  
**Biểu diễn lược đồ.** Lược đồ đầy đủ được cung cấp dưới dạng tuần tự hóa văn bản gọn, bao gồm tên bảng, tên cột, kiểu dữ liệu (khi có), và quan hệ khóa ngoại. Tác nhân Chọn lược đồ trả về một lược đồ con đã lọc, đồng thời giữ nguyên định danh gốc để đảm bảo khả năng thực thi.  
**Giao thức đánh giá.** Chúng tôi tuân theo giao thức và bộ đánh giá chính thức của Spider như mô tả trong bộ chuẩn Spider [3].

### 4.2 Kết quả chính

Bảng 1 trình bày so sánh giữa **cấu hình cơ sở (4-step)** và **cấu hình đầy đủ (6-step)** trên Spider 1.0 (1.034 câu hỏi).

**Bảng 1. Kết quả chính trên Spider 1.0 (1.034 câu hỏi)**

| Cấu hình chuỗi xử lý | Exact Match (EM, %) | Execution Accuracy (EX, %) |
| :--- | ---: | ---: |
| Cấu hình cơ sở (4-step) | 71.2 | 79.5 |
| Cấu hình đầy đủ (6-step) | 76.8 | 84.1 |

**Nhận xét.** Cấu hình đầy đủ đạt EM và EX cao hơn cấu hình cơ sở trong cùng bối cảnh đánh giá. Dưới góc nhìn chuỗi xử lý, hai thành phần bổ sung (lập kế hoạch và tinh chỉnh) cung cấp hai lớp kiểm soát: bước lập kế hoạch làm rõ logic trước khi viết SQL, còn bước tinh chỉnh bắt các sai lệch phổ biến sau khi đã có SQL ban đầu. Trong khi đó, cấu hình cơ sở phụ thuộc nhiều hơn vào Chuyên gia SQL để “đúng ngay từ lần đầu”, và bước kiểm tra chỉ có thể phát hiện lỗi kỹ thuật chứ không chủ động sửa lỗi ngữ nghĩa.

**Diễn giải theo độ phức tạp truy vấn (định tính).** Dựa trên quan sát khi chạy hệ thống, lợi ích của cấu hình đầy đủ thường rõ hơn ở các câu hỏi có nhiều bước suy luận (nhiều JOIN, có điều kiện tổng hợp, hoặc có cấu trúc truy vấn con). Với các câu hỏi đơn giản, cả hai cấu hình đều có thể tạo SQL hợp lệ; khác biệt chủ yếu xuất hiện khi cần lập luận về đường JOIN hoặc cần ràng buộc đúng trường SELECT theo yêu cầu câu hỏi.

**Vì sao bước lập kế hoạch giúp trong các truy vấn nhiều bước.** Bước lập kế hoạch can thiệp trước khi SQL xuất hiện, nên tác động của nó mang tính “phòng ngừa”. Với các câu hỏi yêu cầu (i) nhiều bảng và đường JOIN không hiển nhiên, hoặc (ii) các thao tác tập hợp (“cả A và B”, “A nhưng không phải B”), kế hoạch logic giúp làm rõ loại phép toán cần dùng và dữ liệu đến từ đâu. Khi không có kế hoạch, Chuyên gia SQL có thể chọn một chiến lược truy vấn “đủ chạy” nhưng sai logic (ví dụ dùng OR thay vì INTERSECT, hoặc join theo một khóa không đúng).

**Vì sao bước tinh chỉnh giúp ở các lỗi gần-đúng.** Bước tinh chỉnh hoạt động sau khi đã có một truy vấn ban đầu, nên thường hiệu quả trong các trường hợp “gần đúng”: cấu trúc truy vấn hợp lý, nhưng sai một chi tiết quan trọng như cột SELECT, COUNT(DISTINCT), hoặc GROUP BY. Bước tinh chỉnh có lợi thế là có thể đối chiếu đồng thời ba nguồn thông tin: (i) yêu cầu trường đầu ra từ bước phân tích, (ii) kế hoạch logic từ bước lập kế hoạch (nếu có), và (iii) SQL ban đầu từ Chuyên gia SQL. Do đó, bước tinh chỉnh đóng vai trò như một lớp “đối soát ngữ nghĩa” trước khi bước kiểm tra thực hiện đối soát kỹ thuật.

**Giới hạn của so sánh 4-step và 6-step.** Bảng 1 chỉ phản ánh sự khác nhau giữa hai cấu hình ở mức tổng thể. Nó không trực tiếp trả lời “thành phần nào quan trọng nhất” vì bước lập kế hoạch và bước tinh chỉnh được bật/tắt đồng thời khi chuyển từ 4-step sang 6-step. Đây là lý do chúng tôi đưa giao thức thí nghiệm cắt giảm (Mục 4.3) để tách hiệu ứng của từng thành phần trong các thực nghiệm tiếp theo.

### 4.3 Thí nghiệm cắt giảm (giao thức và kế hoạch đánh giá)

Mục này mô tả **giao thức thí nghiệm cắt giảm** mà chúng tôi dự kiến thực hiện để định lượng vai trò từng thành phần trong cấu hình đầy đủ. Do nghiên cứu hiện tại chỉ báo cáo hai cấu hình (4-step và 6-step) cùng các kết quả ở Bảng 1, chúng tôi **không** đưa số liệu cắt giảm định lượng trong bài; thay vào đó, chúng tôi mô tả kế hoạch thí nghiệm và các đại lượng cần đo. Trong các phiên bản tiếp theo, các thí nghiệm này có thể được bổ sung như thực nghiệm tương lai.

**Thiết kế thí nghiệm cắt giảm (từ cấu hình đầy đủ).** Xuất phát từ cấu hình đầy đủ (6-step), chúng tôi dự kiến đánh giá các biến thể sau:

- **–Lập kế hoạch**: bỏ bước lập kế hoạch truy vấn, giữ bước tinh chỉnh và bước kiểm tra. Mục tiêu: đo vai trò của lập kế hoạch logic độc lập với tinh chỉnh.
- **–Tinh chỉnh**: bỏ bước tinh chỉnh SQL, giữ bước lập kế hoạch và bước kiểm tra. Mục tiêu: đo vai trò của tinh chỉnh một lần sau khi đã có kế hoạch.
- **–Kiểm tra**: thay bước kiểm tra bằng một kiểm tra tối thiểu (hoặc chỉ kiểm tra cú pháp). Mục tiêu: đánh giá tác động của lớp kiểm tra kỹ thuật đối với tỷ lệ SQL hợp lệ.
- **(Tuỳ chọn) –Chọn lược đồ**: dùng lược đồ đầy đủ thay vì lược đồ lọc. Mục tiêu: định lượng ảnh hưởng của giảm nhiễu lược đồ lên EM/EX và độ ổn định.

**Đại lượng đo (what to measure).** Với mỗi biến thể, chúng tôi dự kiến đo:

- **EM** và **EX** trên cùng tập Spider 1.0 (1.034 câu hỏi) để đảm bảo so sánh công bằng.
- **Tỷ lệ lỗi kỹ thuật**: tỷ lệ SQL bị loại do lỗi cú pháp hoặc không khớp lược đồ (báo bởi bước kiểm tra).
- **Chi phí suy luận**: số đơn vị mã hóa đầu vào/đầu ra (ước lượng) và thời gian chạy trung bình theo mẫu, để đo đánh đổi chất lượng–chi phí.

**Phân tích theo nhóm truy vấn (planned stratification).** Bên cạnh báo cáo tổng EM/EX, chúng tôi dự kiến phân tích theo các lát cắt sau để diễn giải vai trò từng thành phần rõ hơn:

- **Theo độ khó của Spider** (nếu dùng nhãn độ khó theo giao thức bộ dữ liệu): Dễ / Trung bình / Khó / Rất khó. Mục tiêu là kiểm tra giả thuyết rằng lập kế hoạch/tinh chỉnh tạo khác biệt lớn hơn khi độ khó truy vấn tăng.
- **Theo mẫu cấu trúc SQL**: nhóm truy vấn có JOIN nhiều bảng, nhóm có tổng hợp, nhóm có truy vấn lồng, nhóm có phép toán tập hợp. Phân tích này phù hợp với phân loại lỗi ở Mục 5, và giúp gắn “thành phần chuỗi xử lý ↔ nhóm lỗi”.
- **Theo kích thước lược đồ**: số bảng/cột trong lược đồ của mỗi cơ sở dữ liệu. Lát cắt này giúp đánh giá trực tiếp lợi ích của tác nhân Chọn lược đồ trong các lược đồ lớn.

**Giao thức ghi nhật ký để phục vụ thí nghiệm cắt giảm và phân tích lỗi.** Để hỗ trợ phân tích sau thực nghiệm, chúng tôi dự kiến lưu lại các tư liệu trung gian cho mỗi mẫu: `analysis`, `schema_filtered`, `plan`, `y0`, `y1`, và `report`. Các nhật ký này cho phép (i) kiểm tra lỗi phát sinh ở pha nào, (ii) đo mức độ “sửa” của bước tinh chỉnh (ví dụ thay đổi SELECT, thêm GROUP BY), và (iii) tái hiện các trường hợp thất bại để phân tích định tính. Lưu ý rằng việc ghi nhật ký không thay đổi giao thức EM/EX; nó chỉ phục vụ diễn giải.

**Giả thuyết làm việc (không kèm số liệu).** Dựa trên vai trò thiết kế, chúng tôi kỳ vọng:

- biến thể –Lập kế hoạch sẽ ảnh hưởng nhiều hơn đến các câu hỏi cần suy luận nhiều bước và các lỗi JOIN/tổng hợp;
- biến thể –Tinh chỉnh sẽ làm tăng các sai lệch “gần đúng” như chọn sai trường trong SELECT hoặc sai COUNT vs COUNT(DISTINCT);
- biến thể –Kiểm tra sẽ tăng tỷ lệ SQL không hợp lệ về mặt kỹ thuật, ảnh hưởng trực tiếp đến EX trong đánh giá thực thi.

Các giả thuyết này sẽ được kiểm chứng trong thực nghiệm tương lai với cùng giao thức đo lường nêu trên.

## 5. Phân tích lỗi

Mục này trình bày phân loại lỗi và phân tích định tính nhằm làm rõ những kiểu sai còn tồn tại, đồng thời liên hệ chúng với các thành phần trong chuỗi xử lý. Mục tiêu ở đây là “đọc lỗi” theo cấu trúc, không phải là báo cáo thêm kết quả định lượng.

### 5.1 Phân loại lỗi

Chúng tôi phân loại lỗi NL2SQL thành các nhóm sau (có thể chồng lấn trong một truy vấn):

- **Lỗi chọn trường**: chọn sai cột trong SELECT (hoặc sai thứ tự cột khi thứ tự quan trọng). Đây là lỗi thường xuất hiện khi nhiều cột có nghĩa gần nhau (ví dụ `name` vs `title`, `id` vs `code`).
- **Lỗi đường JOIN**: chọn sai bảng trung gian, sai điều kiện JOIN, hoặc thiếu JOIN cần thiết. Lỗi này thường liên quan đến suy luận quan hệ khóa ngoại hoặc quan hệ nhiều-nhiều.
- **Lỗi tổng hợp/nhóm**: dùng sai hàm tổng hợp (COUNT vs COUNT(DISTINCT)), `GROUP BY` thiếu cột, hoặc `HAVING`/`ORDER BY` không phù hợp.
- **Lỗi truy vấn lồng**: sai cấu trúc truy vấn con (`IN`/`EXISTS`), sai mức lồng, hoặc nhầm tương quan (truy vấn con tương quan).
- **Lỗi gắn giá trị**: lọc sai giá trị trong WHERE do chuẩn hóa chuỗi/ngày/tháng, hoặc chọn sai cột để so sánh với giá trị.
- **Lỗi phép toán tập hợp**: dùng sai `UNION`/`INTERSECT`/`EXCEPT`, hoặc nhầm logic `OR` với hợp nhất tập kết quả.
- **Xử lý mơ hồ**: câu hỏi mơ hồ dẫn tới giả định khác với truy vấn chuẩn; đây là lỗi khó tránh nếu không có cơ chế hỏi lại người dùng.

Phân loại này giúp liên hệ lỗi với thiết kế chuỗi xử lý: chọn trường được xử lý từ Pha 1 (phân tích) và Pha 3 (tinh chỉnh), join/nhóm được hỗ trợ bởi bước lập kế hoạch, còn bước kiểm tra chủ yếu phát hiện lỗi kỹ thuật và không thay đổi logic.

Để phục vụ phân tích có cấu trúc, chúng tôi cũng gợi ý cách “gán lỗi” theo tầng quyết định trong chuỗi xử lý (không kèm số liệu). Mục đích là giúp người đọc hiểu: nếu một truy vấn sai, lỗi có thể bắt nguồn từ đâu trong chuỗi xử lý.

- **Lỗi gốc từ Pha 1 (phân tích/lược đồ)**: thường biểu hiện dưới dạng chọn sai trường đầu ra (tác nhân phân tích) hoặc thiếu bảng/cột quan trọng trong lược đồ lọc (tác nhân chọn lược đồ). Khi lược đồ lọc thiếu cột/khóa, các bước sau có thể phải “chế” đường JOIN hoặc suy đoán tên cột, làm tăng nguy cơ sai.
- **Lỗi gốc từ Pha 2 (lập kế hoạch/sinh SQL)**: thường liên quan đến đường JOIN, cấu trúc truy vấn lồng, ngữ nghĩa tổng hợp, và phép toán tập hợp. Ngay cả khi bước phân tích chọn đúng trường đầu ra, một kế hoạch JOIN sai có thể dẫn tới truy vấn trả về kết quả khác hoàn toàn.
- **Lỗi gốc từ Pha 3 (tinh chỉnh/kiểm tra)**: thường là lỗi gần-đúng nhưng thiếu một ràng buộc (GROUP BY/HAVING), dùng sai hàm tổng hợp, hoặc tham chiếu sai tên cột. Bước kiểm tra có thể phát hiện lỗi kỹ thuật, nhưng nếu không có bước tinh chỉnh thì hệ thống thiếu bước sửa ngữ nghĩa có kiểm soát.

Từ góc nhìn hệ thống, phân loại này cũng cho thấy “vì sao” một khung cấu hình được là hữu ích: nếu ta có thể bật/tắt bước lập kế hoạch hoặc tinh chỉnh, ta có thể kiểm tra giả thuyết rằng một nhóm lỗi chủ yếu bị ảnh hưởng bởi thành phần nào (được kiểm chứng bằng thí nghiệm cắt giảm trong tương lai).

### 5.2 Phân tích định tính với một trường hợp

**Mẫu nghiên cứu tình huống (sẽ được điền bằng một ví dụ Spider thực tế).**  
- `db_id`: **[TODO: Spider db_id]**  
- Question: **[TODO: exact question text from Spider dev]**  
- Gold SQL:  
```sql
[TODO: exact gold SQL]
```
- SQL dự đoán (cấu hình cơ sở, 4-step):  
```sql
[TODO: exact predicted SQL]
```
- SQL dự đoán (cấu hình đầy đủ, 6-step):  
```sql
[TODO: exact predicted SQL]
```

**Cách sử dụng mẫu này.** Chúng tôi dùng định dạng nghiên cứu tình huống này để “neo” phân tích lỗi vào một mẫu Spider có thể kiểm chứng. Khi các trường đã được điền, chúng tôi chú thích: (i) loại lỗi nào trong phân loại tương ứng, (ii) sai lệch xuất hiện đầu tiên ở đâu trong các tư liệu trung gian của chuỗi xử lý (`analysis`, `schema_filtered`, `plan`, `y0`, `y1`, `report`), và (iii) hành vi của tác nhân tinh chỉnh/tác nhân kiểm tra có phù hợp với trách nhiệm dự định hay không. Chúng tôi không đưa ví dụ bịa ở đây để tránh đưa vào các khẳng định không thể kiểm chứng.

## 6. Thảo luận

Mục này thảo luận về các đánh đổi và phạm vi áp dụng của khung, dựa trên thiết kế và quan sát thực nghiệm, trong khi giữ giọng văn trung tính và tránh kết luận vượt quá dữ liệu.

**Chất lượng và chi phí suy luận.** Cấu hình đầy đủ thêm hai bước (lập kế hoạch, tinh chỉnh), nên chi phí đơn vị mã hóa và độ trễ dự kiến cao hơn so với cấu hình cơ sở. Điều này tạo ra đánh đổi tự nhiên: chất lượng (EM/EX) tăng nhưng chi phí cũng tăng. Với các hệ thời gian thực, cấu hình cơ sở có thể là lựa chọn thực dụng; với các truy vấn phức tạp hoặc yêu cầu độ tin cậy cao, cấu hình đầy đủ có thể phù hợp hơn.

**Giới hạn của tinh chỉnh một lần.** Tinh chỉnh một lần giúp giữ chi phí thấp hơn so với các vòng lặp tự sửa nhiều lượt, nhưng cũng có giới hạn rõ: nếu SQL ban đầu sai cấu trúc ở mức “gốc” (ví dụ thiếu hẳn một bảng cần join, hoặc chọn sai chiến lược truy vấn lồng), một lần tinh chỉnh có thể không đủ để đảo chiều quyết định. Hơn nữa, nếu bước tinh chỉnh sửa quá mạnh mà không bám sát `analysis`/`plan`, hệ thống có nguy cơ tạo ra truy vấn “khác mục tiêu”. Vì vậy, chúng tôi thiết kế bước tinh chỉnh theo hướng đối soát có kiểm soát: ưu tiên sửa các sai lệch có thể kiểm chứng (các trường SELECT, COUNT vs COUNT(DISTINCT), GROUP BY/HAVING) và hạn chế thay đổi chiến lược truy vấn.

**Giới hạn về mơ hồ ngôn ngữ và tri thức miền.** Spider là bộ dữ liệu chuẩn, nhưng nhiều câu hỏi trong thực tế còn mơ hồ hơn hoặc đòi hỏi tri thức miền không nằm trong lược đồ. Khung của chúng tôi không giải quyết triệt để vấn đề này vì chuỗi xử lý vẫn dựa vào câu hỏi và lược đồ cung cấp. Do đó, với các trường hợp mơ hồ, hệ thống có thể tạo SQL hợp lệ nhưng khác ý định chuẩn; một hướng tiềm năng là cơ chế hỏi lại hoặc tương tác nhiều lượt, nằm ngoài phạm vi bài báo.

**Tái lập và sai khác do lời nhắc.** Với hệ NL2SQL dựa trên LLM, lời nhắc và cách trình bày lược đồ là một phần quan trọng của hệ thống. Ngay cả khi giữ mô hình nền cố định, thay đổi nhỏ trong mẫu lời nhắc hoặc việc có/không có ví dụ minh họa có thể làm thay đổi hành vi. Vì vậy, khung ghi lại các tư liệu trung gian và tách lời nhắc theo vai trò tác nhân để hỗ trợ tái lập và phân tích.

**Khả năng tổng quát.** Dù bài báo tập trung vào NL2SQL, ý tưởng “chuỗi xử lý mô-đun hóa và cấu hình được để đánh giá” có thể áp dụng cho các tác vụ tạo đầu ra có cấu trúc khác (ví dụ tạo lời gọi API, tạo truy vấn hệ tri thức, hoặc tạo mã có ràng buộc). Tuy nhiên, để khẳng định tính tổng quát theo nghĩa thực nghiệm cần thêm đánh giá trên nhiều bộ dữ liệu và miền, do đó chúng tôi coi đây là hướng mở.

## 7. Kết luận và hướng nghiên cứu tương lai

Bài báo này đề xuất một khung NL2SQL đa tác nhân theo chuỗi xử lý mô-đun hóa, cho phép cấu hình số bước để phục vụ đánh giá có cấu trúc và phân tích vai trò thành phần. Khung tách chuỗi xử lý thành ba pha: (i) phân tích câu hỏi và liên kết/lọc lược đồ, (ii) lập kế hoạch logic và sinh SQL, và (iii) tinh chỉnh một lần và kiểm tra kỹ thuật. Chúng tôi đánh giá hai cấu hình: cấu hình cơ sở (4-step) và cấu hình đầy đủ (6-step) trên Spider 1.0 (1.034 câu hỏi). Kết quả cho thấy cấu hình đầy đủ đạt **EM 76.8% / EX 84.1%**, trong khi cấu hình cơ sở đạt **EM 71.2% / EX 79.5%**.

Ở mức đóng góp, bài báo nhấn mạnh rằng giá trị của khung không chỉ nằm ở con số tổng, mà ở khả năng hỗ trợ nghiên cứu theo hướng có cấu trúc: cấu hình được chuỗi xử lý, thiết kế thí nghiệm cắt giảm theo thành phần, và phân tích lỗi theo phân loại gắn với từng pha. Dựa trên kết quả hiện tại, chúng tôi tránh kết luận quá mức và coi đây là bằng chứng trong bối cảnh triển khai của nghiên cứu.

**Hướng tương lai** tập trung vào ba hướng chính:

- **Thí nghiệm cắt giảm định lượng có kiểm soát**: thực hiện các biến thể –Lập kế hoạch/–Tinh chỉnh/–Kiểm tra và đo EM/EX, chi phí đơn vị mã hóa, và độ trễ như mô tả ở Mục 4.3.
- **Mở rộng cơ chế kiểm soát mơ hồ**: bổ sung tác nhân làm rõ câu hỏi hoặc cơ chế hội thoại nhiều lượt cho các câu hỏi mơ hồ.
- **Tăng tính tái lập và chuẩn hóa**: công bố cấu hình chạy, mẫu lời nhắc (ở mức tối thiểu cần thiết), và kịch bản đánh giá để cộng đồng có thể tái lập và mở rộng.

## Phụ lục / Tài liệu bổ trợ (không tính trang)

### A. Chỗ giữ chỗ cho lời nhắc/cấu hình

- **Mẫu lời nhắc (chỗ giữ chỗ)**: `Repository available upon request for review; public release planned for camera-ready version./prompts/`
  - `question_analyzer.md`
  - `schema_selector.md`
  - `query_planner.md`
  - `sql_expert.md`
  - `sql_refiner.md`
  - `sql_validator.md`

Ghi chú: Bản thân bài chỉ mô tả ý tưởng và trách nhiệm của từng tác nhân. Mô tả đầy đủ về lời nhắc/hướng dẫn theo vai trò (nếu công bố) nên đi kèm phiên bản hóa để đảm bảo tái lập.

### B. Cấu hình chuỗi xử lý (chỗ giữ chỗ)

Ví dụ cấu hình YAML (minh họa, không phải bản đầy đủ):

```yaml
llm:
  provider: <PROVIDER>
  model: <MODEL_NAME>
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

### C. Danh mục tái lập (chỗ giữ chỗ)

- Kho mã nguồn: `Repository available upon request for review; public release planned for camera-ready version.`
- Kịch bản đánh giá: `Repository available upon request for review; public release planned for camera-ready version./eval/`
- Hướng dẫn dữ liệu: tuân theo giao thức đánh giá Spider 1.0 [3]
- Hạt giống ngẫu nhiên / tính tất định: Không thiết lập; giải mã một mẫu (n=1) với tham số sinh cố định.

### D. Tài liệu tham khảo (giữ nguyên tiêu đề; cho phép chỗ giữ chỗ)

[1] V. Zhong et al., “Seq2SQL,” ACL 2017.  
[2] T. Yu et al., “SyntaxSQLNet,” EMNLP 2018.  
[3] T. Yu et al., “Spider,” EMNLP 2018.  
[4] B. Wang et al., “RAT-SQL,” ACL 2020.  
[5] S. Ruan et al., “RESDSQL,” arXiv 2023.  
[8] Y. Wang et al., “AutoGen,” arXiv 2023.  
[9] H. Chase et al., LangChain, khung mã nguồn mở, kho lưu trữ GitHub, https://github.com/langchain-ai/langchain, truy cập năm 2024.

[10] J. Moura et al., CrewAI, khung đa tác nhân mã nguồn mở, kho lưu trữ GitHub, https://github.com/joaomdmoura/crewAI, truy cập năm 2024.
[11] E. Gan et al., “BRIDGE,” NAACL 2021.  
[12] T. Scholak et al., “PICARD,” EMNLP 2021.  
[17] Z. Yuan et al., “CRITIC,” arXiv 2023.  

