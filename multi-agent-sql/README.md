# Multi-Agent SQL Generation System

## 📋 Tổng quan

Dự án nghiên cứu và so sánh hiệu suất của 3 mô hình Multi-Agent khác nhau cho việc chuyển đổi ngôn ngữ tự nhiên thành SQL (NL2SQL), nhằm tìm ra sự cân bằng tối ưu giữa **độ chính xác**, **thời gian thực thi** và **chi phí**.

## 🎯 Mục tiêu

- **Nghiên cứu**: So sánh 3 kiến trúc Multi-Agent với độ phức tạp khác nhau
- **Benchmark**: Đánh giá hiệu suất trên dataset Spider với 50 câu hỏi
- **Tối ưu**: Tìm mô hình cân bằng accuracy-speed-cost cho production
- **Chuẩn hóa**: Xây dựng framework có thể mở rộng cho các domain khác

## 🏗️ Cấu trúc dự án

```
multi-agent-sql/
├── README.md                           # Tài liệu chính
├── requirements.txt                    # Dependencies
├── .env.example                        # Environment variables template
├── config/
│   ├── __init__.py
│   ├── settings.py                     # Global configuration
│   └── prompts/                        # Prompt templates
│       ├── query_refinement.yaml
│       ├── entity_recognition.yaml
│       ├── question_analyzer.yaml
│       ├── schema_selector.yaml
│       ├── sql_expert.yaml
│       └── sql_validator.yaml
├── data/
│   ├── test_questions/                 # Test datasets
│   │   ├── spider_50_questions.json
│   │   ├── easy_questions.json
│   │   ├── medium_questions.json
│   │   └── hard_questions.json
│   ├── schemas/
│   │   ├── tables.json                 # Database schemas
│   │   └── database/                   # SQLite database files
│   └── results/                        # Benchmark results
│       ├── model_3_step/
│       ├── model_4_step/
│       └── model_6_step/
├── src/
│   ├── __init__.py
│   ├── core/                           # Core components
│   │   ├── __init__.py
│   │   ├── base_agent.py              # Base agent class
│   │   ├── pipeline.py                # Pipeline orchestrator
│   │   └── models.py                  # Pydantic models
│   ├── agents/                        # Agent implementations
│   │   ├── __init__.py
│   │   ├── query_refinement.py        # Query refinement agent
│   │   ├── entity_recognition.py      # Entity recognition agent
│   │   ├── question_analyzer.py       # Question analysis agent
│   │   ├── schema_selector.py         # Schema filtering agent
│   │   ├── sql_expert.py              # SQL generation agent
│   │   └── sql_validator.py           # SQL validation agent
│   ├── models/                        # Model implementations
│   │   ├── __init__.py
│   │   ├── model_3_step.py            # Lightweight model
│   │   ├── model_4_step.py            # Balanced model
│   │   └── model_6_step.py            # Enhanced model
│   ├── utils/                         # Utility functions
│   │   ├── __init__.py
│   │   ├── data_loader.py             # Data loading utilities
│   │   ├── metrics.py                 # Metrics calculation
│   │   ├── benchmark.py               # Benchmark utilities
│   │   └── sql_enhancement.py         # SQL enhancement functions
│   └── evaluation/                    # Evaluation system
│       ├── __init__.py
│       ├── evaluator.py               # Main evaluator
│       ├── test_suite_integration.py  # test-suite-sql-eval integration
│       └── result_parser.py           # Result parsing
├── experiments/                       # Experiment scripts
│   ├── __init__.py
│   ├── run_benchmark.py               # Main benchmark runner
│   ├── compare_models.py              # Model comparison
│   ├── analyze_results.py             # Result analysis
│   └── generate_report.py             # Report generation
├── test-suite-sql-eval/               # External evaluation tool
│   ├── evaluation.py                  # Evaluation script
│   ├── database/                      # Test databases
│   ├── tables.json                    # Schema definitions
│   └── ...                           # Other evaluation files
├── tests/                             # Unit tests
│   ├── __init__.py
│   ├── test_agents/
│   ├── test_models/
│   ├── test_utils/
│   └── test_evaluation/
├── docs/                              # Documentation
│   ├── architecture.md                # System architecture
│   ├── api_reference.md               # API documentation
│   ├── benchmark_guide.md             # Benchmark guide
│   └── deployment.md                  # Deployment guide
└── scripts/                           # Utility scripts
    ├── setup_environment.sh           # Environment setup
    ├── download_data.sh               # Data download
    └── run_experiments.sh             # Experiment runner
```

