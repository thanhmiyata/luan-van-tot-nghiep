# Scientific Paper Writing Plan & Prompts

## Overview
This document provides a comprehensive workflow and detailed prompts for writing a scientific paper using multiple LLM models, each optimized for specific tasks.

## Model Assignment

| Phase | Model | Purpose |
|-------|-------|---------|
| Research | Gemini 3 Pro | Literature review, finding related papers, data gathering |
| Abstract | GPT-5 | Concise summary of entire paper |
| Introduction | GPT-5 | Problem statement, motivation, contributions |
| Methodology | GPT-5 | Technical details, architecture, algorithms |
| Related Work | Opus 4.5 | Comprehensive literature review and comparison |
| Discussion | Opus 4.5 | Analysis, interpretation, limitations |
| Conclusion | ChatGPT 5 | Summary, future work, concise and accurate |
| Review | ChatGPT 5 | Grammar check, technical accuracy verification |

---

## Phase 1: Research (Gemini 3 Pro)

### Objective
Gather comprehensive background information, identify related work, and understand the research landscape.

### Prompt Template

```
You are a research assistant helping to prepare a scientific paper on [TOPIC]. 

Your task is to:
1. Identify the top 20-30 most relevant papers in the field of [TOPIC]
2. Summarize key contributions of each paper
3. Identify research gaps and opportunities
4. List important datasets, benchmarks, and evaluation metrics used in this field
5. Identify common methodologies and approaches
6. Note any recent trends or emerging techniques

Focus on papers from:
- Top-tier conferences: [CONFERENCE_NAMES]
- High-impact journals: [JOURNAL_NAMES]
- Recent work (2020-2024)

Provide your findings in a structured format:
- Paper title, authors, venue, year
- Key contribution (2-3 sentences)
- Methodology summary
- Results/Findings
- Relevance to our work

Format the output as a markdown document with clear sections.
```

### Example for NL2SQL Multi-Agent System

```
You are a research assistant helping to prepare a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Your task is to:
1. Identify the top 20-30 most relevant papers in NL2SQL and Multi-Agent Systems
2. Summarize key contributions of each paper
3. Identify research gaps between single-agent and multi-agent approaches for NL2SQL
4. List important datasets (Spider, WikiSQL, etc.) and evaluation metrics (exact match, execution accuracy)
5. Identify common methodologies: sequence-to-sequence, semantic parsing, retrieval-augmented generation
6. Note recent trends: LLM-based approaches, tool learning, agentic RAG

Focus on papers from:
- Top-tier conferences: ACL, EMNLP, NAACL, SIGIR, ICML, NeurIPS
- High-impact journals: TACL, JMLR, AI Journal
- Recent work (2020-2024)

Provide your findings in a structured format with clear sections.
```

### Output Format Expected
- `research_findings.md` with categorized papers
- `related_work_summary.md` with key themes
- `datasets_benchmarks.md` with evaluation details

---

## Phase 2: Abstract (GPT-5)

### Objective
Create a concise, compelling abstract that summarizes the entire paper in 150-250 words.

### Prompt Template

```
You are writing the abstract for a scientific paper on [TOPIC]. 

Requirements:
- Length: 150-250 words
- Structure: Problem → Approach → Results → Impact
- Use formal academic language
- Include key metrics/numbers if available
- No citations in abstract
- Write in third person

Context:
- Research Problem: [PROBLEM_DESCRIPTION]
- Proposed Solution: [SOLUTION_OVERVIEW]
- Key Contributions: [CONTRIBUTION_1], [CONTRIBUTION_2], [CONTRIBUTION_3]
- Main Results: [KEY_RESULTS]
- Dataset/Evaluation: [DATASET_NAME], [METRICS]

Write an abstract that:
1. Clearly states the problem and its importance
2. Briefly describes your approach/methodology
3. Highlights key contributions
4. Presents main experimental results with specific numbers
5. Concludes with the impact or significance

Ensure the abstract is:
- Self-contained (readable without reading the paper)
- Accurate (all claims must be verifiable in the paper)
- Compelling (encourages readers to continue)
```

