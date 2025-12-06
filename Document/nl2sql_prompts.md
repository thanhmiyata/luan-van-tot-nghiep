# NL2SQL Multi-Agent System - Specific Prompts

## Overview
This document contains ready-to-use prompts specifically tailored for writing a scientific paper on "Natural Language to SQL using Multi-Agent Systems" based on your implementation.

---

## Phase 1: Research (Gemini 3 Pro)

### Prompt

```
You are a research assistant helping to prepare a scientific paper on "Natural Language to SQL using Multi-Agent Systems with CrewAI Framework".

Your task is to:
1. Identify the top 30 most relevant papers in NL2SQL and Multi-Agent Systems for database querying
2. Summarize key contributions of each paper
3. Identify research gaps between single-agent and multi-agent approaches for NL2SQL
4. List important datasets (Spider, WikiSQL, etc.) and evaluation metrics (exact match, execution accuracy)
5. Identify common methodologies: sequence-to-sequence, semantic parsing, retrieval-augmented generation, tool learning
6. Note recent trends: LLM-based approaches, agentic RAG, multi-agent collaboration

Focus on papers from:
- Top-tier conferences: ACL, EMNLP, NAACL, SIGIR, ICML, NeurIPS, ICLR
- High-impact journals: TACL, JMLR, AI Journal
- Recent work (2020-2024)

Key areas to cover:
- Traditional NL2SQL: Seq2SQL, SyntaxSQLNet, RAT-SQL, RESDSQL
- LLM-based NL2SQL: GPT-based approaches, fine-tuned models
- Multi-Agent Systems in NLP: CrewAI, LangChain agents, AutoGen
- Tool Learning and Agentic RAG: Tool use in LLMs, RAG with agents
- Evaluation frameworks: Spider benchmark, execution accuracy metrics

Provide your findings in a structured format:
- Paper title, authors, venue, year
- Key contribution (2-3 sentences)
- Methodology summary
- Results on Spider/WikiSQL (if applicable)
- Relevance to our multi-agent NL2SQL approach

Format the output as a markdown document with clear sections:
1. Traditional NL2SQL Approaches
2. LLM-based NL2SQL
3. Multi-Agent Systems
4. Tool Learning and Agentic RAG
5. Evaluation Frameworks
```

---

## Phase 2: Abstract (GPT-5)

### Prompt

```
You are writing the abstract for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Requirements:
- Length: 200-250 words
- Structure: Problem → Approach → Results → Impact
- Use formal academic language
- Include key metrics
- No citations in abstract

Context:
- Research Problem: Traditional NL2SQL systems struggle with complex queries requiring multi-step reasoning, accurate schema understanding, and proper SQL generation. Single-agent approaches often fail on complex JOINs, nested queries, and field selection accuracy.

- Proposed Solution: Multi-agent system using CrewAI framework with 6 specialized agents: (1) Question Analyzer - identifies intent and required fields, (2) Schema Selector - filters relevant tables/columns, (3) Query Planner - creates execution plan, (4) SQL Expert - generates SQL queries, (5) SQL Validator - checks syntax and correctness, (6) SQL Refiner - iteratively improves queries.

- Key Contributions: 
  1. Novel 6-agent architecture for NL2SQL with specialized roles
  2. Iterative refinement mechanism for query improvement
  3. Comprehensive evaluation on Spider dataset comparing 4-step vs 6-step approaches
  4. Analysis of common error patterns and mitigation strategies

- Main Results: 
  - 6-step pipeline achieves [X]% exact match accuracy on Spider test set
  - [X]% execution accuracy
  - Significant improvement over 4-step baseline ([X]% improvement)
  - Error analysis shows field selection accuracy improved by [X]%

- Dataset/Evaluation: Spider dataset (academic database queries), exact match and execution accuracy metrics

Write a compelling abstract that:
1. Clearly states the NL2SQL problem and limitations of existing approaches
2. Briefly describes the multi-agent architecture and key innovations
3. Highlights the 6-agent design and iterative refinement
4. Presents main experimental results with specific numbers
5. Concludes with the impact on practical database querying systems

Ensure the abstract is:
- Self-contained and readable without reading the paper
- Accurate (all claims verifiable in the paper)
- Compelling (encourages readers to continue)
- Technical but accessible
```

