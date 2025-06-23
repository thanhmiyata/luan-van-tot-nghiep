# KẾ HOẠCH LUẬN VĂN: Multi-Agent LLM System for Natural Language to PostgreSQL Query Generation

## THÔNG TIN DỰ ÁN
- **Tên đề tài (EN):** Multi-Agent LLM System for Natural Language to PostgreSQL Query Generation
- **Tên đề tài (VN):** Hệ thống Multi-Agent LLM Sinh Truy Vấn PostgreSQL Từ Ngôn Ngữ Tự Nhiên
- **Mục tiêu chính:** So sánh hiệu quả giữa single-agent và multi-agent approach trong việc chuyển đổi ngôn ngữ tự nhiên thành truy vấn PostgreSQL

## CẤU TRÚC 2 THỰC NGHIỆM
### 🔬 **Thực nghiệm 1: Single-Agent Approach (Baseline)**
- Sử dụng **GPT-4** để chuyển đổi trực tiếp từ ngôn ngữ tự nhiên sang SQL
- Một AI duy nhất xử lý toàn bộ pipeline
- Baseline để so sánh với multi-agent system
- **Target Accuracy**: 70-80% (theo literature review)

### 🔬 **Thực nghiệm 2: Multi-Agent Approach (Advanced)**
- **Kiến trúc inspired by paper của thầy:** "Multi-Agent Chatbot for Efficient Interaction with Blockchain APIs"
- **6 agents chuyên biệt theo pattern từ paper:**
  - **Query Refinement Agent:** Làm rõ và chuẩn hóa câu hỏi người dùng
  - **Schema Recognition Agent:** Hiểu và phân tích database schema (thay cho Entity Recognition)
  - **Query Planning Agent:** Lập kế hoạch truy vấn SQL
  - **SQL Generator Agent:** Sinh SQL từ natural language
  - **Validation Agent:** Kiểm tra syntax và semantic
  - **Response Generation Agent:** Tạo explanation và response cuối
- **Target Accuracy**: 90%+ (theo kết quả paper thầy: 91.95%)
- So sánh performance, accuracy, explainability với Thực nghiệm 1

---

## GIAI ĐOẠN 1: NGHIÊN CỨU & PHÂN TÍCH (Tuần 1-3)

### 1.1 Literature Review & State-of-the-art
- [ ] Nghiên cứu các paper về Text-to-SQL (Spider, BIRD benchmarks)
- [ ] Phân tích các hệ thống Multi-Agent hiện tại
- [ ] Tìm hiểu các phương pháp Schema Reasoning
- [ ] Nghiên cứu các LLM APIs (GPT-4, Claude, Gemini, etc.)
- [ ] Phân tích ưu/nhược điểm của từng approach

### 1.2 Dataset & Benchmark Analysis
- [ ] Download và phân tích Spider dataset
- [ ] Download và phân tích BIRD dataset
- [ ] Nghiên cứu Vietnamese Text-to-SQL datasets (nếu có)
- [ ] Xác định metrics đánh giá (Execution Accuracy, Exact Match, etc.)

### 1.3 Technical Requirements  
- [ ] **LLM Providers**: GPT-4, Claude, Gemini, DeepSeek cho multi-model testing
- [ ] **Specialized Models** (inspired by paper thầy):
  - LLM-Embedder (109M params) cho vector embeddings
  - GLiNER (400M params) cho entity/schema recognition  
  - BGE Rerank cho cross-encoder filtering
- [ ] **Database Schemas**:
  - Spider dataset (benchmark evaluation)
  - DVD Rental schema (practical evaluation)
- [ ] **Tech Stack**: Python, FastAPI, PostgreSQL, Vector DB (Qdrant), Elastic Search
- [ ] Setup development environment

---

## GIAI ĐOẠN 2: THIẾT KẾ HỆ THỐNG (Tuần 4-5)

### 2.1 System Architecture Design (Based on Multi-Agent Paper)
- [ ] **Pipeline Architecture** theo pattern từ paper thầy:
  ```
  User Query → Query Refinement → Schema Recognition → Query Planning 
  → SQL Generation → Validation → Response Generation
  ```
