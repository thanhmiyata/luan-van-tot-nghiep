# Sequential Tasks - Complete Paper Assembly

## Overview

This document provides sequential tasks with ready-to-use prompts for ChatGPT 5 to combine and finalize the complete scientific paper "Natural Language to SQL using Multi-Agent Systems".

**Model:** ChatGPT 5 (recommended for final assembly, formatting, and polish)

**Total Tasks:** 5 sequential tasks

---

## Prerequisites

### Files Available
- `Document/abstract_draft.md` or `Document/abstract_review.md`
- `Document/introduction_review.md`
- `Document/related_work_draft.md`
- `Document/methodology_draft.md`
- `Document/discussion_draft.md`
- `Document/conclusion_draft.md`
- `Document/phase8_review_reports.md` (for reference)

### Experimental Results Needed
- Exact match accuracy percentages
- Execution accuracy percentages
- Improvement percentages over baseline
- Field selection accuracy improvement

---

## Task 1: Combine All Sections into Single Document

### Objective
Combine all paper sections into one complete document with consistent formatting.

### Input Files Required
- Abstract draft/review
- Introduction review
- Related Work draft
- Methodology draft
- Discussion draft
- Conclusion draft

### Prompt for ChatGPT 5

```
You are assembling a complete scientific paper from individual sections. Your task is to combine all sections into a single, well-formatted document.

## Context
I have completed all sections of a scientific paper on "Natural Language to SQL using Multi-Agent Systems" and need you to combine them into one complete document.

## Files to Combine
Please read and combine these files in order:
1. `Document/abstract_draft.md` - Abstract section
2. `Document/introduction_review.md` - Introduction section
3. `Document/related_work_draft.md` - Related Work section
4. `Document/methodology_draft.md` - Methodology section
5. `Document/discussion_draft.md` - Discussion section
6. `Document/conclusion_draft.md` - Conclusion section

## Requirements

### Structure
Combine sections in this order:
1. Abstract
2. 1. Introduction
3. 2. Related Work
4. 3. Methodology
5. 4. Discussion (or Experiments + Discussion if separate)
6. 5. Conclusion

### Formatting
- Use consistent heading levels (# for title, ## for main sections, ### for subsections)
- Maintain consistent spacing between sections
- Keep all content from each section (do not remove anything)
- Preserve all citations in current format [Author et al., Year]
- Keep placeholders [X]% as-is (will be replaced in later task)

### Quality Checks
- Ensure smooth transitions between sections
- Remove any duplicate content
- Verify section numbering is sequential
- Check that all sections are included
- Maintain consistent terminology throughout

### Output Format
Provide:
1. Complete combined paper in markdown format
2. Brief summary of:
   - Total word count
   - Number of sections
   - Any issues found (duplicates, missing content, etc.)

## Notes
- Do not modify content, only combine and format
- Keep all technical details intact
- Preserve all citations and references
- Maintain academic writing style throughout
```

### Expected Output
- Single markdown file with all sections combined
- Consistent formatting
- Proper section numbering
- Word count summary

### Checklist
- [ ] All 6 sections included
- [ ] Consistent formatting
- [ ] Proper section numbering
- [ ] No duplicate content
- [ ] All citations preserved
- [ ] Placeholders [X]% still present

---

## Task 2: Format Citations and Create Reference List

### Objective
Convert citation format from [Author et al., Year] to journal-specific format (IEEE/ACM) and create complete reference list.

### Input Files Required
- Combined paper from Task 1
- `Document/related_work_draft.md` (for citation list)

### Prompt for ChatGPT 5