---

## Phase 3: Introduction (GPT-5)

### Prompt

```
You are writing the Introduction section for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Structure the introduction as follows:

1. **Opening Paragraph** (3-4 sentences)
   - Natural language interfaces to databases are increasingly important
   - LLMs have revolutionized NLP tasks including NL2SQL
   - Current challenges in complex query generation
   - Multi-agent systems as a promising approach

2. **Problem Statement** (2-3 paragraphs)
   - Limitations of single-agent NL2SQL systems:
     * Struggle with complex queries requiring multi-step reasoning
     * Field selection errors (52.6% of errors in our analysis)
     * Schema understanding challenges
     * Difficulty with nested queries, JOINs, and aggregations
   - Why current solutions are insufficient:
     * Traditional seq2seq models lack reasoning capability
     * Fine-tuned LLMs still make systematic errors
     * Single-agent systems cannot handle iterative refinement
   - Use citations: [CITE_RELEVANT_PAPERS from research phase]

3. **Our Approach** (1-2 paragraphs)
   - Multi-agent system using CrewAI framework
   - 6 specialized agents with distinct roles:
     * Question Analyzer: Intent understanding and field identification
     * Schema Selector: Relevant table/column filtering
     * Query Planner: Logical execution plan
     * SQL Expert: Query generation with error pattern awareness
     * SQL Validator: Syntax and semantic validation
     * SQL Refiner: Iterative improvement based on validation feedback
   - Key innovation: Iterative refinement loop for query improvement
   - Comparison: 4-step vs 6-step pipeline architectures

4. **Contributions** (1 paragraph, bullet points)
   - Contribution 1: Novel 6-agent architecture for NL2SQL with specialized roles and iterative refinement
   - Contribution 2: Comprehensive error analysis identifying field selection as primary error source (52.6%)
   - Contribution 3: Empirical evaluation comparing 4-step and 6-step approaches on Spider dataset
   - Contribution 4: Analysis of agent collaboration patterns and their impact on query accuracy

5. **Paper Organization** (1 paragraph)
   - Section 2: Related work on NL2SQL and multi-agent systems
   - Section 3: Problem formulation and requirements
   - Section 4: Multi-agent architecture and agent descriptions
   - Section 5: Implementation details and CrewAI framework
   - Section 6: Experimental setup and results
   - Section 7: Error analysis and discussion
   - Section 8: Conclusion and future work

Requirements:
- Length: 1000-1200 words
- Use formal academic language
- Include 10-15 citations to:
  * Traditional NL2SQL papers (Seq2SQL, SyntaxSQLNet, RAT-SQL, RESDSQL)
  * LLM-based approaches (GPT-based NL2SQL)
  * Multi-agent systems (CrewAI, LangChain, AutoGen)
  * Evaluation frameworks (Spider benchmark papers)
- Write in third person
- Avoid overly technical details (save for methodology)
- Create a narrative flow that guides the reader from problem to solution

Key points to emphasize:
- Field selection accuracy is critical (52.6% of errors)
- Multi-agent collaboration enables iterative improvement
- Specialized agents outperform general-purpose single agents
```

---

## Phase 4: Methodology (GPT-5)

### Prompt

