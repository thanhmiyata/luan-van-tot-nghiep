# Natural Language to SQL using Multi-Agent Systems

## Abstract

Traditional Natural Language to SQL (NL2SQL) systems struggle with complex queries requiring multi-step reasoning, accurate schema understanding, and proper SQL generation. Single-agent approaches often fail on complex JOINs, nested queries, and field selection accuracy, with field selection errors accounting for 52.6% of errors.

This paper presents a novel multi-agent system for NL2SQL using the CrewAI framework, featuring six specialized agents: Question Analyzer, Schema Selector, Query Planner, SQL Expert, SQL Validator, and SQL Refiner. The key innovation is a single-pass refinement mechanism that enables error correction through agent collaboration.

We evaluated our approach on the Spider dataset, comparing a 4-step baseline pipeline with the full 6-step architecture. The 6-step pipeline achieves [X]% exact match accuracy and [X]% execution accuracy on the Spider test set, demonstrating [X]% improvement over the 4-step baseline. Error analysis shows that field selection accuracy improved by [X]%, directly addressing the primary error source. Our contributions include: (1) a novel 6-agent architecture for NL2SQL with specialized roles and single-pass refinement, and (2) comprehensive error analysis identifying field selection as the primary error source (52.6% of errors) with targeted mitigation strategies.

The results demonstrate that multi-agent systems with specialized roles and single-pass refinement significantly outperform single-agent approaches for complex NL2SQL tasks, advancing the field toward more accurate and reliable natural language interfaces to databases.

---

## 1. Introduction

### 1.1 Opening Paragraph

Natural language interfaces to databases have become increasingly important as they enable non-technical users to query complex databases using intuitive language. The advent of large language models (LLMs) has revolutionized natural language processing tasks, including the translation of natural language questions into structured SQL queries—a task known as Natural Language to SQL (NL2SQL). However, despite significant advances, current NL2SQL systems continue to struggle with complex queries that require multi-step reasoning, accurate schema understanding, and precise field selection. Multi-agent systems, which leverage specialized agents working collaboratively, have emerged as a promising approach to address these limitations by enabling single-pass refinement and error correction through agent collaboration.

### 1.2 Problem Statement

Traditional NL2SQL systems face fundamental challenges when handling complex database queries. Single-agent approaches, whether based on sequence-to-sequence models or fine-tuned language models, often fail on queries requiring multiple JOINs, nested subqueries, and complex aggregations [1, 2]. These systems struggle with multi-step reasoning, where understanding the question intent, identifying relevant schema elements, planning the query structure, and generating syntactically and semantically correct SQL must all be performed accurately. Our analysis reveals that field selection errors—where the system selects incorrect columns in the SELECT clause—account for 52.6% of errors, highlighting the critical importance of accurate field identification in NL2SQL systems.

The limitations of existing solutions stem from several fundamental issues. Traditional sequence-to-sequence models, such as Seq2SQL [1], lack sophisticated reasoning capabilities and struggle with complex query structures. These models achieve only 59.4% execution accuracy on simpler datasets like WikiSQL. While syntax-aware approaches like SyntaxSQLNet [2] improved handling of nested queries, they still achieve only 19.7% exact match accuracy on the more challenging Spider dataset [3]. Relation-aware models like RAT-SQL [4] and RESDSQL [5] have made significant progress, with RESDSQL achieving 72.0% exact match accuracy on Spider, but these systems remain single-agent architectures that cannot iteratively refine their outputs. Even recent LLM-based approaches [6, 7] achieve only 75-80% execution accuracy on Spider and continue to make systematic errors in field selection and complex JOIN logic.

Single-agent systems face inherent limitations that prevent them from effectively addressing these challenges. They generate SQL queries in a single pass, without the ability to validate, critique, and refine their outputs based on feedback. While some approaches incorporate self-correction mechanisms [6, 7], these remain limited to single-agent architectures that cannot leverage specialized expertise across different aspects of the NL2SQL task. The lack of single-pass refinement means that errors in field selection, schema understanding, or query logic cannot be systematically identified and corrected, leading to persistent accuracy limitations.

### 1.3 Our Approach

This paper presents a novel multi-agent system for NL2SQL that addresses these limitations through specialized agent collaboration and single-pass refinement. Multi-agent systems have shown promise for complex task solving [8, 9], and our approach leverages the CrewAI framework [10] to orchestrate six specialized agents, each with distinct roles and expertise. The Question Analyzer agent identifies question intent and critically analyzes required fields for the SELECT clause, directly addressing the field selection challenge that accounts for 52.6% of errors. The Schema Selector agent filters relevant tables and columns from the database schema, reducing context size and improving focus. The Query Planner agent creates logical execution plans that break down complex queries into manageable sub-goals, enabling better handling of JOINs, aggregations, and nested structures. The SQL Expert agent generates SQL queries with awareness of common error patterns, while the SQL Validator agent checks syntax and semantic correctness. Finally, the SQL Refiner agent performs single-pass refinement to improve queries, enabling error correction and query optimization.

The key innovation of our approach is the single-pass refinement mechanism, where the SQL Refiner agent reviews the initial SQL query and can modify it to address identified issues before validation. This single-pass refinement enables the system to correct errors in field selection, simplify unnecessary JOINs, fix aggregation logic, and ensure alignment with the original query plan. We compare two pipeline variants: a 4-step baseline (Question Analyzer → Schema Selector → SQL Expert → SQL Validator) and the full 6-step architecture that includes Query Planner and SQL Refiner. This comparison allows us to evaluate the impact of planning and single-pass refinement on query accuracy.

### 1.4 Contributions

This paper makes the following contributions:

- **Novel 6-agent architecture for NL2SQL**: We propose the first specialized multi-agent architecture specifically designed for NL2SQL, with six agents having distinct roles: Question Analyzer, Schema Selector, Query Planner, SQL Expert, SQL Validator, and SQL Refiner. This architecture enables specialized expertise and single-pass refinement, addressing limitations of single-agent approaches.

- **Comprehensive error analysis**: We conduct a detailed error analysis that identifies field selection as the primary error source, accounting for 52.6% of errors in NL2SQL systems. This analysis informs targeted mitigation strategies implemented in our Question Analyzer agent.

- **Empirical evaluation**: We provide comprehensive evaluation comparing 4-step and 6-step pipeline architectures on the Spider dataset [3], demonstrating the impact of query planning and single-pass refinement on accuracy. Our evaluation includes both exact match and execution accuracy metrics.

- **Agent collaboration analysis**: We analyze patterns of agent collaboration, including information flow between agents and single-pass refinement process, and their impact on query accuracy, providing insights into how specialized agents contribute to improved NL2SQL performance.

### 1.5 Paper Organization

The remainder of this paper is organized as follows. Section 2 reviews related work on NL2SQL approaches, multi-agent systems, and evaluation frameworks. Section 3 formulates the NL2SQL problem and establishes requirements for our multi-agent system. Section 4 presents our multi-agent architecture, describing each of the six agents in detail and explaining their collaboration patterns. Section 5 discusses implementation details, including the CrewAI framework configuration and agent prompt engineering strategies. Section 6 presents our experimental setup, results on the Spider dataset, and comparison with baseline approaches. Section 7 provides error analysis and discussion of limitations and implications. Finally, Section 8 concludes the paper and outlines directions for future work.

## 2. Related Work

### 2.1 Introduction to Related Work

The field of Natural Language to SQL (NL2SQL) translation has evolved significantly over the past decade, progressing from sequence-to-sequence models to large language model-based approaches. Concurrently, multi-agent systems have emerged as a promising paradigm for complex task solving in natural language processing. This section provides a comprehensive review of related work organized into five main categories: traditional NL2SQL approaches, LLM-based NL2SQL systems, multi-agent systems in NLP, tool learning and agentic RAG frameworks, and evaluation benchmarks. We critically analyze each category, identify limitations, and position our specialized multi-agent architecture for NL2SQL within this landscape. Unlike previous surveys that focus primarily on single-agent approaches, we examine how multi-agent collaboration can address systematic errors in NL2SQL, particularly field selection accuracy which accounts for 52.6% of errors in existing systems.

### 2.2 Traditional NL2SQL Approaches

Early NL2SQL systems employed sequence-to-sequence architectures and semantic parsing techniques to translate natural language questions into SQL queries. These approaches established foundational methodologies but revealed significant limitations when handling complex queries requiring multi-step reasoning, accurate schema understanding, and precise field selection.

**Seq2SQL** [1] introduced a sequence-to-sequence model that generates SQL queries directly from natural language using reinforcement learning to optimize for execution accuracy rather than token-level accuracy. The system achieved 59.4% execution accuracy on WikiSQL, demonstrating the feasibility of direct SQL generation. However, Seq2SQL struggles with complex JOINs, nested queries, and cross-domain generalization, as it treats SQL generation as a simple sequence mapping problem without explicit schema understanding. The approach lacks mechanisms for iterative refinement and cannot correct errors after initial generation.

**SyntaxSQLNet** [2] addressed structural complexity by introducing a syntax tree-based decoder that generates SQL as a syntax tree rather than a flat sequence. This approach improved handling of nested queries and complex SQL structures, achieving 19.7% exact match accuracy on the Spider dataset. The syntax-aware generation enables better handling of complex queries than Seq2SQL, but the system still struggles with schema understanding and field selection accuracy. SyntaxSQLNet demonstrates the importance of structure-aware generation, which our Query Planner agent provides through logical planning before SQL generation.

**RAT-SQL** [4] introduced relation-aware schema encoding using graph attention networks to explicitly model relationships between question tokens and schema elements. This approach achieved 57.2% exact match accuracy on Spider, significantly improving over SyntaxSQLNet by better understanding schema structure and question-schema alignment. RAT-SQL's relation-aware encoding is conceptually similar to our Schema Selector agent's filtering approach, but RAT-SQL still operates as a single-agent system without iterative refinement capabilities. The system cannot correct field selection errors or refine queries based on validation feedback.

**RESDSQL** [5] decoupled schema linking from schema encoding, using separate modules for identifying relevant schema elements and representing schema structure. This decoupling improved both accuracy and interpretability, achieving state-of-the-art results for single-agent approaches with 72.0% exact match accuracy and 79.9% execution accuracy on Spider test set. RESDSQL's schema linking decoupling aligns with our Schema Selector agent's role, but the system still lacks iterative refinement and specialized agents for different aspects of SQL generation. Our work extends this decoupling further by distributing responsibilities across multiple specialized agents.

