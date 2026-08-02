# NL2SQL Multi-Agent Pipelines (code)

Public code snapshot for advisor / peer review.

## Contents

| Path | Description |
|------|-------------|
| `src/nl2sql_6step/` | Proposed 6-stage CrewAI pipeline (agents + tasks + orchestration) |
| `src/nl2sql_4step/` | 4-stage baseline pipeline |
| `run_complete_nl2sql_pipeline.py` | Main Spider benchmark runner |
| `run_ablation_study.py` | 5-stage ablation helper (skip Planner / Refiner) |
| `run_single_prompt_nl2sql.py` | Single-prompt baseline runner |
| `experiments/test-suite-sql-eval/` | Official Spider evaluation scripts (**no SQLite DB files**) |
| `scripts/` | Hybrid fail-rerun / Dr.Spider smoke helpers |
| `test/` | Unit / guard tests |
| `.env.example` | API key placeholders (copy to `.env`) |

## Locked Spider 1.0 Dev results (reference)

Evaluated with the official Spider script on the full 1,034-question development set:

| Pipeline | EX (%) | EM (%) |
|----------|-------:|-------:|
| 4-stage baseline | 84.9 | 57.4 |
| **6-stage proposed** | **89.0** | **75.0** |

Prediction artifacts and paper draft are **not** included in this code-only package.

## Setup (high level)

```bash
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env   # fill API keys
```

Spider SQLite databases are required to re-run evaluation; place them under `experiments/test-suite-sql-eval/database/` (standard Spider layout).

## Note

Do not commit `.env`. This folder is intended as a standalone GitHub repo root (`cd publish && git init`).
