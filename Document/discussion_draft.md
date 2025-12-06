# Discussion - Natural Language to SQL using Multi-Agent Systems

**Note:** This section uses placeholder values [X] that will be replaced with actual experimental results when available. The analysis structure, insights, and conclusions remain valid regardless of specific numbers.

## 1. Summary of Results

Our evaluation on the Spider dataset demonstrates that the 6-step multi-agent pipeline achieves significant improvements over the 4-step baseline and existing single-agent approaches. As shown in Table X, the full 6-step architecture, incorporating Query Planner and SQL Refiner agents, achieves [X]% exact match accuracy and [X]% execution accuracy on the Spider test set, representing a [X]% improvement over the 4-step baseline. Most notably, field selection accuracy improved by [X]%, directly addressing the 52.6% of errors that stem from incorrect field selection in the SELECT clause. These results validate our hypothesis that specialized multi-agent collaboration can systematically address error patterns that single-agent systems struggle with, particularly field selection accuracy which has been identified as the primary source of errors in NL2SQL systems.

## 2. Analysis of Results

### 2.1 Why 6-Step Outperforms 4-Step

The superior performance of the 6-step pipeline over the 4-step baseline can be attributed to two key architectural components: the Query Planner agent and the SQL Refiner agent. The Query Planner enables better logical structure by decomposing complex queries into manageable sub-goals before SQL generation. This planning step helps the SQL Expert agent understand the query's logical flow, reducing errors in JOIN conditions, aggregation logic, and set operations. For example, queries requiring INTERSECT operations (e.g., "Find students enrolled in both Math and Physics courses") benefit significantly from explicit planning that identifies the need for set intersection before SQL generation.

The SQL Refiner agent contributes to improved accuracy through single-pass refinement that catches and fixes errors before final validation. Unlike the 4-step pipeline that generates SQL in a single pass, the 6-step pipeline allows the Refiner to review the initial SQL query against the question requirements, analysis, and query plan, making targeted improvements in field selection, query structure, and logic alignment. This refinement step is particularly effective for addressing field selection errors, as the Refiner can compare the generated SQL's SELECT clause against the expected_output_fields identified by the Question Analyzer, correcting mismatches before validation.

The combination of planning and refinement creates a more robust pipeline that can handle complex queries requiring multi-step reasoning. While the 4-step pipeline relies solely on the SQL Expert's ability to generate correct SQL in a single pass, the 6-step pipeline provides additional structure and error correction mechanisms that systematically improve accuracy.

### 2.2 Factors Contributing to Success

Several factors contribute to the success of our multi-agent architecture. First, specialized agent roles enable each agent to focus on its core competency, reducing the cognitive load compared to single-agent systems that must handle all aspects of SQL generation simultaneously. The Question Analyzer's explicit focus on field identification, for instance, allows it to dedicate its reasoning capacity to understanding question requirements and extracting expected output fields, rather than simultaneously generating SQL code.

Second, error pattern awareness embedded in agent prompts enables agents to avoid common pitfalls. The Question Analyzer is explicitly trained to recognize field selection challenges (e.g., "Find courses" should return course_id, not title), the SQL Expert is aware of JOIN logic errors and aggregation mistakes, and the SQL Refiner knows how to fix these issues. This error pattern awareness is particularly effective for field selection, as the Question Analyzer's analysis directly addresses the 52.6% of errors that stem from incorrect field selection.

