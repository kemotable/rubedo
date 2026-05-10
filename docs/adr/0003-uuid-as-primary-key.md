# ADR-0003: UUID primary keys via pgcrypto

- **Status**: Draft
- **Date**: 2026-05-09
- **Deciders**: Tomasz Pietrzyk

## Context

Rails defaults to `bigint` primary keys. UUIDs are commonly preferred in
projects where IDs are exposed externally, where merge / sync between
environments is foreseeable, or where ID enumeration would leak business
information.

For Rubedo specifically: financial domain, future possibility of multi-user
(household) model, future possibility of CSV import producing reproducible
identifiers, and personal preference for IDs that don't reveal record counts.

## Decision (proposed)

Adopt UUID primary keys for all new models, generated server-side via the
PostgreSQL `pgcrypto` extension (`gen_random_uuid()`). Configure Rails
generators accordingly. References between tables use UUID foreign keys.

## Alternatives considered

- **`bigint` (Rails default)** — simpler, slightly faster joins, more compact
  storage. Loses the merge / leak / cross-env benefits.
- **UUID v7 (time-ordered)** — better index locality than UUID v4. Requires
  custom generator (Postgres 17+ has built-in support; check current target
  version).
- **ULID** — similar properties to UUID v7 but non-standard; tooling and
  driver support weaker than UUID.

## Consequences

- **Positive**: IDs safe to expose; merge between environments trivial; no
  count leak.
- **Negative / accepted costs**: ~16 bytes per key vs 8; slightly worse index
  locality for v4; mild DX cost (longer IDs in URLs, logs).
- **Neutral**: requires `pgcrypto` extension migration before first model.

## Open questions

- UUID v4 vs UUID v7 — depends on Postgres version available on target VPS
  and on Rails 8.1 generator support. Decide before promoting to Accepted.
- Whether to keep an internal `bigint` `id` for join performance and use UUID
  as a separate `public_id`. Likely no — adds complexity for marginal gain —
  but worth one explicit consideration.

## References

- ADR-0001 (modular monolith) — single database, so no distributed-ID
  argument applies.
