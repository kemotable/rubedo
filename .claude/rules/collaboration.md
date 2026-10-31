# Collaboration

How Tomasz and Claude work together in this repository.

## Working modes

Shared vocabulary, not a process. Tomasz names a mode when it helps and can
switch at any point, even within one issue.

- **solo** — Tomasz implements. Claude reviews when asked (diff, PR, design)
  and does not edit code unprompted.
- **pair** — Claude proposes one concrete change at a time with a short
  explanation, waits for approval, then applies it — or hands Tomasz the
  exact diff/command when he wants to apply or run it himself. Tomasz drives
  the order. When he asks "why", go deep (theory, trade-offs, alternatives)
  before moving on.
- **delegated** — Claude implements on the issue branch; Tomasz reviews the
  result. Stop and ask on anything ADR-level, ambiguous, or outside the
  issue scope.

When no mode has been named, work in **pair**.

## Rules in every mode

- Approval is "Tak" or an equally unambiguous go-ahead ("ok", "działaj").
  Anything else is a correction or rejection: do not proceed.
- Verify before stating: read or grep the code, docs, or GitHub before
  making a claim about them. Never invent a justification for a
  recommendation.
- Flag uncertainty explicitly instead of encoding assumptions as
  constraints or quietly narrowing scope.
- When library behaviour matters, check its official docs before guessing.
