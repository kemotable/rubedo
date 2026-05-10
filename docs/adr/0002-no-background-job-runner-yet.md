# ADR-0002: No background job runner on the initial baseline

- **Status**: Accepted
- **Date**: 2026-05-09
- **Deciders**: Tomasz Pietrzyk

## Context

Rails projects routinely include Sidekiq + Redis (or Solid Queue + Postgres)
from day one. Rubedo runs on a small VPS where every running process competes
for ~2 GB RAM. Until a concrete background workload exists, adding a queue is
pure overhead.

## Decision

Do **not** include any background job runner (Sidekiq, Solid Queue, GoodJob,
etc.) in the initial baseline. Defer this decision until a workload requiring
asynchronous processing actually appears (e.g. CSV import beyond a trivial
size, scheduled imports, outbound integrations).

## Alternatives considered

- **Sidekiq + Redis** — adds a Redis process and worker process, ~150–250 MB
  RAM combined, on a 2 GB host. Not justified without a workload.
- **Solid Queue (Postgres-backed)** — no Redis, but still adds a worker
  process and DB load. Defensible later; premature now.
- **Inline / synchronous** — current default; perfectly adequate until a real
  async need appears.

## Consequences

- **Positive**: minimal RAM footprint; one fewer moving part; one fewer
  failure mode.
- **Negative / accepted costs**: the day a real async workload appears, this
  decision must be revisited and a runner introduced. That introduction will
  itself require an ADR.
- **Neutral**: no impact on domain code; service objects remain the natural
  pattern.

## References

- ADR-0001 (modular monolith).