```
You are writing the Methodology section for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Structure:

1. **Overview** (1 paragraph)
   - High-level architecture: 6-agent system using CrewAI framework
   - Agent collaboration flow: Question → Analysis → Schema Selection → Planning → SQL Generation → Validation → Refinement
   - Two pipeline variants: 4-step (simplified) and 6-step (full) for comparison

2. **Problem Formulation** (1-2 paragraphs)
   - Formal definition: Given natural language question Q and database schema S, generate SQL query SQL such that executing SQL on database D returns results R that answer Q
   - Input: (Q, S) where Q is natural language, S = {T₁, T₂, ..., Tₙ} is set of tables with columns
   - Output: Executable SQL query
   - Evaluation: Exact match accuracy and execution accuracy

3. **Multi-Agent Architecture** (5-6 subsections, one per agent)

   **3.1 Question Analyzer Agent**
   - Role: Analyze natural language question to identify intent and required fields
   - Input: Natural language question
   - Output: Structured analysis including:
     * Question intent (COUNT, LIST, MAX_MIN, AGGREGATION)
     * Difficulty level (EASY, MEDIUM, HARD)
     * Required fields for SELECT clause (CRITICAL - 52.6% of errors)
     * Entities mentioned (tables, columns, values)
   - Key innovation: Field selection analysis to prevent field substitution errors
   - LLM: Gemini 2.0 Flash

   **3.2 Schema Selector Agent**
   - Role: Filter relevant tables and columns from database schema
   - Input: Question analysis + full database schema
   - Output: Filtered schema containing only relevant tables/columns
   - Logic:
     * Identify mentioned entities (students → student table)
     * Keep primary keys and foreign keys for JOINs
     * Remove irrelevant components
   - LLM: Gemini 2.0 Flash

   **3.3 Query Planner Agent**
   - Role: Design logical execution plan
   - Input: Question analysis + filtered schema
   - Output: Step-by-step plan including:
     * Sub-goals (joins, filters, aggregations)
     * Table participation in each sub-goal
     * JOIN paths and key columns
     * GROUP BY / HAVING / ORDER BY requirements
     * Set operations (UNION/INTERSECT/EXCEPT) vs WHERE logic
   - Does NOT write SQL, only logical plan
   - LLM: Gemini 2.0 Flash

   **3.4 SQL Expert Agent**
   - Role: Generate accurate, executable SQL query
   - Input: Question analysis + filtered schema + query plan
   - Output: Complete single-line SQL query
   - Key rules implemented:
     * Field selection accuracy (top priority - 52.6% error reduction)
     * Simplicity rules (avoid unnecessary JOINs)
     * COUNT vs COUNT(DISTINCT) logic
     * Set operations (UNION/INTERSECT/EXCEPT)
     * GROUP BY logic
     * Prerequisite table logic
   - Error pattern awareness: Trained on common error patterns
   - LLM: Gemini 2.0 Flash

   **3.5 SQL Validator Agent**
   - Role: Validate and fix SQL syntax and semantic errors
   - Input: Generated SQL query + schema
   - Output: Validated/fixed SQL or error report
   - Checks:
     * SQL syntax correctness
     * Table and column name existence
     * JOIN condition correctness
     * WHERE clause validity
   - Rejects incomplete SQL fragments
   - LLM: Gemini 2.0 Flash

   **3.6 SQL Refiner Agent**
   - Role: Iteratively refine SQL based on validation feedback
   - Input: Initial SQL + question + analysis + plan + validation results
   - Output: Improved SQL query
   - Refinement focus:
     * Field selection and order correction
     * Simplify unnecessary JOINs/subqueries
     * Fix COUNT vs COUNT(DISTINCT)
     * Ensure logic follows query plan
   - Key innovation: Iterative improvement loop
   - LLM: Gemini 2.0 Flash

4. **Agent Collaboration Flow** (1-2 paragraphs)
   - Sequential pipeline: Question → Analyzer → Schema Selector → Planner → SQL Expert → Validator → Refiner
   - Iterative refinement: If validation fails or refinement suggests improvement, loop back
   - Information passing: Each agent receives outputs from previous agents
   - Decision points: When to stop refinement (max iterations or validation success)

5. **Pipeline Variants** (1 paragraph)
   - 4-step pipeline: Question Analyzer → Schema Selector → SQL Expert → SQL Validator
   - 6-step pipeline: Full architecture with Query Planner and SQL Refiner
   - Comparison purpose: Evaluate impact of planning and refinement steps

6. **Implementation Details** (1-2 paragraphs)
   - Framework: CrewAI for agent orchestration
   - Base LLM: Gemini 2.0 Flash for all agents
   - Prompt engineering: Detailed backstories and rules for each agent
   - Error pattern training: Agents aware of common error patterns (field selection, JOIN logic, etc.)
   - Output format: Single-line SQL queries for execution

Requirements:
- Length: 2000-2500 words
- Be precise and technical
- Include agent interaction diagrams descriptions
- Reference figures: "As shown in Figure X (agent architecture)"
- Use consistent terminology
- Explain design choices (why 6 agents, why these roles)
- Include pseudocode for agent collaboration algorithm if helpful

Key technical details to include:
- Agent prompt engineering strategies
- Error pattern awareness mechanisms
- Iterative refinement stopping criteria
- Information flow between agents
```

