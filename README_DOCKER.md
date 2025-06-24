# 🐳 Docker Setup cho Luận Văn Multi-Agent Text-to-SQL

## 📋 Tổng Quan

Repository này chứa Docker setup hoàn chỉnh cho Luận Văn **"Multi-Agent LLM System for Natural Language to PostgreSQL Query Generation"**.

### 🏗️ Kiến Trúc Hệ Thống

```
┌─────────────────┬─────────────────┬─────────────────┐
│   Single Agent  │  Multi Agent    │   Databases     │
│     (8001)      │     (8002)      │                 │
├─────────────────┼─────────────────┼─────────────────┤
│                 │                 │ PostgreSQL:5432 │
│  - GPT-4        │ 6 Agents:       │ Redis:6379      │
│  - Claude       │ • Query Refine  │ Qdrant:6333     │
│  - Gemini       │ • Schema Recog  │                 │
│                 │ • Query Plan    │                 │
│                 │ • SQL Generate  │                 │
│                 │ • Validation    │                 │
│                 │ • Response Gen  │                 │
└─────────────────┴─────────────────┴─────────────────┘
```

## 🚀 Quick Start

### 1. Chuẩn Bị Môi Trường

```bash
# Clone repository
git clone <repository-url>
cd luan-van-tot-nghiep

# Tạo file .env với API keys
make env
# Chỉnh sửa .env và thêm API keys của bạn
```

### 2. Khởi Động Hệ Thống

```bash
# Setup hoàn chỉnh (lần đầu tiên)
make dev-setup

# Hoặc khởi động nhanh
make quick-start
```

### 3. Kiểm Tra Hệ Thống

```bash
# Test kết nối các services
make test-connection

# Test databases
make test-databases

# Chạy benchmark
make benchmark
```

## 📊 Databases Có Sẵn

### 1. 🇻🇳 Vietnamese Test Database
- **Database**: `vietnamese_test`
- **Tables**: `nhan_vien`, `san_pham`, `don_hang`  
- **Mục đích**: Test Vietnamese language support
- **Example queries**: Xem `scripts/sql/02_sample_queries.sql`

### 2. 🎬 DVD Rental Database
- **Database**: `dvdrental`
- **Tables**: `customer`, `film`, `actor`, `rental`, `payment`, etc.
- **Mục đích**: Complex joins và aggregations testing
- **Source**: PostgreSQL Tutorial sample database

### 3. 🕷️ Spider Benchmark
- **Database**: Multiple databases from Spider dataset
- **Mục đích**: Standard Text-to-SQL evaluation
- **Source**: Yale-LILY Spider dataset

### 4. 📚 Existing Test Data
- **Files**: `50_test_dataset.json`, `lv1-lv5_test_question.json`
- **Mục đích**: Structured test questions với difficulty levels

## 🛠️ Makefile Commands

### Development
```bash
make help              # Hiển thị tất cả commands
make build             # Build Docker images
make up                # Start tất cả services
make down              # Stop tất cả services
make restart           # Restart services
make logs              # Xem logs tất cả services
```

### Database Management
```bash
make init-db           # Khởi tạo databases với test data
make download-datasets # Download Spider và DVD Rental
make setup-spider      # Setup Spider benchmark
make setup-dvd         # Setup DVD Rental database
make setup-vietnamese  # Setup Vietnamese test database
make backup-db         # Backup database
```

### Testing & Benchmarking
```bash
make test              # Chạy tất cả tests
make test-single       # Test single agent
make test-multi        # Test multi agent
make benchmark         # Chạy benchmark trên Spider
make benchmark-vietnamese # Benchmark trên Vietnamese data
make benchmark-comparison # So sánh Single vs Multi Agent
```

### Development Tools
```bash
make shell-single      # Vào single agent container
make shell-multi       # Vào multi agent container  
make shell-db          # Vào PostgreSQL shell
make format            # Format code với black
make lint              # Lint code với flake8
```

### Monitoring & Cleanup
```bash
make monitor           # Monitor resource usage
make health            # Check service health
make clean             # Xóa containers và volumes
make clean-all         # Xóa tất cả (bao gồm images)
```

## 🔧 Service URLs

Sau khi khởi động, các services sẽ available tại:

- **Single Agent API**: http://localhost:8001
- **Multi Agent API**: http://localhost:8002  
- **Jupyter Notebook**: http://localhost:8888
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379
- **Qdrant Vector DB**: http://localhost:6333

## 📝 Environment Variables

Tạo file `.env` với nội dung sau:

```env
# API Keys - REQUIRED
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here  
GOOGLE_API_KEY=your_google_api_key_here

# Database URLs
DATABASE_URL=postgresql://postgres:postgres123@localhost:5432/text2sql_db
REDIS_URL=redis://localhost:6379
QDRANT_URL=http://localhost:6333

# Development Settings
DEBUG=True
LOG_LEVEL=INFO
```

## 🧪 Testing Framework

### 1. Unit Tests
```bash
# Test single agent experiment
make test-single

# Test multi agent experiment  
make test-multi
```

### 2. Integration Tests
```bash
# Test toàn bộ pipeline
make test

# Test database connections
make test-connection
```

### 3. Benchmark Testing
```bash
# Chạy Spider benchmark
make benchmark-spider

# Chạy Vietnamese benchmark
make benchmark-vietnamese

# So sánh performance
make benchmark-comparison
```

## 📊 Performance Metrics

Hệ thống track các metrics sau:

- **Accuracy Rate**: % correct SQL generation
- **Execution Time**: Time per query (milliseconds)
- **Token Usage**: Input/Output tokens cho cost analysis
- **Success Rate**: % queries execute successfully
- **Agent Performance**: Individual agent metrics (multi-agent only)

## 🐛 Troubleshooting

### Database Connection Issues
```bash
# Check PostgreSQL status
make logs-db

# Test connection manually
make shell-db
```

### API Key Issues
```bash
# Verify .env file
cat .env

# Check container environment
make shell-single
env | grep API
```

### Performance Issues
```bash
# Monitor resource usage
make monitor

# Check service health
make health

# View container sizes
make size
```

### Missing Dependencies
```bash
# Rebuild containers
make build

# Clean và rebuild
make clean
make build
```

## 📚 Documentation

- **Project Plan**: `THIS_IS_PLAN.md`
- **Database Schemas**: `scripts/sql/01_init_main_db.sql`
- **Sample Queries**: `scripts/sql/02_sample_queries.sql`
- **API Documentation**: 
  - Single Agent: http://localhost:8001/docs
  - Multi Agent: http://localhost:8002/docs

## 🎯 Next Steps

1. **Setup Environment**: `make dev-setup`
2. **Run Tests**: `make test`
3. **Start Experiments**: 
   - Single Agent: `make test-single`
   - Multi Agent: `make test-multi`
4. **Compare Results**: `make benchmark-comparison`

## 💡 Tips

- Sử dụng `make logs` để debug issues
- `make clean` để reset environment
- `make monitor` để theo dõi resource usage
- Jupyter notebook available tại port 8888 cho data analysis
- Database backup tự động với `make backup-db`

---

**Happy Coding! 🚀**

*Luận Văn: Multi-Agent LLM System for Text-to-SQL* 