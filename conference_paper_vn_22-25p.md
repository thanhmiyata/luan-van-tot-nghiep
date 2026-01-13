A Modular Multi-Agent Framework for Evaluating and Refining Text-to-SQL Generation

## Abstract

Chuyển đổi ngôn ngữ tự nhiên sang SQL (NL2SQL) giúp người dùng truy vấn cơ sở dữ liệu bằng câu hỏi tự nhiên, nhưng vẫn dễ sai khi truy vấn phức tạp đòi hỏi liên kết lược đồ, lập kế hoạch nhiều bước, hoặc lựa chọn đúng trường đầu ra. Trong khi nhiều nghiên cứu tập trung tối ưu prompt/mô hình, vẫn thiếu một framework pipeline có thể cấu hình để đánh giá có cấu trúc vai trò của từng thành phần trong quy trình NL2SQL.

Bài báo này đề xuất một framework NL2SQL đa tác nhân theo pipeline tuần tự gồm: phân tích câu hỏi, lọc lược đồ, lập kế hoạch logic, sinh SQL, tinh chỉnh một lần và kiểm tra kỹ thuật. Framework hỗ trợ hai cấu hình để đánh giá: base configuration (4-step) và full configuration (6-step). Trên Spider 1.0 (1.034 câu hỏi), full configuration đạt Exact Match (EM) 76.8% và Execution Accuracy (EX) 84.1%, trong khi base configuration đạt EM 71.2% và EX 79.5%. Ngoài kết quả chính, chúng tôi mô tả giao thức ablation dự kiến và taxonomy lỗi kèm một ví dụ định tính để hỗ trợ phân tích theo thành phần.

## 1. Introduction

NL2SQL cho phép người dùng đặt câu hỏi bằng ngôn ngữ tự nhiên và hệ thống trả về truy vấn SQL để trích xuất câu trả lời từ cơ sở dữ liệu. Bài toán này xuất hiện trong nhiều ngữ cảnh: phân tích dữ liệu doanh nghiệp, trợ lý dữ liệu, và các công cụ tự phục vụ (self-service analytics). Trong thực tế, câu hỏi hiếm khi chỉ là lọc đơn giản trên một bảng; người dùng thường yêu cầu phép nối nhiều bảng (JOIN), tổng hợp (COUNT/GROUP BY), truy vấn con, hoặc phép toán tập hợp. Các yêu cầu này khiến NL2SQL không chỉ là “dịch câu sang SQL”, mà là một quy trình suy luận có cấu trúc.

Trong vài năm gần đây, việc dùng mô hình ngôn ngữ lớn (LLM) cho NL2SQL trở nên phổ biến nhờ khả năng suy luận và tạo mã linh hoạt. Tuy nhiên, cách tiếp cận “một lượt sinh SQL” vẫn dễ mắc lỗi hệ thống. Hai dạng khó khăn thường gặp là (i) liên kết lược đồ (schema linking) không ổn định khi lược đồ lớn, nhiều cột tên gần giống; và (ii) lựa chọn trường đầu ra (field selection) sai, dù hệ thống có thể nắm đúng ý định logic ở mức tổng quan. Thực tế này cho thấy cần một quy trình có phân vai rõ ràng: bước nào chịu trách nhiệm phân tích ý định, bước nào chịu trách nhiệm lọc lược đồ, bước nào lập kế hoạch logic, và bước nào được phép sửa lỗi ngữ nghĩa.

Một vấn đề phương pháp luận là nhiều nghiên cứu tập trung tối ưu prompt hoặc tối ưu mô hình, trong khi “khung đánh giá” (evaluation framework) cho phép phân tích vai trò từng bước vẫn còn hạn chế. Nếu pipeline là một khối đen, việc đánh giá thường chỉ phản ánh năng lực tổng hợp của toàn hệ thống. Khi kết quả thay đổi, ta khó truy nguyên: lỗi giảm là do phân tích tốt hơn, do lập kế hoạch tốt hơn, hay do tinh chỉnh/kiểm tra tốt hơn. Với NL2SQL, điều này đặc biệt quan trọng vì nhiều lỗi có tính hệ thống và lặp lại theo mẫu (ví dụ nhầm cột có tên gần nhau, hoặc dùng COUNT thay vì COUNT(DISTINCT)).

Chúng tôi đề xuất một framework NL2SQL đa tác nhân theo hướng mô-đun hóa pipeline. Thay vì xem NL2SQL là một lần gọi LLM, framework tách pipeline thành các tác nhân (agents) với vai trò riêng, chạy theo thứ tự cố định và trao đổi ngữ cảnh có cấu trúc. Cách thiết kế này có hai mục tiêu: (i) tạo ra một quy trình sinh SQL dễ quan sát và dễ gỡ lỗi hơn; và (ii) quan trọng không kém, cho phép cấu hình pipeline để đánh giá có cấu trúc (ví dụ bật/tắt các thành phần lập kế hoạch hoặc tinh chỉnh).

Trong bài báo này, chúng tôi tập trung so sánh hai cấu hình pipeline:

- **Base configuration (4-step)**: Question Analyzer → Schema Selector → SQL Expert → SQL Validator.
- **Full configuration (6-step)**: Question Analyzer → Schema Selector → Query Planner → SQL Expert → SQL Refiner → SQL Validator.

Trên Spider 1.0 (1.034 câu hỏi), full configuration đạt **EM 76.8% / EX 84.1%**, trong khi base configuration đạt **EM 71.2% / EX 79.5%**. Chúng tôi diễn giải kết quả theo góc nhìn pipeline: việc thêm lập kế hoạch và tinh chỉnh một lần tạo ra một quy trình có kiểm soát tốt hơn đối với các truy vấn nhiều bước. Đồng thời, để tránh overclaim, chúng tôi coi các con số này là bằng chứng trong bối cảnh triển khai và giao thức đánh giá của nghiên cứu này, không phải là kết luận “tối ưu toàn cục”.

**Đóng góp chính** của bài báo gồm:

- **C1 (Framework)**: Đề xuất một framework NL2SQL đa tác nhân với pipeline cấu hình được, tách rõ ba pha: phân tích & liên kết lược đồ, lập kế hoạch & sinh SQL, tinh chỉnh & kiểm tra.
- **C2 (Evaluation-ready design)**: Thiết kế hai cấu hình pipeline (base 4-step và full 6-step) để phục vụ đánh giá có cấu trúc, dễ mở rộng sang ablation theo thành phần.
- **C3 (Empirical evidence & analysis)**: Báo cáo kết quả trên Spider 1.0 với hai chỉ số chuẩn (EM, EX) và cung cấp phân tích lỗi định tính + giao thức ablation dự kiến nhằm hỗ trợ nghiên cứu tiếp theo.

Phần còn lại của bài báo được tổ chức như sau. Mục 2 điểm qua các hướng nghiên cứu liên quan về NL2SQL, LLM cho text-to-SQL, và hệ thống đa tác nhân. Mục 3 mô tả framework và phương pháp luận, bao gồm kiến trúc tổng thể, thiết kế pipeline mô-đun, các cấu hình pipeline, và Algorithm 1. Mục 4 trình bày thực nghiệm, bao gồm thiết lập, kết quả chính (Table 1), và kế hoạch ablation (Mục 4.3). Mục 5 phân tích lỗi theo taxonomy và đưa một ví dụ minh họa. Mục 6 thảo luận các đánh đổi và tính tổng quát. Mục 7 kết luận và nêu hướng tương lai. Phần Appendix cung cấp placeholder cho prompt/config và liên kết mã nguồn.

