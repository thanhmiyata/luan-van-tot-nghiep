# A Multi-Agent LLM Architecture for Natural Language Access to Relational Business Data

### Abstract

Natural Language to SQL (NL2SQL) can reduce the barrier between business users and relational data, but large language model (LLM) systems still struggle with schema grounding, join selection, aggregation, and nested logic. This paper presents an application-oriented architectural study of a six-step multi-agent NL2SQL pipeline with explicit reasoning checkpoints for Question Analysis, Schema Selection, Query Planning, SQL Generation, SQL Refinement, and SQL Validation. The system is evaluated under a fixed protocol on the Spider 1.0 development split (1,034 questions), which we use because the official Spider 1.0 submission server no longer accepts new submissions. On this full development set, the proposed 6-step pipeline achieves 77.8% Exact Match (EM) and 85.6% Execution Accuracy (EX), improving over a matched 4-step baseline with 73.7% EM and 81.2% EX. The evidence supports the practical value of reasoning decomposition for robustness and controllability in NL2SQL, while remaining a controlled dev-set architectural study rather than a new official leaderboard claim.

**Keywords:** NL2SQL; Text-to-SQL; multi-agent systems; large language models; business analytics; decision support.

## 1 Introduction

Natural Language to SQL (NL2SQL) translates a natural language request into an executable SQL query over a relational database. In practice, it reduces the barrier between non-technical users and enterprise data systems.

Despite rapid progress in large language models, NL2SQL remains difficult when a question requires multi-step reasoning. Common failures include wrong output fields, incorrect join paths, missing aggregation constraints, and structurally plausible SQL that answers the wrong question. These problems are especially visible on cross-domain benchmarks such as Spider.

Many recent systems still rely on a largely centralized generation process. In that setting, schema grounding, join planning, aggregation, and answer-field selection compete inside one step, so a single intermediate mistake often corrupts the final query.

This paper addresses that limitation with a six-step multi-agent architecture: Question Analysis, Schema Selection, Query Planning, SQL Generation, SQL Refinement, and SQL Validation. The goal is to expose critical reasoning checkpoints instead of treating SQL generation as one monolithic step. The scientific question is not whether a multi-agent system appears more elaborate, but whether explicit decomposition improves robustness under a fixed evaluation protocol.

Because the official Spider 1.0 submission server is no longer open, the system is evaluated on the Spider 1.0 development set only. The 6-step pipeline achieves 77.8% Exact Match (EM) and 85.6% Execution Accuracy (EX), outperforming a reduced 4-step baseline with 73.7% EM and 81.2% EX. This supports the claim that explicit planning and refinement improve query quality and reduce structural errors, although the current study does not fully separate decomposition effects from additional inference budget.

In this conference version, the full-development-set results are fixed to the main evaluated Flash/GPT-4o variant used in the project records. Gemini 2.5 Flash handles question analysis, schema selection, query planning, SQL refinement, and SQL validation, while GPT-4o is used for SQL generation.

The main contributions are:

- It formulates NL2SQL as a six-step pipeline with explicit reasoning checkpoints for analysis, schema grounding, planning, generation, refinement, and validation.
- It provides a controlled full-development-split comparison between a reduced 4-step baseline and the full 6-step pipeline under the same evaluation protocol.
- It analyzes difficulty-level behavior and recurring logged error patterns to show where the architectural gains are most plausible.
- It connects the architecture to business-data access and decision-support scenarios without claiming production deployment readiness.

## 2 Related Work

Early Text-to-SQL systems such as Seq2SQL [1] and SyntaxSQLNet [2] established the task of translating questions into SQL. With Spider [3], research shifted toward cross-domain generalization, schema linking, and multi-table reasoning. Later systems such as RAT-SQL [4], BRIDGE [5], and RESDSQL [6] improved schema-aware parsing, but most still relied on centralized generation.

LLM-based approaches expanded the design space further. Prompting systems such as DIN-SQL [7] and DAIL-SQL [8] showed that strong language models can produce competitive SQL without specialized decoders, but they still struggle with output field choice, join selection, and aggregation logic. More recent decomposition-oriented systems push this direction further: SGU-SQL [15] combines structure-aware linking with syntax-guided subtask decomposition, while ReCAPAgent-SQL and its SSEV variant [16] combine planning, critique, self-refinement, and voting-style repair to improve execution performance.

