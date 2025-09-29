# Kế hoạch thực nghiệm Multi-Agent NL2SQL System

## 📋 Tổng quan

Thực nghiệm so sánh 3 mô hình Multi-Agent khác nhau cho hệ thống NL2SQL, nhằm tìm ra sự cân bằng tối ưu giữa **độ chính xác**, **thời gian thực thi** và **chi phí** (số lần gọi AI API).

---

## 🎯 Mục tiêu thực nghiệm

- **Đánh giá hiệu suất**: Execution Accuracy, Exact Match Rate
- **Đo lường tài nguyên**: Thời gian, số API calls, token usage
- **Tìm mô hình tối ưu**: Cân bằng accuracy-speed-cost
- **Benchmark dataset**: 50 câu hỏi Spider dataset (Easy: 20, Medium: 20, Hard: 10)

---

## 🔬 Mô hình 1: Lightweight (3 bước)

### Kiến trúc
```
Natural Language Question → SQL Expert → SQL Validator → Final SQL
```

### Chi tiết các bước

#### Bước 1: SQL Expert Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: Raw question + full database schema
- **Nhiệm vụ**: Trực tiếp tạo SQL từ câu hỏi tự nhiên
- **Prompt**:
```
You are an SQL Expert. Generate accurate SQL query from this question:

Question: {question}
Database Schema: {full_schema}

Rules:
- Return only executable SQL query
- Use single-line format
- Be precise with table/column names
- Handle JOIN operations correctly

Return JSON: {"sql": "SELECT ..."}
```

#### Bước 2: SQL Validator Agent  
- **AI Model**: Gemini 2.0 Flash
- **Input**: Generated SQL + question + schema
- **Nhiệm vụ**: Kiểm tra và sửa lỗi SQL
- **Prompt**:
```
Validate and fix this SQL query:

SQL: {sql}
Question: {question}
Schema: {schema}

Check:
1. Syntax correctness
2. Table/column existence
3. Logic accuracy
4. Executability

Return JSON: {
  "sql": "corrected_sql",
  "explain": "what_this_sql_does",
  "error": "error_message_if_any"
}
```

### Dự kiến benchmark (50 câu hỏi)

| Metric | Giá trị dự kiến |
|--------|----------------|
| **Execution Accuracy** | 75% ± 5% |
| **Exact Match Rate** | 65% ± 5% |
| **Avg Response Time** | 4.5s/câu hỏi |
| **Total API Calls** | 150 calls (3/câu hỏi) |
| **Avg Tokens/Question** | Input: 800, Output: 150 |
| **Total Time (50Q)** | ~225 giây (3.75 phút) |
| **Cost Index** | 1.0 (baseline) |

---

## ⚖️ Mô hình 2: Balanced (4 bước) - Current

### Kiến trúc
```
Natural Language Question → Question Analyzer → Schema Selector → SQL Expert → SQL Validator → Final SQL
```

### Chi tiết các bước

#### Bước 1: Question Analyzer Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: Raw question + full schema
- **Nhiệm vụ**: Phân tích intent, complexity, entities
- **Prompt**:
```
Analyze this question for SQL generation:

Question: {question}
Database: {raw_db_schema}

Identify:
1. Intent: COUNT, LIST, MAX_MIN, AGGREGATION
2. Complexity: EASY (1 table), MEDIUM (2-3 tables), HARD (complex)
3. Required tables: which tables are needed
4. Required columns: which columns are needed
5. Filter values: specific values mentioned

Return JSON: {
  "intent": "COUNT|LIST|MAX_MIN|AGGREGATION",
  "complexity": "EASY|MEDIUM|HARD",
  "entities": {
    "tables": ["table1", "table2"],
    "columns": ["col1", "col2"],
    "values": ["val1", "val2"]
  },
  "confidence": 0.95
}
```

#### Bước 2: Schema Selector Agent
- **AI Model**: Gemini 2.0 Flash  
- **Input**: Question + analysis + full schema
- **Nhiệm vụ**: Lọc schema chỉ giữ lại phần cần thiết
- **Prompt**:
```
Filter database schema to keep only necessary components:

Question: {question}
Original Schema: {raw_db_schema}
Analysis: {question_analysis}

Based on analysis:
1. Keep tables mentioned in "entities.tables"
2. Keep columns mentioned in "entities.columns"
3. Keep primary/foreign keys for JOINs
4. Remove irrelevant components

Return filtered schema with same JSON format as original.
```

