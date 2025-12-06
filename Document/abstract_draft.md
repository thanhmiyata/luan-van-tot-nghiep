# Abstract - Natural Language to SQL using Multi-Agent Systems

## Draft Version

Traditional Natural Language to SQL (NL2SQL) systems struggle with complex queries requiring multi-step reasoning, accurate schema understanding, and proper SQL generation. Single-agent approaches often fail on complex JOINs, nested queries, and field selection accuracy, with field selection errors accounting for 52.6% of errors.

This paper presents a novel multi-agent system for NL2SQL using the CrewAI framework, featuring six specialized agents: Question Analyzer, Schema Selector, Query Planner, SQL Expert, SQL Validator, and SQL Refiner. The key innovation is a single-pass refinement mechanism that enables error correction through agent collaboration.

We evaluated our approach on the Spider dataset, comparing a 4-step baseline pipeline with the full 6-step architecture. The 6-step pipeline achieves [X]% exact match accuracy and [X]% execution accuracy on the Spider test set, demonstrating [X]% improvement over the 4-step baseline. Error analysis shows that field selection accuracy improved by [X]%, directly addressing the primary error source. Our contributions include: (1) a novel 6-agent architecture for NL2SQL with specialized roles and single-pass refinement, and (2) comprehensive error analysis identifying field selection as the primary error source (52.6% of errors) with targeted mitigation strategies.

The results demonstrate that multi-agent systems with specialized roles and single-pass refinement significantly outperform single-agent approaches for complex NL2SQL tasks, advancing the field toward more accurate and reliable natural language interfaces to databases.

---

**Word Count:** ~215 words
**Status:** Draft - Awaiting experimental results for final numbers
**Keywords:** Natural Language to SQL, Multi-Agent Systems, Database Querying, CrewAI, Spider Dataset