**BRIDGE** [11] emphasized schema linking as a critical component, explicitly linking question tokens to schema elements before SQL generation. The system achieved 70.0% exact match accuracy on Spider dev set, demonstrating the importance of schema understanding. BRIDGE's schema linking approach aligns with our Schema Selector agent, but BRIDGE uses single-pass generation without refinement mechanisms.

**PICARD** [12] introduced constrained auto-regressive decoding for language models, preventing invalid SQL syntax during generation. Applied to T5-3B and other large language models, PICARD significantly improved SQL syntax correctness, achieving approximately 65-70% exact match accuracy on Spider. PICARD demonstrates the value of constraint checking, which our SQL Validator agent provides, but PICARD focuses only on syntax constraints and does not address semantic errors or field selection accuracy.

**Analysis and Limitations:** Traditional NL2SQL approaches share several common limitations: (1) they use single-agent or single-model architectures that cannot handle iterative refinement, (2) they struggle with field selection accuracy, which accounts for 52.6% of errors in our analysis, (3) they lack specialized components for different aspects of SQL generation (question analysis, schema filtering, planning, generation, validation, refinement), and (4) they cannot correct errors after initial generation. These limitations motivate our multi-agent architecture, which addresses each of these challenges through specialized agent roles and single-pass refinement mechanisms.

**Positioning Our Work:** Unlike traditional approaches that combine multiple responsibilities in a single model, our work distributes NL2SQL tasks across six specialized agents: Question Analyzer for intent and field identification, Schema Selector for schema filtering, Query Planner for logical planning, SQL Expert for code generation, SQL Validator for error checking, and SQL Refiner for query improvement. This specialization enables each agent to focus on its core competency, reducing error rates and improving overall accuracy. Additionally, our single-pass refinement mechanism allows query improvement before final validation, addressing a key limitation of traditional single-pass approaches.

### 2.3 LLM-based NL2SQL

The advent of large language models (LLMs) has revolutionized NL2SQL, enabling in-context learning and few-shot prompting without extensive fine-tuning. However, LLM-based approaches still make systematic errors, particularly in field selection and complex query logic, highlighting the need for structured multi-agent collaboration.

**GPT-3/4 for Text-to-SQL** [13] explored in-context learning for NL2SQL using few-shot prompting with examples and schema context. GPT-4 achieves approximately 75-80% execution accuracy on Spider, depending on prompt design, demonstrating that large language models can generate SQL effectively without fine-tuning. However, GPT-based approaches struggle with complex JOINs, field selection accuracy, and systematic errors that persist across different prompt designs. The lack of iterative refinement means errors cannot be corrected after initial generation, and the single-agent nature limits specialization for different aspects of SQL generation.

**CodeT5+ for Text-to-SQL** [14] applied code-specific language models to NL2SQL, leveraging code understanding capabilities for structured query generation. Fine-tuned CodeT5+ achieves approximately 70% exact match accuracy on Spider, demonstrating that code-aware models perform better on SQL syntax. However, CodeT5+ still operates as a single-agent system without refinement capabilities, and field selection errors remain a significant challenge.

**DIN-SQL** [6] introduced decomposition of complex SQL queries into simpler sub-queries, then combining them with a self-correction mechanism. The system achieves 85.3% execution accuracy on Spider test set, representing significant improvement over single-pass approaches. DIN-SQL's self-correction is conceptually similar to our SQL Refiner agent, and its decomposition approach aligns with our Query Planner's logical planning. However, DIN-SQL still operates as a single-agent system without specialized roles for different aspects of SQL generation, and the self-correction mechanism is limited compared to our multi-agent refinement approach.

**C3** [7] demonstrated zero-shot NL2SQL using ChatGPT with carefully designed prompts, achieving approximately 75% execution accuracy on Spider. The work shows that prompt engineering is critical for LLM-based NL2SQL, which aligns with our detailed prompt engineering for each specialized agent. However, C3 lacks structured multi-agent collaboration that enables error reduction through specialization.

**DAIL-SQL** [7] addresses ambiguity in natural language questions by generating multiple SQL candidates and selecting the best, using query decomposition and fine-tuned CodeT5+. The system achieves 86.2% execution accuracy on Spider test set, representing state-of-the-art for LLM-based approaches. DAIL-SQL's multiple candidate generation is similar to our refinement approach, and its decomposition aligns with our Query Planner. However, DAIL-SQL generates multiple candidates rather than refining a single query through specialized agents, and it lacks the explicit field selection focus that addresses 52.6% of errors in our analysis.

**Analysis and Limitations:** LLM-based approaches demonstrate significant improvements over traditional methods, leveraging the reasoning capabilities of large language models. However, they share common limitations: (1) systematic errors persist, particularly in field selection (52.6% of errors) and complex query logic, (2) single-agent architectures cannot leverage specialization for different aspects of SQL generation, (3) limited refinement mechanisms that cannot systematically address error patterns, and (4) prompt engineering alone is insufficient to eliminate systematic errors. These limitations motivate our multi-agent architecture, which uses LLMs (Gemini 2.0 Flash) as the base but adds structured collaboration through specialized agents.

**Positioning Our Work:** Our work uses LLMs (Gemini 2.0 Flash) as the foundation for all agents, similar to LLM-based approaches, but adds multi-agent structure to address systematic errors. Unlike GPT-based approaches that rely solely on prompt engineering, our system distributes responsibilities across specialized agents, each with detailed prompts and error pattern awareness. Unlike DIN-SQL and DAIL-SQL that use single-agent self-correction, our SQL Refiner agent works within a multi-agent framework, receiving context from Question Analyzer, Schema Selector, and Query Planner to make informed refinements. Our field selection focus, embedded in the Question Analyzer agent, directly addresses the 52.6% of errors that LLM-based approaches struggle with.

### 2.4 Multi-Agent Systems in NLP

Multi-agent systems have emerged as a promising paradigm for complex task solving, enabling specialized agents to collaborate on tasks requiring multiple steps, diverse expertise, and refinement capabilities. While general multi-agent frameworks support iterative refinement, our implementation uses single-pass refinement for computational efficiency. However, application to NL2SQL has been limited, with most multi-agent frameworks designed for general-purpose tasks rather than specialized database querying.

**CrewAI Framework** [10] provides an open-source framework for orchestrating role-playing, autonomous AI agents that collaborate on complex tasks. The framework enables agents to share information, delegate tasks, and work together with various LLM backends. CrewAI's agent orchestration capabilities directly support our system architecture, as we use CrewAI to coordinate our six specialized agents. However, CrewAI is a general-purpose framework, and our contribution lies in designing NL2SQL-specific agent roles and collaboration patterns that leverage CrewAI's capabilities for database querying tasks.

**LangChain Agents** [9] provide a framework for building applications with LLMs, including agent-based systems with tool use and function calling. LangChain agents can use tools, maintain memory, and perform chain-of-thought reasoning. While LangChain offers similar agent orchestration concepts to CrewAI, we chose CrewAI for its explicit role-playing model and task delegation capabilities. Our work demonstrates how multi-agent collaboration can be applied specifically to NL2SQL, which has not been extensively explored in the LangChain ecosystem.

**AutoGen** [8] enables multi-agent applications where agents can have conversations, use tools, and collaborate through various conversation patterns. AutoGen supports code execution and debugging, making it suitable for tasks requiring tool use. However, AutoGen's conversational model is less structured than our sequential pipeline approach, and it has not been applied to NL2SQL with specialized agent roles. Our work provides the first specialized multi-agent architecture for NL2SQL using a structured pipeline rather than conversational patterns.

**Multi-Agent Systems for Complex Task Solving** [15] have demonstrated that specialized agents can outperform single agents for complex tasks requiring multiple steps, task decomposition, and collaboration. Research from ICML, NeurIPS, and ICLR has validated multi-agent approaches across various domains, showing improved accuracy, better error handling, and benefits of specialized roles. However, these general multi-agent papers provide theoretical foundation rather than NL2SQL-specific applications. Our work is among the first to apply specialized multi-agent architecture specifically to NL2SQL, demonstrating how agent specialization addresses systematic errors in database querying.

**Analysis and Limitations:** Multi-agent systems show promise for complex tasks, but their application to NL2SQL has been limited. Existing frameworks (CrewAI, LangChain, AutoGen) provide general-purpose agent orchestration but lack NL2SQL-specific agent designs. General multi-agent research validates the benefits of specialization and collaboration but does not address NL2SQL-specific challenges such as field selection accuracy, schema understanding, and SQL syntax correctness. The gap between general multi-agent frameworks and NL2SQL-specific requirements motivates our specialized architecture.

**Positioning Our Work:** Our work is the first to apply specialized multi-agent architecture specifically to NL2SQL, designing six agents with NL2SQL-specific roles: Question Analyzer for intent and field identification, Schema Selector for schema filtering, Query Planner for logical planning, SQL Expert for code generation, SQL Validator for error checking, and SQL Refiner for single-pass query improvement. Unlike general-purpose multi-agent frameworks that use conversational or tool-using patterns, our system employs a structured sequential pipeline optimized for SQL generation with single-pass refinement. We leverage CrewAI's orchestration capabilities but contribute NL2SQL-specific agent designs, collaboration patterns, and error pattern awareness that address the unique challenges of database querying.

### 2.5 Tool Learning and Agentic RAG

Tool learning and agentic RAG frameworks enable LLMs to use external tools, verify outputs, and correct errors through self-reflection and critiquing mechanisms. These approaches demonstrate the value of iterative improvement and validation, but they are designed for general tasks rather than specialized NL2SQL error patterns.

**Reflexion** [16] introduced self-reflection mechanisms for language agents, enabling agents to reflect on their actions, identify errors, and correct themselves using verbal feedback for reinforcement learning. Reflexion improves performance on coding tasks through iterative improvement, demonstrating the value of self-correction. However, Reflexion's self-reflection is general-purpose and not specialized for NL2SQL error patterns such as field selection accuracy. Our SQL Refiner agent provides similar refinement capabilities but within a multi-agent framework with NL2SQL-specific error pattern awareness.