- [ ] **Agent Definitions** inspired by blockchain chatbot paper:
  - **Query Refinement Agent**: Chuẩn hóa và làm rõ user input
  - **Schema Recognition Agent**: Hiểu database schema + entity recognition  
  - **Query Planning Agent**: Lập chiến lược truy vấn (ReAct approach)
  - **SQL Generator Agent**: Sinh SQL với tool-calling pattern
  - **Validation Agent**: Kiểm tra syntax/semantic + hallucination detection
  - **Response Generation Agent**: Tạo explanation với Chain-of-Thought

### 2.2 Agent Communication Protocol
- [ ] Thiết kế message format giữa các agents
- [ ] Định nghĩa workflow và coordination logic
- [ ] Thiết kế error handling và fallback mechanisms

### 2.3 Database Schema Design
- [ ] Thiết kế schema cho metadata storage
- [ ] Thiết kế schema cho conversation history
- [ ] Thiết kế test databases với độ phức tạp khác nhau

---

## GIAI ĐOẠN 3: IMPLEMENTATION (Tuần 6-12)

### 3.1 Core Infrastructure
- [x] Setup project structure và dependencies
- [x] Implement base Agent class
- [x] Implement Agent communication system
- [x] Setup PostgreSQL connection và ORM
- [x] Implement logging và monitoring

### 3.2 THỰC NGHIỆM 1: Single-Agent Implementation (Tháng 3)
- [ ] **GPT-4 Single Agent (Baseline):**
  - Setup OpenAI API integration với multiple models (GPT-4, Claude, Gemini)
  - Design comprehensive prompt templates với schema injection
  - Few-shot learning examples từ Spider dataset
  - Error handling và fallback logic
  
- [ ] **Single-Agent Pipeline:**
  - Natural language input processing (VN/EN)
  - Schema-aware prompt construction
  - API calls với optimized parameters
  - SQL output parsing và validation
  - Result explanation generation
  
- [ ] **Testing & Evaluation trên 2 schemas:**
  - **Spider benchmark**: Phân loại độ phức tạp SQL
  - **DVD Rental**: Practical real-world scenarios
  - Vietnamese language support test
  - Multi-LLM comparison (GPT vs Claude vs Gemini)
  - **Target**: 70-80% accuracy

### 3.3 THỰC NGHIỆM 2: Multi-Agent Implementation (Tháng 3-4)
- [ ] **Query Refinement Agent** (Module 1):
  - Vector database cho conversation history (Qdrant)
  - LLM-Embedder cho context retrieval
  - Query rewriting với conversation context
  
- [x] **Schema Recognition Agent** (Modules 2-3):
  - GLiNER model cho entity recognition
  - Elastic Search cho schema entity matching
  - Parse và analyze database schema (đã có base)
  
- [ ] **Query Planning Agent** (Module 6):
  - ReAct approach (Reason + Act + Observe)
  - JSON-based tool planning
  - Multi-step query decomposition
  
- [ ] **SQL Generator Agent** (Module 8):
  - Tool execution cho SQL generation
  - Template-based với dynamic parameters
  - Support cho complex SQL constructs
  
- [ ] **Validation Agent** (Module 7):
  - Hallucination detection
  - Syntax và semantic validation  
  - Plan verification logic
  
- [ ] **Response Generation Agent** (Module 10):
  - Chain-of-Thought explanations
  - Natural language SQL descriptions
  - Multi-language support (VN/EN)

### 3.4 Integration & Testing
- [ ] Unit tests cho single agent
- [ ] Unit tests cho từng multi-agent
- [ ] Integration tests cho agent communication
- [ ] End-to-end testing cho cả 2 approaches
- [ ] Performance comparison testing

---

## GIAI ĐOẠN 4: ADVANCED FEATURES (Tuần 10-12)

### 4.1 Enhanced Schema Reasoning
- [ ] Implement complex relationship detection
- [ ] Handle many-to-many relationships
- [ ] Support cho recursive queries
- [ ] Schema evolution handling

### 4.2 Vietnamese Language Support
- [ ] Vietnamese text preprocessing
- [ ] Vietnamese-specific NLP enhancements
- [ ] Bilingual query support (VN/EN)

### 4.3 Advanced SQL Features
- [ ] Support cho advanced SQL constructs:
  - Window functions
  - CTEs (Common Table Expressions)
  - Subqueries
  - Aggregations với HAVING
  - CASE statements

