---
name: rubedo-cr-feedback
description: Process code review feedback on a pull request. Fetches all unresolved reviewer comments, walks through them one by one, and helps the user respond or implement changes. Use when a reviewer (e.g. Copilot) has left comments on an open PR.
---

You are processing code review feedback for a Rubedo pull request. Follow these steps precisely.

## Step 1 — Determine PR number

Derive the PR number from the current branch name:

```bash
git branch --show-current
```

Branch names follow the pattern `{number}-{slug}`. Extract the leading number and find the associated PR:

```bash
gh pr list --head BRANCH_NAME --json number --jq '.[0].number'
```

If no PR can be determined, ask the user.

## Step 2 — Fetch repository identity

```bash
gh repo view --json owner,name --jq '"\\(.owner.login)/\\(.name)"'
```

Store as `OWNER/REPO` for use in subsequent commands.

## Step 3 — Fetch unresolved review threads

Use GraphQL to get all review threads and their resolution status. This is the only way to distinguish resolved from unresolved comments — the REST API does not expose this field.

```bash
gh api graphql -f query='
{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: PR_NUMBER) {
      reviewThreads(first: 100) {
        nodes {
          isResolved
          comments(first: 10) {
            nodes {
              databaseId
              body
              path
              line
              author { login }
            }
          }
        }
      }
    }
  }
}'
```

Filter to threads where `isResolved: false`. Extract the **first comment** of each thread (the original reviewer comment). Store the `databaseId` of each — you will need it to post replies.

If there are no unresolved threads, inform the user and stop.

## Step 4 — Walk through each unresolved comment

Present comments one at a time in the order they appear. For each comment, show:

- **File and line:** `path:line`
- **Author:** from the `author.login` field
- **Comment:** the full body text
- **Suggested change:** if the body contains a ` ```suggestion ` block, highlight it clearly as a diff the reviewer proposes to apply

Then provide your analysis:
- Is the suggestion technically correct?
- Is there a reason to reject it (e.g. false positive, conflicts with an architectural decision, already handled elsewhere)?
- What is the recommended course of action?

Wait for the user's decision. Do **not** move to the next comment until the user explicitly approves.

The user may decide to:
- **Accept** — note it and ask whether to implement the change now or defer to a later commit
- **Reject** — proceed to Step 5 to draft a reply
- **Discuss** — continue the conversation about this comment before deciding

## Step 5 — Draft reply for rejected comments

When the user rejects a comment, draft a concise reply explaining the reasoning. The reply must:
- Acknowledge the reviewer's concern
- State clearly why the suggestion is not being applied
- Reference an ADR, issue, or prior decision if relevant

Present the draft reply to the user for approval before posting.

Once approved, post the reply using:

```bash
gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments \
  --method POST \
  --field body="REPLY_TEXT" \
  --field in_reply_to=COMMENT_DATABASE_ID
```

Replace `OWNER`, `REPO`, `PR_NUMBER`, `REPLY_TEXT`, and `COMMENT_DATABASE_ID` with the actual values.

## Step 6 — Summary

After all unresolved comments have been processed, print a summary table:

| # | File | Decision | Note |
|---|------|----------|------|
| 1 | path:line | Accepted / Rejected / Deferred | brief note |

This gives a clear record of what was decided and why before any commit or push.
