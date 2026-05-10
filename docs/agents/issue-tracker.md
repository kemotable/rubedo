# Agent issue tracker

Rubedo uses GitHub Issues as the source of truth for planned work.

## Issue types

- `Task` is the standard unit for implementation work.
- `Spike` is a time-boxed research unit that should end in a conclusion,
  follow-up tasks, or both.

Agents should follow the issue structures defined in
`docs/conventions/workflow.md` and the GitHub templates in
`.github/ISSUE_TEMPLATE/`.

## Labels

When creating a `Task`, suggest one label based on the issue context and ask
for confirmation before submitting:

- `feature`
- `bug`
- `chore`
- `infra`
- `docs`

When creating a `Spike`, use `spike`.

All issues are assigned to `kemotable`.
Milestones are assigned manually after issue creation.