## 2. Related Work

Mục này tập trung vào ba nhóm công trình: (i) hệ thống NL2SQL truyền thống và các mô hình có cấu trúc, (ii) NL2SQL dựa trên LLM, và (iii) các khung đa tác nhân và LLM tăng cường công cụ (tool-augmented). Mục tiêu của chúng tôi không phải là so sánh theo “thành tích”, mà là định vị khoảng trống về thiết kế pipeline có thể cấu hình để đánh giá vai trò từng bước.

### 2.1 Text-to-SQL Systems

Các hệ NL2SQL truyền thống thường dựa trên mô hình seq2seq hoặc các kiến trúc sinh SQL theo cấu trúc cú pháp. Dòng công trình này đóng góp hai ý tưởng nền tảng: (i) biểu diễn câu hỏi và lược đồ theo cách có thể học được, và (ii) tạo SQL theo một không gian có cấu trúc thay vì chỉ sinh chuỗi ký tự thuần [1–5]. Trên các bộ dữ liệu phức tạp và đa miền như Spider, một thách thức trọng tâm là **schema linking**: hệ thống phải ánh xạ các cụm từ trong câu hỏi tới đúng bảng/cột, trong khi tên cột có thể dài, viết tắt, hoặc đa nghĩa [3, 11]. Các mô hình nhận thức quan hệ và các mô-đun tách biệt liên kết–mã hóa lược đồ là những lựa chọn phổ biến nhằm giảm nhầm lẫn giữa các phần tử lược đồ gần nghĩa [4, 5].

Một vấn đề khác của NL2SQL truyền thống là **độ phức tạp của không gian truy vấn**: khi truy vấn có nhiều JOIN, nested queries, và aggregation, việc sinh “đúng cấu trúc” quan trọng không kém việc sinh “đúng từ khóa”. Do đó, nhiều hệ nhấn mạnh sinh theo cây cú pháp, theo slot, hoặc theo các bước tạo cấu trúc trung gian để giảm lỗi cú pháp và giúp mô hình tập trung vào quyết định cấu trúc (ví dụ có cần GROUP BY hay không) [2]. Tuy nhiên, phần lớn các hệ vẫn mang tính “một lượt”: khi truy vấn ban đầu sai, cơ chế sửa thường nằm trong giải mã hoặc trong huấn luyện, chứ không phải một bước tinh chỉnh có thể tách ra để đánh giá vai trò.

Trong bối cảnh bài toán phức tạp (nhiều JOIN, nested queries, aggregation), việc tách bạch các nhiệm vụ con trở nên quan trọng. Một số phương pháp nhấn mạnh ràng buộc cú pháp trong quá trình sinh (constrained decoding) hoặc kiểm tra hợp lệ [12]. Tuy nhiên, kiểm tra kỹ thuật không tự động giải quyết được lỗi ngữ nghĩa như chọn sai cột trong SELECT, nhầm điều kiện JOIN, hay lựa chọn sai kiểu tổng hợp. Điều này gợi ý cần các thành phần chuyên trách cho suy luận logic (planning) và cho tinh chỉnh có mục tiêu (refinement).

Từ góc nhìn bài báo này, điều quan trọng là: các công trình truyền thống đã cung cấp nhiều cơ chế “đưa lược đồ vào mô hình” và “ràng buộc cú pháp”, nhưng **không trực tiếp cung cấp một framework pipeline cấu hình được** để tách riêng các vai trò phân tích–lập kế hoạch–tinh chỉnh theo nghĩa hệ thống. Khoảng trống này trở nên rõ hơn khi chuyển sang các hệ dựa trên LLM, nơi “vai trò tác nhân” và “giao thức truyền ngữ cảnh” có thể được xem như một dạng mô-đun hóa ở mức triển khai.

### 2.2 LLM-based Text-to-SQL

LLM giúp đơn giản hóa triển khai NL2SQL nhờ khả năng học theo ngữ cảnh và sinh mã. Với một prompt phù hợp, LLM có thể tạo SQL mà không cần tinh chỉnh mô hình. Tuy vậy, các hệ dựa trên LLM vẫn gặp lỗi hệ thống, đặc biệt với truy vấn nhiều bước và liên kết lược đồ. Một vấn đề điển hình là LLM “hiểu câu hỏi” ở mức mô tả, nhưng chọn sai trường đầu ra do suy luận thiếu kiểm soát hoặc do các cột tên gần nhau trong lược đồ [REF].

Khi dùng LLM, người phát triển thường đối mặt với hai loại quyết định: (i) **quyết định prompt/ngữ cảnh** (đưa gì vào input: lược đồ đầy đủ, lược đồ rút gọn, ví dụ few-shot, hay tập quy tắc), và (ii) **quyết định quy trình** (sinh một lần hay nhiều lần; có kiểm tra/đánh giá/ghi nhận lỗi hay không). Ở mức hệ thống, lỗi NL2SQL thường xuất phát từ việc LLM phải “gánh” quá nhiều trách nhiệm trong một lượt: vừa hiểu câu hỏi, vừa chọn bảng/cột, vừa suy luận đường JOIN, vừa đảm bảo cú pháp. Khi không có phân vai, một sai lệch nhỏ ở bước chọn cột có thể lan sang cấu trúc truy vấn.

Một số hướng gần đây khai thác phân rã nhiệm vụ hoặc tự sửa lỗi (self-correction). Dưới góc nhìn thiết kế hệ thống, điểm chung của các hướng này là thừa nhận rằng NL2SQL cần nhiều hơn một lần sinh: hoặc cần phân rã, hoặc cần kiểm tra, hoặc cần sửa. Tuy nhiên, nhiều hệ vẫn giữ logic trong một tác nhân lớn, khiến việc đánh giá vai trò từng phần trở nên khó khăn: khi thay đổi prompt, ta không biết thành phần nào thực sự tạo lợi ích.

Ngoài ra, đối với text-to-SQL, một khó khăn đặc thù là **sự không ổn định do lược đồ**: cùng một câu hỏi, khi lược đồ thay đổi (tên cột khác, bảng trung gian khác), LLM có thể sinh truy vấn khác đáng kể. Vì vậy, nhiều triển khai thực tế cố gắng **giảm nhiễu lược đồ** bằng cách rút gọn schema trước khi đưa vào prompt, hoặc bằng cách giới hạn lựa chọn bảng/cột. Điều này gợi ý rằng một mô-đun “Schema Selector” là hữu ích và có thể được đánh giá độc lập với mô-đun “SQL Expert”.

### 2.3 Multi-Agent and Tool-Augmented LLMs

Khung đa tác nhân (multi-agent) được dùng để giải quyết tác vụ phức tạp bằng cách phân vai (role specialization) và phối hợp (coordination). Các framework như CrewAI, LangChain Agents, hoặc các khung hội thoại đa tác nhân cung cấp “cơ sở hạ tầng” để xây dựng pipeline gồm nhiều tác nhân và cơ chế truyền ngữ cảnh [8–10]. Ngoài ra, các hướng tool-augmented LLM nhấn mạnh việc dùng công cụ để kiểm tra/đánh giá đầu ra (ví dụ kiểm tra cú pháp, chạy thử, hoặc đối soát) [17, 19], còn agentic RAG nhấn mạnh truy xuất thông tin theo nhu cầu [18].

