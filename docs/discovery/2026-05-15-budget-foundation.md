# Session

## Context

- Topic: core monthly budgeting model for Rubedo
- Why now: first product-shaping session from a blank page
- Triggering idea: shape a coherent foundation for monthly income/expense
  monitoring before continuing with implementation ideas

## Users / actors

- Primary: owner-user of Rubedo managing a personal/home budget manually
- Secondary: none for MVP

## Desired outcomes

- Understand monthly inflows and outflows in one place
- Start each period from a reusable template instead of a blank slate
- Compare predicted values against realized values
- Preserve enough structure for future reporting without overbuilding MVP

## Story map

| Activity | Candidate steps |
| --- | --- |
| Define budget vocabulary | Create `BudgetEntry`, assign category, maintain template |
| Prepare next period | Open period from template, fill missing planned amounts |
| Work inside the period | Add occurrences, duplicate entries, cancel plan items, mark realized |
| Monitor the period | Compare planned totals to realized totals, inspect burden vs real cost |
| Close the period | Resolve all planned occurrences, close active period, ensure next period exists |

## Domain model checkpoint

### Core entities

| Entity | Responsibility |
| --- | --- |
| `Budget` | Top-level budget container and ownership scope |
| `BudgetMember` | Actor participating in a budget |
| `BudgetCategory` | Broad, flat category used to classify `BudgetEntry` |
| `BudgetEntry` | Canonical identity of a budget item |
| `BudgetEntryOccurrence` | Atomic occurrence of a `BudgetEntry` within a `BudgetPeriod` |
| `BudgetPeriod` | Budgeting period with lifecycle and chronological rules |
| `BudgetTemplate` | Global template used when opening a new `BudgetPeriod` |
| `BudgetTemplateEntry` | Template row that generates one initial occurrence |

### `Budget`

- Top-level domain container for the budgeting space
- Owns the rest of the budgeting model
- Keeps the model open to future multi-budget support
- MVP behavior is effectively single-budget, but structure should stay
  budget-scoped

### `BudgetMember`

- Actor participating in a `Budget`
- Distinct from technical authentication concepts such as `User` or `Account`
- In MVP the budget has one effective member
- Future collaboration should grow around `BudgetMember`, not around a
  god-class `User`

### `BudgetCategory`

- Explicit domain entity, not a free-text string
- Belongs to one `Budget`
- Broad and flat in MVP
- Managed manually
- Each `BudgetEntry` belongs to exactly one `BudgetCategory`

### `BudgetEntry`

- Canonical identity of a budget item across time
- Applies to recurring, occasional, and rare items alike
- Always belongs to exactly one broad, flat category
- Category is mutable as a correction, but this should not retroactively rewrite
  closed periods in the long run
- Examples: `VAT tax`, `Mortgage installment`, `Kids medicine`

### `BudgetEntryOccurrence`

- Separate entity from `BudgetEntry`
- Exists only when a `BudgetEntry` was actually included in a given period
- Belongs to one `BudgetPeriod`
- References one `BudgetEntry`
- Is an atomic budget event, not a monthly container
- Multiple occurrences of the same `BudgetEntry` may exist in one period
- Holds:
  - `planned_amount`
  - `actual_amount`
  - `status`
  - `occurrence_date` as the actual realization date
- Snapshot fields from `BudgetEntry` are intentionally postponed beyond MVP

### `BudgetPeriod`

- Explicit domain entity, not just `year + month`
- Lifecycle:
  - `draft`
  - `active`
  - `closed`
- Exactly one period may be `active`
- Up to three future periods may exist as `draft`
- `draft` is fully editable
- Closing must respect chronology
- A period cannot be closed while any `BudgetEntryOccurrence` remains
  `planned`
- After closing the active period, the system must ensure the next period
  exists and becomes `active`

### `BudgetTemplate`

- Single global template for MVP
- "Global" means one template per `Budget` in practice
- Editable over time
- Changes affect only future, not-yet-opened periods
- Contains `BudgetTemplateEntry` records

### `BudgetTemplateEntry`

- References one `BudgetEntry`
- Is unique per `BudgetEntry` within the global template
- Generates exactly one `BudgetEntryOccurrence` when a period is opened
- May contain `planned_amount`
- Missing `planned_amount` means "create the occurrence, fill the plan later"
- Generated occurrences always start with status `planned`

## Financial semantics checkpoint

### Planned vs realized

