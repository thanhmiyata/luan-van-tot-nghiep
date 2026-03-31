# A Multi-Agent LLM Architecture for Natural Language Access to Relational Business Data

### Abstract

Natural Language to SQL (NL2SQL) enables non-technical users to access relational data without writing SQL. However, LLM-based NL2SQL systems still struggle with schema selection, joins, aggregation, and nested logic. This paper presents a six-step multi-agent architecture that decomposes NL2SQL into Question Analysis, Schema Selection, Query Planning, SQL Generation, SQL Refinement, and SQL Validation. We evaluate the system on the Spider 1.0 development set using Exact Match (EM) and Execution Accuracy (EX). On the full development set, the proposed 6-step pipeline achieves 77.8% EM and 85.6% EX, outperforming a reduced 4-step baseline with 73.7% EM and 81.2% EX under the same protocol. The results indicate that explicit reasoning decomposition improves robustness and controllability in NL2SQL generation, making this design relevant for business analytics and decision-support settings.

**Keywords:** NL2SQL; Text-to-SQL; multi-agent systems; large language models; business analytics; decision support.

## 1 Introduction

Natural Language to SQL (NL2SQL) translates a natural language request into an executable SQL query over a relational database. In practice, it reduces the barrier between non-technical users and enterprise data systems.

Despite rapid progress in large language models, NL2SQL remains difficult when a question requires multi-step reasoning. Common failures include wrong output fields, incorrect join paths, missing aggregation constraints, and structurally plausible SQL that answers the wrong question. These problems are especially visible on cross-domain benchmarks such as Spider.

Many recent systems still rely on a largely centralized generation process. In that setting, schema grounding, join planning, aggregation, and answer-field selection compete inside one step, so a single intermediate mistake often corrupts the final query.

This paper addresses that limitation with a six-step multi-agent architecture: Question Analysis, Schema Selection, Query Planning, SQL Generation, SQL Refinement, and SQL Validation. The goal is to expose critical reasoning checkpoints instead of treating SQL generation as one monolithic step.

The system is evaluated on the Spider 1.0 development set. The 6-step pipeline achieves 77.8% Exact Match (EM) and 85.6% Execution Accuracy (EX), outperforming a reduced 4-step baseline with 73.7% EM and 81.2% EX. This suggests that reasoning decomposition improves query quality and reduces structural errors.

In this conference version, the full-development-set results are fixed to the main evaluated Flash/GPT-4o variant used in the project records. Gemini 2.5 Flash handles question analysis, schema selection, query planning, SQL refinement, and SQL validation, while GPT-4o is used for SQL generation.

The main contributions are:

- It proposes a six-step multi-agent architecture for NL2SQL with explicit planning and refinement stages.
- It evaluates the architecture on the Spider 1.0 development set under a consistent protocol.
- It shows that the full six-step pipeline outperforms a reduced four-step baseline on both EM and EX, with supporting ablation and error analysis.

## 2 Related Work

Early Text-to-SQL systems such as Seq2SQL [1] and SyntaxSQLNet [2] established the task of translating questions into SQL. With Spider [3], research shifted toward cross-domain generalization, schema linking, and multi-table reasoning. Later systems such as RAT-SQL [4], BRIDGE [5], and RESDSQL [6] improved schema-aware parsing, but most still relied on centralized generation.

LLM-based approaches expanded the design space further. Prompting systems such as DIN-SQL [7] and DAIL-SQL [8] showed that strong language models can produce competitive SQL without specialized decoders, but they still struggle with output field choice, join selection, and aggregation logic.

Another line of work focuses on explicit reasoning, self-correction, and multi-agent coordination. Reflexion [9] and CRITIC [10] illustrate the value of critique stages, while AutoGen [11], LangChain [12], and CrewAI [13] support task decomposition through cooperating agents. This paper applies that idea to NL2SQL to improve schema grounding and structural control.

## 3 Proposed Architecture

### 3.1 Overview

The proposed system decomposes NL2SQL into six sequential stages:

1. Question Analysis
2. Schema Selection
3. Query Planning
4. SQL Generation
5. SQL Refinement
6. SQL Validation

Each agent handles a separate decision subproblem. The Question Analyzer extracts intent and expected output fields. The Schema Selector reduces schema noise. The Query Planner builds a logical plan before SQL is written. The SQL Generator produces SQL, the SQL Refiner performs one semantic correction pass, and the SQL Validator checks technical consistency.

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

The architecture targets three common error groups: wrong output fields, weak logical planning, and unrepaired semantic mistakes after initial SQL generation. Accordingly, field prediction is isolated early, planning is separated from SQL writing, and refinement is limited to one pass. We compare a reduced 4-step baseline without the Planner and Refiner against the full 6-step pipeline to isolate the effect of these two stages.

### 3.4 Implementation Notes

The system uses fixed structured prompts in a modular multi-agent workflow. Each agent receives the natural language question, a schema representation, and relevant intermediate outputs from earlier stages. All experiments use deterministic decoding with temperature set to 0.

For the full Spider 1.0 development-set results reported in this paper, the evaluated configuration is fixed as follows:

- Question Analyzer: Gemini 2.5 Flash
- Schema Selector: Gemini 2.5 Flash
- Query Planner: Gemini 2.5 Flash
- SQL Generator: GPT-4o
- SQL Refiner: Gemini 2.5 Flash
- SQL Validator: Gemini 2.5 Flash

This is the main full-dev-set variant recorded in the project summaries. Other hybrid variants, including DeepSeek-R1-based configurations, are treated as follow-up experiments and are not the primary setup reported here.

## 4 Experimental Setup

