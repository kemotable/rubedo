# Frontend dependency conventions

How JavaScript/CSS packages (managed by Yarn, in `package.json`) are
upgraded and kept in sync with their Rails counterparts. Like the other
convention files, this is intentionally thin — entries are added only as
real rules stabilise.

## npm ↔ gem pairing

Several frontend packages are integrated into Rails by a companion gem.
The two halves are coupled: upgrading one side without considering the
other can cause a mismatch. When updating either half of a pair, check
and, if needed, update the other in the same change.

| npm package             | Rails gem           |
| ----------------------- | ------------------- |
| `@hotwired/turbo-rails` | `turbo-rails`       |
| `@hotwired/stimulus`    | `stimulus-rails`    |
| `@tailwindcss/cli`      | `cssbundling-rails` |
| `esbuild`               | `jsbundling-rails`  |

## Upgrade policy

Rubedo keeps frontend dependencies **proactively up-to-date as hygiene**,
not "only when forced". This is a deliberate departure from the common
Rails-project habit of leaving JS packages stale until something breaks.

Rationale: a shorter window of exposure to known vulnerabilities, avoiding
painful big-bang upgrades that accumulate when updates are deferred, and
keeping the shipped bundle on current, supported APIs. The accepted cost
is periodic small upgrades and — until system tests exist — a manual
browser smoke of runtime packages (Turbo, Stimulus, daisyUI).

Upgrade order follows blast radius: build-time tooling (esbuild, the
Tailwind CLI, ESLint, Prettier) first — it fails loudly at build time —
then runtime packages that ship to the browser, where breakage is silent.

## Pre-1.0 packages

For packages still on a `0.x` version (currently `esbuild`), a caret range
(`^0.28.0`) does **not** allow all `0.x` releases — it behaves like a tilde
and permits only patch releases within the same minor (`>=0.28.0 <0.29.0`).
Minor bumps (e.g. `0.28` → `0.29`) are therefore potentially breaking and
must be done explicitly, after reading the changelog.
