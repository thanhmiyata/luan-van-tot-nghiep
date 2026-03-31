# Experimental Tables — Draft Template

Use this file to collect all numbers before merging into `complete_paper_combined.md` / `complete_paper_combined_vi.md`.

**Conventions**

- Dataset: **Spider 1.0 development set** (1,034 examples) unless a table says otherwise.
- Metrics: **EX** = execution accuracy; **EM** = exact match (official Spider evaluation script).
- Replace every `[TBD]` with your measured value; add footnotes where methodology differs from the main pipeline.

---

## E0. Experimental setup checklist (fill for reproducibility)

| Item | Value |
| :--- | :--- |
| Model name & exact version / API snapshot | `[TBD]` |
| `temperature` | `[TBD]` |
| `max_tokens` / `top_p` | `[TBD]` |
| Schema representation (JSON fields, truncation policy) | `[TBD]` |
| Number of runs (if multiple seeds) | `[TBD]` |
| Evaluation command / script version | `[TBD]` |
| Date of experiments | `[TBD]` |

---

## E1. Main architectural comparison (internal)

*Maps to paper Table 4.*

| Configuration | EX (%) | EM (%) | Notes |
| :--- | :---: | :---: | :--- |
| 4-step baseline (no Planner, no Refiner) | `[TBD]` | `[TBD]` | Same prompts/schema as full system except removed stages |
| 6-step proposed (full pipeline) | `[TBD]` | `[TBD]` | Full pipeline |

**Δ improvement (6-step vs 4-step):** EX `[TBD]` pp · EM `[TBD]` pp  

---

## E2. Prompting baselines (same backbone LLM, same schema format)

*Same model as Table E1 unless you explicitly study cross-model; critical for reviewers.*

| Method | EX (%) | EM (%) | Notes |
| :--- | :---: | :---: | :--- |
| Single prompt — direct SQL | `[TBD]` | `[TBD]` | One user message; no chain-of-thought |
| Single prompt — chain-of-thought (CoT) | `[TBD]` | `[TBD]` | CoT in one shot; then extract final SQL |
| 4-step pipeline | `[TBD]` | `[TBD]` | Same as E1 row |
| 6-step pipeline (proposed) | `[TBD]` | `[TBD]` | Same as E1 row |

---

## E3. External / literature-style baseline (optional but strongly recommended)

Pick at least one row you can defend (reimplementation, official code, or cited number + **clear caveat**).

| Method | EX (%) | EM (%) | Source | Notes / caveats |
| :--- | :---: | :---: | :--- | :--- |
| Your reimplementation: `[NAME]` (e.g., DAIL-SQL-style / DIN-SQL-style) | `[TBD]` | `[TBD]` | This work | Same dev split & eval script |
| Reported in paper: `[CITATION]` | `[TBD]` | `[TBD]` | `[Author, Year]` | If settings differ, describe in footnote |

---

## E4. Ablation study (full Spider dev)

*Maps to paper Table 6; keep model + prompts fixed, change only one module.*

| Variant | EX (%) | EM (%) | Observation (short) |
| :--- | :---: | :---: | :--- |
| Full 6-step pipeline | `[TBD]` | `[TBD]` | Best overall |
| w/o Query Planner (skip planning; pass filtered schema + analysis to SQL Expert) | `[TBD]` | `[TBD]` | `[TBD]` |
| w/o SQL Refiner | `[TBD]` | `[TBD]` | `[TBD]` |
| w/o SQL Validator (if applicable) | `[TBD]` | `[TBD]` | `[TBD]` |
| w/o Schema Selector (full schema to downstream) | `[TBD]` | `[TBD]` | Optional; shows noise impact |
| 4-step pipeline | `[TBD]` | `[TBD]` | Should align with E1 |

---

## E5. Results by difficulty (Spider dev)

*Required for Text-to-SQL papers.*

| Difficulty | #Examples | 4-step EX (%) | 4-step EM (%) | 6-step EX (%) | 6-step EM (%) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Easy | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |
| Medium | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |
| Hard | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |
| Extra Hard | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |
| **All** | **1034** | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |

*If you use official `evaluation.py`, difficulty counts should match the released split files.*

---

## E6. Error distribution (failed predictions)

*Sample size: e.g., all execution failures, or random 100 / 200 failures — state N below.*

**Population analyzed:** `[TBD]` (e.g., “all examples with EX=0 under 6-step”, N = `[TBD]`)