#### Bước 3: SQL Expert Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: Question + filtered schema + analysis
- **Nhiệm vụ**: Tạo SQL query chính xác
- **Prompt**: (Tương tự mô hình 1 nhưng với filtered schema)

#### Bước 4: SQL Validator Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: Generated SQL + question + filtered schema
- **Nhiệm vụ**: Validate và fix SQL
- **Prompt**: (Tương tự mô hình 1)

### Dự kiến benchmark (50 câu hỏi)

| Metric | Giá trị dự kiến |
|--------|----------------|
| **Execution Accuracy** | 85% ± 3% |
| **Exact Match Rate** | 75% ± 3% |
| **Avg Response Time** | 6.8s/câu hỏi |
| **Total API Calls** | 200 calls (4/câu hỏi) |
| **Avg Tokens/Question** | Input: 1200, Output: 200 |
| **Total Time (50Q)** | ~340 giây (5.67 phút) |
| **Cost Index** | 1.33 |

---

## 🚀 Mô hình 3: Enhanced (6 bước) - Theo bài báo

### Kiến trúc
```
Natural Language Question → Query Refinement → Entity Recognition → Question Analyzer → Schema Selector → SQL Expert → SQL Validator → Final SQL
```

### Chi tiết các bước

#### Bước 1: Query Refinement Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: Current question + conversation history (if any)
- **Nhiệm vụ**: Làm rõ câu hỏi, xử lý context
- **Prompt**:
```
Refine this question to be self-contained and clear:

Current Question: {question}
Conversation History: {history}

Tasks:
1. Resolve pronoun references (it, that, them)
2. Add missing context from history
3. Make question standalone
4. Preserve original intent

Return JSON: {
  "refined_question": "clear_standalone_question",
  "changes_made": ["change1", "change2"],
  "confidence": 0.95
}
```

#### Bước 2: Entity Recognition Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: Refined question + database metadata
- **Nhiệm vụ**: Nhận diện entities chính xác
- **Prompt**:
```
Extract and recognize entities from this SQL question:

Question: {refined_question}
Database Metadata: {db_metadata}

Identify:
1. Table entities (exact table names)
2. Column entities (exact column names)  
3. Value entities (specific values, dates, numbers)
4. Relationship entities (foreign keys, joins)

Handle:
- Spelling variations (Student vs student)
- Synonyms (class vs course)
- Abbreviations (dept vs department)

Return JSON: {
  "tables": [{"mentioned": "students", "actual": "student", "confidence": 0.9}],
  "columns": [{"mentioned": "name", "actual": "student_name", "confidence": 0.95}],
  "values": [{"mentioned": "2023", "type": "year", "confidence": 1.0}],
  "relationships": ["student.dept_name = department.dept_name"]
}
```

#### Bước 3: Question Analyzer Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: Refined question + recognized entities
- **Nhiệm vụ**: Phân tích sâu hơn với entities chính xác
- **Prompt**: (Tương tự mô hình 2 nhưng với refined question và entities)

#### Bước 4: Schema Selector Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: Analysis + recognized entities + full schema
- **Nhiệm vụ**: Lọc schema thông minh hơn
- **Prompt**: (Tương tự mô hình 2 nhưng với entity recognition data)

#### Bước 5: SQL Expert Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: Refined question + filtered schema + analysis + entities
- **Nhiệm vụ**: Tạo SQL với độ chính xác cao
- **Prompt**:
```
Generate SQL query with enhanced context:

Refined Question: {refined_question}
Filtered Schema: {filtered_schema}
Analysis: {analysis}
Recognized Entities: {entities}

Use entity mappings:
- Table mappings: {table_mappings}
- Column mappings: {column_mappings}
- Value mappings: {value_mappings}

Advanced rules:
1. Use exact entity names from recognition
2. Apply relationship constraints
3. Handle complex logic (AND/OR, aggregations)
4. Optimize for performance

Return JSON: {"sql": "optimized_sql_query"}
```

