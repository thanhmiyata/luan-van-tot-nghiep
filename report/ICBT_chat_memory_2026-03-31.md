# ICBTIstanbul Working Memory

Date: 2026-03-31

This file saves the key decisions, reviewer-style critiques, and writing strategy established during the working session for the ICBTIstanbul conference paper.

## Paper Goal

Prepare a conference paper in English, ideally within 10-12 pages, for ICBTIstanbul.

The main manuscript is:

- `report/conference-ready-12.md`

The paper must be restricted to:

- Spider 1.0 development set only
- 1,034 development questions
- no official Spider 1.0 test submission
- no expansion to other datasets in the conference version

## Core Positioning

The paper should not be positioned as:

- a new SOTA benchmark paper
- a pure NLP leaderboard paper
- a vague multi-agent trend paper
- a business paper with weak technical evidence

The recommended positioning is:

- an application-oriented architectural empirical study

In practice, this means:

- technical core: a multi-stage multi-agent NL2SQL architecture
- venue-facing framing: natural language access to relational business data and decision support

## Main Framing

Recommended framing direction:

- `A Multi-Agent LLM Architecture for Natural Language Access to Relational Business Data`
- `Improving Natural Language-to-SQL Generation for Decision Support Using a Multi-Agent LLM Architecture`

The paper should connect Spider results to business analytics carefully, without overclaiming deployment readiness or generalization beyond the evidence.

## What Counts as Novelty

Novelty should not be claimed as:

- merely splitting a pipeline into more steps
- vague human-like collaboration analogies

Novelty should be described as:

1. Architectural novelty
- NL2SQL is decomposed into explicit reasoning checkpoints:
- analysis -> schema selection -> planning -> generation -> refinement -> validation

2. Methodological novelty
- the paper empirically studies whether reasoning decomposition improves robustness under a controlled evaluation protocol

3. Application-oriented framing
- the architecture is motivated as a structured interface for accessing relational business data

Important distinction:

- business-data-access is framing
- controlled reasoning decomposition is the scientific core

## Why 6-Step Should Beat 4-Step

The answer should not be:

- just because there are more calls
- just because there is more context
- just because the model is stronger

The answer should be:

- `Query Planner` separates logical reasoning from SQL surface realization
- `SQL Refiner` provides one semantic correction layer after SQL generation
- these steps target different failure modes and improve controllability

This claim must be supported by matched experiments where possible.

## Locked Evidence Package

The current conference-ready evidence package should treat the following as fixed anchors:

- 4-step baseline: EM 73.7, EX 81.2
- 6-step proposed: EM 77.8, EX 85.6

Difficulty breakdown currently locked:

- Easy: 4-step EX 76.6 / EM 69.0, 6-step EX 81.9 / EM 72.2
- Medium: 4-step EX 83.4 / EM 75.8, 6-step EX 86.3 / EM 79.1
- Hard: 4-step EX 78.2 / EM 70.7, 6-step EX 87.4 / EM 79.9
- Extra Hard: 4-step EX 85.5 / EM 78.3, 6-step EX 87.3 / EM 80.1

Output artifacts exist in:

- `output/nl2sql_4step_full/`
- `output/nl2sql_6step_full/`
- `output/`

These should be used later for stronger error analysis and qualitative examples.

## Recommended Benchmark Strategy

Best next-step matched comparison:

1. Single prompt
2. 4-step
3. 5-step without Planner
4. 5-step without Refiner
5. 6-step

If possible, run them:

- on the same Spider dev split
- with the same evaluation script
- with matched model settings where fairness matters

## Literature Comparison Policy

Literature comparison should be retained, but only as:

- contextual comparison

It should not be presented as:

- fully fair leaderboard comparison

Reason:

- prior work may use different backbones
- different prompting setups
- different splits
- official test settings rather than current dev-only protocol

Safe label suggestions:

- `Context Against Reported Spider References`
- `Contextual Comparison with Reported Spider 1.0 Results`

## Four Most Important Tables

The strongest conference package should focus on four tables:

1. Matched internal comparison
- single prompt
- 4-step
- 5-step without Planner
- 5-step without Refiner
- 6-step

2. Results by difficulty
- Easy / Medium / Hard / Extra Hard

3. Error analysis
- based on `predict.sql`, `gold.sql`, and categorized failure patterns

4. Contextual literature comparison
- clearly marked with caveats

## Reviewer Concerns Identified

These are likely reviewer questions:

1. What exactly is novel beyond adding more stages?
2. Is the gain caused by reasoning decomposition or by additional compute?
3. Why is Spider dev-only evaluation enough to support the paper's claims?
4. Is comparison with prior literature fair if the settings differ?
5. If business framing is removed, is the technical contribution still strong enough?
6. Is the additional cost and latency of the 6-step system justified by the performance gain?

## Recommended Answers

1. Novelty
- the paper introduces explicit reasoning checkpoints and empirically validates their effect under a fixed protocol

2. 6-step vs 4-step
- Planner and Refiner target different failure modes rather than simply adding more calls

3. Spider dev-only
- the official Spider 1.0 submission server is closed
- the dev set remains large, cross-domain, and appropriate for controlled architectural comparison

4. Literature fairness
- literature rows are contextual references only, not apples-to-apples claims

5. Business framing
- the paper remains technically meaningful without it, but business-data framing makes it much more suitable for ICBTIstanbul

6. Cost-vs-gain
- depends on deployment setting
- the paper should present improved controllability and quality first, and avoid overclaiming universal cost efficiency unless measured

## Guidance from Prior Papers in `Document/`

Most useful folders for writing-pattern transfer:

1. `Document/Conversational_Product_Navigation_for_E_commerce_via_Knowledge_Based_Multi_Agent_Chatbots`
2. `Document/Multi_Agent_Chatbot_for_Efficient_Interaction_with_Blockchain_APIs`

Use them for:

- abstract rhythm
- contribution paragraph style
- problem-gap-solution flow
- limitation writing

Do not use them for:

- benchmark claims
- metric choices
- evidence standards for this Spider paper

## Final Recommendation for ICBTIstanbul

Submit the paper as:

- an application-oriented architectural empirical study

with the following balance:

- strong technical core
- conservative claims
- business-analytics framing
- Spider dev-only transparency
- matched internal baselines as primary evidence
- literature comparison as contextual support only

