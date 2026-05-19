# Agent product discovery

Rubedo should shape product ideas through lightweight discovery artifacts that
lead naturally into GitHub `Spike` and `Task` issues.

## Session phases

Use this progression when an idea is still fuzzy:

1. **Framing** — capture the raw intention, target user, expected outcome, and
   likely discovery method.
2. **Domain shaping** — clarify vocabulary, lifecycle, entities, and core
   invariants when the idea is still conceptually unstable.
3. **Story map backbone** — identify the user activities and the candidate
   steps inside each activity.
4. **Slice selection** — choose the thinnest meaningful walking skeleton or
   next outcome slice.
5. **Checkpoint / publish** — update the discovery note with decisions, open
   questions, parking lot, and conscious debt.
6. **Issue extraction** — publish the next `Spike` or `Task` issues only after
   the slice is clear enough.

Do not skip straight from a vague idea to implementation tickets unless the
scope is already obvious.

Do not advance between phases without explicit user agreement.

## Primary artifact

For discovery sessions, the primary durable artifact is a Markdown note in
`docs/discovery/`.

Each note should contain:

- `Context` — what idea or problem the session explored
- `Users / actors` — whose workflow is being shaped
- `Desired outcomes` — what success looks like
- `Story map` — activities and steps
- `Candidate slices` — thin increments that could be built
- `Open questions` — uncertainty that still blocks decisions
- `Parking lot` — out-of-scope ideas intentionally deferred
- `Decision log` — resolved choices from the session
- `Conscious debt log` — trade-offs accepted for MVP or current scope
- `Issue extraction` — links or planned titles for follow-up `Spike` / `Task`

The note exists to preserve reasoning. It does not replace Issues, ADRs, or
conventions.

## Artifact flow

- A discovery note is the working memory for shaping.
- A `Spike` is created when a key question remains unanswered.
- A `Task` is created when a slice is concrete enough to build.
- An ADR is created only when the outcome is hard to reverse, surprising
  without context, and the result of a real trade-off.

At the end of each session, make one explicit closing recommendation:

- `do nothing` — the session surfaced no concrete next step yet
- `open Spike` — a key question remains unanswered before building can start
- `open Task(s)` — a slice is concrete enough to hand off to development

## Session naming

Store discovery notes under `docs/discovery/` using:

`YYYY-MM-DD-short-topic.md`

Examples:

- `2026-05-12-budgeting-onboarding.md`
- `2026-05-20-reconciliation-workflow.md`

## Facilitation rules for agents

- Prefer concrete user behavior over feature lists.
- Name the current phase explicitly when it changes.
- If the session is mostly about entities, lifecycle, state, or invariants,
  treat it as `domain shaping`, not story mapping.
- Watch for bounded-context sprawl. If the current context starts absorbing
  unrelated responsibilities, call it out explicitly instead of silently
  accepting it.
- Keep the backbone stable and move uncertainty into candidate steps or open
  questions.
- Prefer outcome slices over component slices.
- The user decides when a topic is closed.
- Suggest a checkpoint if the session goes deep into one phase for a long time.
- When the discussion becomes research-heavy, propose a `Spike`.
- When a slice becomes implementation-ready, hand off to issue creation.

## Method options

User Story Mapping is the default for shaping end-to-end user workflows.

Prefer another method when the problem calls for it:

- **Opportunity Solution Tree** when the goal is known but the solution space is
  wide.
- **Event Storming Lite** when the hard part is domain behavior, sequence, and
  state transitions.
- **Jobs To Be Done** when motivation, context, and trade-offs matter more than
  screen flow.
- **Impact Mapping** when the main question is whether a feature supports a
  strategic outcome.

Agents may mix methods, but the final output should still converge into a
discovery note plus concrete follow-up issues.
