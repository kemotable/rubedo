# ADR-0003: UUID v7 primary keys

- **Status**: Accepted
- **Date**: 2026-05-09
- **Decided**: 2026-05-30
- **Deciders**: Tomasz Pietrzyk

## Context

Rails defaults to `bigint` primary keys. UUIDs are commonly preferred in
projects where IDs are exposed externally, where merge / sync between
environments is foreseeable, or where ID enumeration would leak business
information.

For Rubedo specifically: financial domain, future possibility of multi-user
(household) model, future possibility of CSV import producing reproducible
identifiers, personal preference for IDs that don't reveal record counts, and
a planned mobile client where offline-first record creation (client-side ID
generation before server sync) is a realistic use case.

This decision was finalised after a dedicated spike:
[Issue #26 — Spike: evaluate UUID v4 vs v7](https://github.com/kemotable/rubedo/issues/26).

## Decision

Adopt UUID v7 primary keys for all new models, generated database-side via the
PostgreSQL 18 built-in `uuidv7()` function. Configure Rails generators
accordingly. References between tables use UUID foreign keys.

No `pgcrypto` extension required. No gem required. Rails 8 + PostgreSQL 18
support this natively.

```ruby
# config/application.rb
config.generators do |g|
  g.orm :active_record, primary_key_type: :uuid
end
```

```ruby
# migration
create_table :users, id: :uuid, default: -> { "uuidv7()" }
```

## Why UUID v7 over UUID v4

UUID v4 is fully random. In PostgreSQL's B-tree index, each insert lands at a
random position, causing frequent page splits, index fragmentation, and poor
cache locality. Measured at 1M rows on PostgreSQL 18:

| Metric | UUID v4 | UUID v7 |
|---|---|---|
| Leaf page fragmentation | 49.99% | 0% |
| Average page fill | 71% | ~90% |
| Contiguous leaf page links | 0 / 4 861 | 3 812 / 3 832 |
| Index size | ~40 MB | ~31.6 MB (−26%) |
| `ORDER BY id` scan (1M rows) | 318 ms | 113 ms |

UUID v7 is time-ordered (48-bit Unix timestamp prefix). Inserts land
sequentially at the end of the B-tree — the same pattern as `bigint SERIAL`.

At Rubedo's scale (single user, personal finance) this performance difference
is not measurable in practice. The real arguments for UUID v7 are:

1. **Lower friction than v4** — `uuidv7()` is built into PostgreSQL 18; the
   `pgcrypto` extension is not needed.
2. **Right default for the future** — if a mobile client materialises, UUID v7
   enables offline-first ID generation on the client before server sync.
3. **Irreversibility** — PK type is decided once, before any data exists.
   Migrating after domain modelling (M3) would require touching every table,
   every foreign key, and every serializer.

## Why not bigint

`bigint` is faster and more compact (8 bytes vs 16 bytes). Benchmarks at 5M+
rows show 15–26× faster point lookups and joins. But:

- IDs are enumerable — reveals record counts, enables enumeration attacks in a
  financial domain.
- Cross-environment merge is harder (sequences diverge).
- Client-side generation for offline-first is impossible without a server
  round-trip.

At Rubedo's scale the performance gap is not measurable. The non-enumeration
and offline-first arguments outweigh the storage and speed advantage.

## Why not dual-key (bigint internal + UUID public_id)

Adds schema complexity — two columns, two indexes per table, FK joins by
bigint but external references by UUID — for zero measurable benefit at
Rubedo's scale. Rejected outright.

## Why not ULID

Similar properties to UUID v7 but non-standard. Weaker tooling and PostgreSQL
driver support. No benefit over UUID v7 given PostgreSQL 18 native support.

## Consequences

- **Positive**: IDs safe to expose; no record-count leak; cross-environment
  merge trivial; enables future offline-first mobile client; no extension
  dependency (simpler migrations).
- **Negative / accepted costs**: 16 bytes per key vs 8 bytes (bigint);
  creation timestamp embedded in ID at millisecond precision (non-issue for a
  single-user app where IDs are not externally exposed to third parties).
- **Neutral**: PK type is not reversible without a full schema migration; this
  decision is made deliberately in M1 before any data exists.

## References

- ADR-0001 (modular monolith) — single database, no distributed-ID requirement.
- [Issue #26 — Spike: evaluate UUID v4 vs v7](https://github.com/kemotable/rubedo/issues/26)
- [credativ.de — UUID v4 vs v7 deep dive in PostgreSQL 18](https://www.credativ.de/en/blog/postgresql-en/a-deeper-look-at-old-uuidv4-vs-new-uuidv7-in-postgresql-18/)
- [chayuto.com — Rails 8 UUIDv7 PostgreSQL primary key](https://chayuto.com/blog/rails-8-uuidv7-postgresql-primary-key/)
- [aiven.io — Exploring PostgreSQL 18 UUIDv7 support](https://aiven.io/blog/exploring-postgresql-18-new-uuidv7-support)
