# UCBICBIT 2026 Submission Checklist

## 1. Venue Facts to Lock First

- Conference: UCBICBIT 2026, University College of Bahrain
- Conference dates: 20-21 May 2026
- Paper submission deadline: 22 April 2026
- Notification: 25 April 2026
- Registration payment deadline for accepted authors: 01 May 2026
- Participation modes: Virtual and in-person
- Fee reference: Virtual + publication = USD 300; Physical + publication = USD 500
- Submission system: ConfManage
- Template currently posted on the website: Springer Word camera-ready template
- Best-fit tracks for this paper:
  - Track 1: Artificial Intelligence, Machine Learning, and Advanced Analytics
  - Track 7: Digital Transformation, Innovation, and Interdisciplinary Research

## 2. Critical Risks to Keep in Mind

- The website says the review process is double-blind, but the submission page points directly to a camera-ready Springer template.
- The website does not clearly state the maximum page limit for full papers.
- The publication wording is still ambiguous: Springer or Emerald is mentioned, but the exact proceedings series is not clearly identified.
- The current manuscript is too draft-like for direct submission because it still contains placeholders and internal inconsistencies.

## 3. Step-by-Step Execution Checklist

### Step 0. Freeze the Submission Strategy

**Goal**

Lock one conference target, one evaluated system variant, and one manuscript scope.

**Checklist**

- Confirm that UCBICBIT 2026 is the primary conference target.
- Decide whether the paper will report:
  - the exact variant currently implemented in code, or
  - a specific evaluated variant with a clearly stated experimental configuration.
- Decide whether the paper scope is:
  - pure NL2SQL architecture paper, or
  - NL2SQL for business data access / AI-enabled decision support.
- Freeze the main quantitative claims that will appear in the title, abstract, introduction, and conclusion.

**Output of this step**

- One fixed paper story with no internal contradiction.

**What to watch out for**

- Do not keep changing the system story after writing the abstract. The biggest current risk is mismatch between code, reported numbers, and paper wording.

### Step 1. Reconfirm Venue Rules by Email

**Goal**

Remove format uncertainty before spending time on final layout.

**Checklist**

- Email the conference contact and ask three concrete questions:
  - What is the maximum page limit for a full paper?
  - Should the initial submission be anonymized for double-blind review?
  - What is the exact proceedings publisher/series for accepted papers?
- Save the reply for later proof when formatting or discussing with advisors.

**Output of this step**

- A confirmed rule set for page length, author information, and publication expectations.

**What to watch out for**

- If there is no reply in time, use the Springer template for structure but keep an anonymized review version ready.

### Step 2. Fix the Implementation Story

**Goal**

Make the manuscript consistent with the evaluated system.

**Checklist**

- Audit the actual model assignment in the codebase.
- Replace all inaccurate claims that all agents use Gemini 2.5 Flash if that is not the evaluated configuration.
- Decide whether to present the system as:
  - a homogeneous six-agent pipeline, or
  - a hybrid multi-model pipeline.
- Ensure the same configuration appears consistently in:
  - title and abstract if needed
  - methodology
  - implementation details
  - tables of parameters
  - conclusion

**Output of this step**

- One consistent implementation narrative across the whole paper.

**What to watch out for**

- A reviewer can forgive missing extra experiments more easily than contradictory implementation claims.

### Step 3. Complete the Minimum Experimental Package

**Goal**

Turn the paper from a draft into a submission-ready empirical study.

**Checklist**

- Fill all placeholders in the manuscript.
- Keep the full-dev-set main comparison with at least:
  - 4-step baseline
  - 6-step proposed system
- Complete the ablation table with actual values for:
  - full 6-step
  - no_planner
  - no_refiner
  - 4-step baseline
- Complete quantitative error analysis:
  - missing join
  - column mismatch
  - aggregation errors
  - nested query errors
- Report FSED with a real number.
- Add at least one compact difficulty-level breakdown if available.
- Add one short efficiency comparison if token or latency data can be produced quickly.

**Output of this step**

- A paper with no `xx`, `XX.X`, `PLACEHOLDER`, or empty evidence gaps.

**What to watch out for**

- If Single Prompt and Chain-of-Thought baselines cannot be run in time, remove or rewrite that table instead of leaving partial placeholders.

### Step 4. Reframe the Paper for UCBICBIT Scope

**Goal**

Make the paper look native to the conference, not transplanted from a generic NLP venue.

**Checklist**

- Adjust the title toward one of these framings:
  - natural language access to structured business data
  - AI-enabled decision support over relational databases
  - analytics-oriented NL2SQL systems
