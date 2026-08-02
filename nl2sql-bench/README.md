# NL2SQL-Bench

[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PyPI version](https://badge.fury.io/py/nl2sql-bench.svg)](https://badge.fury.io/py/nl2sql-bench)

A standardized evaluation framework for Natural Language to SQL (NL2SQL) systems. Easily benchmark your text-to-SQL models against standard datasets like Spider.

## Features

- **Standardized Interface**: Abstract base class for implementing NL2SQL systems
- **Spider Dataset Support**: Built-in loader for the Spider benchmark
- **Multiple Metrics**: Exact Match (EM) and Execution Accuracy (EX)
- **Error Analysis**: Comprehensive error taxonomy and classification
- **CLI Tools**: Command-line interface for quick evaluations
- **Baselines**: Reference implementations for comparison

## Installation

### From PyPI (coming soon)

```bash
pip install nl2sql-bench
```

### From Source

```bash
git clone https://github.com/nl2sql-research/nl2sql-bench.git
cd nl2sql-bench
pip install -e .
```

### With Development Dependencies

```bash
pip install -e ".[dev]"
```

### With Baseline Systems

```bash
pip install -e ".[baselines]"
```

## Quick Start

### 1. Implement Your System

```python
from nl2sql_bench import NL2SQLSystem, NL2SQLInput, NL2SQLOutput

class MyNL2SQLSystem(NL2SQLSystem):
    @property
    def name(self) -> str:
        return "MySystem"
    
    @property
    def version(self) -> str:
        return "1.0.0"
    
    def predict(self, input: NL2SQLInput) -> NL2SQLOutput:
        # Your SQL generation logic here
        sql = generate_sql(input.question, input.schema)
        return NL2SQLOutput(sql=sql)
```

### 2. Run Evaluation

```python
from nl2sql_bench import SpiderDataset, Evaluator

# Load dataset
dataset = SpiderDataset(data_dir="./spider_data", split="dev")

# Initialize evaluator
evaluator = Evaluator(
    dataset=dataset,
    db_dir="./spider_data/database"
)

# Run evaluation
system = MyNL2SQLSystem()
results = evaluator.run(system, verbose=True)

# Print results
print(results.summary())
```

### 3. Using CLI

```bash
# Evaluate a system
nl2sql-bench evaluate \
    --system mypackage.MySystem \
    --dataset ./spider_data \
    --output ./results

# Compare multiple systems
nl2sql-bench compare \
    --results results/system1.json results/system2.json

# Analyze errors
nl2sql-bench analyze \
    --results results/evaluation.json \
    --show-examples
```

## Usage Guide

### Implementing NL2SQLSystem

Your system must inherit from `NL2SQLSystem` and implement the `predict` method:

```python
from nl2sql_bench import NL2SQLSystem, NL2SQLInput, NL2SQLOutput

class MySystem(NL2SQLSystem):
    def __init__(self, model_name: str = "gpt-4"):
        self.model = load_model(model_name)
        self._version = "1.0.0"
    
    @property
    def name(self) -> str:
        return f"MySystem-{self.model.name}"
    
    @property
    def version(self) -> str:
        return self._version
    
    def predict(self, input: NL2SQLInput) -> NL2SQLOutput:
        try:
            # Generate SQL
            sql = self.model.generate(
                question=input.question,
                schema=input.schema
            )
            return NL2SQLOutput(
                sql=sql,
                confidence=0.9,
                intermediate_steps=[{"step": "generation", "output": sql}]
            )
        except Exception as e:
            return NL2SQLOutput(sql="", error=str(e))
```

### Input/Output Models

**NL2SQLInput**:
- `question` (str): Natural language question
- `db_id` (str): Database identifier
- `schema` (dict): Database schema in Spider format
- `evidence` (str, optional): Additional context

**NL2SQLOutput**:
- `sql` (str): Generated SQL query
- `confidence` (float): Confidence score (0-1)
- `intermediate_steps` (list, optional): Pipeline steps for debugging
- `error` (str, optional): Error message if failed

### Understanding Results

The evaluation produces:

```
============================================================
         NL2SQL-Bench Evaluation Results
============================================================

System:    MySystem v1.0.0
Dataset:   Spider dev (1034 questions)

------------------------------------------------------------
OVERALL METRICS
------------------------------------------------------------

  Exact Match:         76.8%
  Execution Accuracy:  84.0%

------------------------------------------------------------
BY DIFFICULTY
------------------------------------------------------------

  Easy    :  92.3% EM |  95.1% EX  ( 234 questions)
  Medium  :  78.5% EM |  86.2% EX  ( 456 questions)
  Hard    :  68.2% EM |  75.4% EX  ( 289 questions)
  Extra   :  54.1% EM |  62.3% EX  (  55 questions)
```

### Error Taxonomy

The framework classifies errors into categories:

| Category | Description |
|----------|-------------|
| FIELD_SELECTION | Incorrect columns in SELECT |
| JOIN_PATH | Missing/extra/wrong JOINs |
| AGGREGATION | Wrong COUNT/SUM/AVG/etc |
| GROUP_BY | Incorrect GROUP BY clause |
| NESTED_QUERY | Wrong subquery structure |
| VALUE_GROUNDING | Wrong filter values |
| SET_OPERATION | Wrong UNION/INTERSECT/EXCEPT |
| ORDER_LIMIT | Wrong ORDER BY or LIMIT |
| CONDITION_LOGIC | Wrong AND/OR logic |
| SYNTAX_ERROR | SQL syntax error |

## Baselines

### Multi-Agent 6-Step System

Our reference implementation using 6 specialized agents:

```python
from nl2sql_bench.baselines import MultiAgent6StepSystem

system = MultiAgent6StepSystem(
    project_path="/path/to/nl2sql_6step"
)

# Achieves: EM=76.8%, EX=84.0% on Spider dev
```

### Simple LLM System

Basic single-LLM baseline:

```python
from examples.simple_llm_system import SimpleLLMSystem

system = SimpleLLMSystem(
    provider="openai",
    model="gpt-4o"
)
```

## Spider Dataset

Download the Spider dataset:

1. Visit [Spider Official Page](https://yale-lily.github.io/spider)
2. Download and extract to `./spider_data/`

Expected structure:
```
spider_data/
├── dev.json
├── train_spider.json
├── tables.json
└── database/
    ├── concert_singer/
    │   └── concert_singer.sqlite
    └── ...
```

## API Reference

### Core Classes

- `NL2SQLSystem`: Abstract base class for systems
- `NL2SQLInput`: Input data model
- `NL2SQLOutput`: Output data model
- `Evaluator`: Main evaluation orchestrator
- `EvaluationResult`: Evaluation results container
- `SpiderDataset`: Spider dataset loader

### Metrics

- `compute_exact_match()`: Compare SQL structure
- `compute_execution_accuracy()`: Compare execution results

### Analysis

- `ErrorCategory`: Error classification enum
- `classify_error()`: Classify a single error
- `analyze_errors()`: Batch error analysis

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `pytest tests/`
5. Submit a pull request

## Citation

If you use NL2SQL-Bench in your research, please cite:

```bibtex
@software{nl2sql_bench_2026,
  title={NL2SQL-Bench: A Standardized Evaluation Framework for NL2SQL Systems},
  author={NL2SQL Research Team},
  year={2026},
  url={https://github.com/nl2sql-research/nl2sql-bench}
}
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- [Spider Dataset](https://yale-lily.github.io/spider) - Yu et al., EMNLP 2018
- [CrewAI](https://github.com/joaomdmoura/crewAI) - Multi-agent framework