### 4.4 Performance Optimization
- [ ] Implement caching mechanisms
- [ ] Optimize agent communication
- [ ] Database query optimization
- [ ] Response time improvements

---

## GIAI ĐOẠN 5: SO SÁNH & ĐÁNH GIA (Tuần 13-14)

### 5.1 Benchmark Testing
- [ ] Test cả 2 approaches trên Spider dataset
- [ ] Test cả 2 approaches trên BIRD dataset
- [ ] Create custom Vietnamese test cases
- [ ] Performance benchmarking comparison

### 5.2 Metrics Collection & Comparison (Inspired by Paper Results)
- [ ] **Single-Agent Metrics:**
  - **Accuracy Rate**: % correct answers (target: 70-80%)
  - **Response Time**: Average time per query
  - **Input/Output Tokens**: Cost analysis
  - **Exact Match**: SQL syntax correctness
  - **Execution Accuracy**: Result set correctness
  
- [ ] **Multi-Agent Metrics (Target: 91.95% như paper thầy):**
  - **Accuracy Rate**: % correct answers (target: 90%+)
  - **Response Time**: Per agent + total pipeline time  
  - **Input/Output Tokens**: Cost per agent + total
  - **Agent Communication Overhead**: Inter-agent latency
  - **Module Performance**: Individual agent success rates

### 5.3 Comparative Analysis
- [ ] **Accuracy Comparison:**
  - Overall success rate
  - Complex query handling
  - Error types analysis
  
- [ ] **Performance Comparison:**
  - Speed comparison
  - Cost analysis
  - Scalability assessment
  
- [ ] **Explainability Comparison:**
  - Quality of explanations
  - Step-by-step reasoning
  - User understanding improvement
  
- [ ] **Ablation Studies (Following Paper Methodology):**
  - Full architecture vs Raw models (no fine-tuning)
  - Removing Query Refinement Module
  - Removing Schema Recognition Module  
  - Removing Agent Filtering/Planning
  - LLM-only baseline comparison
  - **Expected results**: Demonstrate each module's contribution to accuracy

---

## GIAI ĐOẠN 6: USER INTERFACE & DEMO (Tuần 15-16)

### 6.1 Web Interface Development
- [ ] Design user-friendly web interface
- [ ] Implement chat-like interaction
- [ ] Add query visualization
- [ ] Show explanation và reasoning steps

### 6.2 Demo Preparation
- [ ] Prepare demo scenarios
- [ ] Create presentation materials
- [ ] Record demo videos
- [ ] Prepare example queries

---

## GIAI ĐOẠN 7: DOCUMENTATION & THESIS WRITING (Tuần 17-20)

### 7.1 Technical Documentation
- [ ] API documentation
- [ ] System architecture documentation
- [ ] Deployment guide
- [ ] User manual

### 7.2 Thesis Writing
- [ ] **Chapter 1:** Introduction và Problem Statement
- [ ] **Chapter 2:** Literature Review
- [ ] **Chapter 3:** System Design và Architecture
- [ ] **Chapter 4:** Implementation Details
- [ ] **Chapter 5:** Evaluation và Results
- [ ] **Chapter 6:** Conclusion và Future Work

### 7.3 Final Review
- [ ] Code review và refactoring
- [ ] Thesis proofreading
- [ ] Advisor feedback incorporation
- [ ] Final testing và bug fixes

---

## DELIVERABLES CHECKLIST

### Code & System
- [ ] **Thực nghiệm 1:** Complete Single-Agent (GPT-4) implementation
- [ ] **Thực nghiệm 2:** Complete Multi-Agent System implementation
- [ ] Web interface demo cho cả 2 approaches
- [ ] Test suite với coverage > 80%
- [ ] Deployment scripts và documentation

### Research & Documentation
- [ ] Thesis document (80-100 pages)
- [ ] Technical paper draft
- [ ] Presentation slides
- [ ] Demo video showcasing comparison

### Evaluation Results
- [ ] Benchmark results trên Spider/BIRD cho cả 2 approaches
- [ ] Performance analysis report (Single vs Multi-Agent)
- [ ] Comparative study results với statistical significance
- [ ] Error analysis và insights
- [ ] Cost-benefit analysis
- [ ] Recommendations cho practical usage