- Rewrite the abstract so the first sentence establishes practical business or decision-support relevance.
- Add one paragraph in the introduction explaining why NL2SQL matters for non-technical analysts and decision makers.
- Align keywords toward the venue, for example:
  - NL2SQL
  - multi-agent systems
  - business analytics
  - decision support systems
  - large language models
- In the conclusion, state the practical implication more clearly, not just benchmark improvement.

**Output of this step**

- A manuscript that fits Track 1 or Track 7 more naturally.

**What to watch out for**

- Do not oversell business impact beyond what the experiments support. Frame the system as an enabling architecture, not as a deployed enterprise product.

### Step 5. Compress the Manuscript into Conference Form

**Goal**

Reduce the current draft into a tight conference paper.

**Checklist**

- Shorten the per-agent descriptions so they focus on role, rationale, and one or two important design principles.
- Keep only the most useful tables in the main text:
  - agent summary
  - main results
  - ablation
  - error analysis
- Move or remove material that reads like internal working notes.
- Remove Appendix A and Appendix B from the conference version unless explicitly needed.
- Keep one main architecture figure and at most one supporting process figure.
- Merge overlapping implementation details sections to avoid redundancy.

**Output of this step**

- A shorter paper that reads like a proceedings submission rather than a journal manuscript.

**What to watch out for**

- The current draft is roughly 8,000 words, which is likely too long for a typical conference proceedings format.

### Step 6. Upgrade Professionalism of the Writing

**Goal**

Make the manuscript feel sharper, more academic, and less prompt-centric.

**Checklist**

- Rewrite the contribution list into four concrete, measurable contributions.
- Reduce wording such as "key innovation" where the paper is really making a design choice, not introducing a novel theory.
- Replace long rule catalogs with concise design rationales.
- Add one compact case study showing how planner and refiner improve a query.
- Tighten the conclusion to avoid repeating the abstract.
- Add a clearer limitation paragraph.

**Output of this step**

- A more mature research-paper tone.

**What to watch out for**

- Reviewers respond better to evidence-backed claims than to aggressive novelty language.

### Step 7. Prepare Figures and Springer-Compatible Assets

**Goal**

Make the paper technically ready for Word-based conference formatting.

**Checklist**

- Convert Mermaid diagrams into static images.
- Ensure each figure has a clean caption and can fit in one or two columns.
- Standardize table titles and numbering.
- Check that equations and symbols render correctly outside Markdown.
- Clean reference formatting to match the target template style.

**Output of this step**

- A paper that can be transferred into the Springer template without breaking layout.

**What to watch out for**

- Markdown-native elements often become unstable when moved into Word camera-ready formatting.

### Step 8. Final Submission QA

**Goal**

Catch all preventable mistakes before uploading to ConfManage.

**Checklist**

- Verify title, abstract, and conclusion use the same main numbers.
- Verify all tables and figures are referenced in the text.
- Verify no placeholders remain.
- Verify model names, hyperparameters, and evaluation setup are internally consistent.
- Verify author names and affiliations are either present or removed according to the review policy.
- Verify the PDF export has no broken equations, missing figures, or line-wrap corruption in tables.
- Run one last spelling and grammar check on the final version.

**Output of this step**

- One final submission package with low risk of desk rejection for presentation issues.

**What to watch out for**

- The easiest way to lose credibility is a final PDF that still contains placeholders, broken figures, or conflicting numbers.

### Step 9. Submit and Track Post-Submission Actions

**Goal**

Finish submission cleanly and prepare for the short post-notification window.

**Checklist**

- Submit the paper and save the confirmation email.
- Record the uploaded title, abstract, keywords, track, and file version.
- Prepare a post-acceptance list in advance:
  - payment
  - presentation mode decision
  - camera-ready fixes
  - final figure quality check
- Prepare a backup path to Applied Computer Science or JCS&T if rejected.

**Output of this step**

- A tracked submission with no administrative confusion.

**What to watch out for**

- The notification-to-registration window is very short, so the payment and final-format plan should be ready in advance.

## 4. Minimum Submission-Ready Definition

The paper is ready for UCBICBIT submission only when all of the following are true:

- No placeholder text remains.
- The implementation story matches the evaluated system.
- Main results, ablation, and error analysis all contain real numbers.
- The paper is reframed toward business analytics / decision support relevance.
- The manuscript has been compressed into a realistic conference length.
- Figures are no longer Mermaid blocks.
- The review-version anonymity question has been resolved or mitigated.

## 5. Recommended Execution Order

If time is tight, do the work in this order:

1. Freeze variant and implementation story.
2. Fill all quantitative placeholders.
3. Rewrite title, abstract, introduction, and contributions for UCBICBIT fit.
4. Cut the paper down to conference length.
5. Convert figures and move content into the Springer template.
6. Run final QA and submit.