## 🔬 Các mô hình thực nghiệm

### Model 1: Lightweight (3 bước)
```
Question → SQL Expert → SQL Validator → Result
```
- **Agents**: 2 chính
- **Target**: Nhanh, cost thấp
- **Use case**: Prototype, demo

### Model 2: Balanced (4 bước) 
```
Question → Question Analyzer → Schema Selector → SQL Expert → SQL Validator → Result
```
- **Agents**: 4 chính  
- **Target**: Cân bằng accuracy-speed-cost
- **Use case**: Production standard

### Model 3: Enhanced (6 bước)
```
Question → Query Refinement → Entity Recognition → Question Analyzer → 
Schema Selector → SQL Expert → SQL Validator → Result
```
- **Agents**: 6 chính + tools
- **Target**: Accuracy cao nhất
- **Use case**: High-precision requirements

## 🚀 Quick Start

### 1. Cài đặt

```bash
# Clone repository
git clone <repository-url>
cd multi-agent-sql

# Tạo virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# hoặc
venv\Scripts\activate     # Windows

# Cài đặt dependencies
pip install -r requirements.txt
```

### 2. Cấu hình

```bash
# Copy environment template
cp .env.example .env

# Chỉnh sửa .env với API keys
GOOGLE_API_KEY=your_google_api_key
GEMINI_API_KEY=your_google_api_key
```

### 3. Chuẩn bị dữ liệu

```bash
# Download Spider dataset
python scripts/download_data.py

# Setup test-suite-sql-eval
python scripts/setup_environment.py
```

### 4. Chạy benchmark

```bash
# Chạy benchmark cho tất cả mô hình
python experiments/run_benchmark.py --all

# Hoặc chạy mô hình cụ thể
python experiments/run_benchmark.py --model 3_step --questions 50
python experiments/run_benchmark.py --model 4_step --questions 50  
python experiments/run_benchmark.py --model 6_step --questions 50
```

### 5. Xem kết quả

```bash
# So sánh kết quả các mô hình
python experiments/compare_models.py

# Tạo báo cáo chi tiết
python experiments/generate_report.py
```

## 📊 Benchmark System

### Metrics đánh giá

1. **Execution Accuracy**: Tỷ lệ SQL có thể execute thành công
2. **Exact Match Rate**: Tỷ lệ SQL match chính xác với ground truth
3. **Response Time**: Thời gian trung bình xử lý/câu hỏi
4. **API Call Count**: Số lần gọi AI API
5. **Token Usage**: Input/Output tokens sử dụng
6. **Cost Estimate**: Ước tính chi phí dựa trên token usage

### 🔬 Workflow Thực nghiệm So sánh

**Mục tiêu**: Chạy 3 mô hình (3-bước, 4-bước, 6-bước) với **cùng 50 câu hỏi** từ **cùng 1 database**, đo metrics riêng biệt, sau đó so sánh kết quả.

#### **Bước 1: Chuẩn bị**
```
1. Load 50 câu hỏi từ cùng 1 database (ví dụ: university database)
2. Prepare gold.sql (ground truth) từ dataset Spider
3. Setup 3 mô hình độc lập với cùng configuration
```

#### **Bước 2: Chạy từng mô hình độc lập**