```
You are formatting citations and creating a reference list for a scientific paper.

## Context
I have a complete paper with citations in [Author et al., Year] format. I need you to:
1. Convert citations to IEEE/ACM format (or specify journal format if known)
2. Create a complete reference list
3. Verify all citations have corresponding references

## Input
- Combined paper from Task 1 (with all sections)
- `Document/related_work_draft.md` (contains citation information)

## Citation Format Conversion

### Current Format
[Author et al., Year] - e.g., [Zhong et al., 2017]

### Target Format (IEEE Style)
[1] V. Zhong, C. Xiong, and R. Socher, "Title," Venue, Year.

### Target Format (ACM Style)
[1] Author, V., Xiong, C., and Socher, R. Title. Venue, Year.

**Note:** If you know the target journal/conference, use their specific format. Otherwise, use IEEE format as default.

## Citations to Convert

Based on the paper, you should find citations for:
- Seq2SQL [Zhong et al., 2017]
- SyntaxSQLNet [Yu et al., 2018]
- RAT-SQL [Wang et al., 2020]
- RESDSQL [Ruan et al., 2023]
- BRIDGE [Gan et al., 2021]
- PICARD [Scholak et al., 2021]
- DIN-SQL [Pourreza & Rafiei, 2023]
- DAIL-SQL [Li et al., 2023]
- C3 [Li et al., 2023]
- CodeT5+ [Wang et al., 2023]
- GPT-3/4 [Various, 2022-2024]
- CrewAI [Moura et al., 2023-2024]
- LangChain [Chase et al., 2022-2024]
- AutoGen [Wang et al., 2023]
- Reflexion [Shinn et al., 2023]
- CRITIC [Yuan et al., 2023]
- Spider Dataset [Yu et al., 2018]
- WikiSQL [Zhong et al., 2017]
- BIRD [Li et al., 2023]
- And any other citations found in the paper

## Requirements

### Citation Conversion
1. Replace all [Author et al., Year] in-text citations with numbered citations [1], [2], etc.
2. Number citations in order of first appearance in the paper
3. Use consistent numbering throughout

### Reference List Creation
1. Create a "References" section at the end of the paper
2. List all references in order of citation number
3. Format each reference according to IEEE/ACM style
4. Include: Authors, Title, Venue/Journal, Year, Pages (if available)
5. For papers with incomplete information, use best available information and mark with [Note: incomplete information]

### Verification
1. Verify every in-text citation has a corresponding reference
2. Verify every reference is cited in the text
3. Check for duplicate citations (same paper cited multiple times should use same number)
4. Ensure consistent formatting across all references

## Output Format
Provide:
1. Updated paper with formatted citations [1], [2], etc.
2. Complete References section with all citations
3. Citation mapping table showing:
   - Old format → New number
   - Reference details
4. List of any citations that need additional information

## Notes
- If exact publication details are unknown, use best available information
- Mark incomplete references clearly
- Maintain academic citation standards
- Ensure all citations are properly attributed
```

### Expected Output
- Paper with numbered citations [1], [2], etc.
- Complete References section
- Citation mapping table
- List of incomplete citations (if any)

### Checklist
- [ ] All citations converted to numbered format
- [ ] Reference list created
- [ ] All citations have corresponding references
- [ ] All references are cited in text
- [ ] Consistent formatting
- [ ] No duplicate citations

---

## Task 3: Update Figure and Table References

### Objective
Replace all "Table X" and "Figure X" placeholders with actual numbers and ensure all references are correct.

### Input Files Required
- Paper from Task 2 (with formatted citations)

### Prompt for ChatGPT 5

```
You are updating figure and table references in a scientific paper.

## Context
The paper contains placeholder references like "Table X" and "Figure X" that need to be replaced with actual numbers (Table 1, Figure 1, etc.).

## Input
- Complete paper from Task 2

## Figure References to Update

Based on the paper content, identify and number:

1. **Figure 1:** Multi-agent architecture diagram
   - Referenced in: Methodology Section 1 (Overview)
   - Description: Shows the 6-agent architecture

2. **Figure 2:** Agent collaboration flow diagram
   - Referenced in: Methodology Section 4 (Agent Collaboration Flow)
   - Description: Shows sequential pipeline flow

3. **Figure 3:** Pipeline variants comparison
   - Referenced in: Methodology Section 5 (Pipeline Variants)
   - Description: Compares 4-step vs 6-step pipelines

4. **Figure X:** (if any in Discussion Section 3.3)
   - Referenced in: Discussion Section 3.3
   - Description: Pipeline comparison illustration

## Table References to Update

Based on the paper content, identify and number:

1. **Table 1:** Notation table
   - Location: Methodology Section 2 (Problem Formulation)
   - Already numbered correctly

2. **Table X:** Experimental results (main results)
   - Referenced in: Discussion Section 1 (Summary of Results)
   - Description: Shows 6-step vs 4-step comparison

3. **Table X:** Baseline comparison
   - Referenced in: Discussion Section 2.3 (Comparison with Baselines)
   - Description: Compares with traditional and LLM-based approaches

4. **Table X:** Metrics comparison
   - Referenced in: Discussion Section 2.4 (Interpretation of Metrics)
   - Description: Shows exact match vs execution accuracy

5. **Table X:** Ablation study results
   - Referenced in: Discussion Section 3.1 (Impact of Each Agent)
   - Description: Shows contribution of each agent

## Requirements

### Reference Updates
1. Replace all "Table X" with sequential numbers (Table 2, Table 3, etc.)
2. Replace all "Figure X" with sequential numbers (Figure 1, Figure 2, Figure 3, Figure 4, etc.)
3. Ensure numbering is sequential and logical
4. Update all references throughout the paper

### Verification
1. Check that all figure/table references have corresponding captions (if captions exist)
2. Verify numbering is consistent (no gaps, no duplicates)
3. Ensure references match the order they appear in the paper
4. Check that all references are necessary and accurate

### Caption Creation (if needed)
If figures/tables are mentioned but captions don't exist, create appropriate captions:
- Figure captions: Brief description of what the figure shows
- Table captions: Brief description of table content

## Output Format
Provide:
1. Updated paper with all figure/table references numbered correctly
2. List of all figures with their numbers and locations
3. List of all tables with their numbers and locations
4. Any missing captions that need to be created

## Notes
- Number figures and tables separately (Figure 1, Figure 2, Table 1, Table 2, etc.)
- Maintain sequential numbering
- Ensure all references are updated consistently
- If actual figures/tables don't exist yet, keep placeholders but note them clearly
```