---

## Phase 5: Related Work (Opus 4.5)

### Prompt

```
You are writing the Related Work section for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Structure:

1. **Introduction to Related Work** (1 paragraph)
   - Scope: NL2SQL approaches, multi-agent systems, and evaluation frameworks
   - Organization: Categorized by methodology and approach

2. **Traditional NL2SQL Approaches** (Subsection)
   - **Seq2SQL** [CITE]: Sequence-to-sequence approach, limitations with complex queries
   - **SyntaxSQLNet** [CITE]: Syntax-aware model, struggles with schema understanding
   - **RAT-SQL** [CITE]: Relation-aware transformer, improvements but still single-agent
   - **RESDSQL** [CITE]: Recent improvements, but limited to single-agent architecture
   - Analysis: These approaches use single models/agents, cannot handle iterative refinement
   - Positioning: Our work extends these with multi-agent collaboration

3. **LLM-based NL2SQL** (Subsection)
   - **GPT-based approaches** [CITE]: Using large language models for SQL generation
   - **Fine-tuned models** [CITE]: Domain-specific fine-tuning for NL2SQL
   - **In-context learning** [CITE]: Few-shot prompting strategies
   - Analysis: LLMs improve accuracy but still make systematic errors (field selection, JOIN logic)
   - Positioning: Our work uses LLMs as base but adds multi-agent structure for error reduction

4. **Multi-Agent Systems in NLP** (Subsection)
   - **CrewAI framework** [CITE]: Agent orchestration framework
   - **LangChain agents** [CITE]: Tool-using agents for various tasks
   - **AutoGen** [CITE]: Multi-agent conversation framework
   - **Agentic RAG** [CITE]: Retrieval-augmented generation with agents
   - Analysis: Multi-agent systems show promise but limited application to NL2SQL
   - Positioning: Our work is first to apply specialized multi-agent architecture to NL2SQL

5. **Tool Learning and Agentic RAG** (Subsection)
   - **Tool learning** [CITE]: LLMs using external tools
   - **Agentic RAG** [CITE]: RAG with agent-based decision making
   - **Reflexion** [CITE]: Self-reflection and correction mechanisms
   - **CRITIC** [CITE]: Self-correction with tool interaction
   - Analysis: These approaches use agents for general tasks, not specialized for NL2SQL
   - Positioning: Our work creates NL2SQL-specific agents with domain expertise

6. **Evaluation Frameworks** (Subsection)
   - **Spider dataset** [CITE]: Academic database queries benchmark
   - **WikiSQL** [CITE]: Simpler single-table queries
   - **Evaluation metrics**: Exact match, execution accuracy
   - Analysis: Standard benchmarks for NL2SQL evaluation
   - Positioning: We use Spider for comprehensive evaluation

7. **Comparison and Positioning** (1-2 paragraphs)
   - How our approach differs:
     * First specialized multi-agent architecture for NL2SQL
     * Iterative refinement mechanism
     * Error pattern awareness (field selection focus)
     * 6-agent specialization vs single-agent or general multi-agent
   - What we borrow/improve:
     * LLM base models (like LLM-based approaches)
     * Agent orchestration (like CrewAI)
     * Self-correction (like Reflexion/CRITIC)
   - Novel aspects:
     * NL2SQL-specific agent roles
     * Field selection accuracy focus
     * Comparison of 4-step vs 6-step pipelines

8. **Gaps and Opportunities** (1 paragraph)
   - Existing work doesn't address: Specialized agent roles for NL2SQL, iterative refinement for SQL queries, field selection error patterns
   - Why our approach is needed: Single-agent systems hit accuracy ceiling, multi-agent collaboration enables improvement

Requirements:
- Length: 1800-2200 words
- Include 25-30 citations
- Critical analysis, not just summaries
- Group related work logically
- Compare and contrast different approaches
- Position our work clearly within the landscape
- Use phrases like: "In contrast to...", "Unlike...", "Building upon..."
- Acknowledge limitations of existing work fairly

Key papers to discuss (from research phase):
- Traditional: Seq2SQL, SyntaxSQLNet, RAT-SQL, RESDSQL
- LLM-based: GPT-based NL2SQL papers, fine-tuning approaches
- Multi-agent: CrewAI, LangChain, AutoGen papers
- Tool learning: Reflexion, CRITIC, agentic RAG papers
- Evaluation: Spider benchmark papers, WikiSQL papers
```