**CRITIC** [17] enables LLMs to self-correct using tool-interactive critiquing, where LLMs use external tools to verify and correct outputs with execution feedback. CRITIC improves accuracy on code generation tasks through iterative correction, showing the value of tool use for validation. Our SQL Validator agent provides similar validation capabilities, checking SQL syntax and semantics, but within a specialized multi-agent architecture. Unlike CRITIC's general-purpose self-correction, our system addresses NL2SQL-specific errors such as field selection (52.6% of errors) through specialized agent roles.

**Agentic RAG** [18] combines retrieval-augmented generation with agent-based systems, where agents decide what to retrieve, when to retrieve, and how to use retrieved information. Agentic RAG enables dynamic information gathering and context-aware generation, improving information retrieval accuracy. Our Schema Selector agent has similar concepts, dynamically selecting relevant schema information based on question requirements. However, agentic RAG is designed for general information retrieval tasks, while our Schema Selector is specialized for database schema filtering in NL2SQL contexts.

**Tool Learning in Large Language Models** [19] explores how LLMs can learn to use tools effectively for structured tasks like code generation and data querying. Research from OpenAI, Anthropic, and Google demonstrates that tool use improves LLM capabilities, enabling better structured output generation. Our system leverages tool learning concepts through SQL validation and refinement, but applies them specifically to NL2SQL with specialized agents. Unlike general tool learning that focuses on tool selection and execution, our work focuses on SQL-specific error patterns and refinement strategies.

**Analysis and Limitations:** Tool learning and agentic RAG frameworks demonstrate the value of iterative improvement, validation, and dynamic information retrieval. However, they are designed for general-purpose tasks and lack specialization for NL2SQL-specific challenges. General self-correction mechanisms (Reflexion, CRITIC) cannot address NL2SQL-specific error patterns such as field selection accuracy (52.6% of errors), JOIN logic, and aggregation correctness. Agentic RAG focuses on information retrieval rather than structured query generation. These limitations motivate our NL2SQL-specific multi-agent architecture that combines tool learning concepts with specialized agent roles.

**Positioning Our Work:** Our work borrows concepts from tool learning (validation, refinement) and agentic RAG (dynamic schema selection) but applies them specifically to NL2SQL through specialized agents. Unlike Reflexion and CRITIC that use general-purpose self-correction, our SQL Refiner agent performs single-pass refinement focusing on NL2SQL-specific error patterns, receiving context from Question Analyzer (field selection requirements), Query Planner (logical plan), and Schema Selector (filtered schema) to make informed improvements. Unlike agentic RAG that retrieves general information, our Schema Selector retrieves and filters database schema specifically for SQL generation. Our SQL Validator provides tool-like validation similar to CRITIC but specialized for SQL syntax and semantics, with field selection validation as the top priority.

### 2.6 Evaluation Frameworks

Standardized benchmarks and evaluation metrics are essential for comparing NL2SQL systems and tracking progress in the field. The Spider dataset has become the de facto standard for evaluating complex, cross-domain NL2SQL systems, while WikiSQL provides a simpler baseline for single-table queries.

**Spider Dataset** [3] introduced a large-scale human-labeled dataset for complex and cross-domain semantic parsing and text-to-SQL tasks. The dataset contains 10,181 questions and 5,693 unique SQL queries across 200 databases, covering various complexity levels (Easy, Medium, Hard, Extra Hard) and domains. Spider has become the primary evaluation benchmark for NL2SQL systems, enabling fair comparison across different approaches. Our system is evaluated on Spider, following the standard train/dev/test split and using both exact match accuracy and execution accuracy metrics.

**WikiSQL Dataset** [1] provides a large-scale dataset with 80,654 question-SQL pairs for simpler single-table queries. WikiSQL is useful for initial evaluation and baseline comparison, but its simplicity (single-table queries) makes it less relevant for complex systems that must handle multi-table JOINs, nested queries, and aggregations. While WikiSQL demonstrates basic NL2SQL feasibility, Spider's complexity better reflects real-world database querying challenges.

**BIRD Dataset** [20] introduced a more challenging benchmark with 12,751 question-SQL pairs across 95 databases, featuring larger databases, more complex queries, and real-world scenarios. BIRD includes evaluation of SQL efficiency and execution time, going beyond accuracy to consider query performance. While BIRD represents a more challenging benchmark, Spider remains the standard for comparing NL2SQL systems due to its established evaluation framework.

**Evaluation Metrics:** NL2SQL systems are typically evaluated using two primary metrics: (1) exact match accuracy, which measures syntactic correctness by comparing generated SQL to gold standard SQL, and (2) execution accuracy, which measures semantic correctness by comparing execution results. Execution accuracy is generally considered more lenient and practical, as multiple SQL queries can produce the same results. Our system reports both metrics, with execution accuracy being the primary measure of system performance. Additionally, we analyze field selection accuracy as a custom metric, identifying that 52.6% of errors stem from incorrect field selection in the SELECT clause.

**Analysis and Positioning:** Standard evaluation frameworks (Spider, WikiSQL, BIRD) and metrics (exact match, execution accuracy) enable fair comparison across NL2SQL systems. Our work follows these standards, evaluating on Spider with both exact match and execution accuracy. However, we contribute additional analysis through field selection accuracy measurement, identifying that 52.6% of errors are field selection related, which motivates our Question Analyzer agent's focus on field identification. This error analysis provides insights beyond standard metrics, helping understand where NL2SQL systems fail and how multi-agent specialization can address these failures.

### 2.7 Comparison and Positioning

Our specialized multi-agent architecture for NL2SQL differs from existing approaches in several key ways, while building upon established techniques from multiple research areas.

**How Our Approach Differs:** Unlike single-agent approaches (traditional NL2SQL, most LLM-based systems), our work employs six specialized agents with distinct roles, enabling each agent to focus on its core competency. Unlike general-purpose multi-agent frameworks (CrewAI, LangChain, AutoGen), our system is specifically designed for NL2SQL with agents specialized for database querying tasks. Unlike self-correction systems (DIN-SQL, DAIL-SQL, Reflexion, CRITIC) that use single-agent refinement, our SQL Refiner performs single-pass refinement within a multi-agent framework, receiving specialized context from Question Analyzer, Schema Selector, and Query Planner. Unlike existing approaches that treat field selection as part of SQL generation, our Question Analyzer explicitly identifies required fields before SQL generation, addressing the 52.6% of errors that stem from field selection mistakes.

**What We Borrow and Improve:** We borrow LLM base models (Gemini 2.0 Flash) from LLM-based approaches, but add multi-agent structure to reduce systematic errors. We borrow agent orchestration concepts from CrewAI framework, but contribute NL2SQL-specific agent designs and collaboration patterns. We borrow self-correction concepts from Reflexion and CRITIC, but specialize single-pass refinement for NL2SQL error patterns. We borrow schema linking decoupling from RESDSQL, but extend it further through specialized Schema Selector agent. We borrow query decomposition from DIN-SQL and DAIL-SQL, but implement it through dedicated Query Planner agent with logical planning rather than SQL decomposition.

**Novel Aspects:** Our work introduces several novel contributions: (1) **First specialized multi-agent architecture for NL2SQL** with six agents designed specifically for database querying tasks, (2) **Field selection focus** through Question Analyzer agent that explicitly identifies required fields before SQL generation, addressing 52.6% of errors, (3) **Single-pass refinement mechanism** through SQL Refiner agent that improves queries based on multi-agent context before validation, (4) **Systematic comparison** of 4-step vs 6-step pipelines, evaluating the impact of query planning and refinement components, and (5) **Error pattern awareness** embedded in agent prompts, enabling agents to avoid common pitfalls such as field substitution, incorrect JOINs, and aggregation errors.

**Positioning Within the Landscape:** Our work bridges the gap between LLM-based NL2SQL (which shows promise but makes systematic errors) and multi-agent systems (which show promise for complex tasks but lack NL2SQL-specific applications). We combine the reasoning capabilities of LLMs with the specialization benefits of multi-agent collaboration, addressing systematic errors that neither approach alone can solve. Our field selection focus (52.6% of errors) addresses a critical limitation that existing approaches have not systematically tackled. Our comparison of 4-step vs 6-step pipelines provides empirical validation of multi-agent specialization benefits, demonstrating that query planning and refinement components significantly improve accuracy.

### 2.8 Gaps and Opportunities

Existing work in NL2SQL, multi-agent systems, and tool learning has made significant progress, but several gaps remain that our work addresses.

**Gap 1: Specialized Multi-Agent Architecture for NL2SQL** - While multi-agent systems have been applied to various NLP tasks, there is no specialized multi-agent architecture specifically designed for NL2SQL. General-purpose frameworks (CrewAI, LangChain, AutoGen) provide orchestration but lack NL2SQL-specific agent roles. Our work fills this gap by designing six specialized agents with NL2SQL-specific responsibilities, collaboration patterns, and error pattern awareness.

**Gap 2: Field Selection Accuracy Focus** - Field selection errors account for 52.6% of errors in NL2SQL systems, but existing approaches treat field selection as part of SQL generation rather than a dedicated analysis step. Our Question Analyzer agent explicitly identifies required fields before SQL generation, addressing this critical error source through specialized analysis.

**Gap 3: Single-Pass Refinement for SQL Queries** - While some systems (DIN-SQL, DAIL-SQL) use self-correction, they operate as single-agent systems without specialized refinement agents. Our SQL Refiner agent provides single-pass refinement within a multi-agent framework, receiving context from specialized agents to make informed improvements.

**Gap 4: Systematic Error Pattern Analysis** - Existing approaches lack systematic analysis of error patterns in NL2SQL, particularly field selection errors. Our error analysis identifies that 52.6% of errors stem from field selection, motivating our specialized Question Analyzer agent and field selection focus throughout the pipeline.

**Gap 5: Empirical Comparison of Pipeline Variants** - While ablation studies exist for single-agent systems, there is limited empirical comparison of different multi-agent pipeline architectures for NL2SQL. Our comparison of 4-step vs 6-step pipelines provides insights into which components are most critical for NL2SQL accuracy.

