# Thực nghiệm 2: Multi-Agent Text-to-SQL System ✅

## 🎯 Mô tả
Thực nghiệm này triển khai hệ thống Multi-Agent theo kiến trúc 6-module dựa trên paper của thầy hướng dẫn, nhằm đạt được độ chính xác **90%+** trong việc chuyển đổi ngôn ngữ tự nhiên thành SQL.

## 🏗️ Kiến trúc Multi-Agent (6 Agents)

### 1. 🔧 Query Refinement Agent
- **Chức năng**: Làm sạch và chuẩn hóa input query
- **Input**: Raw natural language query (English/Vietnamese)  
- **Output**: Refined, standardized query
- **Model**: GPT-4-turbo cho text refinement
- **File**: `src/agents/query_refinement_agent.py`

### 2. 🧠 Schema Recognition Agent  
- **Chức năng**: Nhận diện entities và map với database schema
- **Input**: Refined query + Database schema
- **Output**: Identified tables, columns, relationships
- **Model**: GLiNER + Claude-3.5-Sonnet cho NER
- **File**: `src/agents/schema_recognition_agent.py`

### 3. 📋 Query Planning Agent
- **Chức năng**: Lập kế hoạch thực thi SQL query (ReAct approach)
- **Input**: Entities + Schema mapping  
- **Output**: Query execution plan
- **Model**: GPT-4-turbo cho reasoning
- **File**: `src/agents/query_planning_agent.py`

### 4. ⚙️ SQL Generator Agent
- **Chức năng**: Generate SQL code từ execution plan
- **Input**: Query plan + Schema context
- **Output**: PostgreSQL query
- **Model**: GPT-4-turbo specialized cho SQL
- **File**: `src/agents/sql_generator_agent.py`

### 5. ✅ Validation Agent
- **Chức năng**: Kiểm tra syntax và semantic của SQL
- **Input**: Generated SQL + Schema
- **Output**: Validated SQL hoặc error feedback
- **Model**: Rule-based + Claude-3.5-Sonnet validation
- **File**: `src/agents/validation_agent.py`

### 6. 📝 Response Generation Agent
- **Chức năng**: Format kết quả và generate explanation
- **Input**: SQL results + Original query
- **Output**: User-friendly response
- **Model**: GPT-4-turbo cho response generation
- **File**: `src/agents/response_generation_agent.py`

## 🛠️ Tech Stack
- **Vector Database**: Qdrant cho semantic search
- **Embeddings**: LLM-Embedder cho query understanding  
- **NER**: GLiNER cho entity recognition
- **Reranking**: BGE Rerank cho result optimization
- **Coordination**: AsyncIO cho agent communication
- **Database**: PostgreSQL (DVD Rental schema)

## 🚀 Quick Start

### Option 1: Auto Setup
```bash
# Clone và setup tự động
python setup.py

# Chỉnh sửa API keys
# Sửa file .env với API keys của bạn

# Chạy demo
python run_experiment.py
```

### Option 2: Manual Setup
```bash
# 1. Tạo virtual environment
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Linux/Mac

# 2. Install dependencies  
pip install -r requirements.txt

# 3. Copy environment file
copy .env.example .env  # Windows
# cp .env.example .env  # Linux/Mac

# 4. Chỉnh sửa .env với API keys của bạn

# 5. Chạy demo
python run_experiment.py
```

## 🧪 Chạy thử nghiệm

### Demo nhanh
```bash
python run_experiment.py --mode demo
```

### Interactive mode
```bash
python run_experiment.py --mode interactive
```

### Full test suite
```bash
python run_experiment.py --mode test
# hoặc
python test_multi_agent_system.py
```

## 📊 Kết quả mong đợi
- **Target Accuracy**: 90%+ (theo paper: 91.95%)
- **Response Time**: < 10 giây/query (do multi-agent overhead)
- **Agent Coordination**: Success rate > 95%
- **Language Support**: Vietnamese + English

## 🔄 Pipeline Flow
```
User Query → Query Refinement → Schema Recognition → Query Planning 
     ↓              ↓                    ↓                ↓
Response ← Response Generation ← Validation ← SQL Generation
```

## 📈 So sánh với Single-Agent
| Metric | Single-Agent | Multi-Agent | Improvement |
|--------|-------------|-------------|-------------|
| Accuracy | 20.8% (GPT-4) | **90%+** (Target) | **+70%** |
| Response Time | 3-43s | < 10s | Optimized |
| Complexity | Thấp | Cao | Scalable |
| Explainability | Thấp | **Cao** | Multi-step |
| Error Handling | Kém | **Tốt** | Validation |

## 🏗️ Cấu trúc dự án
```
experiment2_multi_agent/
├── src/
│   ├── agents/               # 6 specialized agents
│   │   ├── base_agent.py    # Base class cho tất cả agents
│   │   ├── query_refinement_agent.py
│   │   ├── schema_recognition_agent.py
│   │   ├── query_planning_agent.py
│   │   ├── sql_generator_agent.py
│   │   ├── validation_agent.py
│   │   └── response_generation_agent.py
│   ├── config.py            # Configuration cho 6 agents
│   └── multi_agent_coordinator.py  # Main coordinator
├── test_multi_agent_system.py      # Comprehensive test suite
├── run_experiment.py               # Quick start script
├── setup.py                        # Auto setup script
├── requirements.txt                # Dependencies
├── .env.example                    # Environment template
└── README.md                       # Documentation này
```

## 🎯 Performance Targets
- **Overall Accuracy**: ≥ 90%
- **Response Time**: < 10 seconds
- **Agent Coordination Success**: ≥ 95%
- **Vietnamese Accuracy**: ≥ 85%
- **English Accuracy**: ≥ 95%

## 🔧 Configuration
Edit `.env` file:
```env
# LLM API Keys (Required)
OPENAI_API_KEY=your_openai_key
ANTHROPIC_API_KEY=your_anthropic_key
GOOGLE_API_KEY=your_google_key

# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/dvdrental

# Optional: Vector DB
QDRANT_URL=localhost
QDRANT_PORT=6333
```

## 📝 Test Queries Examples
```python
# Vietnamese
"Có bao nhiêu bộ phim trong cơ sở dữ liệu?"
"Liệt kê tên tất cả các thể loại phim"
"Khách hàng nào đã thuê nhiều phim nhất?"

# English  
"How many customers are in the system?"
"Show the first 5 films"
"Which customer has rented the most films?"
```

## 🎉 Status: **READY TO RUN** ✅
- ✅ 6 Agents implemented
- ✅ Multi-Agent Coordinator ready
- ✅ Test suite available
- ✅ Quick start scripts ready
- ⏳ Waiting for API keys setup 