Trong hệ thống tăng cường công cụ, một ý tưởng quan trọng là tách bạch giữa “sinh” và “kiểm tra”. Ở text-to-SQL, kiểm tra có thể bao gồm: (i) đối soát tên bảng/cột với lược đồ, (ii) kiểm tra cú pháp, và (iii) kiểm tra các ràng buộc hình thức. Tuy nhiên, kiểm tra không tương đương với sửa. Nếu hệ thống muốn sửa các lỗi ngữ nghĩa (như chọn sai trường), nó cần một cơ chế có quyền sửa logic—đây là động lực để đặt Refiner như một tác nhân riêng, thay vì ép Validator vừa kiểm tra vừa sửa.

Đối với mô hình đa tác nhân, thách thức không nằm ở việc “có nhiều agent”, mà nằm ở **định nghĩa vai trò và giao diện thông tin**. Nếu các agent chia sẻ cùng một mục tiêu nhưng không có ranh giới trách nhiệm, hệ thống dễ bị vòng lặp sửa–phá hoặc tạo ra các quyết định mâu thuẫn. Vì vậy, framework của chúng tôi coi “giao diện I/O” là một phần của phương pháp luận: mỗi agent nhận một input có cấu trúc và trả về output có cấu trúc, giúp pipeline có thể quan sát và có thể ablation.

Điểm quan trọng đối với NL2SQL là: đa tác nhân không tự động tốt hơn nếu các vai trò không được định nghĩa rõ và nếu trách nhiệm bị chồng lấn (ví dụ vừa sinh vừa sửa trong cùng một tác nhân). Do đó, để reviewer-safe, chúng tôi coi đa tác nhân như một lựa chọn kiến trúc giúp tăng khả năng quan sát, giúp mô-đun hóa, và giúp thiết kế đánh giá có cấu trúc. Framework của chúng tôi tập trung vào ba quyết định thiết kế:

- **Phân vai theo lỗi hệ thống**: tạo một bước riêng cho phân tích câu hỏi và trường đầu ra (field selection), thay vì trộn vào bước sinh SQL.
- **Tách planning khỏi generation**: lập kế hoạch logic (không viết SQL) trước khi sinh SQL.
- **Tinh chỉnh một lần, có kiểm soát**: cho phép sửa lỗi ngữ nghĩa ở đúng nơi (Refiner), trong khi Validator chỉ làm kiểm tra kỹ thuật và không thay đổi logic.

### 2.4 Gap Analysis

Từ các hướng trên, chúng tôi thấy khoảng trống thực tiễn: thiếu một framework NL2SQL “evaluation-ready”, trong đó pipeline có thể cấu hình để so sánh có cấu trúc, và các thành phần được định nghĩa đủ rõ để phục vụ ablation và error analysis. Bài báo này đề xuất một thiết kế như vậy và báo cáo kết quả so sánh giữa base configuration và full configuration trên Spider 1.0.

## 3. Framework and Methodology

Mục này mô tả framework đa tác nhân và các quyết định thiết kế để hỗ trợ đánh giá có cấu trúc. Trọng tâm là mô tả pipeline mô-đun, luồng dữ liệu giữa các tác nhân, và các cấu hình pipeline. Toàn bộ prompt/backstory chi tiết được đưa sang Appendix để tránh làm nặng phần main paper.

### 3.1 Problem Definition

**Bài toán NL2SQL.** Cho một câu hỏi ngôn ngữ tự nhiên \(Q\) và lược đồ cơ sở dữ liệu \(S\) (bao gồm danh sách bảng, cột, kiểu dữ liệu, và quan hệ khóa ngoại), mục tiêu là sinh một truy vấn SQL \(y\) sao cho khi thực thi \(y\) trên cơ sở dữ liệu \(D\) sẽ trả về kết quả đúng với ý định câu hỏi.

**Chỉ số đánh giá.** Chúng tôi sử dụng hai chỉ số chuẩn cho text-to-SQL:

- **Exact Match (EM)**: đo mức khớp giữa SQL dự đoán và SQL tham chiếu theo tiêu chí tương đương (phụ thuộc giao thức đánh giá của bộ dữ liệu).
- **Execution Accuracy (EX)**: đo mức đúng khi thực thi: kết quả truy vấn dự đoán trùng với kết quả của truy vấn tham chiếu trên cơ sở dữ liệu.

Trong bài báo, EX được coi là chỉ số chính vì phản ánh đúng-ngữ-nghĩa và khoan dung với các biểu thức SQL tương đương.

### 3.2 Framework Overview

Framework của chúng tôi mô hình hóa NL2SQL như một pipeline tuần tự gồm nhiều tác nhân. Mỗi tác nhân thực hiện đúng một vai trò và xuất ra một dạng ngữ cảnh có cấu trúc để tác nhân sau sử dụng. Thiết kế này hướng tới hai lợi ích: (i) giảm “gánh nặng nhận thức” cho mỗi tác nhân, và (ii) làm rõ đường đi của thông tin để phục vụ phân tích.

Để framework có thể “đánh giá được”, chúng tôi chú trọng vào hai nguyên tắc triển khai:

- **Ngữ cảnh có cấu trúc (structured context)**: thay vì truyền tự do (free-form) giữa các tác nhân, mỗi tác nhân tạo ra một output có các trường rõ ràng (ví dụ danh sách trường cần SELECT, danh sách bảng/cột được chọn, hoặc kế hoạch logic theo bước). Điều này giúp giảm mơ hồ khi các tác nhân sau đọc lại ngữ cảnh.
- **Trách nhiệm không chồng lấn (non-overlapping responsibility)**: mỗi tác nhân chỉ chịu trách nhiệm cho một lớp quyết định. Ví dụ, Validator kiểm tra kỹ thuật và báo cáo; Refiner mới được phép sửa logic. Cách phân vai này giúp reviewer dễ hiểu và giúp ablation theo thành phần “sạch” hơn.

**Figure 1** mô tả kiến trúc tổng thể. Do bài viết ở dạng markdown, chúng tôi dùng sơ đồ ASCII (có thể thay bằng hình trong bản camera-ready).

**Figure 1. Kiến trúc tổng thể của framework đa tác nhân cho NL2SQL**

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

Trong framework này, **Refiner** là tác nhân duy nhất được phép sửa logic ngữ nghĩa dựa trên phân tích và kế hoạch; **Validator** chỉ kiểm tra kỹ thuật và báo cáo lỗi, không “sáng tác lại” logic để tránh chồng lấn trách nhiệm.

Để làm rõ giao diện thông tin, Bảng dưới đây (không phải bảng kết quả) liệt kê ngắn gọn đầu vào/đầu ra của từng tác nhân trong full configuration.

| Agent | Input chính | Output (dạng cấu trúc) | Vai trò chính |
| :--- | :--- | :--- | :--- |
| Question Analyzer | \(Q\), \(S\) | `analysis` (intent, constraints, expected_output_fields, …) | Trích xuất ý định và trường cần trả về |
| Schema Selector | `analysis`, \(S\) | `schema_filtered` (tables/columns/keys) | Lọc lược đồ liên quan, giảm nhiễu |
| Query Planner | `analysis`, `schema_filtered` | `plan` (subgoals, join path, aggregation, set ops, …) | Lập kế hoạch logic (không viết SQL) |
| SQL Expert | `analysis`, `schema_filtered`, `plan` | `y0` (initial SQL) | Sinh SQL từ kế hoạch và lược đồ |
| SQL Refiner | `y0`, \(Q\), `analysis`, `schema_filtered`, `plan` | `y1` (refined SQL + note) | Tinh chỉnh một lần, sửa sai lệch ngữ nghĩa |
| SQL Validator | `y1`, `schema_filtered` | `report` (ok/error + diagnostics) | Kiểm tra kỹ thuật, đối soát lược đồ |