### Example for NL2SQL

```
You are writing the abstract for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Requirements:
- Length: 200-250 words
- Structure: Problem → Approach → Results → Impact
- Use formal academic language
- Include key metrics
- No citations

Context:
- Research Problem: Traditional NL2SQL systems struggle with complex queries requiring multi-step reasoning and database schema understanding
- Proposed Solution: Multi-agent system with specialized agents for query understanding, schema analysis, SQL generation, and validation
- Key Contributions: 
  1. Novel multi-agent architecture for NL2SQL
  2. Iterative refinement mechanism
  3. Comprehensive evaluation on Spider dataset
- Main Results: 85.2% exact match accuracy, 92.1% execution accuracy on Spider test set
- Dataset/Evaluation: Spider dataset, exact match and execution accuracy metrics

Write a compelling abstract following the structure above.
```

---

## Phase 3: Introduction (GPT-5)

### Objective
Set the context, motivate the problem, and outline contributions.

### Prompt Template

```
You are writing the Introduction section for a scientific paper on [TOPIC].

Structure the introduction as follows:

1. **Opening Paragraph** (3-4 sentences)
   - Broad context of the field
   - General importance of the problem
   - Current state/trends

2. **Problem Statement** (2-3 paragraphs)
   - Specific challenges in the field
   - Limitations of existing approaches
   - Why current solutions are insufficient
   - Use citations: [CITE_RELEVANT_PAPERS]

3. **Our Approach** (1-2 paragraphs)
   - High-level overview of proposed solution
   - Key ideas/innovations
   - How it addresses the identified problems

4. **Contributions** (1 paragraph, bullet points)
   - Contribution 1: [DESCRIPTION]
   - Contribution 2: [DESCRIPTION]
   - Contribution 3: [DESCRIPTION]

5. **Paper Organization** (1 paragraph)
   - Brief roadmap of paper sections

Requirements:
- Length: 800-1200 words
- Use formal academic language
- Include 8-12 citations
- Write in third person
- Avoid overly technical details (save for methodology)
- Create a narrative flow that guides the reader

Context from research phase:
[INSERT_RELEVANT_FINDINGS_FROM_RESEARCH]

Key papers to cite:
[LIST_OF_IMPORTANT_PAPERS]
```

### Example for NL2SQL

```
You are writing the Introduction section for a scientific paper on "Natural Language to SQL using Multi-Agent Systems".

Structure:
1. Opening: NL2SQL importance, LLM advances, need for accurate database querying
2. Problem: Complex queries, schema understanding, error handling in single-agent systems
3. Approach: Multi-agent collaboration with specialized roles
4. Contributions: Architecture, evaluation framework, results
5. Organization: Brief section overview

Include citations to: Seq2SQL, SyntaxSQLNet, RAT-SQL, RESDSQL, recent LLM-based approaches
```

---

## Phase 4: Methodology (GPT-5)

### Objective
Provide detailed technical description of the proposed approach.

### Prompt Template

```
You are writing the Methodology section for a scientific paper on [TOPIC].

Structure:

1. **Overview** (1 paragraph)
   - High-level architecture description
   - Main components and their relationships

2. **Problem Formulation** (1-2 paragraphs)
   - Formal definition of the problem
   - Notation and terminology
   - Input/output specifications

3. **Architecture Details** (3-5 subsections)
   - For each major component:
     * Purpose and role
     * Technical details
     * Algorithms (if applicable)
     * Mathematical formulations (if applicable)
   - Include diagrams/figures descriptions

4. **Implementation Details** (1-2 paragraphs)
   - Key design choices
   - Hyperparameters
   - Training/inference procedures

Requirements:
- Length: 1500-2500 words
- Be precise and technical
- Use mathematical notation where appropriate
- Include pseudocode for key algorithms
- Reference figures/diagrams: "As shown in Figure X"
- Use consistent notation throughout
- Explain design choices and trade-offs

Context:
- System Architecture: [ARCHITECTURE_DESCRIPTION]
- Key Components: [COMPONENT_LIST]
- Algorithms: [ALGORITHM_DESCRIPTIONS]
- Technical Specifications: [TECHNICAL_DETAILS]
```

