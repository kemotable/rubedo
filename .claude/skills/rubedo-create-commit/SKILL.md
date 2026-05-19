---
name: rubedo-create-commit
description: Stage all changed files and create a git commit in the Rubedo project. Use when user wants to commit work in progress.
---

You are creating a git commit for the Rubedo project. Follow these steps precisely.

## Step 1 — Determine issue number
Derive the issue number from the current branch name:

```bash
git branch --show-current
```

Branch names follow the pattern `{number}-{slug}`, e.g. `20-switch-pr-and-issue-workflow-to-gh-cli` → issue #20.
Extract the leading number. If no number can be determined, ask the user.

## Step 2 — Show pending changes
Run:

```bash
git status && git diff --stat
```

Present the output so the user can see what will be committed.

## Step 3 — Propose commit message
Based on the changes from Step 2, propose a commit message. Do not ask the user to provide one.

The message must be:
- Short and clear (one line, no extended description)
- Written in imperative mood (e.g. "Add gh CLI commands", not "Added")

Ask the user to confirm or correct the proposed message.

## Step 4 — Confirm
Show the user the full commit command before executing:

```
git add -A && git commit -m "[#ISSUE_NUMBER] MESSAGE"
```

Ask for confirmation.

## Step 5 — Commit
Run:

```bash
git add -A && git commit -m "[#ISSUE_NUMBER] MESSAGE"
```

Replace `ISSUE_NUMBER` and `MESSAGE` with the values from Steps 1 and 3.

**Do NOT run `git push`.**
