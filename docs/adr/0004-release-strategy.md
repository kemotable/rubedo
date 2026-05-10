# ADR-0004: Release strategy via SemVer + GitHub Releases

- **Status**: Draft
- **Date**: 2026-05-09
- **Deciders**: Tomasz Pietrzyk

## Context

Rubedo's `main` branch acts as the integration branch. Production deployment
infrastructure does not yet exist (deferred to M4 — Kamal/VPS). A release
contract is needed so that, when deployment lands, the link between code
state and deployed state is unambiguous.

## Decision (proposed)

- Versioning: **Semantic Versioning**, starting from `v0.1.0`.
- Releases: created via the GitHub UI ("Create Release"), tagged on `main`.
- Production deploys are tied **strictly** to versioned releases, not to
  arbitrary commits on `main`.
- Automatic deploy on release publication: deferred to a later milestone
  (separate ADR when introduced).
- `main` is not a per-environment branch.

## Alternatives considered

- **Continuous deploy from `main`** — simpler pipeline, but loses the
  controlled-cut property and removes a natural pause point for human review.
- **Tag-based releases without GitHub Releases** — works but loses the
  release-notes UX and discoverability.
- **Long-lived `production` branch** — adds branching overhead with no
  benefit at this project's scale.

## Consequences

- **Positive**: clear, reviewable cut between development and what's
  deployed; release notes are a natural artefact; rollback target is
  unambiguous.
- **Negative / accepted costs**: requires manual action to cut releases;
  cadence becomes a discipline matter.

## Open questions

- Do we want a `CHANGELOG.md` in the repo, or are GitHub Releases sufficient?
  Lean: GitHub Releases only, to avoid duplication. Confirm before Accepted.
- Pre-release / RC tags policy — defer until first real need.

## References

- `docs/conventions/workflow.md` — branch and PR rules.