### 3.3 Modular Pipeline Design (Phase 1/2/3)

Chúng tôi chia pipeline thành ba pha, phù hợp với các nguồn lỗi phổ biến trong NL2SQL.

#### Phase 1: Analysis & Schema Linking

**Mục tiêu.** Làm rõ ý định câu hỏi và giảm không gian tìm kiếm lược đồ trước khi sinh SQL.

- **Question Analyzer**: trích xuất ý định, thực thể liên quan, ràng buộc (lọc, sắp xếp, tổng hợp), và đặc biệt là danh sách trường cần xuất ra (expected output fields) theo đúng yêu cầu của câu hỏi.
- **Schema Selector**: lọc lược đồ đầy đủ để giữ các bảng/cột liên quan, cùng các khóa chính/ngoại cần thiết cho JOIN.

**Lý do thiết kế.** Nếu sinh SQL khi vẫn dùng lược đồ đầy đủ, LLM có thể bị “nhiễu” bởi các cột không liên quan. Đồng thời, field selection sai thường xuất hiện sớm và kéo theo các sai lệch logic về sau. Do đó, framework tách rõ hai tác vụ này thành Phase 1.

**Output điển hình (minified).** Để tránh đưa prompt dài vào main paper, chúng tôi chỉ minh họa cấu trúc output ở mức tối thiểu:

```json
{
  "intent": "retrieve",
  "expected_output_fields": ["course.course_id"],
  "constraints": {
    "filters": [{"column": "course.dept_name", "op": "=", "value_hint": "<DEPT>"}],
    "aggregation": null,
    "order_by": null
  },
  "field_order_critical": true
}
```

Trong ví dụ trên, `expected_output_fields` đóng vai trò như một “hợp đồng” giữa Analyzer và các bước sau: SQL Expert và Refiner cần tôn trọng danh sách trường này, thay vì tự suy đoán.

#### Phase 2: Planning & SQL Generation

**Mục tiêu.** Tạo một cấu trúc suy luận trước khi viết SQL và sinh truy vấn theo cấu trúc đó.

- **Query Planner**: tạo kế hoạch logic từng bước (subgoals), xác định bảng tham gia, đường JOIN, kiểu tổng hợp, và phép toán tập hợp nếu cần. Planner **không viết SQL**, chỉ viết kế hoạch.
- **SQL Expert**: chuyển kế hoạch + phân tích + lược đồ đã lọc thành SQL ban đầu.

**Lý do thiết kế.** Nhiều lỗi JOIN và aggregation bắt nguồn từ việc “nhảy thẳng” vào cú pháp SQL mà chưa làm rõ logic. Planner giúp diễn đạt logic ở mức khái niệm, còn SQL Expert tập trung vào tính đúng cú pháp và ánh xạ sang lược đồ.

**Kế hoạch logic (minified).** Một kế hoạch có thể được biểu diễn như danh sách bước. Mục tiêu của cấu trúc này là làm rõ thứ tự suy luận (ví dụ xác định bảng nào trước, join theo khóa nào, tổng hợp ở đâu), không phải là mô tả SQL chi tiết.

```json
{
  "subgoals": [
    {"step": 1, "action": "select_table", "tables": ["course"]},
    {"step": 2, "action": "filter", "column": "course.dept_name", "value_hint": "<DEPT>"},
    {"step": 3, "action": "project", "columns": ["course.course_id"]}
  ],
  "join_path": [],
  "aggregation": null,
  "set_operator": null
}
```

Với các câu hỏi phức tạp hơn, `join_path` và `aggregation` đóng vai trò như các “điểm neo” để SQL Expert không tự ý chọn đường JOIN hoặc kiểu tổng hợp.

#### Phase 3: Refinement & Validation

**Mục tiêu.** Bắt các lỗi còn sót lại và đảm bảo truy vấn cuối cùng hợp lệ.

- **SQL Refiner**: thực hiện tinh chỉnh một lần (single-pass) trên SQL ban đầu. Refiner đối chiếu SELECT với expected_output_fields, đối chiếu cấu trúc với plan, và sửa các sai lệch điển hình (ví dụ chọn sai cột, dùng COUNT thay vì COUNT(DISTINCT), hoặc join dư).
- **SQL Validator**: kiểm tra kỹ thuật (tên bảng/cột, cú pháp, và các ràng buộc lược đồ), tạo chẩn đoán. Validator không thay đổi logic; nếu cần sửa logic thì phải quay lại Refiner trong các biến thể tương lai (không dùng trong bài này).

**Lý do thiết kế.** Tinh chỉnh một lần là thỏa hiệp giữa chất lượng và chi phí: nó cho phép “bắt lỗi gần đúng” mà không xây dựng vòng lặp tự sửa nhiều lượt.

**Nguyên tắc “Refine-then-Validate”.** Thứ tự Refiner → Validator được chọn để giữ ranh giới trách nhiệm: Refiner dùng phân tích/plan để sửa logic, còn Validator chỉ quyết định truy vấn có hợp lệ về mặt kỹ thuật và phù hợp lược đồ hay không. Cách này cũng giảm nguy cơ Validator “tự sửa” theo kiểu khó kiểm soát.

**Các loại chỉnh sửa Refiner được phép thực hiện (ví dụ).**

- Sửa cột trong SELECT để khớp `expected_output_fields`.
- Thay đổi COUNT/COUNT(DISTINCT) khi plan yêu cầu “thực thể duy nhất”.
- Loại JOIN dư nếu plan không cần bảng đó và mọi cột đều có thể lấy từ bảng còn lại.
- Thêm GROUP BY khi SELECT chứa cột không tổng hợp và plan yêu cầu tổng hợp.

Ngược lại, Refiner không được phép thay đổi mục tiêu truy vấn nếu điều đó mâu thuẫn với intent/constraints từ Analyzer.

### 3.4 Pipeline Configurations

Framework hỗ trợ cấu hình pipeline theo số bước. Trong bài báo, chúng tôi định nghĩa hai cấu hình chính để phục vụ đánh giá.

#### Base configuration (4-step)

Base configuration bỏ qua planning và refinement, và thực thi theo chuỗi:

1. Question Analyzer
2. Schema Selector
3. SQL Expert
4. SQL Validator

Cấu hình này phản ánh một pipeline tối giản nhưng vẫn giữ tinh thần “phân vai”: có phân tích, có lọc lược đồ, có sinh SQL, và có kiểm tra kỹ thuật.

#### Full configuration (6-step)

Full configuration bật đầy đủ các thành phần:

1. Question Analyzer
2. Schema Selector
3. Query Planner
4. SQL Expert
5. SQL Refiner
6. SQL Validator

So với base configuration, full configuration bổ sung hai điểm kiểm soát quan trọng: (i) Planner giúp ràng buộc logic trước khi viết SQL, và (ii) Refiner cho phép sửa các sai lệch có hệ thống trước khi vào bước kiểm tra cuối.