### Expected Output
- Paper with numbered figure/table references
- List of all figures and tables
- Missing captions (if any)

### Checklist
- [ ] All "Table X" replaced with actual numbers
- [ ] All "Figure X" replaced with actual numbers
- [ ] Sequential numbering (no gaps)
- [ ] All references updated consistently
- [ ] Captions created (if needed)
- [ ] Reference list verified

---

## Task 4: Replace Placeholders with Experimental Results

### Objective
Replace all [X]% placeholders with actual experimental results.

### Input Files Required
- Paper from Task 3 (with updated references)
- Experimental results data

### Prompt for ChatGPT 5

```
You are replacing placeholder values with actual experimental results in a scientific paper.

## Context
The paper contains [X]% placeholders that need to be replaced with actual experimental results from the evaluation.

## Input
- Complete paper from Task 3
- Experimental results (provide actual numbers when available)

## Placeholders to Replace

Based on the paper, find and replace:

1. **Abstract:**
   - [X]% exact match accuracy
   - [X]% execution accuracy
   - [X]% improvement over baseline
   - [X]% field selection accuracy improvement

2. **Discussion Section 1 (Summary of Results):**
   - [X]% exact match accuracy
   - [X]% execution accuracy
   - [X]% improvement over 4-step baseline
   - [X]% field selection accuracy improvement

3. **Discussion Section 4.2 (Patterns in Errors):**
   - [X]% field selection error rate (remaining errors)

4. **Conclusion:**
   - [X]% exact match accuracy
   - [X]% execution accuracy
   - [X]% improvement over baseline
   - [X]% field selection accuracy improvement

## Requirements

### Replacement Process
1. Replace all [X]% with actual percentages
2. Ensure numbers are consistent across sections (same metric = same number)
3. Use appropriate precision (typically 1 decimal place for percentages)
4. Maintain consistency: if "85.2%" appears in Abstract, use same number in Conclusion

### Verification
1. Check that all placeholders are replaced
2. Verify consistency across sections (same results mentioned in multiple places should match)
3. Ensure numbers are realistic and make sense
4. Check that improvements are calculated correctly (6-step vs 4-step)

### Formatting
- Use consistent format: "X.X%" (e.g., "85.2%")
- For improvements, use "+X.X%" or "X.X% improvement" consistently
- Ensure all percentages are properly formatted

## Output Format
Provide:
1. Updated paper with all placeholders replaced
2. Results summary table showing:
   - Metric name
   - Value
   - Location(s) in paper
3. Consistency check report:
   - All instances of each metric
   - Verification that they match

## Notes
- If actual results are not yet available, clearly mark remaining placeholders
- Ensure all numbers are accurate and consistent
- Double-check calculations for improvements
- Maintain scientific precision (appropriate decimal places)
```

### Expected Output
- Paper with all placeholders replaced
- Results summary table
- Consistency check report

### Checklist
- [ ] All [X]% placeholders replaced
- [ ] Numbers consistent across sections
- [ ] Appropriate precision used
- [ ] Calculations verified
- [ ] Formatting consistent
- [ ] Results summary provided

---

## Task 5: Final Proofread and Format Check

### Objective
Final grammar check, consistency verification, and formatting according to journal requirements.

### Input Files Required
- Complete paper from Task 4 (with all updates)
- `Document/phase8_review_reports.md` (for reference)
- `Document/section_checklists.md` (for verification)