**Mô hình 3-bước (Lightweight):**
```python
FOR each question in 50_questions:
    start_time = now()
    api_calls = 0
    
    # Step 1: SQL Expert
    sql_result = sql_expert_agent(question, full_schema)
    api_calls += 1
    
    # Step 2: SQL Validator  
    final_sql = sql_validator_agent(sql_result, question, schema)
    api_calls += 1
    
    end_time = now()
    
    # Record metrics
    record_result(question_id, final_sql, api_calls, end_time - start_time)

# Generate predict_3step.sql
```

**Mô hình 4-bước (Balanced):**
```python
FOR each question in 50_questions:
    start_time = now()
    api_calls = 0
    
    # Step 1: Question Analyzer
    analysis = question_analyzer_agent(question, full_schema)
    api_calls += 1
    
    # Step 2: Schema Selector
    filtered_schema = schema_selector_agent(question, analysis, full_schema)
    api_calls += 1
    
    # Step 3: SQL Expert
    sql_result = sql_expert_agent(question, filtered_schema, analysis)
    api_calls += 1
    
    # Step 4: SQL Validator
    final_sql = sql_validator_agent(sql_result, question, filtered_schema)
    api_calls += 1
    
    end_time = now()
    
    # Record metrics
    record_result(question_id, final_sql, api_calls, end_time - start_time)

# Generate predict_4step.sql
```

**Mô hình 6-bước (Enhanced):**
```python
FOR each question in 50_questions:
    start_time = now()
    api_calls = 0
    
    # Step 1: Query Refinement
    refined_question = query_refinement_agent(question, context)
    api_calls += 1
    
    # Step 2: Entity Recognition
    entities = entity_recognition_agent(refined_question, db_metadata)
    api_calls += 1
    
    # Step 3: Question Analyzer
    analysis = question_analyzer_agent(refined_question, entities)
    api_calls += 1
    
    # Step 4: Schema Selector
    filtered_schema = schema_selector_agent(analysis, entities, full_schema)
    api_calls += 1
    
    # Step 5: SQL Expert
    sql_result = sql_expert_agent(refined_question, filtered_schema, analysis, entities)
    api_calls += 1
    
    # Step 6: SQL Validator
    final_sql = sql_validator_agent(sql_result, refined_question, filtered_schema)
    api_calls += 1
    
    end_time = now()
    
    # Record metrics
    record_result(question_id, final_sql, api_calls, end_time - start_time)

# Generate predict_6step.sql
```

#### **Bước 3: Validation với test-suite-sql-eval**

```bash
# Chạy đánh giá cho từng mô hình với cùng gold.sql
python test-suite-sql-eval/evaluation.py \
    --gold gold.sql \
    --pred predict_3step.sql \
    --db database \
    --etype all \
    --table tables.json \
    --plug_value

python test-suite-sql-eval/evaluation.py \
    --gold gold.sql \
    --pred predict_4step.sql \
    --db database \
    --etype all \
    --table tables.json \
    --plug_value

python test-suite-sql-eval/evaluation.py \
    --gold gold.sql \
    --pred predict_6step.sql \
    --db database \
    --etype all \
    --table tables.json \
    --plug_value
```

#### **Bước 4: Thu thập và So sánh Metrics**

```python
# Metrics cho mỗi mô hình
model_metrics = {
    "3_step": {
        "total_questions": 50,
        "total_api_calls": sum(api_calls_per_question),
        "avg_api_calls": total_api_calls / 50,
        "total_time": sum(execution_times),
        "avg_time_per_question": total_time / 50,
        "execution_accuracy": from_test_suite_eval,
        "exact_match_accuracy": from_test_suite_eval,
        "successful_queries": count_non_empty_sql,
        "failed_queries": count_empty_sql,
        "cost_estimate": calculate_cost(total_tokens)
    },
    "4_step": { ... },
    "6_step": { ... }
}
```

#### **Bước 5: Bảng So sánh Chi tiết**