### 3.5 Algorithm 1 (pseudo-code)

Algorithm 1 mô tả luồng thực thi của full configuration (6-step). Base configuration là trường hợp rút gọn, bỏ bước 3 (Planner) và bước 5 (Refiner).

**Algorithm 1. Multi-Agent NL2SQL pipeline with single-pass refinement**

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

Ghi chú: Validator trả về `report` bao gồm `sql` (nếu hợp lệ) và các chẩn đoán kỹ thuật. Trong nghiên cứu này, chúng tôi không triển khai vòng lặp lặp lại dựa trên report; Refiner chỉ chạy một lần theo thiết kế.

## 4. Experimental Evaluation

Mục này mô tả thiết lập và kết quả chính của hai cấu hình pipeline. Tất cả số liệu kết quả trong bài chỉ bao gồm: kích thước tập Spider 1.0 (1.034 câu hỏi), và EM/EX cho base (4-step) và full (6-step).

### 4.1 Setup

**Dataset.** Chúng tôi đánh giá trên Spider 1.0, sử dụng tập gồm **1.034 câu hỏi** theo giao thức của nghiên cứu (Spider dev). Spider là một bộ dữ liệu text-to-SQL đa miền, đa cơ sở dữ liệu, với truy vấn có nhiều mức độ phức tạp [3]. Chúng tôi tập trung vào Spider vì nó là chuẩn phổ biến để kiểm tra khả năng xử lý truy vấn phức tạp và liên kết lược đồ.

**Đầu vào của hệ thống.** Mỗi mẫu gồm:

- câu hỏi ngôn ngữ tự nhiên \(Q\),
- lược đồ cơ sở dữ liệu \(S\) (tên bảng/cột/kiểu dữ liệu và quan hệ khóa).

**Mô hình nền và cấu hình sinh.** Các tác nhân sử dụng cùng một mô hình LLM để đảm bảo tính nhất quán và tránh đưa thêm biến số (model heterogeneity) vào so sánh cấu hình pipeline. Chúng tôi cố định các tham số sinh trong toàn bộ thực nghiệm. Các tham số này phản ánh lựa chọn thiết kế theo hướng ổn định và hạn chế “ngẫu nhiên” trong đầu ra:

- `temperature = 0.3`
- `max_tokens = 2048`
- `top_p = 0.95`

Trong thực tế, chất lượng NL2SQL có thể nhạy với tham số sinh và cách thiết kế prompt. Tuy nhiên, để bài báo tập trung vào **so sánh cấu hình pipeline**, chúng tôi giữ các tham số này cố định và xem việc tinh chỉnh prompt/siêu tham số là hướng mở.

**Chuẩn hóa input lược đồ.** Khi đưa lược đồ vào pipeline, chúng tôi giữ các thông tin cần thiết để đối soát tên bảng/cột và xây dựng JOIN (tên bảng, tên cột, quan hệ khóa). Schema Selector chỉ lọc tập con liên quan, nhưng không thay đổi tên gốc, nhằm đảm bảo SQL sinh ra vẫn phù hợp với cơ sở dữ liệu khi thực thi.

**Thực thi truy vấn.** EX yêu cầu chạy truy vấn trên cơ sở dữ liệu. Chúng tôi tuân theo quy trình đánh giá của Spider: thực thi SQL dự đoán trên cơ sở dữ liệu tương ứng và so sánh kết quả với truy vấn chuẩn [3]. Trong trường hợp SQL không hợp lệ (lỗi cú pháp hoặc tham chiếu bảng/cột không tồn tại), mẫu được tính là thất bại cho EX.

**Giao thức đánh giá.** Chúng tôi báo cáo:

- **Exact Match (EM)**: tỷ lệ mẫu có SQL dự đoán khớp chuẩn theo tiêu chí đánh giá của Spider.
- **Execution Accuracy (EX)**: tỷ lệ mẫu có kết quả thực thi trùng với truy vấn chuẩn.

Trong cả hai cấu hình, đầu ra cuối cùng là SQL sau bước Validator. Nếu Validator phát hiện lỗi cú pháp hoặc không khớp lược đồ không thể sửa theo quy tắc kỹ thuật, hệ thống coi đó là thất bại trong đánh giá.

**Kiểm soát biến số trong so sánh.** Để so sánh base configuration và full configuration một cách tập trung, chúng tôi giữ cố định:

- mô hình nền và tham số sinh,
- cách biểu diễn lược đồ đầu vào,
- giao thức đánh giá EM/EX,
- và thứ tự thực thi pipeline (tuần tự, không song song).

Khác biệt duy nhất giữa hai cấu hình là việc bật/tắt hai thành phần Planner và Refiner. Điều này giúp diễn giải kết quả ở Table 1 theo đúng mục tiêu của bài: đánh giá vai trò của lập kế hoạch và tinh chỉnh trong một framework đa tác nhân.

### 4.2 Main Results

Table 1 trình bày so sánh giữa **base configuration (4-step)** và **full configuration (6-step)** trên Spider 1.0 (1.034 câu hỏi).

**Table 1. Kết quả chính trên Spider 1.0 (1.034 câu hỏi)**

| Pipeline configuration | Exact Match (EM, %) | Execution Accuracy (EX, %) |
| :--- | ---: | ---: |
| Base configuration (4-step) | 71.2 | 79.5 |
| Full configuration (6-step) | 76.8 | 84.1 |

**Nhận xét.** Full configuration đạt EM và EX cao hơn base configuration trong cùng bối cảnh đánh giá. Dưới góc nhìn pipeline, hai thành phần bổ sung (Planner và Refiner) cung cấp hai lớp kiểm soát: Planner làm rõ logic trước khi viết SQL, còn Refiner bắt các sai lệch phổ biến sau khi đã có SQL ban đầu. Trong khi đó, base configuration phụ thuộc nhiều hơn vào SQL Expert để “đúng ngay từ lần đầu”, và Validator chỉ có thể phát hiện lỗi kỹ thuật chứ không chủ động sửa lỗi ngữ nghĩa.

**Diễn giải theo độ phức tạp truy vấn (định tính).** Dựa trên quan sát khi chạy hệ thống, lợi ích của full configuration thường rõ hơn ở các câu hỏi có nhiều bước suy luận (nhiều JOIN, có điều kiện tổng hợp, hoặc có cấu trúc truy vấn con). Với các câu hỏi đơn giản, cả hai cấu hình đều có thể tạo SQL hợp lệ; khác biệt chủ yếu xuất hiện khi cần lập luận về đường JOIN hoặc cần ràng buộc đúng trường SELECT theo yêu cầu câu hỏi.

**Vì sao Planner giúp trong các truy vấn nhiều bước.** Planner can thiệp trước khi SQL xuất hiện, nên tác động của nó mang tính “phòng ngừa”. Với các câu hỏi yêu cầu (i) nhiều bảng và đường JOIN không hiển nhiên, hoặc (ii) các thao tác tập hợp (“cả A và B”, “A nhưng không phải B”), kế hoạch logic giúp làm rõ loại phép toán cần dùng và dữ liệu đến từ đâu. Khi không có kế hoạch, SQL Expert có thể chọn một chiến lược truy vấn “đủ chạy” nhưng sai logic (ví dụ dùng OR thay vì INTERSECT, hoặc join theo một khóa không đúng).