### 4.1 Dataset and Metrics

We evaluate on Spider 1.0 [3], a standard cross-domain Text-to-SQL benchmark. Following current practice, we report results on the development split, which contains 1,034 questions across 20 databases.

We use two standard metrics: Exact Match (EM), which measures structural equivalence to the reference SQL, and Execution Accuracy (EX), which measures whether the predicted query returns the same result as the gold query.

### 4.2 Compared Configurations

The main comparison is between:

- a 4-step baseline: Question Analysis -> Schema Selection -> SQL Generation -> SQL Validation
- the proposed 6-step pipeline: Question Analysis -> Schema Selection -> Query Planning -> SQL Generation -> SQL Refinement -> SQL Validation

All compared variants use the same dataset and evaluation protocol.

### 4.3 Reproducibility Information

Table 2 summarizes the evaluated configuration used for the main full-development-set results.

| Parameter | Value |
| :--- | :--- |
| Agent configuration | Gemini 2.5 Flash for Analyzer, Schema Selector, Query Planner, Refiner, and Validator; GPT-4o for SQL Generator |
| Temperature | 0 |
| Max output tokens | 2048 |
| Prompting policy | Fixed structured prompts |
| Evaluation protocol | Official Spider evaluation script |

*Table 2. Compact implementation summary for the evaluated full-development-set configuration.*

## 5 Results and Discussion

### 5.1 Main Results

Table 3 reports the main results on the full Spider 1.0 development set. The proposed 6-step system improves over the reduced 4-step baseline by 4.1 EM points and 4.4 EX points.

| Configuration | EM (%) | EX (%) |
| :--- | :---: | :---: |
| 4-Step baseline | 73.7 | 81.2 |
| 6-Step proposed | **77.8** | **85.6** |

*Table 3. Main results on the Spider 1.0 development set.*

These gains suggest that the benefit comes from separating reasoning stages that would otherwise compete within a single generation pass. Planning helps structure joins and grouping, while refinement provides one controlled opportunity to repair local semantic mistakes.

### 5.2 Ablation Perspective

Table 4 summarizes a compact ablation experiment on a 100-question diagnostic subset. Although this subset is separate from the full development-set run in Table 3, it isolates the contribution of the Planner and Refiner stages.

| Variant | EM (%) | EX (%) |
| :--- | :---: | :---: |
| 4-Step baseline | 44.0 | 78.0 |
| 6-Step without Planner | 58.0 | 86.0 |
| 6-Step without Refiner | 62.0 | 84.0 |
| Full 6-Step | **68.0** | **90.0** |

*Table 4. Component ablation on a 100-question diagnostic subset.*

The ablation supports the central architectural claim. Removing the Planner lowers EM by 10 points relative to the full 6-step pipeline, suggesting that explicit logical decomposition helps preserve query structure. Removing the Refiner lowers EX by 6 points, indicating that one post-generation repair step is important for correcting semantically weak SQL. The strongest degradation appears in the 4-step baseline, which removes both stages and falls to 44.0 EM and 78.0 EX. This pattern is consistent with Table 3: the gain comes from structured decomposition rather than simply increasing prompt length or agent count.

### 5.3 Error Analysis Perspective

Table 5 reports the observed error composition from the available 6-step execution-failure log. On this logged subset, most failures are structural result-shape errors rather than syntax errors.

| Error type | Count | Share of 6-step failures (%) | Interpretation |
| :--- | :---: | :---: | :--- |
| Shape mismatch | 4 | 57.1 | Wrong cardinality, over-returned rows, or incorrect structural constraints |
| Value mismatch | 3 | 42.9 | Query shape is plausible, but aggregation or filtering semantics remain incorrect |

*Table 5. Failure-type distribution for the available 6-step execution-failure log (7 failed queries).* 

This result matches the architectural motivation of the system. The remaining failures are dominated by structural execution problems, such as wrong cardinality or grouping logic, rather than by basic SQL well-formedness.

We also examined a field-level diagnostic subset to understand whether decomposition improves output grounding. On that subset, field-selection accuracy rises from 28.7% in the 4-step baseline to 48.1% in the 6-step pipeline. Together, the ablation and error evidence suggest that the proposed architecture is especially useful for reducing errors in query structure and output specification, even when some aggregation and ranking decisions remain challenging.

### 5.4 Practical Implications

From an application perspective, the results support multi-agent LLM pipelines for natural language access to structured business data. Although the evaluation is conducted on Spider rather than on an enterprise dataset, the architectural pattern is relevant to analytics-oriented settings where users need reliable access to relational data without writing SQL. The main practical implication is improved controllability rather than immediate deployment readiness.

## 6 Conclusion

This paper presented a six-step multi-agent architecture for NL2SQL that separates question understanding, schema reduction, logical planning, SQL generation, refinement, and validation. On the Spider 1.0 development set, the proposed 6-step pipeline achieved 77.8% Exact Match and 85.6% Execution Accuracy, outperforming a reduced 4-step baseline.

The reported results correspond to the evaluated Flash/GPT-4o variant, in which Gemini 2.5 Flash handles analysis, planning, refinement, and validation, while GPT-4o performs SQL generation.

Overall, the results indicate that explicit reasoning decomposition improves robustness and controllability in Text-to-SQL generation, making multi-agent NL2SQL a practical direction for analytics and decision-support settings.

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

[12] H. Chase, "LangChain," 2022-2024. [Online]. Available: https://python.langchain.com

[13] J. Moura et al., "CrewAI: Open-Source Framework for Multi-Agent Collaboration," 2023-2024. [Online]. Available: https://github.com/crewAIInc/crewAI