---

## TECH STACK & TOOLS

### Backend (Enhanced with Multi-Agent Components)
- **Language:** Python 3.9+
- **Framework:** FastAPI
- **Database:** PostgreSQL
- **ORM:** SQLAlchemy
- **LLM APIs:** OpenAI GPT-4, Anthropic Claude, Google Gemini, DeepSeek
- **Specialized Models:**
  - LLM-Embedder (109M params) - text embeddings
  - GLiNER (400M params) - entity recognition
  - BGE Rerank - cross-encoder reranking
- **Vector Database:** Qdrant cho conversation history
- **Search Engine:** Elastic Search cho entity matching

### Frontend
- **Framework:** Streamlit (for demo và prototyping)
- **UI Library:** Streamlit components
- **Advanced UI:** React.js với Material-UI (optional)

### DevOps & Testing
- **Testing:** pytest, unittest
- **CI/CD:** GitHub Actions
- **Containerization:** Docker
- **Monitoring:** Prometheus + Grafana

### Research Tools
- **Data Analysis:** pandas, numpy
- **Visualization:** matplotlib, plotly
- **Benchmarking:** Spider evaluation scripts

---

## RISK MANAGEMENT

### Technical Risks
- **LLM API limitations:** Backup với multiple providers
- **Performance issues:** Early optimization và caching
- **Complex query handling:** Incremental complexity approach

### Timeline Risks
- **Scope creep:** Stick to MVP first, then enhance
- **Technical blockers:** Weekly progress reviews
- **Integration issues:** Early integration testing

---

## NEXT STEPS & MILESTONES

### Immediate Next Steps (Following Timeline in Kế hoạch đề tài)
1. **Tháng hiện tại:** 
   - ✅ Update project plan với 2-experiment approach và multi-agent architecture
   - 🎯 Bắt đầu Thực nghiệm 1: Multi-LLM Single Agent approach
   - Setup API integrations (GPT-4, Claude, Gemini)
   - Download và setup Spider + DVD Rental datasets

2. **Tháng 3:** 
   - **Xây dựng baseline**: Triển khai Single-Agent với GPT-4/Claude/Gemini
   - **Xây dựng Multi-Agent**: Implement 6-agent system theo paper thầy
   - Test trên cả Spider benchmark và DVD Rental schema

### Key Milestones (Aligned with Original Timeline)
- **Milestone 1:** Tháng 3 - Cả 2 thực nghiệm hoàn thành
  - Single-agent baseline: 70-80% accuracy target
  - Multi-agent system: 90%+ accuracy target
  
- **Milestone 2:** Tháng 4 - Evaluation và comparison
  - Chạy test trên Spider và DVD Rental
  - Statistical analysis và ablation studies
  - Performance comparison reports
  
- **Milestone 3:** Tháng 5 - Academic outputs
  - Viết bài báo khoa học cho hội nghị (KSE, VLSP)
  - Tổng hợp kết quả cho luận văn

---

## REFERENCES & INSPIRATION

### Key Paper Reference
- **"Multi-Agent Chatbot for Efficient Interaction with Blockchain APIs"** - Nguyen et al.
  - Achieved 91.95% accuracy với multi-agent architecture
  - 6-module pipeline: Query Refinement → Entity Recognition → Tool Filtering → Multi-Agent Planning → Response Generation
  - Technical stack: LLM-Embedder, GLiNER, BGE Rerank, Qdrant Vector DB

### Architecture Adaptation for Text-to-SQL
```
Blockchain APIs → Database Schema Understanding
Entity Recognition → Schema Entity Recognition  
Tool Selection → SQL Generation Planning
API Calling → SQL Query Execution
```

## NOTES & UPDATES
- [x] ✅ **Updated plan** dựa trên paper thầy và kế hoạch đề tài gốc
- [x] ✅ **Aligned timeline** với kế hoạch 6 tháng
- [x] ✅ **Incorporated multi-agent architecture** từ blockchain chatbot paper
- [x] ✅ **Added technical stack** recommendations từ paper
- [ ] Track actual vs planned timeline
- [ ] Document implementation lessons learned
- [ ] Note technical decisions và rationale

---

*Last Updated: [Updated with Multi-Agent Architecture & Paper References]*
*Next Review: Monthly progress check* 