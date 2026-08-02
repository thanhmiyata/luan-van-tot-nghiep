# NL2SQL 6-step — artifact layout

## Evaluation source of truth

Use these files for EX/EM and any claimed numbers:

- `full_dev/predict.sql` + `full_dev/gold.sql` (1034 lines)
- `per_db/<db_id>/predict.sql` + `per_db/<db_id>/gold.sql`

`full_dev` is the concatenation of `per_db` in database-group order (not Spider’s original interleaved index order).

## `raw_responses` ↔ `predict.sql`

Each active file `raw_responses/<db_id>/qXXXX.json` has `final_sql` aligned to the matching line in `per_db/<db_id>/predict.sql` (same local order within that DB).

How to compare:

1. Prefer `per_db/<db_id>/`: line `i` ↔ the `i`-th `q*.json` in that folder (sorted by filename).
2. Do **not** assume `q0491.json` equals `full_dev/predict.sql` line 491. Filename / `question_index` follow the pipeline’s global id; `full_dev` lines are regrouped by DB.

When `final_sql` was rewritten to match predict, the previous value is kept in `final_sql_before_predict_sync`, with metadata under `predict_sync` (`reason`, `synced_at`). Typical reasons: alias/quote normalization (`enhance_sql`), offline repairs (e.g. population `SUM`, `ORDER BY` aggregate alias).

Sync summary: `raw_predict_sync_summary.json`.

## Archives

Folders under `raw_responses/_archive*` are historical rerun snapshots. They are **not** the public prediction set; ignore them when auditing against `predict.sql`.
