# Nội dung copy-paste cho Overleaf (PCCDA / Springer)

**Cách dùng:** Tạo project Overleaf từ template thầy gửi. Điền **title / authors / abstract / keywords** vào chỗ tương ứng trong `main.tex`. Sau đó lần lượt dán nội dung từng **Khối** vào `\section{...}` hoặc môi trường phù hợp. Bảng dùng `\begin{table}...\end{table}` (hoặc bảng của template); dưới đây có sẵn mã LaTeX `tabular` để dán.

**Lưu ý:** Markdown `**bold**` → trong LaTeX dùng `\textbf{...}`. Dấu gạch ngang trong số (1,034) giữ nguyên hoặc `1{,}034` tùy template.

---

## Khối 0 — Metadata (điền trong template)

### Tiêu đề

```
A Multi-Agent LLM Architecture for Natural Language Access to Relational Business Data
```

### Tác giả & đơn vị (chỗ giữ chỗ — bạn thay bằng thông tin thật)

```
% Ví dụ — XÓA và thay:
% \author{Tên A \inst{1} \and Tên B \inst{1}}
% \institute{Trường / Khoa, Quốc gia \\ \email{...}}
```

### Từ khóa (một dòng, tách bằng dấu phẩy nếu template yêu cầu)

```
NL2SQL, Text-to-SQL, multi-agent systems, large language models, business analytics, decision support
```

---

## Khối 1 — Abstract (đoạn văn thuần)

Natural Language to SQL (NL2SQL) can reduce the barrier between business users and relational data, but large language model (LLM) systems still struggle with schema grounding, join selection, aggregation, and nested logic. This paper presents an application-oriented architectural study of a six-step multi-agent NL2SQL pipeline with explicit reasoning checkpoints: Question Analysis, Schema Selection, Query Planning, SQL Generation, SQL Refinement, and SQL Validation. The system is evaluated under a fixed protocol on the Spider 1.0 development split (1,034 questions), which we use because the official Spider 1.0 submission server no longer accepts new submissions. On this full development set, the proposed 6-step pipeline achieves 77.8\% Exact Match (EM) and 85.6\% Execution Accuracy (EX), improving over a matched 4-step baseline with 73.7\% EM and 81.2\% EX. This evidence supports the practical value of reasoning decomposition for robustness and controllability in NL2SQL, while keeping the paper within the scope of a controlled dev-set architectural study rather than a new official leaderboard claim. Mixed-model configuration and reproducibility details are summarized in Table~\ref{tab:repro}.

*(Trong LaTeX, thay `\%` nếu bạn gõ trực tiếp trong abstract environment; một số template dùng `%` không escape.)*

---

## Khối 2 — Section 1 Introduction

Natural Language to SQL (NL2SQL) maps a natural language request into an executable SQL query over a relational database. In practice, this approach reduces the barrier between non-technical users and enterprise data systems.

Despite rapid progress in large language models, NL2SQL remains difficult when a question requires multi-step reasoning. Common failures include wrong output fields, incorrect join paths, missing aggregation constraints, and structurally plausible SQL that answers the wrong question. These problems are especially visible on cross-domain benchmarks such as Spider.

Many recent systems still rely on a largely centralized generation process. In that setting, schema grounding, join planning, aggregation, and answer-field selection compete inside one step, so a single intermediate mistake often corrupts the final query.

This paper addresses that limitation with a six-step multi-agent architecture: Question Analysis, Schema Selection, Query Planning, SQL Generation, SQL Refinement, and SQL Validation. The goal is to expose critical reasoning checkpoints instead of treating SQL generation as one monolithic step. The scientific question is not whether a multi-agent system ``looks'' more elaborate, but whether explicit decomposition improves robustness under a fixed evaluation protocol.

The system is evaluated on Spider 1.0---a large-scale cross-domain Text-to-SQL benchmark with natural language questions and gold SQL spanning multiple databases, widely used to assess generalization and cross-schema reasoning in NL2SQL systems. Because the official Spider 1.0 submission server is no longer operational, the system is evaluated only on the Spider 1.0 development set. The 6-step pipeline achieves 77.8\% Exact Match (EM) and 85.6\% Execution Accuracy (EX), outperforming a 4-step baseline with 73.7\% EM and 81.2\% EX. This supports the claim that explicit planning and refinement improve query quality and reduce structural errors, although the current study does not fully separate decomposition effects from additional inference budget.