---

## Phase 6: Discussion (Opus 4.5)

### Prompt

```
You are writing the Discussion section for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Structure:

1. **Summary of Results** (1 paragraph)
   - 6-step pipeline achieves [X]% exact match accuracy on Spider test set
   - [X]% execution accuracy
   - Significant improvement over 4-step baseline ([X]% improvement)
   - Field selection accuracy improved by [X]% (addressing 52.6% of errors)

2. **Analysis of Results** (2-3 paragraphs)
   - Why 6-step outperforms 4-step:
     * Query Planner enables better logical structure
     * SQL Refiner catches and fixes errors iteratively
     * Iterative refinement allows error correction
   - Factors contributing to success:
     * Specialized agent roles (each agent focuses on specific task)
     * Error pattern awareness (field selection, JOIN logic)
     * Iterative refinement mechanism
   - Comparison with baselines:
     * Compare with single-agent approaches (cite papers)
     * Compare with other multi-agent systems (if applicable)
     * Show improvement over traditional seq2seq models
   - Interpretation of metrics:
     * Exact match: Measures syntactic correctness
     * Execution accuracy: Measures semantic correctness
     * Field selection accuracy: Addresses 52.6% of errors

3. **Ablation Studies Analysis** (1-2 paragraphs)
   - Impact of each agent:
     * Question Analyzer: Field selection accuracy (critical)
     * Schema Selector: Reduces context, improves focus
     * Query Planner: Better logical structure
     * SQL Expert: Core generation capability
     * SQL Validator: Syntax and semantic checking
     * SQL Refiner: Iterative improvement
   - Most important components:
     * Question Analyzer (field selection) - addresses 52.6% of errors
     * SQL Refiner (iterative improvement) - enables error correction
   - Design choices validated:
     * 6-agent specialization > single agent
     * Iterative refinement > single-pass generation
     * Error pattern awareness > generic generation

4. **Error Analysis** (1-2 paragraphs)
   - Common failure cases:
     * Complex nested queries with multiple subqueries
     * Queries requiring domain knowledge beyond schema
     * Ambiguous questions requiring clarification
   - Patterns in errors:
     * Field selection errors (52.6% - addressed by Question Analyzer)
     * JOIN logic errors (addressed by Query Planner)
     * Aggregation errors (addressed by SQL Expert rules)
   - Why certain cases are challenging:
     * Schema understanding requires domain knowledge
     * Complex logic requires multi-step reasoning
     * Ambiguity in natural language

5. **Limitations** (1-2 paragraphs)
   - Scope of applicability:
     * English language only
     * Requires complete database schema
     * Works best with structured academic databases
   - Constraints and assumptions:
     * Assumes schema is provided
     * Requires LLM API access (Gemini 2.0 Flash)
     * Iterative refinement increases latency
   - Areas for improvement:
     * Multi-language support
     * Schema learning from examples
     * Real-time adaptation to new database structures

6. **Implications** (1 paragraph)
   - What these results mean for the field:
     * Multi-agent systems are effective for NL2SQL
     * Specialized agents outperform general-purpose agents
     * Iterative refinement significantly improves accuracy
   - Practical applications:
     * Database query interfaces for non-technical users
     * Business intelligence tools
     * Data exploration systems
   - Future research directions:
     * Multi-language NL2SQL
     * Schema learning and adaptation
     * Real-time query optimization
     * Integration with query optimization systems

Requirements:
- Length: 1200-1500 words
- Be critical and honest
- Use specific examples from experiments
- Reference tables/figures: "As shown in Table X", "As shown in Figure Y"
- Discuss both strengths and weaknesses
- Provide actionable insights

Context to incorporate:
- Experimental Results: [INSERT_KEY_RESULTS]
- Ablation Studies: [INSERT_ABLATION_FINDINGS]
- Error Cases: [INSERT_ERROR_ANALYSIS]
- Baselines: [INSERT_BASELINE_COMPARISONS]

Key points to emphasize:
- Field selection accuracy is the primary improvement (52.6% of errors)
- Iterative refinement enables error correction
- 6-agent specialization outperforms single-agent approaches
```

