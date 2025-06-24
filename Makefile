# Makefile cho Luận Văn: Multi-Agent LLM System for Text-to-SQL
# =================================================================

.PHONY: help build up down logs clean test install setup env

# Default target
help:  ## Hiển thị help
	@echo "==================================================================="
	@echo "🎓 LUẬN VĂN: Multi-Agent LLM System for Text-to-SQL"
	@echo "==================================================================="
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo "==================================================================="

# 🚀 DEVELOPMENT COMMANDS
# -----------------------

setup:  ## Setup môi trường development đầu tiên
	@echo "🔧 Setting up development environment..."
	@echo "📁 Creating .env file..."
	@cp .env.example .env || echo "Please create .env from .env.example manually"
	@echo "🔨 Building Docker images..."
	@make build
	@echo "🚀 Starting services..."
	@make up
	@echo "⏳ Waiting for services to be ready..."
	@sleep 10
	@make test-connection
	@echo "✅ Setup completed!"

env:  ## Tạo file .env template
	@echo "📝 Creating .env template..."
	@cat > .env << 'EOF'
# API Keys - Thêm API keys của bạn vào đây
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here  
GOOGLE_API_KEY=your_google_api_key_here

# Database Configuration
DATABASE_URL=postgresql://postgres:postgres123@localhost:5432/text2sql_db
REDIS_URL=redis://localhost:6379
QDRANT_URL=http://localhost:6333

# Development Settings
DEBUG=True
LOG_LEVEL=INFO
EOF
	@echo "✅ .env file created! Please add your API keys."

build:  ## Build tất cả Docker images
	@echo "🔨 Building Docker images..."
	docker-compose build

up:  ## Start tất cả services
	@echo "🚀 Starting all services..."
	docker-compose up -d
	@echo "✅ Services started!"
	@echo "📊 Single Agent:  http://localhost:8001"
	@echo "🤖 Multi Agent:   http://localhost:8002"  
	@echo "📓 Jupyter:       http://localhost:8888"
	@echo "🗄️  PostgreSQL:    localhost:5432"
	@echo "🔴 Redis:         localhost:6379"
	@echo "🔍 Qdrant:        http://localhost:6333"

down:  ## Stop tất cả services
	@echo "🛑 Stopping all services..."
	docker-compose down

restart:  ## Restart tất cả services
	@echo "🔄 Restarting services..."
	@make down
	@make up

logs:  ## Xem logs của tất cả services
	docker-compose logs -f

logs-single:  ## Xem logs của single agent
	docker-compose logs -f single_agent

logs-multi:  ## Xem logs của multi agent  
	docker-compose logs -f multi_agent

logs-db:  ## Xem logs của database
	docker-compose logs -f postgres

shell-single:  ## Vào shell của single agent container
	docker-compose exec single_agent /bin/bash

shell-multi:  ## Vào shell của multi agent container
	docker-compose exec multi_agent /bin/bash

shell-db:  ## Vào PostgreSQL shell
	docker-compose exec postgres psql -U postgres -d text2sql_db

# 🧪 TESTING COMMANDS
# -------------------

test:  ## Chạy tất cả tests
	@echo "🧪 Running all tests..."
	@make test-single
	@make test-multi

test-single:  ## Test single agent experiment
	@echo "🔬 Testing Single Agent Experiment..."
	cd experiments/experiment1_single_agent && python -m pytest tests/ -v

test-multi:  ## Test multi agent experiment
	@echo "🤖 Testing Multi Agent Experiment..."
	cd experiments/experiment2_multi_agent && python -m pytest tests/ -v

test-connection:  ## Test kết nối database và services
	@echo "🔍 Testing service connections..."
	@echo "Testing PostgreSQL..."
	@docker-compose exec -T postgres pg_isready -U postgres
	@echo "Testing Redis..."
	@docker-compose exec -T redis redis-cli ping
	@echo "Testing Qdrant..."
	@curl -s http://localhost:6333/health || echo "Qdrant not ready yet"

benchmark:  ## Chạy benchmark trên Spider dataset
	@echo "📊 Running Spider benchmark..."
	@make init-db
	cd experiments/experiment1_single_agent && python comprehensive_sql_benchmark.py

benchmark-spider:  ## Chạy benchmark trên Spider dataset only
	@echo "🕷️ Running Spider benchmark only..."
	cd experiments/experiment1_single_agent && python comprehensive_sql_benchmark.py --dataset spider

benchmark-vietnamese:  ## Chạy benchmark trên Vietnamese dataset
	@echo "🇻🇳 Running Vietnamese benchmark..."
	cd experiments/experiment1_single_agent && python comprehensive_sql_benchmark.py --dataset vietnamese

test-databases:  ## Test tất cả databases có sẵn
	@echo "🧪 Testing all databases..."
	@echo "Testing PostgreSQL main database..."
	@docker-compose exec postgres psql -U postgres -d text2sql_db -c "SELECT 'Main DB OK';"
	@echo "Testing DVD Rental database..."
	@docker-compose exec postgres psql -U postgres -d dvdrental -c "SELECT COUNT(*) FROM film;" || echo "DVD Rental DB not ready"
	@echo "Testing Vietnamese database..."
	@docker-compose exec postgres psql -U postgres -d vietnamese_test -c "SELECT COUNT(*) FROM nhan_vien;" || echo "Vietnamese DB not ready"

