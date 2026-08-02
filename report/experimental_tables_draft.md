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
| Model name & exact version / API snapshot | Main conference variant: Gemini 2.5 Flash for Analyzer/Schema/Planner/Refiner/Validator; GPT-4o for SQL Generator |
| `temperature` | `0` |
| `max_tokens` / `top_p` | `2048` / provider default |
| Schema representation (JSON fields, truncation policy) | Structured Spider schema with table/column metadata; schema filtered before downstream generation |
| Number of runs (if multiple seeds) | Single deterministic run per configuration |
| Evaluation command / script version | `experiments/test-suite-sql-eval/evaluation.py` with official Spider-style EM/EX evaluation |
| Date of experiments | Logged in project records; exact run timestamp not preserved in the committed breakdown files |

---

## E1. Main architectural comparison (internal)

*Maps to paper Table 4.*

| Configuration | EX (%) | EM (%) | Notes |
| :--- | :---: | :---: | :--- |
| 4-step baseline (no Planner, no Refiner) | `81.2` | `73.7` | Same prompts/schema as full system except removed stages |
| 6-step proposed (full pipeline) | `85.6` | `77.8` | Full pipeline |

**Δ improvement (6-step vs 4-step):** EX `+4.4` pp · EM `+4.1` pp  

---

## E2. Prompting baselines (same backbone LLM, same schema format)

*Same model as Table E1 unless you explicitly study cross-model; critical for reviewers.*

| Method | EX (%) | EM (%) | Notes |
| :--- | :---: | :---: | :--- |
| Single prompt — direct SQL | `Not reported` | `Not reported` | Omitted from conference version to avoid unmatched late-stage baselines |
| Single prompt — chain-of-thought (CoT) | `Not reported` | `Not reported` | Same reason as above |
| 4-step pipeline | `81.2` | `73.7` | Same as E1 row |
| 6-step pipeline (proposed) | `85.6` | `77.8` | Same as E1 row |

---

## E3. External / literature-style baseline (optional but strongly recommended)

Pick at least one row you can defend (reimplementation, official code, or cited number + **clear caveat**).

| Method | EX (%) | EM (%) | Source | Notes / caveats |
| :--- | :---: | :---: | :--- | :--- |
| PICARD + T5-3B | `75.7` | `70.6` | Scholak et al. | Commonly cited Spider reference; not matched to this work's dev-only setup |
| RESDSQL + NatSQL | `78.2` | `76.7` | Li et al. | Reported benchmark value from prior literature; settings differ |
| DIN-SQL + Codex | `78.0` | `57.0` | Pourreza and Rafiei | Prompt-based reference; settings differ |
| 6-step proposed (this work) | `85.6` | `77.8` | This work | Spider 1.0 dev only; included for contextual, not apples-to-apples, comparison |

---

## E4. Ablation study (full Spider dev)

*Maps to paper Table 6; keep model + prompts fixed, change only one module.*

| Variant | EX (%) | EM (%) | Observation (short) |
| :--- | :---: | :---: | :--- |
| Full 6-step pipeline | `85.6` | `77.8` | Best overall among locked conference results |
| w/o Query Planner (skip planning; pass filtered schema + analysis to SQL Expert) | `Not carried into conference main text` | `Not carried into conference main text` | Existing subset-only diagnostics were not treated as primary evidence |
| w/o SQL Refiner | `Not carried into conference main text` | `Not carried into conference main text` | Same reason |
| w/o SQL Validator (if applicable) | `Not reported` | `Not reported` | Not part of the conference evidence package |
| w/o Schema Selector (full schema to downstream) | `Not reported` | `Not reported` | Optional future study |
| 4-step pipeline | `81.2` | `73.7` | Aligns with E1 |

---

## E5. Results by difficulty (Spider dev)

*Required for Text-to-SQL papers.*

| Difficulty | #Examples | 4-step EX (%) | 4-step EM (%) | 6-step EX (%) | 6-step EM (%) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Easy | `248` | `76.6` | `69.0` | `81.9` | `72.2` |
| Medium | `446` | `83.4` | `75.8` | `86.3` | `79.1` |
| Hard | `174` | `78.2` | `70.7` | `87.4` | `79.9` |
| Extra Hard | `166` | `85.5` | `78.3` | `87.3` | `80.1` |
| **All** | **1034** | `81.2` | `73.7` | `85.6` | `77.8` |