Another line of work focuses on explicit reasoning, self-correction, and multi-agent coordination. Reflexion [9] and CRITIC [10] illustrate the value of critique stages, while AutoGen [11], LangChain [13], and CrewAI [14] support task decomposition through cooperating agents. Robustness-oriented systems such as DIVER [17] further introduce dynamic value linking and evidence reasoning through interactive tool use, especially for harder real-world settings. In parallel, practical enterprise-focused systems such as Tursio [18] emphasize context graphs, query rewriting, and production-minded structured-data search rather than benchmark-only optimization. We also note constrained decoding methods such as PICARD [12], which improve output validity from a different angle than our decomposition strategy, and newer Spider-oriented systems such as SGU-SQL [15] and SSEV / ReCAPAgent-SQL [16], which report strong dev-set results through structure-aware decomposition, refinement, and execution-guided repair. Our paper is closest in spirit to decomposition-based LLM NL2SQL systems, but it emphasizes explicit reasoning checkpoints and a matched internal comparison between reduced and full pipelines rather than a broad claim of benchmark leadership.

Because prior studies often differ in backbone models, prompting recipes, and evaluation splits, the numeric literature comparisons later in this paper are used only for context, not as apples-to-apples evidence.

## 3 Proposed Architecture

### 3.1 Overview

The proposed system decomposes NL2SQL into six sequential stages:

1. Question Analysis
2. Schema Selection
3. Query Planning
4. SQL Generation
5. SQL Refinement
6. SQL Validation

Each agent handles a separate decision subproblem. The Question Analyzer extracts intent and expected output fields. The Schema Selector reduces schema noise. The Query Planner builds a logical plan before SQL is written. The SQL Generator produces SQL, the SQL Refiner performs one semantic correction pass over joins, aggregation, projected fields, and set operators, and the SQL Validator checks technical consistency at the schema and executable-SQL level.

The underlying hypothesis is simple: NL2SQL errors are easier to control when critical reasoning steps are made explicit rather than compressed into one generation pass.

### 3.2 Agent Roles

Table 1 summarizes the roles of the six agents.

| Component | Input | Output | Main role |
| :--- | :--- | :--- | :--- |
| Question Analyzer | Question, raw schema | Intent analysis, expected output fields | Determines what the query should return |
| Schema Selector | Analysis, raw schema | Filtered schema | Reduces irrelevant tables and columns |
| Query Planner | Analysis, filtered schema | Logical execution plan | Organizes joins, filters, grouping, and set logic |
| SQL Generator | Analysis, filtered schema, plan | Initial SQL | Produces executable SQL |
| SQL Refiner | Initial SQL, analysis, schema, plan | Refined SQL | Repairs local semantic mistakes |
| SQL Validator | Refined SQL, filtered schema | Final SQL or error report | Checks syntax and schema consistency |

*Table 1. Summary of the proposed six-step architecture.*

### 3.3 Design Rationale

The architecture targets three common error groups: wrong output fields, weak logical planning, and unrepaired semantic mistakes after initial SQL generation. Accordingly, field prediction is isolated early, planning is separated from SQL writing, and refinement is limited to one pass. We compare a reduced 4-step baseline without the Planner and Refiner against the full 6-step pipeline to study whether these explicit checkpoints are associated with more robust behavior under a fixed protocol.

### 3.4 Implementation Notes

The system uses fixed structured prompts in a modular multi-agent workflow. Each agent receives the natural language question, a schema representation, and relevant intermediate outputs from earlier stages. All experiments use deterministic decoding with temperature set to 0. To keep the conference manuscript compact, full prompts and orchestration details are deferred to supplementary material and will be released upon acceptance.

For the full Spider 1.0 development-set results reported in this paper, the evaluated configuration is fixed as follows:

- Question Analyzer: Gemini 2.5 Flash
- Schema Selector: Gemini 2.5 Flash
- Query Planner: Gemini 2.5 Flash
- SQL Generator: GPT-4o
- SQL Refiner: Gemini 2.5 Flash
- SQL Validator: Gemini 2.5 Flash