### Prompt for ChatGPT 5

```
You are performing final proofreading and format checking for a complete scientific paper.

## Context
I have a complete paper that has been assembled, formatted, and updated. I need you to perform a final comprehensive review.

## Input
- Complete paper from Task 4 (all sections combined, citations formatted, references updated, placeholders replaced)
- `Document/phase8_review_reports.md` (previous review for reference)
- `Document/section_checklists.md` (checklist for verification)

## Review Tasks

### 1. Grammar and Language Check
- Check for grammar and spelling errors
- Verify sentence structure and clarity
- Ensure academic writing style throughout
- Check for awkward phrasing
- Verify proper use of technical terms

### 2. Consistency Verification
- Terminology consistency (NL2SQL, multi-agent system, single-pass refinement, etc.)
- Agent names consistency (Question Analyzer, Schema Selector, etc.)
- Number consistency (52.6% field selection errors - verify all instances)
- Citation format consistency
- Figure/table reference consistency

### 3. Technical Accuracy Check
- Verify all technical claims are accurate
- Check that methodology descriptions match implementation
- Verify algorithm descriptions are correct
- Ensure all numbers/metrics are correct
- Check that citations are appropriate

### 4. Formatting Check
- Verify section numbering is sequential
- Check heading levels are consistent
- Ensure proper spacing and formatting
- Verify citation format is consistent
- Check figure/table references are correct
- Verify reference list format

### 5. Completeness Check
- Verify all sections are present (Abstract, Introduction, Related Work, Methodology, Discussion, Conclusion)
- Check that all citations have references
- Verify all figure/table references have corresponding items (or are noted as placeholders)
- Ensure no missing content
- Check that all placeholders are replaced (or clearly marked if not available)

### 6. Journal Requirements Check
- Word count verification (if journal has limits)
- Page limit check (if applicable)
- Formatting requirements (if known)
- Citation style verification
- Abstract length check (typically 200-250 words)

## Requirements

### Output Format
Provide:
1. **Corrected paper** with all fixes applied
2. **Review report** including:
   - Grammar/spelling errors found and fixed
   - Consistency issues found and fixed
   - Technical accuracy issues found and fixed
   - Formatting issues found and fixed
   - Completeness verification
3. **Final checklist** showing:
   - All sections present
   - All citations formatted
   - All references complete
   - All placeholders replaced (or noted)
   - Word count summary
   - Overall quality assessment

### Quality Standards
- Zero grammar/spelling errors
- 100% terminology consistency
- All technical claims verified
- All citations properly formatted
- All references complete
- Professional academic writing style

## Notes
- Be thorough and critical
- Mark any remaining issues clearly
- Provide specific line numbers for issues found
- Ensure paper is ready for submission (or note what's still needed)
```

### Expected Output
- Final corrected paper
- Comprehensive review report
- Final checklist
- Quality assessment

### Checklist
- [ ] Grammar/spelling errors fixed
- [ ] Terminology consistent
- [ ] Technical accuracy verified
- [ ] Formatting correct
- [ ] All sections complete
- [ ] All citations formatted
- [ ] All references complete
- [ ] Word count verified
- [ ] Ready for submission

---

## Final Deliverables

After completing all 5 tasks, you should have:

1. **Complete Paper** (`complete_paper.md` or `.tex`/`.docx`)
   - All sections combined
   - Citations formatted
   - References complete
   - Figures/tables numbered
   - Placeholders replaced
   - Final proofread

2. **Supporting Documents**
   - Citation mapping table
   - Figure/table list
   - Results summary
   - Review report

3. **Quality Verification**
   - All checklists completed
   - Consistency verified
   - Technical accuracy confirmed
   - Formatting approved

---

## Workflow Summary

```
Task 1: Combine Sections
    ↓
Task 2: Format Citations
    ↓
Task 3: Update References
    ↓
Task 4: Replace Placeholders
    ↓
Task 5: Final Proofread
    ↓
Complete Paper Ready
```

---

## Notes

- **Model:** Use ChatGPT 5 for all tasks (best for accuracy, consistency, and formatting)
- **Order:** Complete tasks sequentially (each task depends on previous)
- **Backup:** Save output of each task before proceeding to next
- **Verification:** Check each task output before moving to next task
- **Time Estimate:** ~2-3 hours total (depending on paper length and complexity)

---

**Last Updated:** [CURRENT_DATE]
**Status:** Ready to Execute