In this conference version, full-development-set results for the proposed 6-step pipeline are reported for a mixed-model variant locked before writing the paper (model assignment and parameters: Table~\ref{tab:repro}; aligned with the 6-step pipeline's \texttt{agents.yaml}).

The main contributions are:
\begin{itemize}
  \item It formulates NL2SQL as a six-step pipeline with explicit reasoning checkpoints for analysis, schema grounding, planning, generation, refinement, and validation.
  \item It provides a full-development-split comparison between a reduced 4-step baseline and the full 6-step pipeline under the same evaluation protocol, with a transparent description of per-pipeline model assignment (Section~\ref{sec:exp}).
  \item It analyzes difficulty-level behavior and recurring logged error patterns to show where architectural benefits are most plausible.
  \item It connects the architecture to business-data access and decision-support scenarios without claiming production deployment readiness.
\end{itemize}

\textbf{Venue positioning:} The paper does not aim to claim leaderboard performance on the official Spider 1.0 test set; the focus is \textbf{controlled architecture} and empirical evidence on the development split under a unified reproducible protocol.

---

## Khối 3 — Section 2 Related Work

Early Text-to-SQL systems such as Seq2SQL~\cite{ref1} and SyntaxSQLNet~\cite{ref2} established the task of translating questions into SQL. With Spider~\cite{ref3}, research shifted toward cross-domain generalization, schema linking, and multi-table reasoning. Later systems such as RAT-SQL~\cite{ref4}, BRIDGE~\cite{ref5}, and RESDSQL~\cite{ref6} improved schema-aware parsing, but most still relied on centralized generation.

LLM-based approaches expanded the design space further. Prompting systems such as DIN-SQL~\cite{ref7} and DAIL-SQL~\cite{ref8} showed that strong language models can produce competitive SQL without specialized decoders, but they still struggle with output field choice, join selection, and aggregation logic. More recent decomposition-oriented systems push this direction further: SGU-SQL~\cite{ref15} combines structure-aware linking with syntax-guided subtask decomposition, while ReCAPAgent-SQL and its SSEV variant~\cite{ref16} combine planning, critique, self-refinement, and voting-style repair to improve execution performance.

Another line of work focuses on explicit reasoning, self-correction, and multi-agent coordination. Reflexion~\cite{ref9} and CRITIC~\cite{ref10} illustrate the value of critique stages, while AutoGen~\cite{ref11}, LangChain~\cite{ref13}, and CrewAI~\cite{ref14} support task decomposition through cooperating agents. Robustness-oriented systems such as DIVER~\cite{ref17} further introduce dynamic value linking and evidence reasoning through interactive tool use, especially for harder real-world settings beyond standard benchmarks. In parallel, practical enterprise-focused systems such as Tursio~\cite{ref18} emphasize context graphs, query rewriting, and production-minded structured-data search rather than benchmark-only optimization. We also note constrained decoding methods such as PICARD~\cite{ref12}, which improve output validity from a different angle than our decomposition strategy, and newer Spider-oriented systems such as SGU-SQL~\cite{ref15} and SSEV / ReCAPAgent-SQL~\cite{ref16}, which report strong dev-set results through structure-aware decomposition, refinement, and execution-guided repair. Our paper is closest in spirit to decomposition-based LLM NL2SQL systems, but it emphasizes explicit reasoning checkpoints and a matched internal comparison between reduced and full pipelines rather than a broad claim of benchmark leadership.

Because prior studies often differ in backbone models, prompting strategies, and evaluation splits, numeric comparisons with prior work in this paper are contextual only, not apples-to-apples evidence.

*(Nếu bạn dùng `\cite{zhong2017seq2sql}` thay vì ref1, hãy đồng bộ với file `.bib` ở Khối 12.)*

---

## Khối 4 — Section 3 Proposed Architecture (§3.1–3.4)

### 3.1 Overview

The proposed system decomposes NL2SQL into six sequential stages:
\begin{enumerate}
  \item Question Analysis
  \item Schema Selection
  \item Query Planning
  \item SQL Generation
  \item SQL Refinement
  \item SQL Validation
\end{enumerate}

Data flow between agents is illustrated in Figure~\ref{fig:pipeline} (diagrammatic only; model assignment details: Table~\ref{tab:repro}). The \textbf{4-step baseline} uses the same inputs (question + raw schema) but \textbf{drops the planning and refinement stages}, i.e., it follows \emph{Analysis $\rightarrow$ Schema $\rightarrow$ SQL Generation $\rightarrow$ Validation}. The \textbf{6-step pipeline} inserts \emph{Query Planning} before SQL generation and \emph{Refinement} immediately after the initial SQL, so the path from natural language to SQL remains sequential; the difference is that two intermediate reasoning stages are separated rather than collapsed into one generation pass.

\textbf{Steps 5 and 6 (refinement vs.\ validation):} In the reported implementation, orchestration is a \textbf{single forward pass} with no multi-round self-critique loop (Section~\ref{sec:impl}). \textbf{Refinement} performs \textbf{one pass} of local semantic repair on the generated SQL, conditioned on analysis, filtered schema, and plan---it does \textbf{not} restart the cycle (e.g., it does not rerun the Planner or Generator) when an error is detected. \textbf{Validation} is a technical/syntax and schema-consistency check; the output is either \textbf{accepted SQL} or an \textbf{error report}---incorrect SQL is \textbf{not} treated as the final product, and the locked evaluation configuration does \textbf{not} trigger a full end-to-end pipeline retry.

Each agent handles a separate decision subproblem. The Question Analyzer extracts intent and expected output fields. The Schema Selector reduces schema noise. The Query Planner builds a logical plan before SQL is written. The SQL Generator produces initial SQL, the SQL Refiner performs one pass of semantic repair, and the SQL Validator checks technical consistency at the schema level and SQL executability.

The underlying hypothesis is simple: NL2SQL errors are easier to control when critical reasoning steps are made explicit rather than compressed into one generation pass.

### Hình pipeline (TikZ — dán vào preamble: `\usepackage{tikz}` và `\usetikzlibrary{positioning,arrows.meta}` nếu cần)

Dán Figure~\ref{fig:pipeline} bằng đoạn sau (chỉnh scale nếu tràn trang):

```latex
\begin{figure}[t]
  \centering
  \small
  \begin{tikzpicture}[
    node distance=6mm and 8mm,
    box/.style={rectangle, draw, rounded corners, minimum width=2.6cm, minimum height=7mm, align=center, font=\scriptsize},
    arr/.style={-{Stealth}, thick}
  ]
    \node[box] (Q) {NL question};
    \node[box, right=of Q] (S0) {Raw schema};
    \node[box, below=8mm of Q, xshift=1.8cm] (A) {1.\ Question Analysis};
    \node[box, below=of A] (B) {2.\ Schema Selection};
    \node[box, below=of B] (C) {3.\ Query Planning};
    \node[box, below=of C] (D) {4.\ SQL Generation};
    \node[box, below=of D] (E) {5.\ SQL Refinement};
    \node[box, below=of E] (F) {6.\ SQL Validation};
    \node[box, below=of F] (OUT) {Final SQL or error};
    \draw[arr] (Q) -- (A);
    \draw[arr] (S0) |- (A);
    \draw[arr] (A) -- (B) -- (C) -- (D) -- (E) -- (F) -- (OUT);
  \end{tikzpicture}
  \caption{Six-step pipeline (single forward pass). Baseline 4-step omits Query Planning and SQL Refinement.}
  \label{fig:pipeline}
\end{figure}
```

*(Nếu template không có TikZ, xuất hình PNG từ draw.io và dùng `\includegraphics`.)*

### 3.2 Agent Roles — Table~\ref{tab:agents}

See Table~\ref{tab:agents}.

### 3.3 Design Rationale

The architecture targets three common error groups: wrong output fields, weak logical planning, and unrepaired semantic mistakes after initial SQL generation. Accordingly, field prediction is isolated early, planning is separated from SQL writing, and refinement is limited to one pass. We compare a reduced 4-step baseline without the Planner and Refiner against the full 6-step pipeline to study whether these explicit checkpoints are associated with more robust behavior under a fixed protocol.

### 3.4 Implementation Notes
\label{sec:impl}

The system uses fixed structured prompts in a modular multi-agent workflow. Each agent receives the natural language question, a schema representation, and relevant intermediate outputs from earlier stages. All experiments use deterministic decoding with temperature set to 0. At the implementation level, each agent prompt is fixed across four components: role description, structured input, reasoning/schema-consistency constraints, and output format. Orchestration is sequential in a single forward pass, with no voting, self-consistency, or multi-round self-critique loops.

For the full Spider 1.0 development-set results reported in this paper, the evaluated configuration is fixed as follows:
\begin{itemize}
  \item Question Analyzer: GPT-4o
  \item Schema Selector: Gemini 2.5 Flash
  \item Query Planner: GPT-4o
  \item SQL Generator: GPT-4o
  \item SQL Refiner: GPT-4o
  \item SQL Validator: Gemini 2.5 Flash
\end{itemize}

This is the primary mixed-model variant used for full-development-set 6-step results in this paper. Internal benchmark runs with homogeneous model assignments (all Gemini 2.5 Flash, all GPT-4o, all Claude Sonnet 4, all Claude Opus 4) were less favorable on the accuracy--cost trade-off than the mixed configuration above. The selected configuration reflects a pragmatic division of labor: GPT-4o covers structural reasoning and SQL generation--repair stages (Analyzer, Planner, Generator, Refiner), where internal benchmarks showed greater stability; Gemini 2.5 Flash handles schema filtering and final validation to balance cost and API-call latency.

---

## Khối 5 — Bảng 1 (Agent roles)

```latex
\begin{table}[t]
  \caption{Summary of the proposed six-step architecture.}
  \label{tab:agents}
  \centering
  \small
  \begin{tabular}{p{2.2cm}p{2.4cm}p{2.4cm}p{3.8cm}}
    \hline
    Component & Input & Output & Main role \\
    \hline
    Question Analyzer & Question, raw schema & Intent analysis, expected output fields & Determines what the query should return \\
    Schema Selector & Analysis, raw schema & Filtered schema & Reduces irrelevant tables and columns \\
    Query Planner & Analysis, filtered schema & Logical execution plan & Organizes joins, filters, grouping, and set logic \\
    SQL Generator & Analysis, filtered schema, plan & Initial SQL & Produces executable SQL \\
    SQL Refiner & Initial SQL, analysis, schema, plan & Refined SQL & Repairs local semantic mistakes \\
    SQL Validator & Refined SQL, filtered schema & Final SQL or error report & Checks syntax and schema consistency \\
    \hline
  \end{tabular}
\end{table}
```

*(Đổi `\hline` thành `\toprule`/`\midrule`/`\bottomrule` nếu template dùng `booktabs`.)*

---

## Khối 6 — Section 4 Experimental Setup
\label{sec:exp}

### 4.1 Dataset and Metrics

We evaluate on Spider 1.0~\cite{ref3}, a standard cross-domain Text-to-SQL benchmark. Following current practice after the official Spider 1.0 evaluation server was closed, we report results on the development split, which contains 1,034 questions across 20 databases.

\textbf{Difficulty} (Easy / Medium / Hard / Extra) is assigned per question by the \texttt{eval\_hardness} function in the Spider evaluation script (\texttt{experiments/test-suite-sql-eval/evaluation.py}, same protocol as~\cite{ref3}): difficulty is \textbf{inferred from the structure of the reference (gold) SQL} (counts of syntactic components such as joins, grouping, set operations, etc.), not from an external label we added outside SQL. Table~\ref{tab:difficulty} labels the hardest group \textbf{Extra Hard} to match common display conventions; in the script log the corresponding level is \textbf{extra}.

We use two standard metrics: Exact Match (EM), which measures structural equivalence to the reference SQL, and Execution Accuracy (EX), which measures whether the predicted query returns the same result as the gold query.

\textbf{Statistical note:} With \texttt{temperature = 0} and deterministic orchestration (Table~\ref{tab:repro}), each configuration requires only \textbf{one} full evaluation pass over 1,034 questions; we do not report bootstrap confidence intervals because there is no LLM sampling randomness in this setup. (API variability or model-version drift remains a threat to reliability---see Section~\ref{sec:limits}.)

### 4.2 Compared Configurations

To clarify the value of each layer of reasoning decomposition, the paper reports four groups of configurations under the same evaluation protocol:
\begin{itemize}
  \item baseline single-pass: direct prompting and chain-of-thought prompting
  \item baseline 4-step pipeline: Question Analysis $\rightarrow$ Schema Selection $\rightarrow$ SQL Generation $\rightarrow$ SQL Validation
  \item two 5-step ablations: dropping Query Planner or dropping SQL Refiner, respectively
  \item proposed 6-step pipeline: Question Analysis $\rightarrow$ Schema Selection $\rightarrow$ Query Planning $\rightarrow$ SQL Generation $\rightarrow$ SQL Refinement $\rightarrow$ SQL Validation
\end{itemize}

For the 6-step pipeline and the 5-step ablations in Table~\ref{tab:main}, per-agent model assignment matches Section~\ref{sec:impl} and Table~\ref{tab:repro} (GPT-4o for Question Analyzer, Query Planner, SQL Generator, and SQL Refiner; Gemini 2.5 Flash for Schema Selector and SQL Validator). The 4-step baseline in the same tables follows the default 4-step pipeline configuration in the codebase: Claude Sonnet 4 for Question Analyzer, Gemini 2.5 Flash for Schema Selector and SQL Validator, GPT-4o for SQL Generator. The two single-prompt baselines in Table~\ref{tab:main} use GPT-4o for the SQL generation call. Thus, the 4-step vs.\ 6-step comparison keeps the same evaluation protocol and dev split but does \textbf{not} fix the same backbone at the Question Analysis step; the discussion and limitations acknowledge this when interpreting architectural gaps.

Accordingly, Table~\ref{tab:main} does not mix ``planned'' rows with ``executed'' rows; every configuration in the table is from a completed evaluation run. Within the pipeline group, the main architectural contrast remains the 4-step baseline versus the full 6-step system; the two 5-step variants are included as intermediate ablations to isolate the contributions of the Planner and Refiner.

### 4.3 Reproducibility — Table~\ref{tab:repro}

See Table~\ref{tab:repro}.

---

## Khối 7 — Bảng 2 (Reproducibility)

```latex
\begin{table}[t]
  \caption{Implementation and reproducibility summary for the locked mixed-model 6-step configuration on the full development set (aligned with \texttt{agents.yaml} in the codebase). The 4-step baseline in Tables~\ref{tab:main}--\ref{tab:difficulty} uses a separate model assignment, as stated in Section~\ref{sec:exp}.}
  \label{tab:repro}
  \centering
  \scriptsize
  \begin{tabular}{p{3.6cm}p{9.5cm}}
    \hline
    Item & Value \\
    \hline
    Agent configuration (proposed 6-step) & GPT-4o for Question Analyzer, Query Planner, SQL Generator, and SQL Refiner; Gemini 2.5 Flash for Schema Selector and SQL Validator \\
    Mixed-model rationale & GPT-4o for structural reasoning and SQL generation--repair; Gemini 2.5 Flash for schema filtering and final validation to balance cost and API latency in internal benchmarks \\
    Temperature & 0 \\
    Top-p / sampling & No additional tuning beyond temperature $=0$; other sampling parameters fixed at provider API defaults and unchanged across compared configurations \\
    Max output tokens & 2048 \\
    Model access & Hosted API calls: Gemini 2.5 Flash, GPT-4o, and (for the 4-step baseline, Question Analyzer) Claude Sonnet 4; no fine-tuning and no self-hosted models \\
    Schema representation & Structured Spider schema (tables, columns, keys); filtered sub-schema passed to downstream agents \\
    Schema filtering policy & Keep tables and columns directly linked to entities, filter predicates, joins, and expected output fields extracted by the Analyzer \\
    Prompting policy & One fixed template per agent; only the question, schema, and per-example intermediate outputs change \\
    Orchestration details & Sequential single pass: each agent's output is structured input to the next; no voting, self-consistency, or multi-round loops \\
    Number of runs & One full evaluation pass over 1,034 questions per reported configuration; with temperature $=0$, the pipeline runs in an application-level deterministic mode \\
    Evaluation protocol & Official Spider evaluation script (EM / EX on SQLite) \\
    Implementation stack & Modular multi-agent workflow (CrewAI-style orchestration) coordinating hosted API calls in a fixed agent order \\
    \hline
  \end{tabular}
\end{table}
```

---

## Khối 8 — Bảng 3 (Main results)

```latex
\begin{table}[t]
  \caption{Main internal comparison across prompting variants and pipeline configurations.}
  \label{tab:main}
  \centering
  \begin{tabular}{lcc}
    \hline
    Configuration & EM (\%) & EX (\%) \\
    \hline
    Single-prompt system (direct SQL) & 71.4 & 79.0 \\
    Single-prompt system (chain-of-thought) & 72.6 & 80.0 \\
    4-step baseline & 73.7 & 81.2 \\
    5-step without Planner & 75.0 & 82.6 \\
    5-step without Refiner & 76.1 & 83.9 \\
    \textbf{6-step proposed} & \textbf{77.8} & \textbf{85.6} \\
    \hline
  \end{tabular}
\end{table}
```

---

## Khối 9 — Section 5 (đoạn văn 5.1–5.7) + Bảng 4–8

### Đoạn sau Table~\ref{tab:main}

On the rows of Table~\ref{tab:main}, the proposed 6-step system improves over the reduced 4-step baseline by 4.1 EM points and 4.4 EX points. This is consistent with the claim that planning separates logical reasoning from SQL surface realization and that refinement provides a controlled semantic correction layer after initial generation.

At the same time, this evidence should be read conservatively. The present results support the usefulness of decomposition under a fixed protocol, but they do not yet fully isolate whether the gain comes from better stage design, from additional inference budget, or from both.

### 5.2 — Table~\ref{tab:difficulty}

Table~\ref{tab:difficulty} breaks down full-development-set results by Spider difficulty (dataset-native labels). The largest improvement appears in the Hard group, where the 6-step pipeline improves EX by 9.2 points and EM by 9.2 points over the 4-step baseline.

```latex
\begin{table}[t]
  \caption{Full Spider 1.0 development-set results by difficulty.}
  \label{tab:difficulty}
  \centering
  \small
  \begin{tabular}{lcccccc}
    \hline
    Difficulty & \#Ex. & 4-St.\ EX & 4-St.\ EM & 6-St.\ EX & 6-St.\ EM \\
    \hline
    Easy & 248 & 76.6 & 69.0 & 81.9 & 72.2 \\
    Medium & 446 & 83.4 & 75.8 & 86.3 & 79.1 \\
    Hard & 174 & 78.2 & 70.7 & 87.4 & 79.9 \\
    Extra Hard & 166 & 85.5 & 78.3 & 87.3 & 80.1 \\
    \textbf{All} & \textbf{1,034} & \textbf{81.2} & \textbf{73.7} & \textbf{85.6} & \textbf{77.8} \\
    \hline
  \end{tabular}
\end{table}
```

The difficulty breakdown sharpens the main claim. Improvements are not limited to easy cases; they are strongest where query structure is more fragile, especially when joins, grouping, or set operations are involved.

### 5.3 — Table~\ref{tab:lit}

```latex
\begin{table}[t]
  \caption{Contextual comparison against selected Spider references and recent decomposition-oriented systems.}
  \label{tab:lit}
  \centering
  \scriptsize
  \begin{tabular}{p{3.8cm}ccp{4.2cm}}
    \hline
    System & EM (\%) & EX (\%) & Split / note \\
    \hline
    PICARD + T5-3B~\cite{ref12} & 70.6 & 75.7 & Commonly cited Spider reference \\
    RESDSQL + NatSQL~\cite{ref6} & 76.7 & 78.2 & Commonly cited Spider reference \\
    DIN-SQL + Codex~\cite{ref7} & 57.0 & 78.0 & Prompt-based literature reference \\
    SGU-SQL~\cite{ref15} & 78.3 & 88.0 & Reported Spider-dev (structure-guided) \\
    SSEV / ReCAPAgent-SQL~\cite{ref16} & --- & 85.5 & Reported Spider-dev EX (refinement/voting) \\
    4-step baseline (this work) & 73.7 & 81.2 & Spider 1.0 dev, 1,034 questions \\
    \textbf{6-step proposed (this work)} & \textbf{77.8} & \textbf{85.6} & Spider 1.0 dev, 1,034 questions \\
    \hline
  \end{tabular}
\end{table}
```

Under that caveat, the proposed system appears competitive with strong reported references while being motivated by architectural control rather than a claim of state-of-the-art benchmark leadership.

### 5.4 — Table~\ref{tab:errors}

To keep the evidence tied to the same full-development-set runs, we inspected recurring phenomena in the non-exact-match predictions from both pipelines. The log contains \textbf{272} non-exact-match cases for the 4-step baseline and \textbf{230} for the 6-step system, consistent with the EM gap in Table~\ref{tab:main}. On this error set, we performed a manual diagnostic audit using a fixed rubric of surface-visible error signatures observable directly from generated SQL and execution outcomes. Labels in Table~\ref{tab:errors} are therefore descriptive evidence to support architectural interpretation, not an independent labeling scheme aimed at strong statistical inference. Counts are \textbf{not mutually exclusive} because a single prediction can exhibit multiple issues; percentages use each pipeline's non-EM total as the denominator.

```latex
\begin{table}[t]
  \caption{Error taxonomy from non-exact-match predictions on full Spider 1.0 dev.}
  \label{tab:errors}
  \centering
  \scriptsize
  \begin{tabular}{p{3.2cm}ccccp{3.5cm}}
    \hline
    Error group & 4-cnt & 4-\% & 6-cnt & 6-\% & Interpretation \\
    \hline
    Subquery wrapper & 47 & 17.3 & 47 & 20.4 & Wrappers persist in both \\
    \texttt{LIMIT 0} & 37 & 13.6 & 27 & 11.7 & Reduced in 6-step \\
    Redundant \texttt{CROSS JOIN} & 28 & 10.3 & 19 & 8.3 & Planner/Refiner help \\
    Predicate-flip risk & 30 & 11.0 & 18 & 7.8 & Reduced, not eliminated \\
    Extra output column & 12 & 4.4 & 4 & 1.7 & Better in 6-step \\
    \hline
  \end{tabular}
\end{table}
```

### 5.5 — Table~\ref{tab:qual}

```latex
\begin{table}[t]
  \caption{Illustrative qualitative cases (shortened).}
  \label{tab:qual}
  \centering
  \scriptsize
  \begin{tabular}{cp{3.5cm}p{3.8cm}p{3.8cm}}
    \hline
    ID & Question (short) & Pattern & One-sentence analysis \\
    \hline
    1 & Movie titles with ratings \textbf{both} 3 and 4 stars & 4-step uses \texttt{OR}; gold uses \texttt{INTERSECT} & Shorter pipelines can flatten intersect semantics \\
    2 & Airlines from a specific source airport & Predicate flip (\texttt{=} vs.\ \texttt{!=}) & Some errors persist despite decomposition \\
    3 & Documents not using a template & \texttt{LIMIT 0} / wrappers & Residual errors in post-generation formatting \\
    \hline
  \end{tabular}
\end{table}
```

### 5.6 Practical Implications

From an application perspective, the results support multi-agent LLM pipelines for natural language access to structured data. Although the evaluation is conducted on Spider rather than on an enterprise dataset, this architectural pattern matters for analytics settings where users need reliable access to relational data without writing SQL. The main practical implication is improved controllability for analytics and decision-support workflows rather than immediate production deployment readiness.

### 5.7 — Table~\ref{tab:cost}

```latex
\begin{table}[t]
  \caption{Cost and latency profile by configuration.}
  \label{tab:cost}
  \centering
  \scriptsize
  \begin{tabular}{lccccccc}
    \hline
    System & Tokens/ex. & API & Rel.\ cost & p50 (s) & p90 (s) & EX (\%) & $\Delta$EX \\
    \hline
    Single-prompt direct & 3,450 & 1 & 1.00x & 2.8 & 4.9 & 79.0 & --- \\
    Single-prompt CoT & 4,080 & 1 & 1.18x & 3.3 & 5.6 & 80.0 & +1.0 \\
    4-step baseline & 6,180 & 4 & 1.79x & 6.4 & 10.8 & 81.2 & +2.2 \\
    5-step w/o Planner & 7,520 & 5 & 2.18x & 8.1 & 13.5 & 82.6 & +3.6 \\
    5-step w/o Refiner & 8,410 & 5 & 2.44x & 9.1 & 15.1 & 83.9 & +4.9 \\
    6-step proposed & 9,460 & 6 & 2.74x & 10.7 & 17.9 & 85.6 & +6.6 \\
    \hline
  \end{tabular}
\end{table}
```

---

## Khối 10 — Section 6 Limitations
\label{sec:limits}

The paper intentionally limits itself to Spider 1.0 development-set evaluation. This is a practical choice because the official Spider 1.0 submission server is no longer open and because Spider offers complete gold SQL, executable databases, and a stable official evaluation script for a controlled study under limited resources. However, this choice also limits direct comparison with older papers that emphasized official test-set reporting. In addition, the literature references in Table~\ref{tab:lit} are only contextual because backbone models, prompting recipes, and evaluation conditions are not fully matched.

The present study also does not fully disentangle architectural decomposition from additional inference budget. The 6-step pipeline uses more stages than the 4-step baseline, so a stronger causal claim would require cost-matched ablations, direct cost logging, and latency analysis from the same rerun package. The 4-step vs.\ 6-step comparison in Tables~\ref{tab:main}--\ref{tab:difficulty} is also coupled with a different backbone at the Question Analysis step (Claude Sonnet 4 vs.\ GPT-4o), so part of the gap may reflect model synergy beyond the presence or absence of the Planner and Refiner. \textbf{Priority follow-up experiment:} run the 4-step baseline with the \textbf{same} GPT-4o at Question Analyzer (other steps unchanged from the baseline codebase) on the \textbf{same} 1,034 questions and protocol---to isolate the Planner/Refiner effect. The mixed-model configuration also introduces an architecture--model synergy confound, although our internal benchmarking favored the current assignment over homogeneous all-Flash, all-GPT-4o, all-Sonnet 4, and all-Opus 4 options. Additional diagnostic analysis by \texttt{SELECT} components (e.g., field-selection error rates within execution-failure sets) can be added in an extended version.

The work should therefore be read as a controlled dev-set architectural study rather than a new official leaderboard claim or an enterprise deployment study. Stronger future validation would include matched intermediate ablations, explicit cost and latency reporting, and evaluation on newer or robustness-focused benchmarks such as BIRD-dev, DR.Spider, Spider-DK, and Spider 2.0-lite.

---

## Khối 11 — Section 7 Conclusion

This paper presented a six-step multi-agent architecture for NL2SQL that separates question understanding, schema reduction, logical planning, SQL generation, refinement, and validation. On the Spider 1.0 development set, the proposed 6-step pipeline achieved 77.8\% Exact Match and 85.6\% Execution Accuracy, outperforming a reduced 4-step baseline under the same protocol.

The 6-step results correspond to the locked mixed-model variant (Table~\ref{tab:repro}).

Overall, the results indicate that explicit reasoning decomposition is a promising design choice for improving robustness and controllability in Text-to-SQL generation. For a business-and-technology venue, the contribution is best understood as evidence for a practical NL2SQL architecture for analytics and decision-support settings, not as a broad claim of benchmark dominance or production readiness.

---

## Khối 12 — References (BibTeX mẫu)

Tạo file `references.bib` trong Overleaf và dán các entry sau (chỉnh key `\cite{...}` trong các khối trên cho thống nhất, ví dụ `zhong2017seq2sql` thay cho `ref1`):

```bibtex
@article{zhong2017seq2sql,
  title={Seq2SQL: Generating Structured Queries from Natural Language Using Reinforcement Learning},
  author={Zhong, Victor and Xiong, Caiming and Socher, Richard},
  journal={arXiv preprint arXiv:1709.00103},
  year={2017}
}
@inproceedings{yu2018syntaxsqlnet,
  title={Syntax{SQL}Net: Syntax Tree Networks for Complex and Cross-Domain Text-to-{SQL} Task},
  author={Yu, Tao and Li, Zifan and Zhang, Zilin and Zhang, Rui and Radev, Dragomir},
  booktitle={EMNLP},
  year={2018}
}
@inproceedings{yu2018spider,
  title={Spider: A Large-Scale Human-Labeled Dataset for Complex and Cross-Domain Semantic Parsing and Text-to-{SQL} Task},
  author={Yu, Tao and others},
  booktitle={EMNLP},
  year={2018}
}
% ... (bổ sung đủ 18 tham chiếu từ conference-ready-12.md — có thể dùng Google Scholar → BibTeX)
```

**Gợi ý:** Trong Overleaf, menu *Project* → upload `references.bib`; trong `main.tex` thêm `\bibliography{references}` và `\bibliographystyle{...}` theo template Springer.

---

## Checklist nhanh Overleaf

1. [ ] Điền tên tác giả, affiliation, email theo template.
2. [ ] Dán Abstract + Keywords.
3. [ ] `\input{sections/...}` hoặc dán từng section theo Khối 2--11.
4. [ ] Thay placeholder `\cite{ref1}` bằng key BibTeX thật.
5. [ ] Biên dịch: **pdfLaTeX → BibTeX → pdfLaTeX ×2** (nếu dùng `.bib`).
6. [ ] Kiểm tra nhãn bảng/hình (`\ref`) sau khi đổi thứ tự.

---

*Tệp nguồn văn bản: `report/conference-ready-12.md`.*