*If you use official `evaluation.py`, difficulty counts should match the released split files.*

---

## E6. Error distribution (failed predictions)

*For the conference version, this section is grounded in the committed non-exact-match logs from the two full-dev runs. Categories are heuristic and non-exclusive.*

**Population analyzed:** all logged non-exact-match cases from the committed full-dev runs: `N = 272` for 4-step and `N = 230` for 6-step.

| Error type | Count | Percentage (%) | Definition (one line) |
| :--- | :---: | :---: | :--- |
| 4-step: subquery wrapper artifact | `47` | `17.3` | `SELECT * FROM (...) AS subq` style wrapper around otherwise simpler SQL |
| 4-step: `LIMIT 0` artifact | `37` | `13.6` | Spurious zero-row limit that breaks equivalence |
| 4-step: redundant `CROSS JOIN` | `28` | `10.3` | Added Cartesian product or obviously unnecessary join |
| 4-step: predicate-flip risk | `30` | `11.0` | Suspicious logical inversion such as `=` versus `!=` |
| 6-step: subquery wrapper artifact | `47` | `20.4` | Same wrapper behavior remained in the stronger pipeline |
| 6-step: `LIMIT 0` artifact | `27` | `11.7` | Reduced versus 4-step |
| 6-step: redundant `CROSS JOIN` | `19` | `8.3` | Reduced versus 4-step |
| 6-step: extra output column | `4` | `1.7` | Added synthetic output column such as `_extra` |
| **Note** | `—` | `—` | Rows are non-exclusive and should be read as recurring patterns, not a partition of all failures |

### E6a. Locked subset diagnostic for current best mixed-model

*Use this block only for internal benchmark/discussion tables, not as a replacement for the full-dev main result.*

**Subset:** `flight_2`, `50` questions, fixed `seed = 42`  
**Config:** `GPT-4o` for Analyzer/Planner/Generator/Refiner, `Gemini 2.5 Flash` for Schema Selector/Validator.

| Item | Value | Interpretation |
| :--- | :---: | :--- |
| EX (%) | `94.0` | `47/50` execution-correct queries |
| EM (%) | `80.0` | `40/50` exact-match queries |
| EX - EM gap | `14.0` pp | `7` cases likely fail only canonical Spider matching while preserving execution |
| Non-EM cases | `10` | Population used for quick qualitative audit |
| Dominant pattern 1 | `4/10` | Entity-linking / FK-ID confusion (e.g., airline name vs `uid`, city vs airport code) |
| Dominant pattern 2 | `5/10` | Canonical-but-equivalent rewrites (`LEFT JOIN ... IS NULL`, `IN` vs `OR`, `COUNT(col)` vs `COUNT(*)`, alternate grouping/order form) |
| Dominant pattern 3 | `1/10` | Projection / aggregation artifact (`SELECT T1.count` instead of `COUNT(*)`) |
| IUEN F1 | `1.000` | Set-operation handling was not the main bottleneck on this subset |

---

## E7. FSED (Field Selection Error Dominance) — diagnostic

**Definition (same as paper):** among execution failures, fraction attributable to `SELECT` mismatch vs gold at `table.column` level (aliases ignored if semantics unchanged).

| Metric | 4-step | 6-step | Notes |
| :--- | :---: | :---: | :--- |
| Total execution failures | `Not isolated in committed logs` | `Not isolated in committed logs` | The committed files capture non-EM cases more reliably than EX-failure subsets |
| Failures with field selection error | `Not reported` | `Not reported` | No stable detector was committed with the locked conference evidence |
| **FSED** (failures with field error / total failures) | `Omitted` | `Omitted` | Better left out than weakly estimated |

---

## E8. Cost and latency

*Per example or per full dev run — be consistent.*