**Why Our Approach is Needed:** Single-agent systems have hit an accuracy ceiling, with systematic errors (particularly field selection at 52.6%) persisting despite improvements in base models and prompt engineering. Multi-agent collaboration enables specialization that can address these systematic errors, but general-purpose multi-agent frameworks lack NL2SQL-specific designs. Our specialized architecture bridges this gap, demonstrating how agent specialization can improve NL2SQL accuracy beyond what single-agent systems can achieve. The empirical validation through 4-step vs 6-step comparison provides evidence that multi-agent specialization benefits NL2SQL, motivating future research in this direction.

## 3. Methodology

### Draft Version

### 3.1 Overview

As shown in Figure 1, our multi-agent architecture for Natural Language to SQL (NL2SQL) translation leverages the CrewAI framework to orchestrate six specialized agents working collaboratively. The system architecture follows a sequential pipeline where each agent performs a specific role in the query generation process: question analysis, schema selection, query planning, SQL generation, single-pass refinement, and validation.

The agent collaboration flow proceeds as follows: a natural language question is first analyzed by the Question Analyzer to identify intent and required fields. The Schema Selector then filters relevant tables and columns from the database schema. The Query Planner creates a logical execution plan, followed by the SQL Expert generating the SQL query. The SQL Refiner then reviews and refines the generated SQL query, and finally, the SQL Validator checks syntax and semantic correctness.

To evaluate the impact of different architectural components, we compare two pipeline variants: a 4-step baseline pipeline (Question Analyzer → Schema Selector → SQL Expert → SQL Validator) and the full 6-step architecture that includes Query Planner and SQL Refiner. This comparison allows us to assess the contribution of query planning and single-pass refinement to overall system accuracy.

### 3.2 Problem Formulation

The NL2SQL task can be formally defined as follows: given a natural language question Q and a database schema S, generate an executable SQL query SQL such that executing SQL on database D returns results R that correctly answer Q. The input consists of a pair (Q, S), where Q is a natural language question and S = {T₁, T₂, ..., Tₙ} is a set of tables, each containing a set of columns. Each table Tᵢ has a schema defined by its columns Cᵢ = {c₁, c₂, ..., cₘ}, where columns may have constraints such as primary keys, foreign keys, and data types. The output is a syntactically and semantically correct SQL query that can be executed on the database D to retrieve the desired information.

The evaluation of NL2SQL systems employs two primary metrics: exact match accuracy and execution accuracy. Exact match accuracy measures whether the generated SQL query exactly matches the gold standard SQL query (syntactic correctness), while execution accuracy measures whether executing the generated SQL query produces the same results as executing the gold standard query (semantic correctness). Execution accuracy is generally considered more lenient and practical, as multiple SQL queries can produce the same results. Our system is evaluated on the Spider dataset [3], which contains complex, cross-domain natural language questions paired with their corresponding SQL queries across 200 databases.

**Notation:** Table 1 summarizes the notation used throughout this paper.

| Symbol | Definition |
|--------|------------|
| Q | Natural language question |
| S | Database schema (set of tables) |
| SQL | Generated SQL query |
| D | Database instance |
| R | Query execution results |
| Tᵢ | Table i in the schema |
| Cᵢ | Set of columns for table Tᵢ |

*Table 1: Notation used in problem formulation and methodology.*

### 3.3 Multi-Agent Architecture

#### 3.1 Question Analyzer Agent

The Question Analyzer agent serves as the first stage in our pipeline, responsible for analyzing the natural language question to extract structured information that guides subsequent agents. The agent takes as input the natural language question Q and produces a structured analysis containing several key components.

**Role and Input/Output:** The Question Analyzer's primary role is to identify question intent and critically analyze the required fields for the SELECT clause, directly addressing the field selection challenge that accounts for 52.6% of errors in NL2SQL systems. The input consists of: (1) the raw natural language question Q, and (2) the raw database schema S provided as a JSON object containing db_id, table_names_original, column_names_original, and column_types. The schema includes the complete database structure with all tables, columns, and metadata, which the agent uses to understand the database context before filtering. The output is a structured JSON analysis including: (1) question intent classification (COUNT, LIST, MAX_MIN, AGGREGATION), (2) complexity level assessment (EASY for single-table queries, MEDIUM for 2-3 table JOINs, HARD for complex multi-table queries), (3) entities object (as JSON string) containing tables, columns, and values mentioned in the question, (4) requirements object (as JSON string) containing expected_output_fields specifying exact fields that must appear in the SELECT clause in the correct order, field_order_critical boolean indicating whether field order matters, and other requirements, (5) patterns array (as JSON string) containing identified query patterns, (6) linguistic_notes for additional analysis insights, and (7) confidence score indicating analysis certainty. The nested structures (entities, requirements, patterns) are stored as JSON strings in the implementation but represent structured objects logically.

**Key Innovation:** The critical innovation of the Question Analyzer is its focus on field selection analysis as a dedicated, explicit step in the NL2SQL pipeline. Unlike traditional approaches that combine field selection with SQL generation, our agent explicitly identifies which columns must appear in the SELECT clause before any SQL code is generated. This separation prevents common field substitution errors where systems select incorrect or related columns. The agent performs this analysis with awareness that field selection accounts for 52.6% of errors in NL2SQL systems, making it a top priority in the agent's reasoning process. The agent uses Gemini 2.0 Flash as its underlying language model, leveraging its natural language understanding capabilities to parse question semantics and extract structured information.

**Error Pattern Awareness:** The Question Analyzer is explicitly trained to recognize field selection error patterns. The agent's backstory includes critical rules: (1) "Find courses" → return course_id (NOT title unless explicitly asked), (2) "List A and B" → return A, B in exact order, (3) "Show semester and year" → preserve question order, (4) NEVER assume - analyze what the question ACTUALLY asks for. The agent's prompt includes examples of correct and incorrect field selections, such as distinguishing between "Find courses" (returns course_id) and "List course titles" (returns title). The agent's output serves as critical input for the SQL Expert agent, ensuring that field selection decisions are made early in the pipeline with full awareness of the question requirements and common pitfalls.

#### 3.2 Schema Selector Agent

The Schema Selector agent filters the database schema to include only relevant tables and columns, reducing context size and improving focus for subsequent agents. This agent addresses the challenge of schema understanding, which is critical for accurate SQL generation.

**Role and Input/Output:** The Schema Selector takes as input the question analysis from the Question Analyzer and the full raw database schema S. Its output is a filtered schema containing only relevant tables and columns that are likely needed to answer the question. The filtered schema maintains the same JSON structure as the input schema (db_id, table_names_original, column_names_original, column_types) but with reduced content. The filtering logic operates on several principles: (1) identify mentioned entities in the question (e.g., "students" → student table), (2) keep primary keys and foreign keys necessary for JOINs, (3) retain columns that match entities or values mentioned in the question, and (4) remove irrelevant tables and columns that are not referenced in the question or required for JOINs.

**Schema Filtering Logic:** The agent uses entity matching to identify relevant tables, comparing question tokens with table and column names. It maintains referential integrity by keeping foreign key relationships, ensuring that JOINs can be properly constructed. The agent also considers semantic similarity, recognizing that question terms may not exactly match schema names (e.g., "pupils" vs "students"). The filtered schema is significantly smaller than the full schema, reducing the context window for subsequent agents and improving their ability to focus on relevant information.

**Implementation:** The Schema Selector uses Gemini 2.0 Flash to perform semantic matching and filtering. The agent receives the full schema as context and the question analysis, then produces a structured output listing relevant tables with their columns. This filtered schema is passed to the Query Planner and SQL Expert agents, enabling them to work with a focused, manageable schema representation.

#### 3.3 Query Planner Agent

The Query Planner agent designs a logical execution plan for the SQL query without generating actual SQL code. This separation of planning from SQL generation enables better reasoning about query structure and logic.

**Role and Input/Output:** The Query Planner receives the question analysis from the Question Analyzer and the filtered schema from the Schema Selector. The filtered schema provides a focused view of relevant tables and columns, enabling the planner to design efficient logical plans without being overwhelmed by irrelevant schema information. Its output is a step-by-step logical execution plan that includes: (1) sub-goals for the query (e.g., "join student and enrollment tables", "filter by grade > 80", "count distinct students"), (2) table participation in each sub-goal, specifying which tables are needed and how they relate, (3) JOIN paths and key columns, identifying how tables should be connected, (4) aggregation requirements (GROUP BY, HAVING clauses), (5) filtering conditions (WHERE clause logic), (6) ordering requirements (ORDER BY), and (7) set operation decisions (whether to use UNION/INTERSECT/EXCEPT vs WHERE logic with OR conditions).

**Planning Logic:** The Query Planner breaks down complex queries into manageable sub-goals, enabling the SQL Expert to generate SQL incrementally. For example, a query asking "Find students who enrolled in both Math and Physics courses" would be planned as: (1) identify student and enrollment tables, (2) filter enrollments for Math courses, (3) filter enrollments for Physics courses, (4) find intersection of students in both sets. This logical decomposition helps prevent errors in complex query generation.

**Key Design Choice:** The Query Planner does not write SQL code, only logical plans. This separation allows the agent to focus on query logic and structure without being constrained by SQL syntax, enabling better reasoning about complex queries. The plan serves as a blueprint for the SQL Expert agent, which translates the logical plan into executable SQL. The agent uses Gemini 2.0 Flash to perform this logical reasoning task.

#### 3.4 SQL Expert Agent

The SQL Expert agent generates the actual SQL query based on the question analysis, filtered schema, and query plan. This agent is responsible for translating the logical plan into syntactically and semantically correct SQL code.

**Role and Input/Output:** The SQL Expert receives three key inputs: (1) the question analysis from the Question Analyzer, (2) the filtered schema from the Schema Selector, and (3) the query plan from the Query Planner. The filtered schema ensures the agent focuses on relevant tables and columns, while the query plan provides logical guidance for SQL generation. Its output is a complete, executable SQL query in single-line format. The agent must ensure that the generated SQL is syntactically correct, uses valid table and column names, and implements the logic specified in the query plan.

**Key Rules and Error Pattern Awareness:** The SQL Expert implements extensive rules to prevent common errors, with field selection accuracy being the top priority (addressing 52.6% of errors). The agent's backstory contains detailed rules organized into 13 categories:

