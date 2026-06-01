# Code conventions

Ruby and Rails patterns specific to this repository. This file is
intentionally thin at this stage — entries are added only when patterns
stabilise into real conventions, not preemptively.

Quality-gate commands (linters, autoload check, etc.) live in
`.github/pull_request_template.md` and, once configured, in CI (milestone
M2). They are not duplicated here.

Conventions derived from architectural decisions are added here only after
the relevant ADR reaches `Status: Accepted`. While an ADR is in `Draft`,
its rules are not yet binding and do not appear in this file.

## Templates

HAML is the template language for all views. ERB is not used.

## Linting

**Ruby** — RuboCop is the linter. `.rubocop.yml` is the authoritative config; run `rubocop` before every merge. Enforcement via CI lands in M2.

**HAML** — haml_lint is the linter. Run `haml_lint app/views/` before every merge. Enforcement via CI lands in M2.

**JavaScript** — ESLint is the linter (`eslint.config.js`); Prettier is the formatter (`.prettierrc`). Run `yarn lint:js` to check and `yarn format:js` to format before every merge.

## Testing

To be added when the test framework lands (milestone M2).
