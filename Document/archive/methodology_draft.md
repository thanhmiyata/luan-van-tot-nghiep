# Methodology - Natural Language to SQL using Multi-Agent Systems

## Draft Version

### 1. Overview

As shown in Figure 1, our multi-agent architecture for Natural Language to SQL (NL2SQL) translation leverages the CrewAI framework to orchestrate six specialized agents working collaboratively. The system architecture follows a sequential pipeline where each agent performs a specific role in the query generation process: question analysis, schema selection, query planning, SQL generation, single-pass refinement, and validation.

The agent collaboration flow proceeds as follows: a natural language question is first analyzed by the Question Analyzer to identify intent and required fields. The Schema Selector then filters relevant tables and columns from the database schema. The Query Planner creates a logical execution plan, followed by the SQL Expert generating the SQL query. The SQL Refiner then reviews and refines the generated SQL query, and finally, the SQL Validator checks syntax and semantic correctness.

To evaluate the impact of different architectural components, we compare two pipeline variants: a 4-step baseline pipeline (Question Analyzer → Schema Selector → SQL Expert → SQL Validator) and the full 6-step architecture that includes Query Planner and SQL Refiner. This comparison allows us to assess the contribution of query planning and single-pass refinement to overall system accuracy.

### 2. Problem Formulation

The NL2SQL task can be formally defined as follows: given a natural language question Q and a database schema S, generate an executable SQL query SQL such that executing SQL on database D returns results R that correctly answer Q. The input consists of a pair (Q, S), where Q is a natural language question and S = {T₁, T₂, ..., Tₙ} is a set of tables, each containing a set of columns. Each table Tᵢ has a schema defined by its columns Cᵢ = {c₁, c₂, ..., cₘ}, where columns may have constraints such as primary keys, foreign keys, and data types. The output is a syntactically and semantically correct SQL query that can be executed on the database D to retrieve the desired information.

The evaluation of NL2SQL systems employs two primary metrics: exact match accuracy and execution accuracy. Exact match accuracy measures whether the generated SQL query exactly matches the gold standard SQL query (syntactic correctness), while execution accuracy measures whether executing the generated SQL query produces the same results as executing the gold standard query (semantic correctness). Execution accuracy is generally considered more lenient and practical, as multiple SQL queries can produce the same results. Our system is evaluated on the Spider dataset [Yu et al., 2018], which contains complex, cross-domain natural language questions paired with their corresponding SQL queries across 200 databases.

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

### 3. Multi-Agent Architecture

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

### 4. Agent Collaboration Flow

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

### 5. Pipeline Variants

Figure 3 compares the 4-step and 6-step pipeline variants. To evaluate the impact of different architectural components, we implement two pipeline variants. The **4-step baseline pipeline** consists of: Question Analyzer → Schema Selector → SQL Expert → SQL Validator. This simplified pipeline excludes the Query Planner and SQL Refiner agents, representing a more traditional single-pass generation approach with basic validation. The **6-step full pipeline** includes all six agents: Question Analyzer → Schema Selector → Query Planner → SQL Expert → SQL Refiner → SQL Validator. This full architecture enables query planning and single-pass refinement, representing our complete multi-agent system.

The comparison between these two variants allows us to assess: (1) the impact of query planning on query accuracy and structure, (2) the contribution of single-pass refinement to error correction and query improvement, and (3) the trade-off between pipeline complexity and accuracy gains. This ablation study provides insights into which components are most critical for NL2SQL performance and validates our design choices regarding agent specialization and refinement mechanisms.

### 6. Implementation Details

**Framework and Infrastructure:** Our system is implemented using the CrewAI framework [Moura et al., 2023-2024], which provides agent orchestration, task delegation, and information sharing capabilities. CrewAI enables us to define specialized agent roles, specify agent goals and backstories, and manage the flow of information between agents. The framework handles agent communication, context management, and task sequencing, allowing us to focus on agent design and prompt engineering.

**Base Language Model:** All six agents use Gemini 2.0 Flash as their underlying language model. This choice provides consistent reasoning capabilities across agents while maintaining computational efficiency. Gemini 2.0 Flash offers strong natural language understanding, code generation capabilities, and the ability to follow detailed instructions, making it well-suited for the diverse tasks performed by our agents.

**Prompt Engineering:** Each agent has a detailed backstory and set of rules defined through prompt engineering. The backstories establish the agent's expertise and role (e.g., "You are an expert SQL query analyzer with deep understanding of database schemas"), while the rules specify the agent's behavior and constraints (e.g., "Always identify required fields for SELECT clause", "Never generate SQL code, only logical plans"). These prompts are carefully crafted to guide agent behavior and prevent common error patterns. The prompts include examples of correct and incorrect outputs, error pattern awareness, and specific instructions for handling edge cases.

**Error Pattern Training:** Agents are made aware of common error patterns through their prompts. The Question Analyzer is trained to recognize field selection challenges, the SQL Expert is aware of JOIN logic errors and aggregation mistakes, and the SQL Refiner knows how to fix these issues. This error pattern awareness is embedded in the agent prompts through explicit rules and examples, enabling agents to avoid known pitfalls and correct common mistakes.

**Output Format:** The system generates SQL queries in single-line format for execution. This format is consistent with the Spider dataset evaluation framework and enables direct execution on databases. All agents produce JSON-structured outputs: Question Analyzer returns JSON with intent, complexity, entities (as JSON string), requirements (as JSON string containing expected_output_fields and field_order_critical), patterns (as JSON string), linguistic_notes, and confidence; Schema Selector returns JSON matching the original schema structure (db_id, table_names_original, column_names_original, column_types) but with filtered content; Query Planner returns JSON with plan field; SQL Expert returns JSON with sql field; SQL Refiner returns JSON with sql and notes fields; SQL Validator returns JSON with sql, explain, and error fields. The SQL Expert and SQL Refiner agents are specifically instructed to produce single-line SQL queries without formatting or comments, ensuring compatibility with evaluation tools.

**Single-Pass Refinement Configuration:** The SQL Refiner performs a single-pass refinement operation, reviewing the initial SQL query and producing an improved version if needed. The agent compares the SQL against the question requirements, analysis, and query plan, making improvements in field selection, query structure, and logic alignment. If the initial SQL is already optimal, the Refiner keeps it unchanged. This single-pass approach balances improvement potential with computational efficiency, avoiding the complexity and cost of iterative loops while still enabling query refinement.

**Hyperparameters:** The system uses consistent hyperparameters across all agents using Gemini 2.0 Flash. The temperature is set to 0.3 to balance creativity and determinism, ensuring consistent outputs while allowing some variation for error correction. The max_tokens parameter is set to 2048 to accommodate complex SQL queries and detailed agent outputs. The top_p (nucleus sampling) is set to 0.95 to maintain high-quality token selection. These hyperparameters (temperature=0.3, max_tokens=2048, top_p=0.95) were selected through preliminary experiments to balance accuracy, consistency, and computational efficiency. Note that actual values may be influenced by CrewAI framework defaults and Gemini 2.0 Flash API settings.

---

**Word Count:** ~2,400 words
**Status:** Draft
**Figure References:** 
- Figure 1: Multi-agent architecture diagram (to be added)
- Figure 2: Agent collaboration flow diagram (to be added)
- Figure 3: Pipeline variants comparison (to be added)