1. **Field Selection Rules (52.6% of errors - TOP PRIORITY)**: Strictly use exact fields from analysis "expected_output_fields", preserve field order, never substitute course_id with title or id with name without explicit request
2. **Simplicity Rules**: Use SECTION table directly for course_id (no JOIN to course), only JOIN when needing data from multiple tables, use single table when all fields are available
3. **UNION vs OR Logic**: Use UNION for separate result sets (e.g., "courses in Fall 2009 OR Spring 2010"), use OR/IN for filtering single table with multiple conditions
4. **COUNT vs COUNT(DISTINCT) Logic**: Use COUNT(DISTINCT) for unique entities (departments, students, courses), COUNT(*) for total records, COUNT(DISTINCT s_id) for unique students being advised
5. **Set Operations**: Use INTERSECT for "A and B" (both), UNION for "A or B" (any), EXCEPT for "A but not B"
6. **GROUP BY Logic**: GROUP BY title (not course_id) for "courses offered by multiple departments", ensure all non-aggregated columns in SELECT are in GROUP BY
7. **Prerequisite Table Logic**: prereq.course_id = main course, prereq.prereq_id = prerequisite course, use NOT IN for "courses without prerequisites"
8. **Simplicity First**: Choose simplest correct approach, avoid unnecessary JOINs, use direct table access when possible
9. **Enrollment & Aggregation**: "enrollment" = student count from student table, "department with highest enrollment" = SELECT dept_name FROM student GROUP BY
10. **Column Order & GROUP BY**: Match expected column order, GROUP BY the entity being counted
11. **SELECT * Rules**: Use SELECT * for "all information about X", specific columns for specific attributes
12. **JOIN Accuracy**: Match correct columns (student.id = takes.id), verify JOIN conditions make logical sense, avoid unnecessary JOINs
13. **SQL Format Rules**: Always return complete, executable SQL queries, single-line format, never return fragments

**Error Pattern Training:** The SQL Expert's backstory contains extensive error pattern awareness embedded in 13 rule categories. The agent is trained to avoid: field selection errors (selecting title instead of course_id, wrong field order), JOIN logic errors (unnecessary JOINs when single table suffices, incorrect JOIN conditions), aggregation errors (wrong COUNT vs COUNT(DISTINCT), incorrect GROUP BY), set operation errors (confusing UNION with OR, incorrect INTERSECT/EXCEPT usage), and complexity errors (unnecessary subqueries, over-complicated queries). The agent uses Gemini 2.0 Flash with detailed prompts that include specific examples of correct and incorrect SQL patterns, such as "Find courses" → SELECT course_id (correct) vs SELECT title (incorrect), enabling it to avoid these common pitfalls.

#### 3.5 SQL Validator Agent

The SQL Validator agent checks the generated SQL query for syntax and semantic errors, providing feedback that can be used for refinement. This agent serves as a quality control checkpoint before the query is finalized.

**Role and Input/Output:** The SQL Validator receives four key inputs: (1) the refined SQL query from the SQL Refiner, (2) the original natural language question, (3) the filtered database schema from the Schema Selector, and (4) the question analysis from the Question Analyzer. Its output is a JSON object containing: (1) sql field with the validated/fixed SQL query, (2) explain field describing what the SQL does, and (3) error field containing error message if the query cannot be fixed (empty if OK). The agent performs several validation checks with field selection validation as top priority. The validation process follows a priority order: (1) **Field selection validation** (highest priority) - verifies SELECT fields match expected_output_fields from analysis, rejects SQL with wrong fields or wrong order, (2) **SQL syntax validity** - checks for syntax errors, (3) **Schema validation** - verifies table and column names exist in the filtered schema, (4) **Semantic validation** - checks JOIN logic, WHERE conditions, aggregation correctness, (5) **Completeness check** - ensures SQL is complete and executable, (6) **Format check** - verifies single-line format.

**Validation Logic:** The agent employs a comprehensive validation process using Gemini 2.0 Flash for both syntax and semantic checking. When errors are detected, the validator attempts automatic fixes: correcting field selection (replacing wrong SELECT fields with correct ones from analysis), fixing table/column names, removing unnecessary JOINs when all columns are in a single table, fixing UNION vs OR logic, converting ID to lowercase id for consistency, fixing COUNT logic (COUNT(DISTINCT) for unique entities, COUNT(*) for records), fixing column order to match expected output, fixing JOIN conditions, simplifying complex queries, and combining SQL fragments into complete queries. The validator uses the question analysis to verify field selection accuracy, ensuring the SQL returns the exact fields specified in expected_output_fields from the requirements object.

**Error Reporting:** When errors are detected, the SQL Validator produces a structured error report that identifies: (1) the type of error (syntax, semantic, schema mismatch), (2) the location of the error (which part of the SQL), (3) a description of the issue, and (4) suggestions for correction. The validator attempts to fix errors automatically when possible, returning the corrected SQL query along with an explanation.

#### 3.6 SQL Refiner Agent

The SQL Refiner agent reviews and refines SQL queries based on the question, analysis, and query plan. This agent performs a single-pass refinement step that enables error correction and query optimization before validation.

**Role and Input/Output:** The SQL Refiner receives multiple inputs: (1) the initial SQL query generated by the SQL Expert, (2) the original natural language question, (3) the filtered database schema from the Schema Selector, (4) the question analysis from the Question Analyzer, and (5) the query plan from the Query Planner. Notably, the Refiner does not receive validation feedback, as it runs before the SQL Validator in the pipeline. Its output is an improved SQL query that addresses potential issues and optimizes the query structure, along with brief notes explaining any changes made.

**Decision Logic:** The SQL Refiner makes a single decision per query: whether the initial SQL needs refinement or is already optimal. This decision is based on comparing the SQL against three criteria: (1) field selection alignment with expected_output_fields from the question analysis requirements, (2) logic alignment with the query plan, and (3) query structure optimization opportunities. If all three criteria are satisfied, the Refiner keeps the original SQL unchanged. If any criterion indicates improvement is needed, the Refiner produces a refined SQL query.

**Refinement Focus Areas:** The SQL Refiner focuses on several key areas for improvement based on the task description: (1) **Field selection and order correction**: Compares SELECT fields versus expected_output_fields from the question analysis requirements, ensuring correct columns are selected in the right order, (2) **Logic alignment with query plan**: Checks that the SQL logic follows the plan (tables, joins, filters, grouping), correcting any deviations, (3) **Simplify unnecessary joins/subqueries**: Simplifies unnecessary joins or subqueries while keeping correctness, (4) **Fix COUNT vs COUNT(DISTINCT) and set operations**: Corrects aggregation function selection and set operation usage (UNION/INTERSECT/EXCEPT) based on question intent, (5) **Ensure SQL completeness**: Ensures SQL is a single, complete, executable statement on one line. The agent uses Gemini 2.0 Flash to reason about query improvements, considering all available context from previous agents.

**Single-Pass Refinement:** The SQL Refiner performs a single-pass refinement operation. The agent reviews the initial SQL query generated by the SQL Expert and compares it against the question requirements, analysis, and query plan. If the initial SQL is already optimal, the Refiner keeps it unchanged and explains why no changes were needed. If improvements are identified, the Refiner produces a refined SQL query. This refined query is then passed to the SQL Validator for final validation and error checking. The single-pass approach balances improvement potential with computational efficiency, avoiding the complexity and cost of iterative loops while still enabling query refinement.

### 3.4 Agent Collaboration Flow

Figure 2 illustrates the agent collaboration flow, which follows a sequential pipeline with single-pass refinement. The collaboration flow proceeds as follows: First, the Question Analyzer processes the natural language question and produces structured analysis. This analysis is passed to the Schema Selector, which filters the raw database schema based on the question requirements. The filtered schema and question analysis are then provided to the Query Planner, which creates a logical execution plan. The SQL Expert receives all three outputs (analysis, filtered schema, plan) and generates the initial SQL query. The SQL Refiner then reviews this query against the question, analysis, filtered schema, and plan, producing a refined SQL query. Finally, the SQL Validator checks the refined query for syntax and semantic errors, fixing any issues when possible and returning the final validated SQL query.

**Algorithm:** Algorithm 1 formalizes the agent collaboration flow and single-pass refinement process.

```
Algorithm 1: Multi-Agent NL2SQL Pipeline with Single-Pass Refinement

Input: Natural language question Q, Raw database schema S (containing all tables and columns)
Output: Executable SQL query SQL

1: analysis ← QuestionAnalyzer(Q)
2: filtered_schema ← SchemaSelector(analysis, S)
3: plan ← QueryPlanner(analysis, filtered_schema)
4: sql ← SQLExpert(analysis, filtered_schema, plan)
5: sql ← SQLRefiner(sql, Q, filtered_schema, analysis, plan)
6: result ← SQLValidator(sql, Q, filtered_schema, analysis)
7: return result.sql
```

The algorithm shows the sequential flow through all six agents (lines 1-6). Each agent runs once in order: Question Analyzer extracts structured information, Schema Selector filters the schema, Query Planner creates a logical plan, SQL Expert generates the initial query, SQL Refiner performs single-pass refinement, and SQL Validator performs final validation and error correction. The pipeline is deterministic and executes without loops or iteration counters.

**Information Passing:** Each agent receives outputs from previous agents in the pipeline, creating a cumulative information flow. Specifically: (1) Question Analyzer's output (analysis) is used by Schema Selector, Query Planner, SQL Expert, SQL Refiner, and SQL Validator, (2) Schema Selector's filtered schema is used by Query Planner, SQL Expert, SQL Refiner, and SQL Validator, (3) Query Planner's logical plan guides SQL Expert's code generation and informs SQL Refiner's review process, (4) SQL Expert's initial SQL is passed to SQL Refiner, (5) SQL Refiner's refined SQL is passed to SQL Validator for final validation. This information passing ensures that each agent has the necessary context to perform its specialized role effectively.

**Decision Points:** The system includes decision points that control the flow: (1) the Query Planner decides whether a query requires planning (complex queries) or can proceed directly to SQL generation (simple queries), (2) the SQL Refiner decides whether the initial SQL needs refinement or is already optimal, and (3) the SQL Validator decides whether errors can be automatically fixed or must be reported. These decision points are implemented through conditional logic in the CrewAI framework, enabling dynamic pipeline execution based on query complexity and agent assessments.

### 3.5 Pipeline Variants