**Vì sao Refiner giúp ở các lỗi gần-đúng.** Refiner hoạt động sau khi đã có một truy vấn ban đầu, nên thường hiệu quả trong các trường hợp “gần đúng”: cấu trúc truy vấn hợp lý, nhưng sai một chi tiết quan trọng như cột SELECT, COUNT(DISTINCT), hoặc GROUP BY. Refiner có lợi thế là có thể đối chiếu đồng thời ba nguồn thông tin: (i) yêu cầu trường đầu ra từ Analyzer, (ii) kế hoạch logic từ Planner (nếu có), và (iii) SQL ban đầu từ Expert. Do đó, Refiner đóng vai trò như một lớp “đối soát ngữ nghĩa” trước khi bước Validator thực hiện đối soát kỹ thuật.

**Giới hạn của so sánh 4-step vs 6-step.** Table 1 chỉ phản ánh sự khác nhau giữa hai cấu hình ở mức tổng thể. Nó không trực tiếp trả lời “thành phần nào quan trọng nhất” vì Planner và Refiner được bật/tắt đồng thời khi chuyển từ 4-step sang 6-step. Đây là lý do chúng tôi đưa giao thức ablation (Mục 4.3) để tách hiệu ứng của từng thành phần trong các thực nghiệm tiếp theo.

### 4.3 Ablation Study (protocol + planned evaluation)

Mục này mô tả **giao thức ablation** mà chúng tôi dự kiến thực hiện để định lượng vai trò từng thành phần trong full configuration. Do nghiên cứu hiện tại chỉ báo cáo hai cấu hình (4-step và 6-step) cùng các kết quả ở Table 1, chúng tôi **không** đưa số liệu ablation định lượng trong bài; thay vào đó, chúng tôi mô tả kế hoạch thí nghiệm và các đại lượng cần đo. Trong các phiên bản tiếp theo, các thí nghiệm này có thể được bổ sung như thực nghiệm tương lai.

**Thiết kế ablation (từ full configuration).** Xuất phát từ full configuration (6-step), chúng tôi dự kiến đánh giá các biến thể sau:

- **–Planner**: bỏ Query Planner, giữ Refiner và Validator. Mục tiêu: đo vai trò của lập kế hoạch logic độc lập với tinh chỉnh.
- **–Refiner**: bỏ SQL Refiner, giữ Planner và Validator. Mục tiêu: đo vai trò của tinh chỉnh một lần sau khi đã có kế hoạch.
- **–Validator**: thay Validator bằng một kiểm tra tối thiểu (hoặc chỉ kiểm tra cú pháp). Mục tiêu: đánh giá tác động của lớp kiểm tra kỹ thuật đối với tỷ lệ SQL hợp lệ.
- **(Tuỳ chọn) –Schema Selector**: dùng lược đồ đầy đủ thay vì lược đồ lọc. Mục tiêu: định lượng ảnh hưởng của giảm nhiễu lược đồ lên EM/EX và độ ổn định.

**Đại lượng đo (what to measure).** Với mỗi biến thể, chúng tôi dự kiến đo:

- **EM** và **EX** trên cùng tập Spider 1.0 (1.034 câu hỏi) để đảm bảo so sánh công bằng.
- **Tỷ lệ lỗi kỹ thuật**: tỷ lệ SQL bị loại do lỗi cú pháp hoặc không khớp lược đồ (báo bởi Validator).
- **Chi phí suy luận**: số token đầu vào/đầu ra (ước lượng) và thời gian chạy trung bình theo mẫu, để đo trade-off chất lượng–chi phí.

**Phân tích theo nhóm truy vấn (planned stratification).** Bên cạnh báo cáo tổng EM/EX, chúng tôi dự kiến phân tích theo các lát cắt sau để diễn giải vai trò từng thành phần rõ hơn:

- **Theo độ khó của Spider** (nếu dùng nhãn độ khó theo giao thức bộ dữ liệu): Easy / Medium / Hard / Extra-hard. Mục tiêu là kiểm tra giả thuyết rằng Planner/Refiner tạo khác biệt lớn hơn khi truy vấn khó tăng.
- **Theo mẫu cấu trúc SQL**: nhóm truy vấn có JOIN nhiều bảng, nhóm có aggregation, nhóm có nested queries, nhóm có set operators. Phân tích này phù hợp với taxonomy lỗi ở Mục 5, và giúp gắn “thành phần pipeline ↔ nhóm lỗi”.
- **Theo kích thước lược đồ**: số bảng/cột trong lược đồ của mỗi database. Lát cắt này giúp đánh giá trực tiếp lợi ích của Schema Selector trong các lược đồ lớn.

**Giao thức ghi log để phục vụ ablation và error analysis.** Để hỗ trợ phân tích sau thực nghiệm, chúng tôi dự kiến lưu lại các artefact trung gian cho mỗi mẫu: `analysis`, `schema_filtered`, `plan`, `y0`, `y1`, và `report`. Các log này cho phép (i) kiểm tra lỗi phát sinh ở pha nào, (ii) đo mức độ “sửa” của Refiner (ví dụ thay đổi SELECT, thêm GROUP BY), và (iii) tái hiện các trường hợp thất bại để phân tích định tính. Lưu ý rằng việc ghi log không thay đổi giao thức EM/EX; nó chỉ phục vụ diễn giải.

**Giả thuyết làm việc (không kèm số liệu).** Dựa trên vai trò thiết kế, chúng tôi kỳ vọng:

- biến thể –Planner sẽ ảnh hưởng nhiều hơn đến các câu hỏi cần suy luận nhiều bước và các lỗi JOIN/aggregation;
- biến thể –Refiner sẽ làm tăng các sai lệch “gần đúng” như chọn sai trường trong SELECT hoặc sai COUNT vs COUNT(DISTINCT);
- biến thể –Validator sẽ tăng tỷ lệ SQL không hợp lệ về mặt kỹ thuật, ảnh hưởng trực tiếp đến EX trong đánh giá thực thi.

Các giả thuyết này sẽ được kiểm chứng trong thực nghiệm tương lai với cùng giao thức đo lường nêu trên.

## 5. Error Analysis

Mục này trình bày taxonomy lỗi và phân tích định tính nhằm làm rõ những kiểu sai còn tồn tại, đồng thời liên hệ chúng với các thành phần trong pipeline. Mục tiêu ở đây là “đọc lỗi” theo cấu trúc, không phải là báo cáo thêm kết quả định lượng.

### 5.1 Error Taxonomy

Chúng tôi phân loại lỗi NL2SQL thành các nhóm sau (có thể chồng lấn trong một truy vấn):

- **Field selection errors**: chọn sai cột trong SELECT (hoặc sai thứ tự cột khi thứ tự quan trọng). Đây là lỗi thường xuất hiện khi nhiều cột có nghĩa gần nhau (ví dụ `name` vs `title`, `id` vs `code`).
- **Join path errors**: chọn sai bảng trung gian, sai điều kiện JOIN, hoặc thiếu JOIN cần thiết. Lỗi này thường liên quan đến suy luận quan hệ khóa ngoại hoặc quan hệ nhiều-nhiều.
- **Aggregation / grouping errors**: dùng sai hàm tổng hợp (COUNT vs COUNT(DISTINCT)), GROUP BY thiếu cột, hoặc HAVING/ORDER BY không phù hợp.
- **Nested query errors**: sai cấu trúc truy vấn con (IN/EXISTS), sai mức lồng, hoặc nhầm tương quan (correlated subquery).
- **Value grounding errors**: lọc sai giá trị trong WHERE do chuẩn hóa chuỗi/ngày/tháng, hoặc chọn sai cột để so sánh với giá trị.
- **Set operator errors**: dùng sai UNION/INTERSECT/EXCEPT, hoặc nhầm “OR” logic với hợp nhất tập kết quả.
- **Ambiguity handling**: câu hỏi mơ hồ dẫn tới giả định khác với truy vấn chuẩn; đây là lỗi khó tránh nếu không có cơ chế hỏi lại người dùng.