| System | Avg input tokens | Avg output tokens | Avg total tokens | Latency p50 (s) | Latency p90 (s) | Latency mean (s) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| Single prompt (direct) | `Not reported` | `Not reported` | `Not reported` | `Not reported` | `Not reported` | `Not reported` |
| Single prompt (CoT) | `Not reported` | `Not reported` | `Not reported` | `Not reported` | `Not reported` | `Not reported` |
| 4-step pipeline | `Not reported` | `Not reported` | `Not reported` | `Not reported` | `Not reported` | `Not reported` |
| 6-step pipeline | `Not reported` | `Not reported` | `Not reported` | `Not reported` | `Not reported` | `Not reported` |

**Measurement notes:** cost/latency were intentionally omitted from the conference version because consistent run-time logging was not preserved for the locked evidence package.

---

## E9. Optional — upper-bound / oracle (shows bottleneck)

*Only if you can run cheaply; helps narrative.*

| Setting | EX (%) | EM (%) | Description |
| :--- | :---: | :---: | :--- |
| 6-step (normal) | `85.6` | `77.8` | Locked conference baseline |
| Gold tables only in schema (oracle tables) | `Not reported` | `Not reported` | Future upper-bound study |
| Gold columns highlighted / given to model | `Not reported` | `Not reported` | Future upper-bound study |

---

## E10. Optional — second benchmark (generalization)

*e.g., BIRD dev subset (first N databases) or Spider-Syn — same eval style if possible.*

| Dataset | Split | #Examples | Method | EX (%) | EM (%) | Notes |
| :--- | :--- | :---: | :--- | :---: | :---: | :--- |
| BIRD | dev subset | `Not used` | 6-step | `Not used` | `Not used` | Outside the conference scope |
| BIRD | dev subset | `Not used` | 4-step | `Not used` | `Not used` | Outside the conference scope |
| Spider-Syn (or other) | `Not used` | `Not used` | 6-step | `Not used` | `Not used` | Outside the conference scope |

---

## E11. Optional — robustness (small stress test)

| Perturbation | #Examples tested | 6-step EX (%) | 6-step EM (%) | Notes |
| :--- | :---: | :---: | :---: | :--- |
| No perturbation (control) | `Not used` | `Not used` | `Not used` | Robustness stress tests were excluded from the conference version |
| Column/table name noise (rule-based) | `Not used` | `Not used` | `Not used` | Outside current scope |
| Paraphrased questions (LLM or manual) | `Not used` | `Not used` | `Not used` | Outside current scope |

---

## E12. Qualitative examples (for appendix)

Fill 3–5 rows for the paper body or appendix.

| ID | Question (short) | Gold SQL (short) | Pred SQL (short) | Error type | One-sentence analysis |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Number of JetBlue Airways flights | `JOIN airlines ... WHERE Airline = "JetBlue Airways"` | `WHERE flights.Airline = "JetBlue Airways"` | FK-ID / entity-linking mismatch | The pipeline copied the surface airline name into a foreign-key field instead of joining through `airlines.uid` |
| 2 | Flights arriving in Aberdeen | `JOIN airports ... WHERE City = "Aberdeen"` | `WHERE DestAirport = "Aberdeen"` | Value-to-column mapping error | The model mapped a city mention directly to an airport-code column, indicating residual schema-linking confusion |
| 3 | Airports with no flights | `NOT IN (SELECT SourceAirport UNION SELECT DestAirport)` | `LEFT JOIN ... WHERE FlightNo IS NULL` | Canonical-equivalent rewrite | Execution stayed correct, but the rewritten anti-join lost exact-match credit under Spider canonicalization |
| 4 | Count United flights to `ASY` | `SELECT count(*) ...` | `SELECT T1.count ...` | Projection artifact | A local surface-form mistake in the `SELECT` clause caused a hard failure despite otherwise correct joins/filters |

---

## Mapping to paper sections (for merge)

| This draft | Suggested location in paper |
| :--- | :--- |
| E0 | §4.4 Implementation + reproducibility |
| E1 | Table 3, §5.1 |
| E2 | Omitted from current conference version |
| E3 | Table 5, §5.3 |
| E4 | Kept as internal note only unless rerun on full dev |
| E5 | Table 4, §5.2 |
| E6 | Table 6, §5.4 |
| E7 | Omit unless a stable detector is added |
| E8 | Omit unless run-time logging is reproduced |
| E9–E11 | Optional future-work teaser only |
| E12 | Appendix |

---

*End of draft template.*
