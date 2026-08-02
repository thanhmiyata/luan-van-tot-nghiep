# Multi-Agent NL2SQL Research Project - AI Agent Instructions

## Project Overview
This is a Vietnamese thesis project comparing single-agent vs multi-agent approaches for Natural Language to SQL conversion using the Spider dataset. The system converts Vietnamese/English questions into PostgreSQL queries with 90%+ target accuracy.

## Architecture & Key Components

### Core Pipeline (run_complete_nl2sql_pipeline.py)
- **Main entry point**: Orchestrates the entire NL2SQL experiment workflow
- **Key workflow**: Database setup → Question selection → NL2SQL generation → Evaluation
- **Database handling**: Auto-copies Spider databases from `Data Set/spider_data/database/` to `experiments/test-suite-sql-eval/database/`
- **Question sampling**: Selects databases with >50 questions, randomly samples test cases

### Multi-Agent System (experiments/experiment3_multi_agent_crewai/)
- **Framework**: CrewAI with 6 specialized agents (question_analyzer, schema_selector, sql_expert, etc.)
- **Agent config**: `src/nl2sql_flow/crews/nl2sql_crew/config/agents.yaml` - contains LLM assignments and specialized roles
- **Task config**: `config/tasks.yaml` - defines the sequential workflow and data formats
- **Main flow**: `src/nl2sql_flow/main.py` - Pydantic models and CrewAI Flow orchestration

### Evaluation System (experiments/test-suite-sql-eval/)
- **Official Spider evaluator**: Uses test-suite semantic evaluation (not just exact match)
- **Format conversion**: `convert-output-format.py` converts CSV results to `gold.sql` and `predict.sql`
- **Evaluation types**: `--etype exec` (semantic), `--etype match` (exact), `--etype all`

## Development Patterns

### File Organization
- **Experiment isolation**: Each experiment in separate subdirectory with own dependencies
- **Shared datasets**: `Data Set/` contains Spider data, Vietnamese questions, and test levels
- **Configuration-driven**: YAML configs for agents/tasks, JSON for datasets
- **Output tracking**: Timestamped CSV files in `output/` directories

### Vietnamese Support
- **Language mixing**: Comments and logs in Vietnamese, code/configs in English
- **Dataset files**: `*_vi.json` variants for Vietnamese translations
- **Encoding**: UTF-8 throughout, explicit encoding in file operations

### Dependency Management
- **Root level**: `requirements.txt` for main pipeline dependencies
- **Experiment level**: `pyproject.toml` + `uv.lock` for isolated environments
- **Key libraries**: CrewAI, Pydantic, test-suite-sql-eval, Spider dataset tools

## Essential Commands & Workflows

### Running Experiments
```bash
# Main pipeline (from project root)
python run_complete_nl2sql_pipeline.py

# Multi-agent experiment (from experiment3_multi_agent_crewai/)
uv run python src/nl2sql_flow/main.py

# Evaluation only (from test-suite-sql-eval/)
python evaluation.py --gold gold.sql --pred predict.sql --etype exec --db database/ --table tables.json
```

### Database Setup
- Spider databases automatically copied on first run
- PostgreSQL container via `docker-compose.yml` for development
- Test databases in SQLite format for evaluation

### Output Processing
- CSV output from NL2SQL system → `convert-output-format.py` → evaluation format
- Results tracking: execution metrics, AI request counts, error analysis

## Critical Patterns

### Schema Handling
- **Original format**: Spider's `table_names_original` and `column_names_original` 
- **Schema filtering**: Agents reduce schema size by removing irrelevant tables/columns
- **Join awareness**: Always preserve primary/foreign keys for table relationships

### Error Handling & Metrics
- **Global tracking**: `ai_request_count`, `execution_metrics` in main pipeline
- **Graceful degradation**: Individual question failures don't stop batch processing
- **Detailed logging**: Vietnamese status messages with emoji indicators

### Agent Specialization
- **schema_selector**: Filters database schema to relevant components
- **sql_expert**: Core SQL generation with specific logic patterns (COUNT, JOIN, etc.)
- **question_analyzer**: Intent classification and complexity assessment
- **Each agent**: Specific LLM assignment and specialized prompting

## Configuration & Environment

### Environment Variables
- API keys in `.env` files (experiment-specific)
- Database connection strings in docker-compose
- LLM model assignments in `agents.yaml`

### Key Directories
- `Data Set/spider_data/`: Original Spider dataset
- `experiments/*/output/`: Generated results and logs  
- `experiments/test-suite-sql-eval/database/`: Evaluation databases
- `Document/`: Research papers and planning documents

When working on this project, prioritize understanding the multi-agent workflow, Spider dataset structure, and the semantic evaluation approach over traditional exact-match SQL validation.