```
📊 KẾT QUẢ SO SÁNH 3 MÔ HÌNH MULTI-AGENT SQL
================================================================
Dataset: 50 câu hỏi từ university database
Thời gian thực nghiệm: 2024-XX-XX
================================================================

| Mô hình | Execution Acc | Exact Match | Avg Time/Q | Total API | Avg API/Q | Success Rate |
|---------|---------------|-------------|------------|-----------|-----------|--------------|
| 3-bước  |    74.2%      |    65.8%    |   4.3s     |    150    |    3.0    |    94.0%     |
| 4-bước  |    86.4%      |    76.2%    |   6.7s     |    200    |    4.0    |    96.0%     |
| 6-bước  |    91.8%      |    84.6%    |   9.1s     |    300    |    6.0    |    98.0%     |

📈 CHI TIẾT HIỆU SUẤT:
================================================================

Mô hình 3-bước (Lightweight):
• Tổng thời gian: 215 giây (3.58 phút)
• API calls: 150 (3.0/câu hỏi)
• Thành công tạo SQL: 47/50 câu hỏi (94%)
• Thất bại: 3 câu hỏi (timeout/error)
• Chi phí ước tính: $0.12 (baseline)

Mô hình 4-bước (Balanced):
• Tổng thời gian: 335 giây (5.58 phút)
• API calls: 200 (4.0/câu hỏi)  
• Thành công tạo SQL: 48/50 câu hỏi (96%)
• Thất bại: 2 câu hỏi
• Chi phí ước tính: $0.16 (+33%)

Mô hình 6-bước (Enhanced):
• Tổng thời gian: 455 giây (7.58 phút)
• API calls: 300 (6.0/câu hỏi)
• Thành công tạo SQL: 49/50 câu hỏi (98%)
• Thất bại: 1 câu hỏi
• Chi phí ước tính: $0.24 (+100%)

🎯 PHÂN TÍCH TRADE-OFFS:
================================================================

Accuracy Improvement:
• 3→4 bước: +12.2% execution, +10.4% exact match
• 4→6 bước: +5.4% execution, +8.4% exact match
• 3→6 bước: +17.6% execution, +18.8% exact match

Cost vs Accuracy:
• Mô hình 4-bước: Best ROI (33% cost tăng, 12% accuracy tăng)
• Mô hình 6-bước: Diminishing returns (100% cost tăng, 5.4% accuracy tăng)

Speed vs Accuracy:
• Mô hình 3-bước: Fastest but lowest accuracy
• Mô hình 6-bước: Highest accuracy but 2.1x slower

📋 KẾT LUẬN:
================================================================
• Production systems: Chọn mô hình 4-bước (best balance)
• Cost-sensitive: Chọn mô hình 3-bước (acceptable accuracy)  
• High-precision: Chọn mô hình 6-bước (premium accuracy)
```

### Benchmark Pipeline

```python
# Workflow tự động
for model in [3_step, 4_step, 6_step]:
    for run in range(3):  # 3 lần chạy để tính trung bình
        results = []
        start_time = time.time()
        
        for question in test_questions:
            # 1. Chạy model
            sql_result = model.process(question)
            
            # 2. Track metrics
            track_metrics(sql_result, question)
            
            # 3. Save results
            results.append(sql_result)
        
        # 4. Convert to evaluation format
        gold_file, pred_file = convert_to_eval_format(results)
        
        # 5. Run test-suite-sql-eval
        eval_metrics = run_test_suite_evaluation(gold_file, pred_file)
        
        # 6. Calculate final metrics
        final_metrics = calculate_final_metrics(results, eval_metrics)
        
        # 7. Save benchmark results
        save_benchmark_results(model, run, final_metrics)
```

### Integration với test-suite-sql-eval

Dự án tích hợp với `test-suite-sql-eval` để đánh giá chính xác:

```python
def run_test_suite_evaluation(gold_file, pred_file):
    """
    Chạy đánh giá bằng test-suite-sql-eval
    Tương tự như run_complete_nl2sql_pipeline.py
    """
    cmd = [
        sys.executable, 'test-suite-sql-eval/evaluation.py',
        '--gold', gold_file,
        '--pred', pred_file, 
        '--db', 'test-suite-sql-eval/database',
        '--etype', 'all',
        '--table', 'test-suite-sql-eval/tables.json',
        '--plug_value'
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    return parse_evaluation_results(result.stdout)
```