### Example for NL2SQL Multi-Agent

```
You are writing the Methodology section for a multi-agent NL2SQL system.

Structure:
1. Overview: Multi-agent architecture with 4-6 specialized agents
2. Problem Formulation: NL2SQL as a sequence-to-sequence task with schema constraints
3. Architecture:
   - Agent 1: Query Understanding Agent (intent, entities)
   - Agent 2: Schema Analysis Agent (table/column selection)
   - Agent 3: SQL Generation Agent (syntax, structure)
   - Agent 4: Validation Agent (syntax check, semantic validation)
   - Agent 5: Refinement Agent (iterative improvement)
4. Implementation: CrewAI framework, GPT-4 as base LLM, specific prompts

Include technical details, agent communication protocols, and iteration mechanisms.
```

---

## Phase 5: Related Work (Opus 4.5)

### Objective
Comprehensive literature review with critical analysis and positioning of our work.

### Prompt Template

```
You are writing the Related Work section for a scientific paper on [TOPIC].

Structure:

1. **Introduction to Related Work** (1 paragraph)
   - Scope of the review
   - Organization of the section

2. **Main Categories** (3-5 subsections)
   For each category:
   - **Category Name** (e.g., "Traditional NL2SQL Approaches")
     * Overview of the category
     * Key papers and their contributions
     * Strengths and limitations
     * Relationship to our work
   - Include 5-8 papers per category with detailed analysis

3. **Comparison and Positioning** (1-2 paragraphs)
   - How our approach differs from existing work
   - What we borrow/improve upon
   - Novel aspects

4. **Gaps and Opportunities** (1 paragraph)
   - What existing work doesn't address
   - Why our approach is needed

Requirements:
- Length: 1500-2000 words
- Include 20-30 citations
- Critical analysis, not just summaries
- Group related work logically
- Compare and contrast different approaches
- Position our work clearly within the landscape
- Use phrases like: "In contrast to...", "Unlike...", "Building upon..."
- Acknowledge limitations of existing work fairly

Research findings to incorporate:
[INSERT_FINDINGS_FROM_RESEARCH_PHASE]

Key papers to discuss:
[LIST_OF_PAPERS_FROM_RESEARCH]
```

### Example for NL2SQL

```
You are writing the Related Work section for a multi-agent NL2SQL paper.

Categories:
1. Traditional NL2SQL Approaches (Seq2SQL, SyntaxSQLNet, RAT-SQL)
2. LLM-based NL2SQL (GPT-based, fine-tuned models)
3. Multi-Agent Systems in NLP (general approaches)
4. Tool Learning and Agentic RAG (relevant frameworks)

For each: analyze contributions, limitations, and how our work relates.
```

---

## Phase 6: Discussion (Opus 4.5)

### Objective
Analyze results, discuss implications, acknowledge limitations, and provide insights.

### Prompt Template

```
You are writing the Discussion section for a scientific paper on [TOPIC].

Structure:

1. **Summary of Results** (1 paragraph)
   - Key findings from experiments
   - Main achievements

2. **Analysis of Results** (2-3 paragraphs)
   - Why the results are as they are
   - What factors contributed to success/failure
   - Comparison with baselines and related work
   - Interpretation of metrics

3. **Ablation Studies Analysis** (1-2 paragraphs)
   - What each component contributes
   - Most/least important components
   - Design choices validated

4. **Error Analysis** (1-2 paragraphs)
   - Common failure cases
   - Patterns in errors
   - Why certain cases are challenging

5. **Limitations** (1-2 paragraphs)
   - Honest assessment of limitations
   - Scope of applicability
   - Constraints and assumptions

6. **Implications** (1 paragraph)
   - What these results mean for the field
   - Practical applications
   - Future research directions

Requirements:
- Length: 1000-1500 words
- Be critical and honest
- Use specific examples from experiments
- Reference tables/figures: "As shown in Table X"
- Discuss both strengths and weaknesses
- Provide actionable insights

Context:
- Experimental Results: [KEY_RESULTS]
- Ablation Studies: [ABLATION_FINDINGS]
- Error Cases: [ERROR_ANALYSIS]
- Baselines: [BASELINE_COMPARISONS]
```

