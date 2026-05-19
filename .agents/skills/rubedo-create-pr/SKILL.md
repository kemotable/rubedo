---
name: rubedo-create-pr
description: Create a GitHub Pull Request in the Rubedo project. Use when user wants to open a PR or merge their branch.
---

You are creating a GitHub Pull Request for the Rubedo project. Follow these steps precisely.

## Step 1 — Read conventions
Read `docs/conventions/workflow.md` from the repository root. Focus on the `## Pull requests` section.

## Step 2 — Determine current branch and issue number
Run `git branch --show-current` in the repository root.
If the branch name starts with an issue number followed by `-`, extract it
(e.g. `12-add-transaction-model` → issue #12).
If the issue number cannot be determined unambiguously from the branch name,
ask the user instead of guessing.

## Step 3 — Fetch issue title
Run:

```bash
gh issue view ISSUE_NUMBER --json title --jq '.title'
```

Use the returned title as the PR title.

## Step 4 — Collect PR body details
Ask the user for:
- Summary: what was implemented and why
- Scope: what is included, what was explicitly left out (if non-obvious)
- Confirmation that QA Notes from the issue have been verified

Propose sensible defaults where possible. Ask one question at a time only
until you have enough context to draft the whole PR.

Once you have enough context, stop asking section-by-section approval
questions and generate the complete PR proposal in one response:

- title
- base branch
- head branch
- full PR body

Format `Summary` and `Scope` for readability:

- Use bullet lists when there is more than one distinct point
- Prefer 2-5 short bullets over one long paragraph
- Use a short paragraph only when the content is genuinely one point

Ask the user to approve or correct the complete proposal.

## Formatting rule
Write prose as single continuous lines — no manual line breaks within paragraphs
or list items. GitHub handles word wrapping. Use blank lines to separate paragraphs.

## Step 5 — Create the PR
Run:

```bash
gh pr create \
  --title "TITLE" \
  --base main \
  --head BRANCH \
  --body "$(cat <<'EOF'
Closes #ISSUE_NUMBER

## Summary
SUMMARY

## Scope
SCOPE

## Verification
VERIFICATION
EOF
)"
```

Replace `TITLE`, `BRANCH`, `ISSUE_NUMBER`, `SUMMARY`, `SCOPE`, and `VERIFICATION`
with the confirmed values.

Confirm the complete PR proposal with the user before running the command.