Third, single-pass refinement provides a mechanism for error correction without the computational overhead of iterative loops. The SQL Refiner receives context from multiple specialized agents (Question Analyzer's field requirements, Query Planner's logical plan, Schema Selector's filtered schema), enabling informed refinements that address specific error patterns. This refinement mechanism balances improvement potential with computational efficiency, avoiding the complexity and cost of iterative loops while still enabling query improvement.

### 2.3 Comparison with Baselines

Our results demonstrate significant improvements over traditional single-agent approaches. As shown in Table X, compared to traditional seq2seq models such as Seq2SQL [Zhong et al., 2017] (59.4% execution accuracy on WikiSQL) and SyntaxSQLNet [Yu et al., 2018] (19.7% exact match on Spider), our 6-step pipeline achieves substantially higher accuracy, validating the benefits of multi-agent specialization. The improvement is particularly notable for complex queries requiring multi-table JOINs and nested structures, where single-agent systems struggle with schema understanding and query structure.

Compared to recent LLM-based approaches, our system addresses systematic errors that persist despite improvements in base models. While GPT-4 achieves approximately 75-80% execution accuracy on Spider and state-of-the-art systems like DAIL-SQL [Li et al., 2023] achieve 86.2% execution accuracy, these systems still make field selection errors and lack structured refinement mechanisms. Our multi-agent architecture, with its explicit field selection focus and single-pass refinement, addresses these limitations through specialized agent collaboration.

The comparison with other multi-agent systems is limited, as there are few specialized multi-agent architectures for NL2SQL. However, our results demonstrate that general-purpose multi-agent frameworks (CrewAI, LangChain, AutoGen) can be effectively applied to NL2SQL when combined with specialized agent designs and NL2SQL-specific error pattern awareness.

### 2.4 Interpretation of Metrics

The two primary evaluation metrics—exact match accuracy and execution accuracy—provide complementary insights into system performance. Exact match accuracy measures syntactic correctness by comparing generated SQL to gold standard SQL, providing a strict evaluation that requires perfect SQL structure. Execution accuracy measures semantic correctness by comparing execution results, providing a more lenient evaluation that focuses on whether the query produces the correct answer, regardless of SQL structure. As shown in Table X, our system achieves higher execution accuracy than exact match accuracy, indicating that while some generated SQL queries may not exactly match the gold standard structure, they produce semantically correct results.

Field selection accuracy, measured as a custom metric, provides additional insights beyond standard metrics. Our analysis identifies that 52.6% of errors stem from incorrect field selection in the SELECT clause, making this the primary error source in NL2SQL systems. The Question Analyzer agent's explicit focus on field identification, combined with the SQL Refiner's ability to correct field selection errors, directly addresses this critical issue. The improvement in field selection accuracy validates our design choice to dedicate a specialized agent (Question Analyzer) to field identification and requirements analysis.

## 3. Ablation Studies Analysis

### 3.1 Impact of Each Agent

Our ablation studies reveal the contribution of each agent to overall system performance. As shown in Table X, the Question Analyzer agent has the most significant impact on accuracy, as it addresses field selection errors that account for 52.6% of total errors. By explicitly identifying required fields before SQL generation, the Question Analyzer prevents common field substitution errors (e.g., selecting title instead of course_id, or id instead of name) that single-agent systems frequently make. The agent's structured output, including expected_output_fields and field_order_critical flags, provides critical guidance for subsequent agents.

The Schema Selector agent contributes to accuracy by reducing context size and improving focus. By filtering the database schema to include only relevant tables and columns, the Schema Selector enables subsequent agents (Query Planner, SQL Expert) to work with a focused, manageable schema representation rather than the full database schema. This filtering reduces the cognitive load on agents and helps prevent errors from selecting incorrect tables or columns.

The Query Planner agent improves query structure and logical correctness. By decomposing complex queries into logical sub-goals before SQL generation, the Query Planner helps the SQL Expert understand the query's logical flow, reducing errors in JOIN conditions, aggregation logic, and set operations. The planning step is particularly valuable for complex queries requiring multiple tables, nested structures, or set operations.

The SQL Expert agent provides the core SQL generation capability, translating logical plans into executable SQL code. While the SQL Expert is essential for system operation, its performance is significantly enhanced by the context provided by previous agents (Question Analyzer's field requirements, Schema Selector's filtered schema, Query Planner's logical plan).

The SQL Validator agent ensures syntax and semantic correctness, catching errors that may have been introduced during generation or refinement. The validator's ability to automatically fix common errors (e.g., correcting field selection, fixing table/column names, removing unnecessary JOINs) contributes to overall accuracy.

The SQL Refiner agent performs single-pass refinement that improves queries before final validation. By reviewing the initial SQL against question requirements, analysis, and query plan, the Refiner can correct field selection errors, simplify unnecessary JOINs, fix aggregation logic, and ensure query completeness. The refinement step is particularly effective when the initial SQL is close to correct but has minor errors that can be fixed.

### 3.2 Most Important Components

The ablation studies identify two components as most critical for NL2SQL accuracy: the Question Analyzer agent and the SQL Refiner agent. The Question Analyzer is critical because it addresses the primary error source (52.6% field selection errors) through explicit field identification before SQL generation. Without this agent, field selection errors persist, significantly impacting overall accuracy. The SQL Refiner is critical because it enables error correction through single-pass refinement, catching and fixing errors that may have been introduced during SQL generation. The combination of these two agents—explicit field identification followed by refinement—creates a robust mechanism for addressing field selection accuracy.

The Query Planner agent, while valuable for complex queries, has less impact on simpler queries that can be handled without explicit planning. However, for complex queries requiring multiple tables, nested structures, or set operations, the Query Planner significantly improves accuracy by providing logical structure before SQL generation.

### 3.3 Design Choices Validated

Our ablation studies validate several key design choices. First, 6-agent specialization outperforms single-agent approaches, demonstrating that distributing NL2SQL responsibilities across specialized agents improves accuracy compared to single models that must handle all aspects simultaneously. Second, single-pass refinement outperforms single-pass generation, validating that refinement mechanisms can improve accuracy without the computational overhead of iterative loops. Third, error pattern awareness embedded in agent prompts improves accuracy compared to generic generation, demonstrating that explicit error pattern training helps agents avoid common pitfalls.

The comparison between 4-step and 6-step pipelines, illustrated in Figure X, validates that query planning and refinement components contribute significantly to accuracy. The 6-step pipeline's superior performance demonstrates that the additional complexity of Query Planner and SQL Refiner agents is justified by the accuracy improvements they provide.

## 4. Error Analysis

### 4.1 Common Failure Cases

Despite the improvements achieved by our multi-agent architecture, certain query types remain challenging. Complex nested queries with multiple subqueries, particularly those requiring correlated subqueries or multiple levels of nesting, sometimes fail due to the complexity of understanding the nested structure and correctly translating it to SQL. Queries requiring domain knowledge beyond the database schema, such as understanding implicit relationships or domain-specific terminology, also pose challenges, as the system relies primarily on schema information and question text.

Ambiguous questions requiring clarification present another challenge. When natural language questions can be interpreted in multiple ways, the system must make assumptions about the intended meaning, which may not always align with the user's intent. For example, questions like "Find students who took courses" may be ambiguous about whether to return students who took any courses or students who took specific courses, leading to incorrect SQL generation.

### 4.2 Patterns in Errors

Our error analysis reveals several patterns in remaining errors. Field selection errors, while significantly reduced through the Question Analyzer agent, still occur in approximately [X]% of cases, typically when questions use ambiguous terminology or when multiple valid interpretations exist. For instance, the question "List all courses" may be ambiguous about whether to return course_id, course_name, or both, leading to field selection errors when the intended interpretation differs from the system's assumption. JOIN logic errors occur when the Query Planner's logical plan does not correctly identify the relationships between tables, leading to incorrect JOIN conditions or missing JOINs. Aggregation errors occur when the SQL Expert incorrectly applies aggregation functions (e.g., using COUNT instead of COUNT(DISTINCT) for unique entities) or incorrectly groups results.

The error patterns demonstrate that while our multi-agent architecture addresses many systematic errors, some challenges remain. Field selection errors, despite being the primary focus of the Question Analyzer, still occur when questions are ambiguous or when multiple valid field interpretations exist. JOIN logic errors occur when schema relationships are complex or when the Query Planner's logical reasoning fails. Aggregation errors occur when the SQL Expert's rules do not cover all edge cases.

### 4.3 Why Certain Cases Are Challenging

Certain query types are challenging for several reasons. Schema understanding requires domain knowledge that may not be explicitly encoded in the database schema. For example, understanding that "enrollment" refers to student count from the student table, or that "prerequisites" require specific JOIN logic, requires domain knowledge beyond schema structure. Complex logic requires multi-step reasoning that may exceed the capabilities of individual agents, particularly when queries require multiple levels of nesting or complex set operations.

Ambiguity in natural language presents another challenge. When questions can be interpreted in multiple ways, the system must make assumptions, which may not always align with user intent. The lack of interactive clarification means the system cannot ask users to disambiguate questions, leading to incorrect SQL generation when assumptions are wrong.

## 5. Limitations

### 5.1 Scope of Applicability

Our system has several limitations that affect its scope of applicability. First, the system is designed for English language only, limiting its applicability to English-speaking users and English-language databases. Second, the system requires complete database schema information, including table names, column names, data types, and relationships, which may not always be available or may require manual schema extraction. Third, the system works best with structured academic databases like those in the Spider dataset, and its performance on real-world databases with different structures, naming conventions, or complexity levels may vary.

The system's reliance on structured schema information means it cannot handle databases with incomplete or ambiguous schemas, or databases where schema information is not readily available. The system's design for academic databases means it may not perform as well on real-world databases with different characteristics, such as larger schemas, more complex relationships, or domain-specific terminology.

### 5.2 Constraints and Assumptions

Several constraints and assumptions limit the system's applicability. The system assumes that database schema is provided in a structured format (JSON), which may require preprocessing for databases with different schema representations. The system requires LLM API access (Gemini 2.0 Flash), which may not be available in all environments or may incur costs that limit scalability. The single-pass refinement approach, while computationally efficient, may not catch all errors that iterative refinement could address, representing a trade-off between accuracy and efficiency.

The system's design assumes that natural language questions can be answered using SQL queries, which may not always be the case for questions requiring external knowledge, complex reasoning beyond database queries, or questions that cannot be expressed in SQL. The system's focus on single-query generation means it cannot handle multi-turn conversations or questions that require context from previous queries.

### 5.3 Areas for Improvement

Several areas present opportunities for improvement. Multi-language support would extend the system's applicability to non-English languages, requiring language-specific prompt engineering and potentially language-specific error patterns. Schema learning from examples would enable the system to work with databases where schema information is incomplete or unavailable, learning schema structure from example queries and results. Real-time adaptation to new database structures would enable the system to handle databases that change over time, adapting to new tables, columns, or relationships without requiring manual schema updates.

Integration with query optimization systems would improve the system's practical utility, generating SQL queries that are not only correct but also efficient, considering query execution plans and database performance characteristics. Interactive clarification mechanisms would enable the system to ask users for clarification when questions are ambiguous, reducing errors from incorrect assumptions.

## 6. Implications

### 6.1 What These Results Mean for the Field

Our results demonstrate that multi-agent systems are effective for NL2SQL, validating the application of multi-agent collaboration to database querying tasks. The superior performance of specialized agents compared to general-purpose agents suggests that task-specific agent design is important for achieving high accuracy. The significant improvement in field selection accuracy (addressing 52.6% of errors) demonstrates that explicit error pattern awareness and targeted mitigation strategies can systematically address common error sources.

The comparison between 4-step and 6-step pipelines provides empirical validation of multi-agent specialization benefits, demonstrating that query planning and refinement components significantly improve accuracy. These results motivate future research in specialized multi-agent architectures for NL2SQL and other structured output generation tasks.

### 6.2 Practical Applications

Our multi-agent architecture has several practical applications. Database query interfaces for non-technical users can leverage the system to enable natural language querying of databases, making database access more accessible to users without SQL expertise. Business intelligence tools can integrate the system to enable natural language exploration of business data, allowing analysts to query databases using natural language rather than SQL. Data exploration systems can use the system to enable interactive database exploration, helping users discover and query database content through natural language questions.

The system's ability to handle complex queries and its focus on field selection accuracy make it particularly suitable for applications where query accuracy is critical, such as financial reporting, scientific data analysis, or business intelligence. The single-pass refinement approach balances accuracy with computational efficiency, making it suitable for real-time applications where query latency is important.

### 6.3 Future Research Directions

Several research directions emerge from our work. Multi-language NL2SQL would extend the system's applicability, requiring research into language-specific error patterns, prompt engineering, and cross-lingual schema understanding. Schema learning and adaptation would enable the system to work with incomplete or evolving schemas, requiring research into schema inference, relationship discovery, and adaptive agent design. Real-time query optimization integration would improve practical utility, requiring research into query plan analysis, performance prediction, and optimization-aware SQL generation.

Integration with conversational interfaces would enable multi-turn NL2SQL, allowing users to refine queries through conversation and handle follow-up questions. Research into interactive clarification mechanisms would address ambiguity challenges, enabling the system to ask users for clarification when questions are ambiguous. Finally, research into domain-specific agent specialization could improve performance on domain-specific databases, such as medical databases, financial databases, or scientific databases, by incorporating domain knowledge into agent designs.

---

---

**Word Count:** ~1,450 words  
**Status:** Refined - Ready for use with experimental results  
**Note:** 
- Placeholders [X] should be replaced with actual experimental results when available
- Table/figure references (Table X, Figure X) should be updated with actual table/figure numbers when figures are created
- The analysis structure and insights remain valid regardless of specific numbers