### Example for NL2SQL

```
You are writing the Discussion section analyzing:
- 85.2% exact match on Spider test set
- Ablation showing multi-agent > single-agent
- Error analysis: complex JOINs, nested queries
- Limitations: requires schema information, English only
- Implications: practical database querying, future multi-language support
```

---

## Phase 7: Conclusion (ChatGPT 5)

### Objective
Concise summary, contributions recap, and future work.

### Prompt Template

```
You are writing the Conclusion section for a scientific paper on [TOPIC].

Structure:

1. **Summary** (2-3 sentences)
   - Restate the problem
   - Brief reminder of approach

2. **Contributions Recap** (1 paragraph, 3-4 bullet points)
   - Contribution 1: [BRIEF_DESCRIPTION]
   - Contribution 2: [BRIEF_DESCRIPTION]
   - Contribution 3: [BRIEF_DESCRIPTION]

3. **Key Results** (2-3 sentences)
   - Main achievements
   - Key metrics (be specific)

4. **Future Work** (1 paragraph)
   - 3-4 concrete directions
   - Be specific, not generic

Requirements:
- Length: 200-300 words
- Be concise and precise
- No new information
- No citations (unless absolutely necessary)
- Write in third person
- End on a forward-looking note

Context:
- Problem: [PROBLEM_STATEMENT]
- Approach: [APPROACH_SUMMARY]
- Contributions: [CONTRIBUTION_LIST]
- Results: [KEY_RESULTS]
```

### Example for NL2SQL

```
Conclusion for multi-agent NL2SQL paper:
- Summary: Addressed complex NL2SQL with multi-agent system
- Contributions: Architecture, evaluation, 85.2% accuracy
- Results: Outperforms single-agent by 12.3%
- Future: Multi-language support, schema learning, real-time adaptation
```

---

## Phase 8: Review & Refinement (ChatGPT 5)

### Objective
Grammar check, technical accuracy verification, consistency check.

### Prompt Template for Grammar Check

```
You are a scientific writing editor reviewing a paper section on [TOPIC].

Task: Review the following text for:
1. Grammar and spelling errors
2. Sentence structure and clarity
3. Academic writing style
4. Consistency in terminology
5. Proper use of technical terms

Text to review:
[INSERT_TEXT]

Provide:
- Corrected version with changes highlighted
- List of grammar/spelling errors found
- Suggestions for clarity improvements
- Terminology consistency notes
```

### Prompt Template for Technical Accuracy

```
You are a technical reviewer for a scientific paper on [TOPIC].

Task: Verify technical accuracy of the following section:
1. Are all technical claims correct?
2. Are algorithms/formulas accurate?
3. Are experimental results consistent?
4. Are citations appropriate and accurate?
5. Are numbers/metrics correct?
6. Is the methodology sound?

Section to review:
[INSERT_SECTION]

Provide:
- List of potential technical inaccuracies
- Questions about unclear technical points
- Suggestions for clarification
- Verification of mathematical formulations
- Cross-check with methodology section
```

### Prompt Template for Consistency Check

```
You are reviewing a complete scientific paper for consistency.

Check:
1. Terminology consistency across sections
2. Notation consistency (same symbols mean same things)
3. Citation format consistency
4. Figure/table reference consistency
5. Section numbering and cross-references
6. Abbreviation consistency (define once, use consistently)

Paper sections:
- Abstract: [ABSTRACT]
- Introduction: [INTRODUCTION]
- Related Work: [RELATED_WORK]
- Methodology: [METHODOLOGY]
- Experiments: [EXPERIMENTS]
- Discussion: [DISCUSSION]
- Conclusion: [CONCLUSION]

Provide:
- Inconsistency report
- Terminology glossary
- Notation table
- Abbreviation list
```

---

