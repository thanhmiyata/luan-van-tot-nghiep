# Multi-Agent LLM System for Natural Language to PostgreSQL Query Generation

## Overview
A sophisticated multi-agent system that leverages multiple Large Language Models (LLMs) working collaboratively to convert natural language queries (Vietnamese/English) into optimized PostgreSQL queries with detailed explanations.

## System Architecture
The system consists of 6 specialized agents:
- **Schema Agent**: Analyzes and understands database schemas
- **Query Planner Agent**: Plans query execution strategy
- **SQL Generator Agent**: Generates SQL from natural language
- **Validator Agent**: Validates and checks generated queries
- **Optimizer Agent**: Optimizes query performance
- **Explainer Agent**: Provides natural language explanations

## Features
- ✅ Natural language to SQL conversion (Vietnamese & English)
- ✅ Multi-agent collaboration for improved accuracy
- ✅ Complex schema reasoning (many-to-many, recursive queries)
- ✅ Query optimization and validation
- ✅ Natural language explanations of generated queries
- ✅ Support for advanced SQL constructs (JOINs, CTEs, Window functions)

## Tech Stack
- **Backend**: Python 3.9+, FastAPI
- **Database**: PostgreSQL
- **ORM**: SQLAlchemy
- **LLM APIs**: OpenAI GPT-4, Anthropic Claude
- **Frontend**: Streamlit (for demo)
- **Testing**: pytest
- **Containerization**: Docker

## Project Structure
```
multi-agent-text2sql/
├── src/
│   ├── agents/           # Individual agent implementations
│   ├── core/            # Core system components
│   ├── database/        # Database models and connections
│   ├── api/             # FastAPI endpoints
│   └── utils/           # Utility functions
├── tests/               # Test suite
├── data/               # Datasets and benchmarks
├── docs/               # Documentation
├── docker/             # Docker configurations
└── scripts/            # Setup and utility scripts
```

## Quick Start

### Prerequisites
- Python 3.9+
- PostgreSQL 13+
- Docker (optional)

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd multi-agent-text2sql

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Setup environment variables
cp .env.example .env
# Edit .env with your API keys and database credentials
```

### Environment Variables
```env
# LLM API Keys
OPENAI_API_KEY=your_openai_key
ANTHROPIC_API_KEY=your_anthropic_key

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/text2sql_db

# System Configuration
DEBUG=True
LOG_LEVEL=INFO
```

## Development Status

### Current Phase: Research & Analysis (Week 1-3)
- [ ] Literature review on Text-to-SQL systems
- [ ] Multi-agent system analysis
- [ ] Spider/BIRD dataset analysis
- [ ] Technical requirements finalization

### Upcoming Milestones
- **Month 1**: Basic multi-agent communication
- **Month 2**: Working SQL generation
- **Month 3**: Complete system with evaluation

## Evaluation
The system will be evaluated on:
- **Spider Dataset**: Cross-domain semantic parsing
- **BIRD Dataset**: Big bench for large-scale database grounded text-to-SQL evaluation
- **Custom Vietnamese Dataset**: Domain-specific Vietnamese queries
- **Metrics**: Execution Accuracy, Exact Match, Response Time

## Contributing
This is a master's thesis project. For questions or suggestions, please contact the author.

## License
This project is part of a master's thesis and is for academic purposes.

## Author
- **Student**: [Your Name]
- **Institution**: [Your University]
- **Advisor**: [Advisor Name]
- **Year**: 2024

## Acknowledgments
- Spider and BIRD benchmark datasets
- OpenAI and Anthropic for LLM APIs
- PostgreSQL community 