| Error type | Count | Percentage (%) | Definition (one line) |
| :--- | :---: | :---: | :--- |
| Missing / wrong JOIN | `[TBD]` | `[TBD]` | `[TBD]` |
| Wrong output columns / order | `[TBD]` | `[TBD]` | `[TBD]` |
| Aggregation / GROUP BY / HAVING | `[TBD]` | `[TBD]` | `[TBD]` |
| Nested query / set ops (IN, EXISTS, INTERSECT, …) | `[TBD]` | `[TBD]` | `[TBD]` |
| Wrong filter / WHERE logic | `[TBD]` | `[TBD]` | `[TBD]` |
| Syntax or non-executable SQL | `[TBD]` | `[TBD]` | `[TBD]` |
| Other / ambiguous | `[TBD]` | `[TBD]` | `[TBD]` |
| **Total** | `[TBD]` | **100.0** | — |

---

## E7. FSED (Field Selection Error Dominance) — diagnostic

**Definition (same as paper):** among execution failures, fraction attributable to `SELECT` mismatch vs gold at `table.column` level (aliases ignored if semantics unchanged).

| Metric | 4-step | 6-step | Notes |
| :--- | :---: | :---: | :--- |
| Total execution failures | `[TBD]` | `[TBD]` | Count where pred ≠ gold result |
| Failures with field selection error | `[TBD]` | `[TBD]` | Per your detector |
| **FSED** (failures with field error / total failures) | `[TBD]` | `[TBD]` | Ratio or % |

---

## E8. Cost and latency

*Per example or per full dev run — be consistent.*

| System | Avg input tokens | Avg output tokens | Avg total tokens | Latency p50 (s) | Latency p90 (s) | Latency mean (s) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| Single prompt (direct) | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |
| Single prompt (CoT) | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |
| 4-step pipeline | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |
| 6-step pipeline | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |

**Measurement notes:** API region / hardware `[TBD]` · concurrent requests `[TBD]` · caching disabled? `[TBD]`

---

## E9. Optional — upper-bound / oracle (shows bottleneck)

*Only if you can run cheaply; helps narrative.*

| Setting | EX (%) | EM (%) | Description |
| :--- | :---: | :---: | :--- |
| 6-step (normal) | `[TBD]` | `[TBD]` | Baseline |
| Gold tables only in schema (oracle tables) | `[TBD]` | `[TBD]` | Schema reduced to gold tables + keys |
| Gold columns highlighted / given to model | `[TBD]` | `[TBD]` | If you try this variant |

---

## E10. Optional — second benchmark (generalization)

*e.g., BIRD dev subset (first N databases) or Spider-Syn — same eval style if possible.*

| Dataset | Split | #Examples | Method | EX (%) | EM (%) | Notes |
| :--- | :--- | :---: | :--- | :---: | :---: | :--- |
| BIRD | dev subset | `[TBD]` | 6-step | `[TBD]` | `[TBD]` | `[TBD]` |
| BIRD | dev subset | `[TBD]` | 4-step | `[TBD]` | `[TBD]` | `[TBD]` |
| Spider-Syn (or other) | `[TBD]` | `[TBD]` | 6-step | `[TBD]` | `[TBD]` | `[TBD]` |

---

## E11. Optional — robustness (small stress test)

| Perturbation | #Examples tested | 6-step EX (%) | 6-step EM (%) | Notes |
| :--- | :---: | :---: | :---: | :--- |
| No perturbation (control) | `[TBD]` | `[TBD]` | `[TBD]` | Same subset as stress test |
| Column/table name noise (rule-based) | `[TBD]` | `[TBD]` | `[TBD]` | Describe rule |
| Paraphrased questions (LLM or manual) | `[TBD]` | `[TBD]` | `[TBD]` | Describe source |

---

## E12. Qualitative examples (for appendix)

Fill 3–5 rows for the paper body or appendix.

| ID | Question (short) | Gold SQL (short) | Pred SQL (short) | Error type | One-sentence analysis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |
| 2 | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |
| 3 | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` | `[TBD]` |

---

## Mapping to paper sections (for merge)

| This draft | Suggested location in paper |
| :--- | :--- |
| E0 | §4.4 Implementation + reproducibility |
| E1 | Table 4, §5.1 |
| E2 | Table 5, §5.2 |
| E3 | §5.2 or new subsection “Comparison with baselines” |
| E4 | Table 6, §6 |
| E5 | New subsection §5.1.1 or §5.4 |
| E6 | Table 7, §7 |
| E7 | §7.1 FSED + §5 optional summary sentence |
| E8 | Table 9, §9 |
| E9–E11 | Optional §5.5 / §10 future work teaser |
| E12 | Appendix |

---

*End of draft template.*