- MVP keeps `planned_amount` and `actual_amount` on the same
  `BudgetEntryOccurrence`
- One occurrence represents one planned/realized budget event
- A single occurrence should not represent a whole batch or aggregate window

### Statuses

- Working MVP statuses:
  - `planned`
  - `realized`
  - `cancelled`
- `realized` represents a real financial event and is treated as final in MVP
- `cancelled` applies only to planned occurrences

### Neutral transfers vs real costs

- Some outgoing entries burden the month but are not real costs
- Example: transfer between owned accounts to reserve money for a future lease
  buyout
- No separate `burden` flag is needed
- Outgoing entries are separated by `real_cost=true/false`

Derived reporting views:

- `monthly burden` = all outgoing entries
- `real cost` = outgoing entries with `real_cost=true`
- `neutral transfers` = outgoing entries with `real_cost=false`

## Lifecycle and operations checkpoint

### `BudgetEntryOccurrence` operations in MVP

- `create`
- `update planned amount`
- `mark realized`
- `cancel`
- `duplicate`

Rules:

- Manual `create` requires an existing `BudgetEntry`
- `mark realized` is an explicit domain operation
- `cancel` is allowed only for `planned`
- `realized` entries are not corrected in MVP; reversal should be modeled as a
  new occurrence
- `duplicate` works only inside the same `BudgetPeriod`
- `duplicate` is allowed for both `planned` and `realized`
- Duplicated occurrence always starts as `planned`
- `reschedule` is intentionally postponed beyond MVP

### `BudgetPeriod` operations in MVP

- `open from template`
- system-driven `activate`
- explicit `close`

Rules:

- `BudgetPeriod` is created only through `open from template`
- `activate` is not a manual user action
- When closing the active period:
  - if the next period already exists as `draft`, it becomes `active`
  - otherwise a new period is created from `BudgetTemplate` and becomes
    `active`

## Candidate slices

### Slice 1

- User value: start and operate one monthly budget period manually
- Included steps:
  - create categories
  - create `BudgetEntry`
  - maintain one global `BudgetTemplate`
  - open `BudgetPeriod` from template
  - create/edit/cancel/duplicate occurrences
  - mark occurrences as realized
  - close active period if no planned occurrences remain
- Excluded steps:
  - snapshots from `BudgetEntry` into occurrences
  - rescheduling to the next period
  - notifications and due dates
  - correction of realized occurrences
  - multiple templates
- Why this slice first: it delivers the full manual monthly budgeting loop

## Open questions

- Which invariants should be enforced per occurrence status?
- How should planned occurrences without `occurrence_date` be ordered in a
  period view?
- Which operations should emit domain events in MVP, and which can wait?
- When should historical snapshots from `BudgetEntry` be copied into
  occurrences?

## Parking lot

- Historical snapshots copied from `BudgetEntry` into occurrences
- `reschedule` between periods
- Corrections of `realized` occurrences
- Due dates and notification system
- Multiple `BudgetTemplate` variants
- Cross-period duplicate

## Decision log

- Introduce `Budget` as the top-level ownership and scoping entity
- Introduce `BudgetMember` as the domain actor, separate from auth concerns
- Introduce `BudgetCategory` as an explicit entity rather than a free-text
  field
- Use `BudgetEntry` as the canonical budget item identity
- Use `BudgetEntryOccurrence` as the atomic period-level record
- Use `BudgetPeriod` as the budgeting period aggregate
- Use one `BudgetTemplate` per `Budget` in MVP
- Keep categories broad, flat, mandatory, and managed manually
- Model neutral transfers as outgoing entries with `real_cost=false`
- Treat realized occurrences as final in MVP
- Exclude rescheduling from MVP

## Conscious debt log

- MVP behavior is still effectively single-budget even though the model is now
  budget-scoped
- Closed periods are not yet protected by occurrence-level snapshots copied
  from `BudgetEntry`
- `planned_amount=nil` currently means both "unknown by nature" and "not filled
  in yet"
- Planned occurrences do not yet have a separate due/planned date
- Domain events are expected, but the MVP event boundary is still undefined
- Status invariants are still an open design detail, not a finalized rule set

## Issue extraction

- Not started yet
- Next likely step: shape the story map backbone from this checkpoint

## Notes

- This note is a discovery checkpoint, not an ADR.
- Several decisions here are intentionally MVP-scoped and may be revisited
  later.
- All ownership, uniqueness, and lifecycle rules should be interpreted within
  the scope of one `Budget`.
