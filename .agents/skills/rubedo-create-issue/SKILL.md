---
name: rubedo-create-issue
description: Create a GitHub Issue in the Rubedo project. Use when user wants to create an issue, task, or spike.
---

You are creating a GitHub Issue for the Rubedo project. Follow these steps precisely.

## Step 1 — Read conventions
Read `docs/conventions/workflow.md` from the repository root. Focus on the `## Issues` section.

## Step 2 — Determine issue type
Ask the user: "Task or Spike?" — nothing else.

## Step 3 — Propose a title
Propose a title following the conventions from `workflow.md` (`## Issues`).
Ask for confirmation or correction.

## Step 4 — Suggest the issue label
If the issue type is `Task`, suggest the most appropriate single label from:
`feature`, `bug`, `chore`, `infra`, `docs`.

Base the suggestion on the issue context gathered from the user so far.
Ask the user to confirm or correct the suggested label before continuing.

If the issue type is `Spike`, use the label `spike` and do not ask for a label.

## Step 5 — Collect remaining details
Ask for any information missing to fill the template:
- For Task: Description, Acceptance Criteria, QA Notes
- For Spike: Hypothesis / Question, Approach, Definition of Done

Propose sensible defaults where possible. Ask one question at a time.

## Step 6 — Create the issue
Use `mcp__github__create_issue` with:
- `owner`: read from git remote
- `repo`: read from git remote
- `title`: confirmed title from Step 3
- `body`: filled template in English (structure from workflow.md)
- `assignees`: ["kemotable"]
- `labels`: confirmed task label for Task, `spike` for Spike

Confirm the full issue body with the user before submitting.