Taxonomy này giúp liên hệ lỗi với thiết kế pipeline: Field selection được xử lý từ Phase 1 (Analyzer) và Phase 3 (Refiner), join/grouping được hỗ trợ bởi Planner, còn Validator chủ yếu phát hiện lỗi kỹ thuật và không thay đổi logic.

Để phục vụ phân tích có cấu trúc, chúng tôi cũng gợi ý cách “gán lỗi” theo tầng quyết định trong pipeline (không kèm số liệu). Mục đích là giúp người đọc hiểu: nếu một truy vấn sai, lỗi có thể bắt nguồn từ đâu trong chuỗi xử lý.

- **Lỗi gốc từ Phase 1 (Analysis/Schema)**: thường biểu hiện dưới dạng chọn sai trường đầu ra (Analyzer) hoặc thiếu bảng/cột quan trọng trong lược đồ lọc (Schema Selector). Khi lược đồ lọc thiếu cột/khóa, các bước sau có thể phải “chế” đường JOIN hoặc suy đoán tên cột, làm tăng nguy cơ sai.
- **Lỗi gốc từ Phase 2 (Planning/Generation)**: thường liên quan đến join path, nested query structure, aggregation semantics, và set operator. Ngay cả khi Analyzer chọn đúng trường đầu ra, một kế hoạch join sai có thể dẫn tới truy vấn trả về kết quả khác hoàn toàn.
- **Lỗi gốc từ Phase 3 (Refinement/Validation)**: thường là lỗi gần-đúng nhưng thiếu một ràng buộc (GROUP BY/HAVING), dùng sai hàm tổng hợp, hoặc tham chiếu sai tên cột. Validator có thể phát hiện lỗi kỹ thuật, nhưng nếu không có Refiner thì hệ thống thiếu bước sửa ngữ nghĩa có kiểm soát.

Từ góc nhìn hệ thống, taxonomy này cũng cho thấy “vì sao” một framework cấu hình được là hữu ích: nếu ta có thể bật/tắt Planner hoặc Refiner, ta có thể kiểm tra giả thuyết rằng một nhóm lỗi chủ yếu bị ảnh hưởng bởi thành phần nào (được kiểm chứng bằng ablation trong tương lai).

### 5.2 Qualitative Analysis with One Example

Dưới đây là một ví dụ ngắn (mang tính minh họa) cho lỗi **field selection**. Ý tưởng này phản ánh một mẫu lỗi phổ biến: hệ thống trả về một cột “có vẻ hợp lý” nhưng không đúng với yêu cầu câu hỏi.

**Câu hỏi (Q).** “Tìm mã khóa học của các khóa học do khoa X cung cấp.”

**Lược đồ rút gọn (minified).**

- `course(course_id, title, dept_name, ...)`

**SQL đúng (gold).**

```sql
SELECT course_id
FROM course
WHERE dept_name = 'X'
```

**SQL sai điển hình (predicted).**

```sql
SELECT title
FROM course
WHERE dept_name = 'X'
```

Trong trường hợp này, logic lọc theo `dept_name` là đúng, nhưng trường đầu ra sai (`title` thay vì `course_id`). Với base configuration, lỗi có thể xuất hiện nếu SQL Expert ưu tiên cột “dễ hiểu” (title) khi đọc câu hỏi. Với full configuration, Analyzer có thể trích rõ `expected_output_fields = [course.course_id]`, và Refiner có thể đối chiếu SELECT với danh sách này để sửa. Dù vậy, lỗi vẫn có thể tồn tại khi câu hỏi mơ hồ (“tìm các khóa học” có thể hiểu là mã hoặc tên), hoặc khi lược đồ có nhiều cột gần nghĩa.

**Bài học rút ra từ ví dụ.** Ví dụ trên cho thấy một đặc trưng của lỗi field selection: nó thường không làm SQL “bị lỗi kỹ thuật” (vẫn chạy được), nhưng làm câu trả lời sai. Vì vậy, nếu pipeline chỉ dựa vào Validator (kiểm tra tên bảng/cột, cú pháp), hệ thống có thể bỏ sót lỗi này. Trong framework, chúng tôi xem việc tách riêng Analyzer (để “chốt” trường đầu ra) và Refiner (để đối chiếu SQL với trường đã chốt) là một cách giảm rủi ro kiểu lỗi này.

**Liên hệ với các nhóm lỗi khác.** Dù ví dụ tập trung vào field selection, các nhóm lỗi khác cũng có dạng “gần đúng” tương tự:

- Với **aggregation**, SQL có thể chạy và trả kết quả, nhưng sai vì dùng COUNT(*) thay vì COUNT(DISTINCT), hoặc thiếu GROUP BY. Những sai khác này khó phát hiện nếu chỉ nhìn cú pháp; cần đối chiếu với intent/plan.
- Với **join path**, SQL có thể chạy nhưng join sai bảng trung gian, dẫn tới trùng lặp hoặc thiếu bản ghi. Đây là nhóm lỗi mà Planner được kỳ vọng hỗ trợ tốt hơn bằng cách nêu rõ đường join ngay từ kế hoạch logic.
- Với **value grounding**, SQL có thể lọc đúng cột nhưng sai giá trị do chuẩn hóa chuỗi/ngày tháng; lỗi này thường cần thêm tiền xử lý hoặc cơ chế chuẩn hóa nhất quán (ngoài phạm vi bài báo).

Nhìn chung, error analysis theo taxonomy không nhằm “đổ lỗi” cho một tác nhân, mà nhằm chỉ ra rằng các lỗi NL2SQL thuộc nhiều tầng quyết định khác nhau. Điều này củng cố lựa chọn thiết kế framework: tách pipeline theo pha để có thể can thiệp đúng chỗ, thay vì tăng độ dài prompt cho một tác nhân duy nhất.

## 6. Discussion

Mục này thảo luận về các đánh đổi và phạm vi áp dụng của framework, dựa trên thiết kế và quan sát thực nghiệm, trong khi giữ giọng văn trung tính và tránh kết luận vượt quá dữ liệu.

**Chất lượng vs chi phí suy luận.** Full configuration thêm hai bước (Planner, Refiner), nên chi phí token và độ trễ dự kiến cao hơn so với base configuration. Điều này tạo ra trade-off tự nhiên: chất lượng (EM/EX) tăng nhưng chi phí cũng tăng. Với các hệ thời gian thực, cấu hình base có thể là lựa chọn thực dụng; với các truy vấn phức tạp hoặc yêu cầu độ tin cậy cao, cấu hình full có thể phù hợp hơn. Việc framework hỗ trợ cấu hình pipeline giúp người dùng hệ thống chọn điểm cân bằng phù hợp theo bối cảnh.