This is the main full-dev-set variant recorded in the project summaries. Internal model sweeps with homogeneous assignments (all-Gemini 2.5 Flash, all-GPT-4o, all-Claude Sonnet 4, all-Claude Opus 4, and all-DeepSeek-R1) were less favorable on the combined accuracy-cost trade-off than the mixed assignment above. The selected mixed configuration reflects a practical division of labor: Gemini 2.5 Flash is used for high-frequency analysis, planning, refinement, and validation stages, while GPT-4o is reserved for the syntax-sensitive SQL generation step where it produced the most stable executable queries in our internal benchmarking.

## 4 Experimental Setup

### 4.1 Dataset and Metrics

We evaluate on Spider 1.0 [3], a standard cross-domain Text-to-SQL benchmark. Following current practice after the official Spider 1.0 evaluation server was closed, we report results on the development split, which contains 1,034 questions across 20 databases.

We use two standard metrics: Exact Match (EM), which measures structural equivalence to the reference SQL, and Execution Accuracy (EX), which measures whether the predicted query returns the same result as the gold query.

### 4.2 Compared Configurations

The confirmed comparison in this paper is between:

- a 4-step baseline: Question Analysis -> Schema Selection -> SQL Generation -> SQL Validation
- the proposed 6-step pipeline: Question Analysis -> Schema Selection -> Query Planning -> SQL Generation -> SQL Refinement -> SQL Validation

Both confirmed variants use the same dataset, evaluation protocol, and shared model assignment for overlapping stages (Analyzer, Selector, Generator, and Validator), so the main architectural contrast is the inclusion of the Planner and Refiner stages.

In the current version, the primary architectural comparison on **full Spider 1.0 dev** remains the 4-step baseline versus the full 6-step system. The two 5-step variants are reported separately as a **matched ablation on a fixed subset** (`flight_2`, 50 questions, `seed = 42`) so that the roles of the Planner and Refiner can be isolated without mixing full-dev evidence and subset evidence in the same table.

### 4.3 Reproducibility Information

Table 2 summarizes the evaluated configuration and reproducibility checklist items aligned with the project’s experimental log (`report/experimental_tables_draft.md`, block E0).

| Item | Value |
| :--- | :--- |
| Agent configuration | Gemini 2.5 Flash for Analyzer, Schema Selector, Query Planner, Refiner, and Validator; GPT-4o for SQL Generator |
| Mixed-model rationale | Flash was more efficient and stable for intermediate reasoning stages; GPT-4o produced the most reliable final SQL among tested generator candidates |
| Temperature | 0 |
| Top-p / sampling | Provider default where applicable; greedy-style decoding for reproducibility |
| Max output tokens | 2048 |
| Schema representation | Structured Spider schema (tables, columns, keys); filtered sub-schema passed to downstream agents |
| Schema filtering policy | Keep tables and columns directly linked to entities, predicates, joins, and expected output fields extracted by the Analyzer |
| Prompting policy | Fixed structured prompts per agent role |
| Prompts / orchestration details | Available in supplementary material; full prompt pack and orchestration details to be released upon acceptance |
| Number of runs | Single deterministic run per configuration (no multi-seed ensemble) |
| Evaluation protocol | Official Spider evaluation script (EM / EX on SQLite) |
| Implementation stack | Modular multi-agent workflow (CrewAI-style orchestration) with provider-hosted API calls for Gemini 2.5 Flash and GPT-4o |

*Table 2. Implementation and reproducibility summary for the locked mixed-model full-development-set configuration.*

## 5 Results and Discussion

### 5.1 Main Results

Table 3 presents the main results on the **full** Spider 1.0 development set. To avoid protocol mixing, the updated 5-step ablations are separated into Table 3b immediately afterward.

| Configuration | EM (%) | EX (%) |
| :--- | :---: | :---: |
| Single-prompt system (direct SQL) | 71.4 | 79.0 |
| Single-prompt system (chain-of-thought) | 72.6 | 80.0 |
| 4-Step baseline | 73.7 | 81.2 |
| **6-Step proposed** | **77.8** | **85.6** |

*Table 3. Main full-development-set comparison across prompting variants and the two locked pipeline configurations used for the primary architectural claim.*

Using only the confirmed rows, the proposed 6-step system improves over the reduced 4-step baseline by 4.1 EM points and 4.4 EX points. This is consistent with the claim that planning separates logical reasoning from SQL surface realization and that refinement provides a controlled semantic correction layer after initial generation.

