# Domain conventions

How we model the world. These are not Ruby/Rails style choices — they are
statements about what we consider correct in the financial domain. Violating
them produces silent domain bugs, not style noise.

> **Note on scope**: this file currently mixes genuinely domain-level rules
> (e.g. Money) with data-handling rules that are arguably infrastructure
> (Time, Locale). The boundary is intentionally provisional at this stage.
> Splitting into `domain.md` + `infra.md` is a candidate for a future
> iteration once there is enough content to justify the split. See the
> related entry in `docs/inbox.md`.

## Money

- All monetary amounts are stored and handled as `BigDecimal` with explicit
  scale (or via a Money-style value object once introduced — see future ADR).
- **Never** use `Float` for money. Not in models, not in service objects, not
  in computations.
- Currency is always explicit and stored alongside the amount.

## Time

- All times are stored in **UTC** in the database and handled in UTC in
  application logic.
  - `config.time_zone = "UTC"`
  - `config.active_record.default_timezone = :utc`
- Timezone conversion of timestamps happens **only** at the presentation
  layer. The one exception is deriving a domain date from the current
  moment (see below).
- Dates are domain-meaningful (e.g. "transaction date") and are stored as
  `DATE`, not as truncated timestamps.
- A domain date that arrives as a date (bank statement booking date, user
  input) is stored as given — never derived from a UTC timestamp.
- When a domain date must be derived from the current moment ("today", the
  current budget period, a form default), it is derived in the user's
  timezone, currently fixed to `Europe/Warsaw`. Never use `Date.today` /
  `Date.current` (UTC) for domain decisions.

## Locale

- Default locale: `pl`.
- Available locales: `pl`, `en`.
- All user-facing strings go through `I18n` from day one. No hardcoded
  Polish or English in views or models.

## Naming

This section will grow as domain decisions are made. The first real domain
decisions land at M3. Until then, this section may stay short.
