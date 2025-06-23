# Thực nghiệm 2: Multi-Agent Text-to-SQL System

## Mô tả
Thực nghiệm này triển khai hệ thống Multi-Agent theo kiến trúc 6-module dựa trên paper của thầy hướng dẫn, nhằm đạt được độ chính xác 90%+ trong việc chuyển đổi ngôn ngữ tự nhiên thành SQL.

## Kiến trúc Multi-Agent (6 Modules)

### 1. Query Refinement Agent
- **Chức năng**: Làm sạch và chuẩn hóa input query
- **Input**: Raw natural language query (English/Vietnamese)  
- **Output**: Refined, standardized query
- **Model**: GPT-4/Claude cho text refinement

### 2. Schema Recognition Agent  
- **Chức năng**: Nhận diện entities và map với database schema
- **Input**: Refined query + Database schema
- **Output**: Identified tables, columns, relationships
- **Model**: GLiNER cho Named Entity Recognition

### 3. Query Planning Agent
- **Chức năng**: Lập kế hoạch thực thi SQL query
- **Input**: Entities + Schema mapping  
- **Output**: Query execution plan
- **Model**: LLM-Embedder cho semantic understanding

### 4. SQL Generator Agent
- **Chức năng**: Generate SQL code từ execution plan
- **Input**: Query plan + Schema context
- **Output**: PostgreSQL query
- **Model**: GPT-4/Claude specialized for SQL

### 5. Validation Agent
- **Chức năng**: Kiểm tra syntax và semantic của SQL
- **Input**: Generated SQL + Schema
- **Output**: Validated SQL hoặc error feedback
- **Model**: Rule-based + LLM validation

### 6. Response Generation Agent
- **Chức năng**: Format kết quả và generate explanation
- **Input**: SQL results + Original query
- **Output**: User-friendly response
- **Model**: BGE Rerank + response generation

## Tech Stack
- **Vector Database**: Qdrant cho semantic search
- **Embeddings**: LLM-Embedder cho query understanding  
- **NER**: GLiNER cho entity recognition
- **Reranking**: BGE Rerank cho result optimization
- **Coordination**: AsyncIO cho agent communication

## Setup
```bash
# 1. Activate virtual environment
venv\Scripts\activate

# 2. Install dependencies  
pip install -r requirements.txt

# 3. Setup Qdrant vector database
# 4. Configure multi-agent coordination
# 5. Run multi-agent test suite
```

## Kết quả mong đợi
- **Target Accuracy**: 90%+ (theo paper: 91.95%)
- **Response Time**: < 10 giây/query (do multi-agent overhead)
- **Agent Coordination**: Success rate > 95%

## So sánh với Single-Agent
| Metric | Single-Agent | Multi-Agent |
|--------|-------------|-------------|
| Accuracy | 70-80% | 90%+ |
| Response Time | < 5s | < 10s |
| Complexity | Thấp | Cao |
| Maintainability | Đơn giản | Phức tạp |

*Chưa triển khai - Sẽ implement sau khi hoàn thành Thực nghiệm 1* 