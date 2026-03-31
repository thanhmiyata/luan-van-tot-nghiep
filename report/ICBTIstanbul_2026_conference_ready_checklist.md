# ICBTIstanbul 2026 Checklist for conference-ready-12.md

## 1. Purpose of This Checklist

This checklist is specifically for completing [conference-ready-12.md](conference-ready-12.md) into a submission-ready conference manuscript for ICBTIstanbul 2026 under the current known constraints:

- maximum 12 pages
- Springer Word template only
- English only
- similarity < 20%
- AI similarity < 20%
- proceedings path confirmed in email as LNNS
- review mode still inconsistent between email and website

## 2. Current Status of conference-ready-12.md

The new file already solves several problems from the longer master draft:

- the structure is much shorter and more conference-oriented
- the business/data-access framing is stronger
- appendix material has been removed
- repeated methodology details have been compressed
- only core evidence sections are retained

However, it is not yet submission-ready.

## 3. Must-Fix Before Submission

### A. Freeze the evaluated system variant

- Decide which exact configuration produced the reported 77.8 EM / 85.6 EX results.
- Ensure the same variant is described consistently in:
  - abstract
  - Section 3.4
  - Table 2
  - conclusion

**Risk if ignored**

- The paper may look inconsistent with the codebase and lose credibility during review.

### B. Finalize Table 2

- Replace `To be finalized from evaluated run` with the exact evaluated agent configuration.
- Add compact but precise model names.
- Keep the description short enough for a conference paper.

**Risk if ignored**

- The implementation section will still look provisional.

### C. Add one real ablation table

- Replace the placeholder-style ablation discussion with a real compact table.
- Include:
  - full 6-step
  - no planner
  - no refiner
  - 4-step baseline

**Risk if ignored**

- The contribution of Planner and Refiner remains asserted rather than demonstrated.

### D. Add one real error-analysis table

- Add actual percentages for the main error categories.
- Report FSED as a real number.
- Keep the table compact.

**Risk if ignored**

- The diagnostic argument of the paper stays incomplete.

### E. Remove all draft wording

- Search for wording such as:
  - `should include`
  - `current draft`
  - `to be finalized`
  - `final conference version`
- Rewrite those lines as finalized manuscript prose.

**Risk if ignored**

- The file will still read like an internal outline rather than a paper.

## 4. Strongly Recommended Improvements

### A. Add one compact case study

- Show one question where the six-step pipeline is better than the simpler baseline.
- Keep it short:
  - question
  - key planning idea
  - final SQL or error category improvement

### B. Add one small figure only

- Prefer a single architecture figure in the final Word version.
- Avoid keeping multiple complex process figures in a 12-page paper.

### C. Tighten the title if needed

- Current title is suitable for the venue.
- If needed, a slightly more business-facing alternative can be used:
  - Improving Natural Language-to-SQL for Decision Support with a Multi-Agent LLM Architecture

### D. Make the conclusion more venue-aware

- Keep the benchmark result.
- End with one sentence linking the architecture to business analytics and structured data access.

## 5. Formatting Checklist for ICBTIstanbul

- Move the content into the Springer Word template.
- Keep the full paper within 12 pages including references.
- Use only English.
- Use figure captions below figures.
- Use table captions above tables.
- Keep references compact and consistent.
- Prepare two versions if needed:
  - version with author names
  - anonymized version if the organizer clarifies double-blind enforcement

## 6. Similarity and AI-Use Checklist

- Run a similarity check before submission.
- Keep similarity under 20% including references at most.
- Keep AI similarity under 20% including references at most.
- Reduce generic phrasing and repetitive wording.
- Avoid copying long passages from the thesis or previous drafts without rewriting.

## 7. Final QA Before Upload

- Verify all reported numbers match exactly across abstract, results, and conclusion.
- Verify the title, keywords, and introduction all fit Track 1 or Track 9.
- Verify no provisional wording remains.
- Verify no Markdown-only elements remain before Word submission.
- Verify the final PDF export is clean.

## 8. Recommended Work Order

1. Freeze the evaluated variant.
2. Finalize the compact implementation table.
3. Insert ablation and error-analysis tables.
4. Rewrite any remaining draft-style wording.
5. Move the paper into the Springer Word template.
6. Reduce to 12 pages if still over limit.
7. Run similarity and final QA.