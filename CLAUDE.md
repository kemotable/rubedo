# CLAUDE.md

Entry point for AI agents and future-self working in this repository.

## Project character

Rubedo is a long-horizon (6–12 months+) personal finance application built
iteratively, without rush. It is simultaneously a real-use product and a
portfolio-grade exercise in domain modelling and pragmatic event-driven
architecture. Trade-offs are made explicit in ADRs, not hidden. Features and
infrastructure are added when a real need appears, not preventively.

## Non-goals

- Not a SaaS, not a multi-tenant product.
- Not optimised for fastest delivery.
- Not "best practices for the sake of best practices".

## Where things live

- `docs/adr/` — architectural decisions. Read the ones touching the area you're
  working in. Each ADR has a `Status` field (Draft / Proposed / Accepted /
  Superseded / Deferred).
- `docs/conventions/` — rules that apply at every step of work.
  - `domain.md` — how the domain is modelled (money, time, locale, naming).
  - `code.md` — Ruby/Rails patterns, structure, testing.
  - `workflow.md` — Git, PR, branch, release.
- `docs/inbox.md` — raw thought capture. Do **not** act on entries here unless
  explicitly asked. They are unrefined and may be wrong.
- `README.md` — public-facing overview; not normally needed during work.
- GitHub **Issues** — concrete tasks.
- GitHub **Milestones** — roadmap and current scope.
- GitHub **Releases** — version history / "what is done".

`docs/CONTEXT.md` (domain glossary) and `docs/ops/` (runbooks) will appear when
the project reaches the relevant milestones; they don't exist yet by design.

## How decisions get made here

- A choice that is **hard to reverse**, **surprising without context**, **and
  the result of a real trade-off** → propose an ADR (Status: Draft) before
  implementing.
- A rule that applies at every step (naming, money, time, Git workflow) →
  propose an addition to the relevant `docs/conventions/*.md`.
- A throwaway thought worth keeping → I'll add it to `docs/inbox.md` myself;
  don't act on it.

## Agent skills

Repo-specific guidance for agents lives in `docs/agents/`.

- Issue tracker workflow: see `docs/agents/issue-tracker.md`
- Domain docs: see `docs/agents/domain.md`
- Dual-agent entry points: see `docs/agents/agent-files.md`
