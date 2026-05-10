# Workflow conventions

How we work in this repository. These rules describe the contract for
contributing changes.

## Branches

- `main` is the only long-lived branch.
- No `develop` branch. No `production` branch.
- Feature branches are derived from a GitHub Issue and use the issue-derived
  branch name.

## Pull requests

- No direct commits to `main`. Every change goes through a PR.
- A PR must reference its issue with `Closes #X` (auto-close) or `Refs #X`
  (link only).
- A PR description must describe: context, scope, reasoning, and
  architectural impact (if any).
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