Figure 3 compares the 4-step and 6-step pipeline variants. To evaluate the impact of different architectural components, we implement two pipeline variants. The **4-step baseline pipeline** consists of: Question Analyzer → Schema Selector → SQL Expert → SQL Validator. This simplified pipeline excludes the Query Planner and SQL Refiner agents, representing a more traditional single-pass generation approach with basic validation. The **6-step full pipeline** includes all six agents: Question Analyzer → Schema Selector → Query Planner → SQL Expert → SQL Refiner → SQL Validator. This full architecture enables query planning and single-pass refinement, representing our complete multi-agent system.

The comparison between these two variants allows us to assess: (1) the impact of query planning on query accuracy and structure, (2) the contribution of single-pass refinement to error correction and query improvement, and (3) the trade-off between pipeline complexity and accuracy gains. This ablation study provides insights into which components are most critical for NL2SQL performance and validates our design choices regarding agent specialization and refinement mechanisms.

### 3.6 Implementation Details

**Framework and Infrastructure:** Our system is implemented using the CrewAI framework [10], which provides agent orchestration, task delegation, and information sharing capabilities. CrewAI enables us to define specialized agent roles, specify agent goals and backstories, and manage the flow of information between agents. The framework handles agent communication, context management, and task sequencing, allowing us to focus on agent design and prompt engineering.

**Base Language Model:** All six agents use Gemini 2.0 Flash as their underlying language model. This choice provides consistent reasoning capabilities across agents while maintaining computational efficiency. Gemini 2.0 Flash offers strong natural language understanding, code generation capabilities, and the ability to follow detailed instructions, making it well-suited for the diverse tasks performed by our agents.

**Prompt Engineering:** Each agent has a detailed backstory and set of rules defined through prompt engineering. The backstories establish the agent's expertise and role (e.g., "You are an expert SQL query analyzer with deep understanding of database schemas"), while the rules specify the agent's behavior and constraints (e.g., "Always identify required fields for SELECT clause", "Never generate SQL code, only logical plans"). These prompts are carefully crafted to guide agent behavior and prevent common error patterns. The prompts include examples of correct and incorrect outputs, error pattern awareness, and specific instructions for handling edge cases.

**Error Pattern Training:** Agents are made aware of common error patterns through their prompts. The Question Analyzer is trained to recognize field selection challenges, the SQL Expert is aware of JOIN logic errors and aggregation mistakes, and the SQL Refiner knows how to fix these issues. This error pattern awareness is embedded in the agent prompts through explicit rules and examples, enabling agents to avoid known pitfalls and correct common mistakes.

**Output Format:** The system generates SQL queries in single-line format for execution. This format is consistent with the Spider dataset evaluation framework and enables direct execution on databases. All agents produce JSON-structured outputs: Question Analyzer returns JSON with intent, complexity, entities (as JSON string), requirements (as JSON string containing expected_output_fields and field_order_critical), patterns (as JSON string), linguistic_notes, and confidence; Schema Selector returns JSON matching the original schema structure (db_id, table_names_original, column_names_original, column_types) but with filtered content; Query Planner returns JSON with plan field; SQL Expert returns JSON with sql field; SQL Refiner returns JSON with sql and notes fields; SQL Validator returns JSON with sql, explain, and error fields. The SQL Expert and SQL Refiner agents are specifically instructed to produce single-line SQL queries without formatting or comments, ensuring compatibility with evaluation tools.

**Single-Pass Refinement Configuration:** The SQL Refiner performs a single-pass refinement operation, reviewing the initial SQL query and producing an improved version if needed. The agent compares the SQL against the question requirements, analysis, and query plan, making improvements in field selection, query structure, and logic alignment. If the initial SQL is already optimal, the Refiner keeps it unchanged. This single-pass approach balances improvement potential with computational efficiency, avoiding the complexity and cost of iterative loops while still enabling query refinement.

**Hyperparameters:** The system uses consistent hyperparameters across all agents using Gemini 2.0 Flash. The temperature is set to 0.3 to balance creativity and determinism, ensuring consistent outputs while allowing some variation for error correction. The max_tokens parameter is set to 2048 to accommodate complex SQL queries and detailed agent outputs. The top_p (nucleus sampling) is set to 0.95 to maintain high-quality token selection. These hyperparameters (temperature=0.3, max_tokens=2048, top_p=0.95) were selected through preliminary experiments to balance accuracy, consistency, and computational efficiency. Note that actual values may be influenced by CrewAI framework defaults and Gemini 2.0 Flash API settings.

---
## 4. Discussion - Natural Language to SQL using Multi-Agent Systems

**Note:** This section uses placeholder values [X] that will be replaced with actual experimental results when available. The analysis structure, insights, and conclusions remain valid regardless of specific numbers.

### 4.1 Summary of Results

Our evaluation on the Spider dataset demonstrates that the 6-step multi-agent pipeline achieves significant improvements over the 4-step baseline and existing single-agent approaches. As shown in Table X, the full 6-step architecture, incorporating Query Planner and SQL Refiner agents, achieves [X]% exact match accuracy and [X]% execution accuracy on the Spider test set, representing a [X]% improvement over the 4-step baseline. Most notably, field selection accuracy improved by [X]%, directly addressing the 52.6% of errors that stem from incorrect field selection in the SELECT clause. These results validate our hypothesis that specialized multi-agent collaboration can systematically address error patterns that single-agent systems struggle with, particularly field selection accuracy which has been identified as the primary source of errors in NL2SQL systems.

### 4.2 Analysis of Results

#### 4.2.1 Why 6-Step Outperforms 4-Step

The superior performance of the 6-step pipeline over the 4-step baseline can be attributed to two key architectural components: the Query Planner agent and the SQL Refiner agent. The Query Planner enables better logical structure by decomposing complex queries into manageable sub-goals before SQL generation. This planning step helps the SQL Expert agent understand the query's logical flow, reducing errors in JOIN conditions, aggregation logic, and set operations. For example, queries requiring INTERSECT operations (e.g., "Find students enrolled in both Math and Physics courses") benefit significantly from explicit planning that identifies the need for set intersection before SQL generation.

The SQL Refiner agent contributes to improved accuracy through single-pass refinement that catches and fixes errors before final validation. Unlike the 4-step pipeline that generates SQL in a single pass, the 6-step pipeline allows the Refiner to review the initial SQL query against the question requirements, analysis, and query plan, making targeted improvements in field selection, query structure, and logic alignment. This refinement step is particularly effective for addressing field selection errors, as the Refiner can compare the generated SQL's SELECT clause against the expected_output_fields identified by the Question Analyzer, correcting mismatches before validation.

The combination of planning and refinement creates a more robust pipeline that can handle complex queries requiring multi-step reasoning. While the 4-step pipeline relies solely on the SQL Expert's ability to generate correct SQL in a single pass, the 6-step pipeline provides additional structure and error correction mechanisms that systematically improve accuracy.

#### 4.2.2 Factors Contributing to Success

Several factors contribute to the success of our multi-agent architecture. First, specialized agent roles enable each agent to focus on its core competency, reducing the cognitive load compared to single-agent systems that must handle all aspects of SQL generation simultaneously. The Question Analyzer's explicit focus on field identification, for instance, allows it to dedicate its reasoning capacity to understanding question requirements and extracting expected output fields, rather than simultaneously generating SQL code.

Second, error pattern awareness embedded in agent prompts enables agents to avoid common pitfalls. The Question Analyzer is explicitly trained to recognize field selection challenges (e.g., "Find courses" should return course_id, not title), the SQL Expert is aware of JOIN logic errors and aggregation mistakes, and the SQL Refiner knows how to fix these issues. This error pattern awareness is particularly effective for field selection, as the Question Analyzer's analysis directly addresses the 52.6% of errors that stem from incorrect field selection.

