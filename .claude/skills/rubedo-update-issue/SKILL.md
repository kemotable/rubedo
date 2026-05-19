---
name: rubedo-update-issue
description: Update the body of an existing GitHub Issue in the Rubedo project. Use when requirements, Acceptance Criteria, or any other issue content needs to change.
---

You are updating a GitHub Issue for the Rubedo project. Follow these steps precisely.

## Formatting rule
Write prose as single continuous lines — no manual line breaks within paragraphs
or list items. GitHub handles word wrapping. Use blank lines to separate paragraphs.

## Step 1 — Determine issue number
If the user provided an issue number explicitly, use it.

Otherwise, derive it from the current branch name:

```bash
git branch --show-current
```

Branch names follow the pattern `{number}-{slug}`, e.g. `20-switch-pr-and-issue-workflow-to-gh-cli` → issue #20.
Extract the leading number. If no number can be determined, ask the user.

## Step 2 — Fetch current issue content
Run:

```bash
gh issue view ISSUE_NUMBER --json title,body --jq '{title: .title, body: .body}'
```

Load the current title and body into context. Do not repeat them back to the user.

## Step 3 — Collect changes
Ask the user what should change. Apply the requested changes to the body while
preserving all unaffected sections.

Once you have enough context, present the complete proposed new body to the user
for approval.

## Step 4 — Update the issue
Run:

```bash
gh issue edit ISSUE_NUMBER --body "NEW_BODY"
```

Replace `ISSUE_NUMBER` with the number from Step 1 and `NEW_BODY` with the
approved body from Step 3.

Confirm with the user before running the command.