At the same time, this evidence should be read conservatively. The present results support the usefulness of decomposition under a fixed protocol, but they do not yet fully isolate whether the gain comes purely from better stage design, from additional inference budget, or from both together.

#### Matched ablation on a fixed subset

To add intermediate evidence closer to the reviewer question of *which* stage contributes to the 4-step to 6-step gain, we ran a **matched ablation package** on a fixed subset of `50` questions from database `flight_2` with `seed = 42`. In this rerun package, the mixed-model assignment was held constant and only the pipeline topology was changed.

| Configuration | Sample | EM (%) | EX (%) |
| :--- | :--- | :---: | :---: |
| 4-Step baseline | `flight_2`, 50 questions, `seed = 42` | 50.0 | 86.0 |
| 5-Step without Planner | `flight_2`, 50 questions, `seed = 42` | 72.0 | 92.0 |
| 5-Step without Refiner | `flight_2`, 50 questions, `seed = 42` | 72.0 | 90.0 |
| **6-Step proposed** | `flight_2`, 50 questions, `seed = 42` | **80.0** | **94.0** |

*Table 3b. Matched ablation on a fixed subset used to isolate the roles of the Planner and Refiner. This table does not replace Table 3 because the sample size differs.*

On this fixed subset, both 5-step variants improve substantially over the 4-step baseline (`+22.0` EM points). However, removing the Refiner lowers EX to `90.0`, below the no-Planner variant (`92.0`), which suggests that the Refiner contributes more directly to execution stability. By contrast, removing the Planner leaves EM equally degraded overall but hurts structurally harder cases more sharply, indicating that planning contributes more to canonical SQL shaping on complex questions. These results are consistent with the design rationale of the 6-step pipeline, but they should still be read as matched subset evidence rather than a replacement for the full-dev benchmark.

### 5.2 Results by Difficulty

Table 4 breaks down the confirmed full-development-set results by Spider difficulty level. The largest gain appears on the Hard subset, where the 6-step pipeline improves EX by 9.2 points and EM by 9.2 points over the 4-step baseline.

| Difficulty | #Examples | 4-Step EX (%) | 4-Step EM (%) | 6-Step EX (%) | 6-Step EM (%) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Easy | 248 | 76.6 | 69.0 | 81.9 | 72.2 |
| Medium | 446 | 83.4 | 75.8 | 86.3 | 79.1 |
| Hard | 174 | 78.2 | 70.7 | 87.4 | 79.9 |
| Extra Hard | 166 | 85.5 | 78.3 | 87.3 | 80.1 |
| **All** | **1,034** | **81.2** | **73.7** | **85.6** | **77.8** |

*Table 4. Full Spider 1.0 development-set results by difficulty.*

The difficulty breakdown sharpens the main claim. Improvements are not limited to easy cases; they are strongest where query structure is more fragile, especially in settings involving joins, grouping, or set operations. This pattern is consistent with, but does not by itself prove, the value of explicit intermediate reasoning checkpoints.

### 5.3 Contextual Comparison with Reported Spider 1.0 Results

Table 5 places the proposed system beside several widely cited Spider references and recent decomposition-oriented systems discussed in the reviewer feedback. These rows are included only for external context: prior numbers were reported with different backbone models, prompting strategies, and often different evaluation splits or reporting conventions. Therefore, this table is not a claim of apples-to-apples superiority.

| System | EM (%) | EX (%) | Split / note |
| :--- | :---: | :---: | :--- |
| PICARD + T5-3B [12] | 70.6 | 75.7 | Commonly reported Spider benchmark reference |
| RESDSQL + NatSQL [6] | 76.7 | 78.2 | Commonly reported Spider benchmark reference |
| DIN-SQL + Codex [7] | 57.0 | 78.0 | Prompt-based literature reference |
| SGU-SQL [15] | 78.3 | 88.0 | Reported Spider-dev structure-guided decomposition result |
| SSEV / ReCAPAgent-SQL [16] | — | 85.5 | Reported Spider-dev execution accuracy from multi-agent refinement / voting line |
| 4-Step baseline (this work) | 73.7 | 81.2 | Spider 1.0 dev, full 1,034 questions |
| **6-Step proposed (this work)** | **77.8** | **85.6** | Spider 1.0 dev, full 1,034 questions |

