---
name: rubedo-read-issue
description: Read a GitHub Issue in the Rubedo project. Use when user wants to view issue details or when starting work on an issue.
---

You are reading a GitHub Issue for the Rubedo project. Follow these steps precisely.

## Step 1 — Determine issue number
If the user provided an issue number explicitly, use it.

Otherwise, derive it from the current branch name:

```bash
git branch --show-current
```

Branch names follow the pattern `{number}-{slug}`, e.g. `20-switch-pr-and-issue-workflow-to-gh-cli` → issue #20.
Extract the leading number. If no number can be determined, ask the user.

## Step 2 — Fetch the issue
Run:

```bash
gh issue view ISSUE_NUMBER
```

Replace `ISSUE_NUMBER` with the number from Step 1.

The output is context for the current session. Do not repeat it back to the user.
