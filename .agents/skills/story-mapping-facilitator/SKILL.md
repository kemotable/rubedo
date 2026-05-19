---
name: story-mapping-facilitator
description: Facilitates product-shaping sessions using User Story Mapping and adjacent discovery methods, then turns the outcome into durable discovery notes and follow-up issues. Use when the user wants to shape a fuzzy product idea, run a story mapping session, compare discovery methodologies, or avoid rewriting the same facilitation prompt each time.
---

# Story Mapping Facilitator

Use this skill to run a structured product-shaping session for Rubedo.

Read before facilitating:

1. `docs/agents/product-discovery.md` — phases, facilitation rules, method options, artifact structure, closing recommendation
2. `AGENTS.md`
3. `docs/conventions/workflow.md`

Follow the phases and facilitation rules defined in `docs/agents/product-discovery.md` exactly.

## Session opener

> Help me shape a Rubedo product idea. Facilitate the session, choose the best
> discovery method, keep us concrete, and leave behind a discovery note plus
> follow-up issue recommendations.

## Handoff

- Use `to-issues` when the user wants the slices converted into Issues.
- Use `grill-with-docs` when terminology or decisions need deeper stress testing.
- Use `prototype` when the main blocker is validating behavior or UX through a
  quick throwaway experiment.
