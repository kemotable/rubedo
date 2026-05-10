# Workflow conventions

How we work in this repository. These rules describe the contract for
contributing changes.

## Branches

- `main` is the only long-lived branch.
- No `develop` branch. No `production` branch.
- Feature branches are derived from a GitHub Issue and use the issue-derived
  branch name.

## Issues

Two issue types exist in this repository, each with its own GitHub template:

**Task** — a standard development unit (feature, chore, fix, infra, docs).
Structure: `Description`, `Acceptance Criteria`, `QA Notes`.

**Spike** — a time-boxed research unit with a defined question and output.
Structure: `Hypothesis / Question`, `Approach`, `Definition of Done`.
A Spike always ends with either a conclusion documented in an ADR or inbox
entry, or one or more follow-up Task issues extracted from it.

Issue titles must be concise and imperative: maximum 5 words, no articles (a, the).
Examples: "Add transaction model", "Spike: evaluate background jobs".
GitHub derives the branch name from the title — keep it short.

All issues are assigned to `kemotable` and labelled on creation.
Available labels: `feature`, `bug`, `chore`, `infra`, `docs`, `spike`.
Milestone is assigned manually after issue creation.

Epics are not used. Milestones serve as the grouping mechanism for related
issues.

## Pull requests

- No direct commits to `main`. Every change goes through a PR.
- A PR must reference its issue with `Closes #X` (auto-close) or `Refs #X`
  (link only).
- The first line of every PR description is `Closes #X` or `Refs #X`.
- A PR description contains: `Summary` (what and why), `Scope` (what is
  included and what was explicitly left out), `Verification` (confirmed
  against Issue QA Notes).
- The PR template lives at `.github/pull_request_template.md`.
- History stays linear: prefer `squash` or `rebase` merges; merge commits
  disabled in the repository settings.

## Releases

See ADR-0004 (currently Draft) for the release strategy. In short: SemVer
starting at `v0.1.0`, releases cut via GitHub UI, production deploys tied
to versioned releases.

## Decisions that change these conventions

Changes to this document also go through a PR. Significant changes — anything
beyond wording — should reference the ADR that motivated them.