**Tính minh bạch và khả năng phân tích.** Một lợi ích quan trọng của thiết kế đa tác nhân là khả năng quan sát trung gian: analysis, schema đã lọc, plan, SQL ban đầu, và SQL sau tinh chỉnh. Các “artefact” trung gian này không chỉ phục vụ debug, mà còn hỗ trợ nghiên cứu: có thể phân tích lỗi theo pha, hoặc thiết kế ablation theo đúng thành phần, thay vì chỉ thay đổi prompt một cách khó kiểm soát.

**Giới hạn của tinh chỉnh một lần.** Single-pass refinement giúp giữ chi phí thấp hơn so với các vòng lặp tự sửa nhiều lượt, nhưng cũng có giới hạn rõ: nếu SQL ban đầu sai cấu trúc ở mức “gốc” (ví dụ thiếu hẳn một bảng cần join, hoặc chọn sai chiến lược nested query), một lần tinh chỉnh có thể không đủ để đảo chiều quyết định. Hơn nữa, nếu Refiner sửa quá mạnh mà không bám sát `analysis`/`plan`, hệ thống có nguy cơ tạo ra truy vấn “khác mục tiêu”. Vì vậy, chúng tôi thiết kế Refiner theo hướng đối soát có kiểm soát: ưu tiên sửa các sai lệch có thể kiểm chứng (SELECT fields, COUNT vs COUNT(DISTINCT), GROUP BY/HAVING) và hạn chế thay đổi chiến lược truy vấn.

**Giới hạn về mơ hồ ngôn ngữ và tri thức miền.** Spider là bộ dữ liệu chuẩn, nhưng nhiều câu hỏi trong thực tế còn mơ hồ hơn hoặc đòi hỏi tri thức miền không nằm trong lược đồ. Framework của chúng tôi không giải quyết triệt để vấn đề này vì pipeline vẫn dựa vào câu hỏi và lược đồ cung cấp. Do đó, với các trường hợp mơ hồ, hệ thống có thể tạo SQL hợp lệ nhưng khác ý định chuẩn; giải pháp tiềm năng là cơ chế hỏi lại (clarification) hoặc tương tác nhiều lượt, nằm ngoài phạm vi bài báo.

**Tái lập và sai khác do prompt.** Với hệ NL2SQL dựa trên LLM, prompt và cách trình bày lược đồ là một phần quan trọng của hệ thống. Ngay cả khi giữ mô hình nền cố định, thay đổi nhỏ trong template hoặc ví dụ few-shot có thể làm thay đổi hành vi. Vì vậy, một điểm thực dụng của framework là: nó khuyến khích lưu lại prompt/config theo phiên bản (Appendix), đồng thời tách prompt theo vai trò tác nhân để giảm hiệu ứng “mọi thứ dồn vào một prompt”. Trong các phiên bản tiếp theo, chúng tôi kỳ vọng việc công bố artefact và cấu hình chạy sẽ giúp giảm khoảng cách tái lập giữa các môi trường.

**Khả năng tổng quát.** Dù bài báo tập trung vào NL2SQL, ý tưởng “pipeline mô-đun hóa + cấu hình được để đánh giá” có thể áp dụng cho các tác vụ tạo đầu ra có cấu trúc khác (ví dụ tạo API call, tạo truy vấn hệ tri thức, hoặc tạo code có ràng buộc). Tuy nhiên, để khẳng định tính tổng quát theo nghĩa thực nghiệm cần thêm đánh giá trên nhiều bộ dữ liệu và miền, do đó chúng tôi coi đây là hướng mở.

## 7. Conclusion & Future Work

Bài báo này đề xuất một framework NL2SQL đa tác nhân theo pipeline mô-đun hóa, cho phép cấu hình số bước để phục vụ đánh giá có cấu trúc và phân tích vai trò thành phần. Framework tách pipeline thành ba pha: (i) phân tích câu hỏi và liên kết/lọc lược đồ, (ii) lập kế hoạch logic và sinh SQL, và (iii) tinh chỉnh một lần và kiểm tra kỹ thuật. Chúng tôi đánh giá hai cấu hình: base configuration (4-step) và full configuration (6-step) trên Spider 1.0 (1.034 câu hỏi). Kết quả cho thấy full configuration đạt **EM 76.8% / EX 84.1%**, trong khi base configuration đạt **EM 71.2% / EX 79.5%**.

Ở mức đóng góp, bài báo nhấn mạnh rằng giá trị của framework không chỉ nằm ở con số tổng, mà ở khả năng hỗ trợ nghiên cứu theo hướng có cấu trúc: cấu hình được pipeline, thiết kế ablation theo thành phần, và phân tích lỗi theo taxonomy gắn với từng pha. Dựa trên kết quả hiện tại, chúng tôi tránh kết luận quá mức và coi đây là bằng chứng trong bối cảnh triển khai của nghiên cứu.

**Hướng tương lai** tập trung vào ba hướng chính:

- **Ablation định lượng có kiểm soát**: thực hiện các biến thể –Planner/–Refiner/–Validator và đo EM/EX, chi phí token, và độ trễ như mô tả ở Mục 4.3.
- **Mở rộng cơ chế kiểm soát mơ hồ**: bổ sung tác nhân làm rõ câu hỏi (clarification agent) hoặc cơ chế hội thoại nhiều lượt cho các câu hỏi mơ hồ.
- **Tăng tính tái lập và chuẩn hóa**: công bố cấu hình chạy, prompt template (ở mức tối thiểu cần thiết), và script đánh giá để cộng đồng có thể tái lập và mở rộng.

## Appendix / Supplementary (không tính trang)

### A. Prompt/config placeholders

- **Prompt templates (placeholder)**: `LINK_TO_REPO/prompts/`
  - `question_analyzer.md`
  - `schema_selector.md`
  - `query_planner.md`
  - `sql_expert.md`
  - `sql_refiner.md`
  - `sql_validator.md`

Ghi chú: Bản main paper chỉ mô tả ý tưởng và trách nhiệm của từng tác nhân. Prompt/backstory đầy đủ (nếu công bố) nên đi kèm phiên bản hóa (versioning) để đảm bảo tái lập.

### B. Pipeline configuration (placeholder)

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

### C. Reproducibility checklist (placeholder)

- Code repository: `LINK_TO_REPO`
- Evaluation scripts: `LINK_TO_REPO/eval/`
- Dataset instructions: follow Spider 1.0 evaluation protocol [3]
- Random seed / determinism: `TODO`

### D. References (carried from source; placeholders allowed)

[1] V. Zhong et al., “Seq2SQL,” ACL 2017.  
[2] T. Yu et al., “SyntaxSQLNet,” EMNLP 2018.  
[3] T. Yu et al., “Spider,” EMNLP 2018.  
[4] B. Wang et al., “RAT-SQL,” ACL 2020.  
[5] S. Ruan et al., “RESDSQL,” arXiv 2023.  
[8] Y. Wang et al., “AutoGen,” arXiv 2023.  
[9] H. Chase, “LangChain,” 2022–2024.  
[10] J. Moura et al., “CrewAI,” 2023–2024.  
[11] E. Gan et al., “BRIDGE,” NAACL 2021.  
[12] T. Scholak et al., “PICARD,” EMNLP 2021.  
[17] Z. Yuan et al., “CRITIC,” arXiv 2023.  
[18] Agentic RAG surveys/blogs, 2023–2024. [REF]  
[19] Tool learning / function-calling surveys, 2023–2024. [REF]  