## 🔧 API Reference

### Core Classes

```python
from src.core.pipeline import Pipeline
from src.models.model_3_step import Model3Step
from src.models.model_4_step import Model4Step  
from src.models.model_6_step import Model6Step

# Khởi tạo pipeline
pipeline = Pipeline(model=Model4Step())

# Xử lý câu hỏi
result = pipeline.process(
    question="What is the average salary of instructors?",
    schema=database_schema
)

# Kết quả
print(f"SQL: {result.sql}")
print(f"Explanation: {result.explanation}")
print(f"Execution time: {result.execution_time}")
```

### Benchmark API

```python
from src.evaluation.evaluator import Evaluator

# Chạy benchmark
evaluator = Evaluator()
results = evaluator.benchmark(
    models=[Model3Step(), Model4Step(), Model6Step()],
    questions=test_questions,
    runs=3
)

# Phân tích kết quả
evaluator.compare_results(results)
evaluator.generate_report(results, output_path="benchmark_report.md")
```

## 📈 Expected Results

| Model | Accuracy | Time/Q | API Calls | Cost Index | Best For |
|-------|----------|--------|-----------|------------|----------|
| 3-step | 75% ± 5% | 4.5s | 3 | 1.0 | Prototyping |
| 4-step | 85% ± 3% | 6.8s | 4 | 1.33 | Production |
| 6-step | 92% ± 2% | 9.2s | 6 | 2.1 | High-precision |

## 🧪 Testing

```bash
# Chạy unit tests
python -m pytest tests/ -v

# Test cụ thể
python -m pytest tests/test_models/ -v
python -m pytest tests/test_evaluation/ -v

# Coverage report
python -m pytest tests/ --cov=src --cov-report=html
```

## 📚 Documentation

- [System Architecture](docs/architecture.md) - Kiến trúc hệ thống chi tiết
- [API Reference](docs/api_reference.md) - Tài liệu API đầy đủ  
- [Benchmark Guide](docs/benchmark_guide.md) - Hướng dẫn benchmark
- [Deployment Guide](docs/deployment.md) - Hướng dẫn triển khai

## 🤝 Contributing

1. Fork repository
2. Tạo feature branch: `git checkout -b feature/new-feature`
3. Commit changes: `git commit -am 'Add new feature'`
4. Push branch: `git push origin feature/new-feature`
5. Tạo Pull Request

## 📄 License

MIT License - xem [LICENSE](LICENSE) file để biết chi tiết.

## 🔗 References

- [Spider Dataset](https://yale-lily.github.io/spider)
- [test-suite-sql-eval](https://github.com/taoyds/test-suite-sql-eval)
- [CrewAI Framework](https://docs.crewai.com/)
- [Gemini API](https://ai.google.dev/docs)

---

*Dự án này được phát triển để nghiên cứu và so sánh các kiến trúc Multi-Agent cho bài toán NL2SQL, với mục tiêu tìm ra mô hình tối ưu cho các ứng dụng thực tế.*

---

## 🚧 Development Progress

**Current Status**: Implementing core system components
- ✅ Project structure and configuration
- ✅ Requirements and environment setup  
- ✅ Pydantic models and data structures
- ✅ Base agent class with LLM integration
- ✅ Core pipeline orchestrator and agent factory
- ✅ Individual agent implementations (SQL Expert, SQL Validator)
- ✅ Prompt templates and configurations for different model types
- ✅ Model wrapper classes (3-step, 4-step, 6-step completed)
- ✅ All agent implementations (with placeholders for complex agents)
- ✅ Basic test script for system verification
- 🔄 **IN PROGRESS**: System ready for testing!
- ⏳ **NEXT**: Run test, fix issues, add data loading utilities