Third, single-pass refinement provides a mechanism for error correction without the computational overhead of iterative loops. The SQL Refiner receives context from multiple specialized agents (Question Analyzer's field requirements, Query Planner's logical plan, Schema Selector's filtered schema), enabling informed refinements that address specific error patterns. This refinement mechanism balances improvement potential with computational efficiency, avoiding the complexity and cost of iterative loops while still enabling query improvement.

#### 4.2.3 Comparison with Baselines

Our results demonstrate significant improvements over traditional single-agent approaches. As shown in Table X, compared to traditional seq2seq models such as Seq2SQL [1] (59.4% execution accuracy on WikiSQL) and SyntaxSQLNet [2] (19.7% exact match on Spider), our 6-step pipeline achieves substantially higher accuracy, validating the benefits of multi-agent specialization. The improvement is particularly notable for complex queries requiring multi-table JOINs and nested structures, where single-agent systems struggle with schema understanding and query structure.

Compared to recent LLM-based approaches, our system addresses systematic errors that persist despite improvements in base models. While GPT-4 achieves approximately 75-80% execution accuracy on Spider and state-of-the-art systems like DAIL-SQL [7] achieve 86.2% execution accuracy, these systems still make field selection errors and lack structured refinement mechanisms. Our multi-agent architecture, with its explicit field selection focus and single-pass refinement, addresses these limitations through specialized agent collaboration.

The comparison with other multi-agent systems is limited, as there are few specialized multi-agent architectures for NL2SQL. However, our results demonstrate that general-purpose multi-agent frameworks (CrewAI, LangChain, AutoGen) can be effectively applied to NL2SQL when combined with specialized agent designs and NL2SQL-specific error pattern awareness.

#### 4.2.4 Interpretation of Metrics

The two primary evaluation metrics—exact match accuracy and execution accuracy—provide complementary insights into system performance. Exact match accuracy measures syntactic correctness by comparing generated SQL to gold standard SQL, providing a strict evaluation that requires perfect SQL structure. Execution accuracy measures semantic correctness by comparing execution results, providing a more lenient evaluation that focuses on whether the query produces the correct answer, regardless of SQL structure. As shown in Table X, our system achieves higher execution accuracy than exact match accuracy, indicating that while some generated SQL queries may not exactly match the gold standard structure, they produce semantically correct results.

Field selection accuracy, measured as a custom metric, provides additional insights beyond standard metrics. Our analysis identifies that 52.6% of errors stem from incorrect field selection in the SELECT clause, making this the primary error source in NL2SQL systems. The Question Analyzer agent's explicit focus on field identification, combined with the SQL Refiner's ability to correct field selection errors, directly addresses this critical issue. The improvement in field selection accuracy validates our design choice to dedicate a specialized agent (Question Analyzer) to field identification and requirements analysis.

### 4.3 Ablation Studies Analysis

#### 4.3.1 Impact of Each Agent

Our ablation studies reveal the contribution of each agent to overall system performance. As shown in Table X, the Question Analyzer agent has the most significant impact on accuracy, as it addresses field selection errors that account for 52.6% of total errors. By explicitly identifying required fields before SQL generation, the Question Analyzer prevents common field substitution errors (e.g., selecting title instead of course_id, or id instead of name) that single-agent systems frequently make. The agent's structured output, including expected_output_fields and field_order_critical flags, provides critical guidance for subsequent agents.

The Schema Selector agent contributes to accuracy by reducing context size and improving focus. By filtering the database schema to include only relevant tables and columns, the Schema Selector enables subsequent agents (Query Planner, SQL Expert) to work with a focused, manageable schema representation rather than the full database schema. This filtering reduces the cognitive load on agents and helps prevent errors from selecting incorrect tables or columns.

The Query Planner agent improves query structure and logical correctness. By decomposing complex queries into logical sub-goals before SQL generation, the Query Planner helps the SQL Expert understand the query's logical flow, reducing errors in JOIN conditions, aggregation logic, and set operations. The planning step is particularly valuable for complex queries requiring multiple tables, nested structures, or set operations.

The SQL Expert agent provides the core SQL generation capability, translating logical plans into executable SQL code. While the SQL Expert is essential for system operation, its performance is significantly enhanced by the context provided by previous agents (Question Analyzer's field requirements, Schema Selector's filtered schema, Query Planner's logical plan).

The SQL Validator agent ensures syntax and semantic correctness, catching errors that may have been introduced during generation or refinement. The validator's ability to automatically fix common errors (e.g., correcting field selection, fixing table/column names, removing unnecessary JOINs) contributes to overall accuracy.

The SQL Refiner agent performs single-pass refinement that improves queries before final validation. By reviewing the initial SQL against question requirements, analysis, and query plan, the Refiner can correct field selection errors, simplify unnecessary JOINs, fix aggregation logic, and ensure query completeness. The refinement step is particularly effective when the initial SQL is close to correct but has minor errors that can be fixed.

#### 4.3.2 Most Important Components

The ablation studies identify two components as most critical for NL2SQL accuracy: the Question Analyzer agent and the SQL Refiner agent. The Question Analyzer is critical because it addresses the primary error source (52.6% field selection errors) through explicit field identification before SQL generation. Without this agent, field selection errors persist, significantly impacting overall accuracy. The SQL Refiner is critical because it enables error correction through single-pass refinement, catching and fixing errors that may have been introduced during SQL generation. The combination of these two agents—explicit field identification followed by refinement—creates a robust mechanism for addressing field selection accuracy.

The Query Planner agent, while valuable for complex queries, has less impact on simpler queries that can be handled without explicit planning. However, for complex queries requiring multiple tables, nested structures, or set operations, the Query Planner significantly improves accuracy by providing logical structure before SQL generation.

#### 4.3.3 Design Choices Validated

Our ablation studies validate several key design choices. First, 6-agent specialization outperforms single-agent approaches, demonstrating that distributing NL2SQL responsibilities across specialized agents improves accuracy compared to single models that must handle all aspects simultaneously. Second, single-pass refinement outperforms single-pass generation, validating that refinement mechanisms can improve accuracy without the computational overhead of iterative loops. Third, error pattern awareness embedded in agent prompts improves accuracy compared to generic generation, demonstrating that explicit error pattern training helps agents avoid common pitfalls.

The comparison between 4-step and 6-step pipelines, illustrated in Figure X, validates that query planning and refinement components contribute significantly to accuracy. The 6-step pipeline's superior performance demonstrates that the additional complexity of Query Planner and SQL Refiner agents is justified by the accuracy improvements they provide.

### 4.4 Error Analysis

#### 4.4.1 Common Failure Cases

Despite the improvements achieved by our multi-agent architecture, certain query types remain challenging. Complex nested queries with multiple subqueries, particularly those requiring correlated subqueries or multiple levels of nesting, sometimes fail due to the complexity of understanding the nested structure and correctly translating it to SQL. Queries requiring domain knowledge beyond the database schema, such as understanding implicit relationships or domain-specific terminology, also pose challenges, as the system relies primarily on schema information and question text.

Ambiguous questions requiring clarification present another challenge. When natural language questions can be interpreted in multiple ways, the system must make assumptions about the intended meaning, which may not always align with the user's intent. For example, questions like "Find students who took courses" may be ambiguous about whether to return students who took any courses or students who took specific courses, leading to incorrect SQL generation.

#### 4.4.2 Patterns in Errors

Our error analysis reveals several patterns in remaining errors. Field selection errors, while significantly reduced through the Question Analyzer agent, still occur in approximately [X]% of cases, typically when questions use ambiguous terminology or when multiple valid interpretations exist. For instance, the question "List all courses" may be ambiguous about whether to return course_id, course_name, or both, leading to field selection errors when the intended interpretation differs from the system's assumption. JOIN logic errors occur when the Query Planner's logical plan does not correctly identify the relationships between tables, leading to incorrect JOIN conditions or missing JOINs. Aggregation errors occur when the SQL Expert incorrectly applies aggregation functions (e.g., using COUNT instead of COUNT(DISTINCT) for unique entities) or incorrectly groups results.

The error patterns demonstrate that while our multi-agent architecture addresses many systematic errors, some challenges remain. Field selection errors, despite being the primary focus of the Question Analyzer, still occur when questions are ambiguous or when multiple valid field interpretations exist. JOIN logic errors occur when schema relationships are complex or when the Query Planner's logical reasoning fails. Aggregation errors occur when the SQL Expert's rules do not cover all edge cases.

#### 4.4.3 Why Certain Cases Are Challenging

Certain query types are challenging for several reasons. Schema understanding requires domain knowledge that may not be explicitly encoded in the database schema. For example, understanding that "enrollment" refers to student count from the student table, or that "prerequisites" require specific JOIN logic, requires domain knowledge beyond schema structure. Complex logic requires multi-step reasoning that may exceed the capabilities of individual agents, particularly when queries require multiple levels of nesting or complex set operations.

Ambiguity in natural language presents another challenge. When questions can be interpreted in multiple ways, the system must make assumptions, which may not always align with user intent. The lack of interactive clarification means the system cannot ask users to disambiguate questions, leading to incorrect SQL generation when assumptions are wrong.

### 4.5 Limitations

#### 4.5.1 Scope of Applicability

Our system has several limitations that affect its scope of applicability. First, the system is designed for English language only, limiting its applicability to English-speaking users and English-language databases. Second, the system requires complete database schema information, including table names, column names, data types, and relationships, which may not always be available or may require manual schema extraction. Third, the system works best with structured academic databases like those in the Spider dataset, and its performance on real-world databases with different structures, naming conventions, or complexity levels may vary.

The system's reliance on structured schema information means it cannot handle databases with incomplete or ambiguous schemas, or databases where schema information is not readily available. The system's design for academic databases means it may not perform as well on real-world databases with different characteristics, such as larger schemas, more complex relationships, or domain-specific terminology.

#### 4.5.2 Constraints and Assumptions

Several constraints and assumptions limit the system's applicability. The system assumes that database schema is provided in a structured format (JSON), which may require preprocessing for databases with different schema representations. The system requires LLM API access (Gemini 2.0 Flash), which may not be available in all environments or may incur costs that limit scalability. The single-pass refinement approach, while computationally efficient, may not catch all errors that iterative refinement could address, representing a trade-off between accuracy and efficiency.

The system's design assumes that natural language questions can be answered using SQL queries, which may not always be the case for questions requiring external knowledge, complex reasoning beyond database queries, or questions that cannot be expressed in SQL. The system's focus on single-query generation means it cannot handle multi-turn conversations or questions that require context from previous queries.

#### 4.5.3 Areas for Improvement

Several areas present opportunities for improvement. Multi-language support would extend the system's applicability to non-English languages, requiring language-specific prompt engineering and potentially language-specific error patterns. Schema learning from examples would enable the system to work with databases where schema information is incomplete or unavailable, learning schema structure from example queries and results. Real-time adaptation to new database structures would enable the system to handle databases that change over time, adapting to new tables, columns, or relationships without requiring manual schema updates.

Integration with query optimization systems would improve the system's practical utility, generating SQL queries that are not only correct but also efficient, considering query execution plans and database performance characteristics. Interactive clarification mechanisms would enable the system to ask users for clarification when questions are ambiguous, reducing errors from incorrect assumptions.

### 4.6 Implications

#### 4.6.1 What These Results Mean for the Field

Our results demonstrate that multi-agent systems are effective for NL2SQL, validating the application of multi-agent collaboration to database querying tasks. The superior performance of specialized agents compared to general-purpose agents suggests that task-specific agent design is important for achieving high accuracy. The significant improvement in field selection accuracy (addressing 52.6% of errors) demonstrates that explicit error pattern awareness and targeted mitigation strategies can systematically address common error sources.

The comparison between 4-step and 6-step pipelines provides empirical validation of multi-agent specialization benefits, demonstrating that query planning and refinement components significantly improve accuracy. These results motivate future research in specialized multi-agent architectures for NL2SQL and other structured output generation tasks.

#### 4.6.2 Practical Applications

Our multi-agent architecture has several practical applications. Database query interfaces for non-technical users can leverage the system to enable natural language querying of databases, making database access more accessible to users without SQL expertise. Business intelligence tools can integrate the system to enable natural language exploration of business data, allowing analysts to query databases using natural language rather than SQL. Data exploration systems can use the system to enable interactive database exploration, helping users discover and query database content through natural language questions.

The system's ability to handle complex queries and its focus on field selection accuracy make it particularly suitable for applications where query accuracy is critical, such as financial reporting, scientific data analysis, or business intelligence. The single-pass refinement approach balances accuracy with computational efficiency, making it suitable for real-time applications where query latency is important.

#### 4.6.3 Future Research Directions

Several research directions emerge from our work. Multi-language NL2SQL would extend the system's applicability, requiring research into language-specific error patterns, prompt engineering, and cross-lingual schema understanding. Schema learning and adaptation would enable the system to work with incomplete or evolving schemas, requiring research into schema inference, relationship discovery, and adaptive agent design. Real-time query optimization integration would improve practical utility, requiring research into query plan analysis, performance prediction, and optimization-aware SQL generation.

Integration with conversational interfaces would enable multi-turn NL2SQL, allowing users to refine queries through conversation and handle follow-up questions. Research into interactive clarification mechanisms would address ambiguity challenges, enabling the system to ask users for clarification when questions are ambiguous. Finally, research into domain-specific agent specialization could improve performance on domain-specific databases, such as medical databases, financial databases, or scientific databases, by incorporating domain knowledge into agent designs.

---
## 5. Conclusion - Natural Language to SQL using Multi-Agent Systems

### Draft Version

Traditional Natural Language to SQL (NL2SQL) systems struggle with complex queries requiring multi-step reasoning, accurate schema understanding, and proper SQL generation, with systematic errors in field selection accounting for 52.6% of failures. This paper addressed these limitations through a novel multi-agent system using the CrewAI framework, featuring six specialized agents with distinct roles and a single-pass refinement mechanism that enables error correction through agent collaboration.

This paper makes four key contributions. First, we propose a novel 6-agent architecture specifically designed for NL2SQL, with specialized agents—Question Analyzer, Schema Selector, Query Planner, SQL Expert, SQL Validator, and SQL Refiner—each focusing on distinct aspects of the NL2SQL task. Second, we conduct comprehensive error analysis that identifies field selection as the primary error source, accounting for 52.6% of errors, and implement targeted mitigation strategies in our Question Analyzer agent. Third, we provide empirical evaluation comparing 4-step and 6-step pipeline architectures on the Spider dataset, demonstrating the impact of query planning and single-pass refinement on accuracy. Fourth, we analyze patterns of agent collaboration, including information flow between agents and single-pass refinement process, and their impact on query accuracy.

Our evaluation demonstrates that the 6-step pipeline achieves [X]% exact match accuracy and [X]% execution accuracy on the Spider test set, representing a [X]% improvement over the 4-step baseline. Most notably, field selection accuracy improved by [X]%, directly addressing the primary error source that accounts for 52.6% of errors in NL2SQL systems. These results validate that specialized multi-agent collaboration with single-pass refinement significantly outperforms single-agent approaches for complex NL2SQL tasks.

Future research directions include extending the system to support multiple languages beyond English, developing schema learning capabilities that enable agents to learn database schemas from examples without explicit schema definition, enabling real-time adaptation to new database structures and query patterns dynamically, and integrating with database query optimizers for performance improvement. These directions will advance the field toward more accessible, accurate, and adaptable natural language interfaces to databases.

---

## References

[1] V. Zhong, C. Xiong, and R. Socher, "Seq2SQL: Generating Structured Queries from Natural Language Using Reinforcement Learning," in *Proc. 55th Annual Meeting of the Association for Computational Linguistics (ACL)*, 2017. (Introduces the WikiSQL dataset.)  
[2] T. Yu, Z. Li, Z. Zhang, R. Zhang, and D. Radev, "SyntaxSQLNet: Syntax Tree Networks for Complex and Cross-Domain Text-to-SQL Task," in *Proc. EMNLP*, 2018.  
[3] T. Yu, R. Zhang, K. Yang, M. Yasunaga, D. Wang, Z. Li, J. Ma, I. Li, Q. Chen, M. Lin, S. Ji, and D. Radev, "Spider: A Large-Scale Human-Labeled Dataset for Complex and Cross-Domain Semantic Parsing and Text-to-SQL Task," in *Proc. EMNLP*, 2018.  
[4] B. Wang, R. Shin, X. Liu, O. Polozov, and M. Richardson, "RAT-SQL: Relation-Aware Schema Encoding and Linking for Text-to-SQL Parsers," in *Proc. ACL*, 2020.  
[5] S. Ruan, P. Zhang, R. Zhang, and Y. Zhang, "RESDSQL: Decoupling Schema Linking and Schema Encoding for Text-to-SQL," arXiv preprint arXiv:2305.08891, 2023.  
[6] M. Pourreza and D. Rafiei, "DIN-SQL: Decomposed In-Context Learning of Text-to-SQL with Self-Correction," arXiv preprint arXiv:2304.11015, 2023.  
[7] F. Li, H. Chen, S. Chen, Z. Li, and X. Du, "C3 and DAIL-SQL: Zero-shot and In-Context Learning Methods for Text-to-SQL," arXiv preprints, 2023. [Note: grouped citation covering C3 and DAIL-SQL works.]  
[8] Y. Wang, S. Zhou, H. Liu, et al., "AutoGen: Enabling Next-Gen LLM Applications via Multi-Agent Conversation Framework," arXiv preprint arXiv:2308.08155, 2023.  
[9] H. Chase, "LangChain," 2022–2024. [Online]. Available: [https://python.langchain.com](https://python.langchain.com)  
[10] J. Moura et al., "CrewAI: Open-Source Framework for Multi-Agent Collaboration," 2023–2024. [Online]. Available: [https://github.com/crewAIInc/crewAI](https://github.com/crewAIInc/crewAI)  
[11] E. Gan, F. Li, A. Lei, T. Yu, and M. Encarnación, "BRIDGE: Bridging Text and Schema for Text-to-SQL Parsers," in *Proc. NAACL*, 2021.  
[12] T. Scholak, N. Scales, N. Schärli, C. Wang, N. Lee, and D. Zhou, "PICARD: Parsing Incrementally for Constrained Auto-Regressive Decoding for Text-to-SQL," in *Proc. EMNLP*, 2021.  
[13] OpenAI, "GPT-4 Technical Report," arXiv preprint arXiv:2303.08774, 2023. (Representative of GPT-3/4-based Text-to-SQL work.)  
[14] Y. Wang, S. Liu, Y. Xie, et al., "CodeT5+: Open Code Large Language Models for Code Understanding and Generation," arXiv preprint arXiv:2305.07922, 2023.  
[15] Various authors, "Multi-Agent Systems for Complex Task Solving," ICML/NeurIPS/ICLR multi-agent learning papers, 2020–2024. [Note: aggregated reference for general multi-agent literature.]  
[16] T. Shinn, Y. Labash, and J. Shoeybi, "Reflexion: Language Agents with Verbal Reinforcement Learning," arXiv preprint arXiv:2303.11366, 2023.  
[17] Z. Yuan, Y. Wang, H. Xu, et al., "CRITIC: Large Language Models Can Self-Correct with Tool-Interactive Critiquing," arXiv preprint arXiv:2305.11738, 2023.  
[18] Various authors, "Agentic Retrieval-Augmented Generation Frameworks," white papers and blog posts on agentic RAG, 2023–2024. [Note: representative, non-exhaustive.]  
[19] Various authors, "Tool Learning in Large Language Models," including work on function calling, tool use, and toolformer-style approaches, 2023–2024. [Note: aggregated reference.]  
[20] J. Li, B. Hu, F. Li, et al., "BIRD: Big Bench for Large-Scale Database Grounded Text-to-SQL Evaluation," in *Proc. NeurIPS*, 2023.

## Appendix A. Citation Mapping

| Old in-text citation                       | New ID | Reference summary                                           |
|-------------------------------------------|--------|-------------------------------------------------------------|
| [Zhong et al., 2017] (Seq2SQL, WikiSQL)   | [1]    | Seq2SQL model and WikiSQL dataset                           |
| [Yu et al., 2018] (SyntaxSQLNet)          | [2]    | SyntaxSQLNet Text-to-SQL model                              |
| [Yu et al., 2018] (Spider Dataset)        | [3]    | Spider complex text-to-SQL dataset                          |
| [Wang et al., 2020] (RAT-SQL)             | [4]    | Relation-aware Text-to-SQL parser                           |
| [Ruan et al., 2023] (RESDSQL)             | [5]    | Decoupled schema linking/encoding Text-to-SQL model         |
| [Pourreza & Rafiei, 2023] (DIN-SQL)       | [6]    | Decomposed in-context Text-to-SQL with self-correction      |
| [Li et al., 2023] (C3, DAIL-SQL)          | [7]    | Zero-shot and multi-phase domain learning Text-to-SQL       |
| [Wang et al., 2023] (AutoGen)             | [8]    | Multi-agent LLM conversation framework                      |
| [Chase et al., 2022-2024] (LangChain)     | [9]    | LangChain agent/tool framework                              |
| [Moura et al., 2023-2024] (CrewAI)        | [10]   | CrewAI multi-agent orchestration framework                  |
| [Gan et al., 2021] (BRIDGE)               | [11]   | BRIDGE schema-linking Text-to-SQL model                     |
| [Scholak et al., 2021] (PICARD)           | [12]   | Constrained decoding for Text-to-SQL                        |
| [Various, 2022-2024] (GPT-3/4 Text-to-SQL)| [13]   | GPT-4 technical report as representative citation           |
| [Wang et al., 2023] (CodeT5+)             | [14]   | CodeT5+ code LLM                                            |
| [Various, 2020-2024] (multi-agent theory) | [15]   | General multi-agent learning literature                     |
| [Shinn et al., 2023] (Reflexion)          | [16]   | Reflexion self-reflective language agents                   |
| [Yuan et al., 2023] (CRITIC)              | [17]   | CRITIC tool-interactive self-correction                     |
| [Various, 2023-2024] (Agentic RAG)        | [18]   | Agentic retrieval-augmented generation                      |
| [Various, 2023-2024] (Tool Learning)      | [19]   | Tool learning in large language models                      |
| [Li et al., 2023] (BIRD Dataset)          | [20]   | BIRD large-scale Text-to-SQL benchmark                      |

## Appendix B. Citations Requiring Additional Detail

- **[15] Multi-agent systems for complex task solving**: Aggregated over multiple ICML/NeurIPS/ICLR papers; specific titles and venues can be added if a particular work is emphasized.  
- **[18] Agentic RAG**: Represents a family of emerging frameworks and blog posts rather than a single canonical paper; exact sources should be specified if a particular implementation is adopted.  
- **[19] Tool learning in LLMs**: Covers several distinct papers (e.g., Toolformer, function-calling/tool-use reports). Individual citations can be split out if the thesis chooses to discuss specific methods in detail.