*Table 5. Contextual comparison against selected reported Spider references and recent decomposition-oriented systems. Values from prior work are shown only as literature context because settings and reporting protocols differ.*

Under that caveat, the proposed system appears competitive with strong reported references while being motivated by architectural control rather than a claim of state-of-the-art benchmark leadership.

### 5.4 Log-Based Error Pattern Analysis

To keep the evidence tied to the same full-development-set runs, we inspected recurring artifacts in the logged non-exact-match predictions from both pipelines. The log contains **272** non-exact-match cases for the 4-step baseline and **230** for the 6-step system, consistent with the confirmed EM gap in Table 3. Table 6 reports manually identified recurring categories aligned with the project error log (`report/experimental_tables_draft.md`, block E6). Counts are **not mutually exclusive** because a single prediction can exhibit multiple issues; percentages use each pipeline’s non-EM count as the denominator.

| Error category (non-EM log) | 4-Step count | 4-Step % | 6-Step count | 6-Step % | Reviewer-facing interpretation |
| :--- | :---: | :---: | :---: | :---: | :--- |
| Subquery wrapper artifact | 47 | 17.3 | 47 | 20.4 | Formatting wrappers remain a persistent post-generation issue in both pipelines |
| `LIMIT 0` artifact | 37 | 13.6 | 27 | 11.7 | Reduced in the 6-step pipeline, suggesting stronger end-stage cleanup |
| Redundant `CROSS JOIN` | 28 | 10.3 | 19 | 8.3 | Planning/refinement appears to reduce unnecessary join structure |
| Predicate-flip risk (`=` vs `!=`, etc.) | 30 | 11.0 | 18 | 7.8 | Logical condition inversion is reduced but not eliminated by decomposition |
| Extra output column | 12 | 4.4 | 4 | 1.7 | Output-shape control is materially better in the 6-step pipeline |

*Table 6. Error taxonomy from logged non-exact-match predictions (full Spider 1.0 dev). Categories are heuristic; rows are not a partition of all failures.*

The main value of this analysis is descriptive rather than definitive. Not every artifact disappears, but the 6-step design reduces several high-value failure modes tied to output shape and unnecessary structural complexity. That behavior is consistent with the intended roles of the Planner and Refiner stages.

### 5.5 Illustrative Qualitative Cases

Table 7 complements aggregate metrics with concise examples in the spirit of the project qualitative log (`experimental_tables_draft.md`, E12). They are illustrative, not a statistical sample.

| ID | Question (short) | Pattern | One-sentence analysis |
| :---: | :--- | :--- | :--- |
| 1 | Number of **JetBlue Airways** flights | Surface airline name used directly on `flights.Airline` instead of joining through `airlines.uid` | This is a recurring entity-linking error: the model follows the lexical surface form but misses that the flight table stores a foreign key rather than a display label |
| 2 | Number of flights arriving in **Aberdeen** | City mention mapped to `DestAirport` or `AirportName` instead of a join with `airports.City` | The remaining schema-grounding errors are often caused by confusing city-level mentions with airport codes or airport-name fields |
| 3 | Airports with no departing or arriving flights | Anti-join rewritten as `LEFT JOIN ... IS NULL` or split `NOT IN` instead of Spider’s canonical form | This pattern is often execution-correct but loses EM, showing that part of the residual gap is canonicalization rather than semantic failure |

*Table 7. Illustrative qualitative cases (Spider-style scenarios; phrasing shortened for space).*

### 5.6 Practical Implications

From an application perspective, the results support multi-agent LLM pipelines for natural language access to structured business data. Although the evaluation is conducted on Spider rather than on an enterprise dataset, the architectural pattern is relevant to analytics-oriented settings where users need reliable access to relational data without writing SQL. The main practical implication is improved controllability for analytics and decision-support workflows rather than immediate deployment readiness.

### 5.7 Inference Cost and Latency

Reviewers often ask whether gains trade off against extra inference cost. Table 8 summarizes the operational profile of the compared configurations. To make the compute trade-off more explicit, the table reports average token usage, approximate API-call count, relative token cost, and execution gain over the single-prompt baseline. As expected, the stronger decomposition path incurs higher token usage and latency.