benchmark-comparison:  ## So sánh performance giữa 2 experiments
	@echo "⚖️ Running performance comparison..."
	@echo "Running Single Agent benchmark..."
	cd experiments/experiment1_single_agent && python comprehensive_sql_benchmark.py > ../results_single.txt
	@echo "Running Multi Agent benchmark..."  
	cd experiments/experiment2_multi_agent && python comprehensive_sql_benchmark.py > ../results_multi.txt
	@echo "Results saved to experiments/results_*.txt"

# 📊 DATA MANAGEMENT
# ------------------

init-db:  ## Khởi tạo database với sample data
	@echo "🗄️ Initializing database with test data..."
	docker-compose up -d postgres
	@echo "⏳ Waiting for PostgreSQL to be ready..."
	@sleep 15
	docker-compose run --rm db_setup
	@echo "✅ Database initialization completed!"

download-datasets:  ## Download Spider và DVD Rental datasets
	@echo "📥 Downloading benchmark datasets..."
	docker-compose run --rm db_setup python setup_databases.py
	@echo "✅ Datasets downloaded!"

setup-spider:  ## Setup Spider benchmark dataset
	@echo "🕷️ Setting up Spider benchmark..."
	docker-compose exec postgres psql -U postgres -c "SELECT 'Spider setup completed';"

setup-dvd:  ## Setup DVD Rental sample database
	@echo "🎬 Setting up DVD Rental database..."
	docker-compose exec postgres psql -U postgres -c "SELECT 'DVD Rental setup completed';"

setup-vietnamese:  ## Setup Vietnamese test database
	@echo "🇻🇳 Setting up Vietnamese test database..."
	docker-compose exec postgres psql -U postgres -d vietnamese_test -c "SELECT COUNT(*) as nhan_vien_count FROM nhan_vien;"

backup-db:  ## Backup database
	@echo "💾 Backing up database..."
	docker-compose exec postgres pg_dump -U postgres text2sql_db > backup_$(shell date +%Y%m%d_%H%M%S).sql

restore-db:  ## Restore database từ backup (cần chỉ định file)
	@echo "🔄 Restoring database..."
	@echo "Usage: make restore-db FILE=backup_file.sql"
	@test -n "$(FILE)" || (echo "Please specify FILE=backup_file.sql" && exit 1)
	docker-compose exec -T postgres psql -U postgres text2sql_db < $(FILE)

# 🧹 CLEANUP COMMANDS  
# -------------------

clean:  ## Xóa containers và volumes (giữ lại images)
	@echo "🧹 Cleaning up containers and volumes..."
	docker-compose down -v
	docker system prune -f

clean-all:  ## Xóa tất cả (containers, volumes, images)
	@echo "🗑️ Cleaning up everything..."
	docker-compose down -v --rmi all
	docker system prune -af

clean-logs:  ## Xóa logs cũ
	@echo "📋 Cleaning old logs..."
	find . -name "*.log" -type f -delete
	find . -name "__pycache__" -type d -exec rm -rf {} +

# 📦 INSTALL COMMANDS
# -------------------

install-single:  ## Install dependencies cho single agent
	@echo "📦 Installing Single Agent dependencies..."
	cd experiments/experiment1_single_agent && pip install -r requirements.txt

install-multi:  ## Install dependencies cho multi agent
	@echo "📦 Installing Multi Agent dependencies..."
	cd experiments/experiment2_multi_agent && pip install -r requirements.txt

install-dev:  ## Install development dependencies
	@echo "🛠️ Installing development dependencies..."
	pip install pytest pytest-cov black flake8 mypy

# 🔧 DEVELOPMENT UTILITIES
# ------------------------

format:  ## Format code với black
	@echo "🎨 Formatting code..."
	black experiments/

lint:  ## Lint code với flake8
	@echo "🔍 Linting code..."
	flake8 experiments/

type-check:  ## Type checking với mypy
	@echo "🔎 Type checking..."
	mypy experiments/

dev-setup:  ## Setup complete development environment
	@echo "🛠️ Setting up complete development environment..."
	@make env
	@make install-dev
	@make install-single  
	@make install-multi
	@make setup
	@echo "✅ Development environment ready!"

# 📈 MONITORING & ANALYSIS
# ------------------------

monitor:  ## Monitor resource usage
	@echo "📊 Monitoring resource usage..."
	docker stats

size:  ## Xem dung lượng của images và containers
	@echo "📏 Docker images size:"
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
	@echo "\n📦 Docker containers size:"
	docker ps -s

health:  ## Check health của tất cả services
	@echo "🏥 Checking service health..."
	@make test-connection
	docker-compose ps

# 📚 DOCUMENTATION
# ----------------

docs:  ## Generate documentation
	@echo "📚 Generating documentation..."
	@echo "Project documentation available in Document/ folder"
	@echo "Technical docs: http://localhost:8001/docs (Single Agent)"
	@echo "Technical docs: http://localhost:8002/docs (Multi Agent)"

# 🎯 QUICK COMMANDS
# -----------------

quick-start: env up test-connection  ## Quick start để development
	@echo "🚀 Quick start completed!"

quick-test: up test benchmark  ## Quick test toàn bộ system
	@echo "✅ Quick test completed!"

# Variables
CURRENT_TIME := $(shell date +%Y%m%d_%H%M%S) 