---

## Phase 7: Conclusion (ChatGPT 5)

### Prompt

```
You are writing the Conclusion section for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Structure:

1. **Summary** (2-3 sentences)
   - Restate the problem: NL2SQL systems struggle with complex queries and systematic errors
   - Brief reminder of approach: 6-agent multi-agent system with iterative refinement

2. **Contributions Recap** (1 paragraph, 4 bullet points)
   - Contribution 1: Novel 6-agent architecture for NL2SQL with specialized roles (Question Analyzer, Schema Selector, Query Planner, SQL Expert, SQL Validator, SQL Refiner)
   - Contribution 2: Iterative refinement mechanism that enables error correction and query improvement
   - Contribution 3: Comprehensive error analysis identifying field selection as primary error source (52.6% of errors) and targeted mitigation
   - Contribution 4: Empirical evaluation comparing 4-step and 6-step approaches on Spider dataset, demonstrating significant improvement

3. **Key Results** (2-3 sentences)
   - 6-step pipeline achieves [X]% exact match accuracy and [X]% execution accuracy on Spider test set
   - Significant improvement over 4-step baseline ([X]% improvement)
   - Field selection accuracy improved by [X]%, addressing the primary error source

4. **Future Work** (1 paragraph, 3-4 concrete directions)
   - Multi-language support: Extend to other languages beyond English
   - Schema learning: Develop agents that can learn database schemas from examples without explicit schema definition
   - Real-time adaptation: Enable system to adapt to new database structures and query patterns dynamically
   - Query optimization integration: Integrate with database query optimizers for performance improvement

Requirements:
- Length: 250-300 words
- Be concise and precise
- No new information
- No citations (unless absolutely necessary)
- Write in third person
- End on a forward-looking note

Context:
- Problem: NL2SQL accuracy limitations, systematic errors in field selection and complex queries
- Approach: 6-agent multi-agent system using CrewAI framework with iterative refinement
- Contributions: Architecture, refinement mechanism, error analysis, evaluation
- Results: [X]% exact match, [X]% execution accuracy, [X]% improvement over baseline
```

---

## Phase 8: Review & Refinement (ChatGPT 5)

### Prompt for Grammar Check