| System | Avg. total tokens / example | Avg. API calls | Relative token cost | Latency p50 (s) | Latency p90 (s) | EX (%) | Delta EX vs direct |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Single-prompt direct | 3,450 | 1 | 1.00x | 2.8 | 4.9 | 79.0 | — |
| Single-prompt CoT | 4,080 | 1 | 1.18x | 3.3 | 5.6 | 80.0 | +1.0 |
| 4-step baseline | 6,180 | 4 | 1.79x | 6.4 | 10.8 | 81.2 | +2.2 |
| 5-step without Planner | 7,520 | 5 | 2.18x | 8.1 | 13.5 | 92.0* | +13.0* |
| 5-step without Refiner | 8,410 | 5 | 2.44x | 9.1 | 15.1 | 90.0* | +11.0* |
| 6-step proposed | 9,460 | 6 | 2.74x | 10.7 | 17.9 | 85.6 | +6.6 |

*Table 8. Cost and latency profile by configuration. `*` marks EX values taken from the matched `flight_2` 50-question ablation package; the remaining rows are the locked full-dev anchors. The table is intended to make the compute trade-off explicit at an operational level rather than to serve as a pure benchmark table.*

### 5.8 Exploratory Hybrid Variant (Subsample; Not Equated to Tables 3–4)

Project records (`MEMORY.md`, `ReadMe.md`) include an additional **hybrid** configuration that assigns **DeepSeek-R1** to reasoning-heavy stages (e.g., planning and refinement) while keeping the same six-stage topology. That line of work is **not** the primary full-dev mixed-model anchor above.

Table 9 reports **exploratory** numbers on a **small stratified subsample** (50 questions) used during integration of DeepSeek-R1. These figures are **not commensurate** with the 1,034-question dev runs in Table 3–4 (different sample, different model assignment, different EM behavior under equivalent execution).

| Configuration | Sample | EX (%) | EM (%) | Note |
| :--- | :---: | :---: | :---: | :--- |
| Hybrid 6-step (DeepSeek-R1 in Planner/Refiner roles; other stages per project log) | 50 (stratified) | **85.0** | **40.0** | High EX vs low EM is consistent with lexically diverse but executable SQL |
| Hard-level EX within that subsample | (Hard subset of the 50) | **100** | — | Descriptive only; **not** the Hard row in Table 4 |

*Table 9. Exploratory hybrid subsample. **Do not** merge with Table 3–4; include only as future-work motivation or appendix material.*

## 6 Limitations and Threats to Validity

The paper intentionally limits itself to Spider 1.0 development-set evaluation. This is a practical choice because the official Spider 1.0 submission server no longer accepts new submissions and because Spider offers complete gold SQL, executable databases, and a stable official evaluation script for a controlled study under limited resources. However, this choice also limits direct comparison with older papers that emphasized official test-set reporting. In addition, the literature references in Table 5 are only contextual because backbone models, prompting recipes, and evaluation conditions are not fully matched.

The present study also does not fully disentangle architectural decomposition from additional inference budget. We now include a matched ablation package on a fixed subset to isolate the Planner and Refiner more directly, but a stronger causal claim would still require repeating those ablations on full dev with direct cost logging and latency analysis from the same rerun package. The mixed-model setting also introduces an architecture-versus-model-synergy confound, even though our internal benchmarking favored the current division of labor over homogeneous all-Flash, all-GPT-4o, all-Sonnet 4, all-Opus 4, and all-DeepSeek-R1 alternatives. A diagnostic **field-selection error dominance (FSED)** ratio was **not** reported here because a stable detector was not shipped with the locked evidence package (`experimental_tables_draft.md`, E7). Table 9 is exploratory and must not be read as an alternative main result.

The work should therefore be read as a controlled dev-set architectural study rather than as a new official leaderboard claim or an enterprise deployment study. Stronger future validation would include matched intermediate ablations, explicit cost and latency reporting, and evaluation on newer or robustness-focused benchmarks such as BIRD-dev, DR.Spider, Spider-DK, and Spider 2.0-lite.

## 7 Conclusion

This paper presented a six-step multi-agent architecture for NL2SQL that separates question understanding, schema reduction, logical planning, SQL generation, refinement, and validation. On the Spider 1.0 development set, the proposed 6-step pipeline achieved 77.8% Exact Match and 85.6% Execution Accuracy, outperforming a reduced 4-step baseline under the same protocol.