## Complete Workflow Checklist

### Pre-Writing
- [ ] Define research topic and scope
- [ ] Gather initial papers and resources
- [ ] Outline paper structure
- [ ] Identify key contributions

### Phase 1: Research (Gemini 3 Pro)
- [ ] Run research prompt
- [ ] Review and organize findings
- [ ] Create paper list with summaries
- [ ] Identify key themes and gaps

### Phase 2: Abstract (GPT-5)
- [ ] Write abstract draft
- [ ] Review for completeness
- [ ] Check word count (150-250)
- [ ] Verify all claims are in paper

### Phase 3: Introduction (GPT-5)
- [ ] Write introduction
- [ ] Add citations (8-12)
- [ ] Verify problem statement clarity
- [ ] Check contributions are clear

### Phase 4: Methodology (GPT-5)
- [ ] Write detailed methodology
- [ ] Include all technical details
- [ ] Add algorithm descriptions
- [ ] Reference figures/diagrams

### Phase 5: Related Work (Opus 4.5)
- [ ] Write comprehensive review
- [ ] Include 20-30 citations
- [ ] Critical analysis of each category
- [ ] Position our work clearly

### Phase 6: Discussion (Opus 4.5)
- [ ] Analyze all results
- [ ] Discuss limitations honestly
- [ ] Provide error analysis
- [ ] Connect to broader implications

### Phase 7: Conclusion (ChatGPT 5)
- [ ] Write concise conclusion
- [ ] Recap contributions
- [ ] List future work
- [ ] Keep under 300 words

### Phase 8: Review (ChatGPT 5)
- [ ] Grammar check entire paper
- [ ] Technical accuracy verification
- [ ] Consistency check
- [ ] Final polish

### Post-Writing
- [ ] Format references
- [ ] Create/verify figures
- [ ] Add table of contents
- [ ] Final proofread
- [ ] Submit/peer review preparation

---

## Tips for Each Model

### Gemini 3 Pro (Research)
- Use for broad information gathering
- Leverage long context window for comprehensive reviews
- Ask for structured outputs (markdown, tables)
- Request source citations

### GPT-5 (Abstract, Introduction, Methodology)
- Use for precise, technical writing
- Provide clear structure requirements
- Request specific formatting
- Use for mathematical/algorithmic content

### Opus 4.5 (Related Work, Discussion)
- Use for analytical, critical writing
- Leverage for nuanced comparisons
- Request deep analysis, not just summaries
- Use for positioning arguments

### ChatGPT 5 (Conclusion, Review)
- Use for concise, accurate summaries
- Leverage for editing and refinement
- Request specific checks (grammar, technical)
- Use for final polish

---

## Quality Control

### Before Final Submission
1. **Completeness Check**
   - All sections present
   - All figures/tables referenced
   - All citations resolved

2. **Accuracy Check**
   - All numbers/metrics verified
   - All technical claims supported
   - All citations accurate

3. **Clarity Check**
   - Clear writing throughout
   - Logical flow between sections
   - Appropriate level of detail

4. **Format Check**
   - Consistent citation style
   - Proper formatting
   - Page limits met

5. **Originality Check**
   - No plagiarism
   - Proper attribution
   - Original contributions clear

---

## Notes

- **Iterative Refinement**: Don't expect perfect output on first try. Refine prompts based on results.
- **Human Review**: Always have domain experts review technical content.
- **Citation Management**: Use Zotero/Mendeley for reference management.
- **Version Control**: Keep versions of each section as you refine.
- **Backup**: Save all outputs and prompts for reproducibility.

---

## Example Timeline

| Week | Phase | Deliverable |
|------|-------|------------|
| 1 | Research | Literature review document |
| 2 | Abstract + Introduction | First draft of intro sections |
| 3 | Methodology | Technical section complete |
| 4 | Related Work | Literature review section |
| 5 | Discussion | Analysis and discussion |
| 6 | Conclusion + Review | Final draft ready |
| 7 | Polish + Format | Submission-ready paper |

---

*Last Updated: [DATE]*
*Version: 1.0*

