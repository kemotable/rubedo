# ADR-0001: Modular monolith as the deployment unit

- **Status**: Accepted
- **Date**: 2026-05-09
- **Deciders**: Tomasz Pietrzyk

## Context

Rubedo is a long-horizon personal finance application targeting a single
constrained VPS host (currently ~2 GB RAM / 25 GB disk). The architectural
goal is clear domain boundaries (Ledger, Budgeting, Import, Analytics, future
Automation) with low operational overhead.

## Decision

Build Rubedo as a **modular monolith**: one Rails application, one deployable
unit, one database. Internal modularity is enforced through namespacing,
explicit module boundaries, and conscious dependency direction — not through
service or process separation.

## Alternatives considered

- **Microservices** — too much operational overhead for a solo, single-host
  project; deployment, observability, and inter-service contracts would
  dominate the work.
- **Majestic monolith (no internal boundaries)** — short-term simpler, but
  loses the domain-modelling discipline that is one of the project's stated
  goals.

## Consequences

- **Positive**: low operational complexity, simple deployment, full ACID
  semantics across the domain, fast local development.
- **Negative / accepted costs**: must self-impose discipline at the module
  boundary (no automatic enforcement); risk of drift toward "majestic" monolith
  if vigilance lapses.
- **Neutral**: future extraction of a module into a separate service remains
  possible if a real need emerges, but is explicitly not planned.

## References

- `CLAUDE.md` — project character.