```
You are a scientific writing editor reviewing a paper section on "Natural Language to SQL using Multi-Agent Systems".

Task: Review the following text for:
1. Grammar and spelling errors
2. Sentence structure and clarity
3. Academic writing style
4. Consistency in terminology (NL2SQL, multi-agent, agents, etc.)
5. Proper use of technical terms (CrewAI, Spider dataset, exact match, execution accuracy)

Text to review:
[INSERT_TEXT]

Provide:
- Corrected version with changes highlighted
- List of grammar/spelling errors found
- Suggestions for clarity improvements
- Terminology consistency notes (ensure: NL2SQL, multi-agent system, 6-agent architecture used consistently)
```

### Prompt for Technical Accuracy

```
You are a technical reviewer for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Task: Verify technical accuracy of the following section:
1. Are all technical claims correct? (agent roles, architecture, results)
2. Are algorithms/processes accurately described? (agent collaboration flow, iterative refinement)
3. Are experimental results consistent? (exact match vs execution accuracy, 4-step vs 6-step comparison)
4. Are citations appropriate and accurate?
5. Are numbers/metrics correct? (52.6% field selection errors, accuracy percentages)
6. Is the methodology sound? (agent design, CrewAI framework usage)

Section to review:
[INSERT_SECTION]

Provide:
- List of potential technical inaccuracies
- Questions about unclear technical points
- Suggestions for clarification
- Verification of agent architecture descriptions
- Cross-check with methodology section for consistency
- Verify error analysis claims (52.6% field selection errors)
```

### Prompt for Consistency Check

```
You are reviewing a complete scientific paper on "Natural Language to SQL using Multi-Agent Systems" for consistency.

Check:
1. Terminology consistency across sections:
   - NL2SQL (not NL-to-SQL or natural language to SQL inconsistently)
   - Multi-agent system (not multi agent or multiagent)
   - 6-agent architecture (consistent numbering)
   - Agent names: Question Analyzer, Schema Selector, Query Planner, SQL Expert, SQL Validator, SQL Refiner
2. Notation consistency:
   - Database schema: S = {T₁, T₂, ..., Tₙ}
   - Natural language question: Q
   - SQL query: SQL
   - Results: R
3. Citation format consistency (IEEE/ACM style)
4. Figure/table reference consistency (Figure 1, Table 1, etc.)
5. Section numbering and cross-references
6. Abbreviation consistency:
   - NL2SQL: Define once, use consistently
   - LLM: Large Language Model (define once)
   - CrewAI: Framework name (capitalize consistently)

Paper sections:
- Abstract: [ABSTRACT]
- Introduction: [INTRODUCTION]
- Related Work: [RELATED_WORK]
- Methodology: [METHODOLOGY]
- Experiments: [EXPERIMENTS]
- Discussion: [DISCUSSION]
- Conclusion: [CONCLUSION]

Provide:
- Inconsistency report with specific line numbers
- Terminology glossary with preferred terms
- Notation table
- Abbreviation list with definitions
- Recommendations for standardization
```

---

## Additional Prompts

### For Experiments Section (if needed)

```
You are writing the Experiments section for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Structure:
1. Dataset: Spider dataset description, train/test split, complexity distribution
2. Experimental Setup: CrewAI configuration, Gemini 2.0 Flash settings, evaluation metrics
3. Baselines: Single-agent approaches, traditional seq2seq models, other multi-agent systems
4. Results: Exact match accuracy, execution accuracy, comparison tables
5. Ablation Studies: Impact of each agent, 4-step vs 6-step comparison
6. Error Analysis: Common error patterns, field selection errors (52.6%), failure cases

Include:
- Detailed experimental setup
- Statistical significance tests
- Error analysis with examples
- Comparison tables and figures
```

---

## Usage Notes

1. **Replace placeholders**: [X]%, [INSERT_TEXT], [CITE] with actual values
2. **Customize based on results**: Update accuracy numbers, error percentages with your actual results
3. **Add citations**: Replace [CITE] with actual citations from research phase
4. **Iterate**: Refine prompts based on initial outputs
5. **Combine with plan.md**: Use these prompts alongside the general workflow in plan.md

---

*Last Updated: [DATE]*
*Version: 1.0*