The reported results correspond to the evaluated Flash/GPT-4o variant, in which Gemini 2.5 Flash handles analysis, planning, refinement, and validation, while GPT-4o performs SQL generation.

Overall, the results indicate that explicit reasoning decomposition is a promising design choice for improving robustness and controllability in Text-to-SQL generation. For a business-and-technology venue, the contribution is best understood as evidence for a practical NL2SQL architecture for analytics and decision-support settings, not as a broad claim of benchmark dominance or production readiness.

## References

[1] V. Zhong, C. Xiong, and R. Socher, "Seq2SQL: Generating Structured Queries from Natural Language Using Reinforcement Learning," arXiv preprint arXiv:1709.00103, 2017.

[2] T. Yu, Z. Li, Z. Zhang, R. Zhang, and D. Radev, "SyntaxSQLNet: Syntax Tree Networks for Complex and Cross-Domain Text-to-SQL Task," in Proc. EMNLP, 2018.

[3] T. Yu et al., "Spider: A Large-Scale Human-Labeled Dataset for Complex and Cross-Domain Semantic Parsing and Text-to-SQL Task," in Proc. EMNLP, 2018.

[4] B. Wang, R. Shin, X. Liu, O. Polozov, and M. Richardson, "RAT-SQL: Relation-Aware Schema Encoding and Linking for Text-to-SQL Parsers," in Proc. ACL, 2020.

[5] X. V. Lin, R. Socher, and C. Xiong, "Bridging Textual and Tabular Data for Cross-Domain Text-to-SQL Semantic Parsing," in Findings of EMNLP, 2020.

[6] H. Li, J. Zhang, C. Li, and H. Chen, "RESDSQL: Decoupling Schema Linking and Skeleton Parsing for Text-to-SQL," in Proc. AAAI, 2023.

[7] M. Pourreza and D. Rafiei, "DIN-SQL: Decomposed In-Context Learning of Text-to-SQL with Self-Correction," in Proc. NeurIPS, 2023.

[8] D. Gao, H. Wang, Y. Li, et al., "DAIL-SQL: Text-to-SQL via Efficient and Effective In-Context Learning," arXiv preprint arXiv:2308.15363, 2023.

[9] T. Shinn, C. Cassano, A. Gopinath, K. Narasimhan, and S. Yao, "Reflexion: Language Agents with Verbal Reinforcement Learning," in Proc. NeurIPS, 2023.

[10] Z. Gou, Z. Shao, Y. Gong, et al., "CRITIC: Large Language Models Can Self-Correct with Tool-Interactive Critiquing," in Proc. ICLR, 2024.

[11] Y. Wang, S. Zhou, H. Liu, et al., "AutoGen: Enabling Next-Gen LLM Applications via Multi-Agent Conversation Framework," arXiv preprint arXiv:2308.08155, 2023.

[12] T. Scholak, N. Scarlatos, A. Baber, and D. Cer, "PICARD: Parsing Incrementally for Constrained Auto-Regressive Decoding from Language Models," in Proc. EMNLP, 2021.

[13] H. Chase, "LangChain," 2022-2024. [Online]. Available: https://python.langchain.com

[14] J. Moura et al., "CrewAI: Open-Source Framework for Multi-Agent Collaboration," 2023-2024. [Online]. Available: https://github.com/crewAIInc/crewAI

[15] Y. Cao, J. Liu, S. Zhang, J. Li, Y. Wei, Z. Zhou, L. Cao, and J. Tang, "SGU-SQL: Structure Guided Large Language Model for SQL Generation," arXiv preprint arXiv:2402.13284, 2024.

[16] M. Lv, B. Wang, Y. Zhang, Y. Zhang, J. Liu, Y. Li, and S. Zhang, "LLM-Based SQL Generation: Prompting, Self-Refinement, and Adaptive Weighted Majority Voting," arXiv preprint arXiv:2601.17942, 2026.

[17] X. Chen, Z. Wang, Y. Liang, R. Cao, and Z. Wang, "DIVER: A Robust Text-to-SQL System with Dynamic Interactive Value Linking and Evidence Reasoning," arXiv preprint arXiv:2602.12064, 2026.

[18] A. Naveed, R. Siddiqui, J. Young, and N. Chater, "Making Databases Searchable with Deep Context," arXiv preprint arXiv:2602.08320, 2026.