#### Bước 6: SQL Validator Agent
- **AI Model**: Gemini 2.0 Flash
- **Input**: All previous context + generated SQL
- **Nhiệm vụ**: Comprehensive validation
- **Prompt**: (Enhanced validation với full context)

### Dự kiến benchmark (50 câu hỏi)

| Metric | Giá trị dự kiến |
|--------|----------------|
| **Execution Accuracy** | 92% ± 2% |
| **Exact Match Rate** | 85% ± 2% |
| **Avg Response Time** | 9.2s/câu hỏi |
| **Total API Calls** | 300 calls (6/câu hỏi) |
| **Avg Tokens/Question** | Input: 1800, Output: 280 |
| **Total Time (50Q)** | ~460 giây (7.67 phút) |
| **Cost Index** | 2.1 |

---

## 📊 So sánh tổng quan

| Mô hình | Accuracy | Time/Q | API Calls | Cost Index | Phù hợp cho |
|---------|----------|--------|-----------|------------|-------------|
| **3-bước** | 75% | 4.5s | 3 | 1.0 | Prototype, demo nhanh |
| **4-bước** | 85% | 6.8s | 4 | 1.33 | Production cân bằng |
| **6-bước** | 92% | 9.2s | 6 | 2.1 | High-accuracy cần thiết |

---

## 🛠️ Implementation Plan

### Phase 1: Chuẩn bị (1-2 ngày)
1. **Setup test dataset**: Chọn 50 câu hỏi Spider (20 Easy, 20 Medium, 10 Hard)
2. **Implement missing functions**: 
   - `enhance_sql_query()` function
   - Query refinement module
   - Entity recognition module
3. **Create experiment framework**: Script chạy tự động 3 mô hình

### Phase 2: Implementation (3-5 ngày)
1. **Mô hình 3-bước**: Simplify current pipeline
2. **Mô hình 4-bước**: Current system (fix bugs)
3. **Mô hình 6-bước**: Add query refinement + entity recognition

### Phase 3: Benchmark (2-3 ngày)
1. **Chạy thực nghiệm**: Mỗi mô hình x 3 lần với 50 câu hỏi
2. **Thu thập metrics**: Accuracy, time, API calls, tokens
3. **Phân tích kết quả**: Statistical significance, trade-offs

### Phase 4: Optimization (2-3 ngày)
1. **Fine-tune prompts** based on results
2. **Optimize best-performing model**
3. **Document findings** và recommendations

---

## 📈 Expected Outcomes

### Hypothesis
- **Mô hình 6-bước** sẽ có accuracy cao nhất nhưng cost và time cao
- **Mô hình 3-bước** nhanh nhất nhưng accuracy thấp với câu hỏi phức tạp
- **Mô hình 4-bước** sẽ là sweet spot cho production

### Success Criteria
- Có ít nhất 1 mô hình đạt >80% execution accuracy
- Identify clear trade-offs giữa các metrics
- Provide actionable recommendations cho production deployment

### Risk Mitigation
- **API Rate Limits**: Implement retry logic và rate limiting
- **Cost Control**: Monitor token usage, set budget limits
- **Quality Assurance**: Human evaluation cho sample results

---

## 💰 Cost Estimation (Gemini 2.0 Flash)

### Token Pricing (estimate)
- Input tokens: $0.001 per 1K tokens
- Output tokens: $0.002 per 1K tokens

### Total Cost Estimate (50 câu hỏi x 3 runs = 150 runs)

| Mô hình | Input Tokens | Output Tokens | Total Cost |
|---------|--------------|---------------|------------|
| **3-bước** | 120K | 22.5K | $0.165 |
| **4-bước** | 180K | 30K | $0.24 |
| **6-bước** | 270K | 42K | $0.354 |
| **Total** | 570K | 94.5K | **$0.759** |

---

## 📝 Deliverables

1. **Code Implementation**: 3 mô hình hoàn chỉnh
2. **Benchmark Results**: Chi tiết metrics và analysis
3. **Research Report**: Findings và recommendations
4. **Production Guide**: Best practices cho deployment
5. **Cost Analysis**: ROI analysis cho từng mô hình

---

*Kế hoạch này sẽ giúp xác định mô hình Multi-Agent tối ưu cho hệ thống NL2SQL, cân bằng giữa độ chính xác, tốc độ và chi phí.*
