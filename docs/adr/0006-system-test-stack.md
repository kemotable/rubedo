# ADR-0006: System/E2E test stack for Hotwire

- **Status**: Draft
- **Date**: 2026-06-03
- **Deciders**: Tomasz Pietrzyk

## Context

Rubedo uses Hotwire (Turbo + Stimulus). The behaviour that matters for the
user — Turbo navigation, Frames/Streams, Stimulus controllers reacting to the
DOM — can only be meaningfully verified by driving a real browser against the
actually-bundled JavaScript. Request/integration tests do not exercise it.

The default Rails system-test stack is Capybara + Selenium. Prior experience
on other projects has been poor: Selenium-driven Stimulus scenarios produced
frequent flaky failures (timing, async settling), to the point of having to
disable them in CI. The root cause is the WebDriver layer and the absence of
robust auto-waiting, not the scenarios themselves.

Rubedo currently has no tests at all. This ADR is a Draft: it records the
intended direction so the choice is made deliberately before system tests are
introduced (test framework lands in M2 per `docs/conventions/code.md`). It is
also relevant to safe frontend dependency upgrades — see
`docs/conventions/frontend-dependencies.md`, whose upgrade policy currently
relies on manual browser smoke precisely because this safety net does not yet
exist.

## Decision

When system tests are introduced, drive them with **Playwright via the
`capybara-playwright-driver`** rather than Selenium. This keeps tests in the
idiomatic Capybara / Rails system-test structure while replacing the engine
with Playwright, whose built-in auto-waiting eliminates the largest class of
Hotwire flakiness (asserting before the DOM/Stimulus has settled).

## Alternatives considered

- **Capybara + Selenium** — the Rails default. Mature and well-documented, but
  the source of the flakiness this ADR exists to avoid. Rejected.
- **Capybara + Cuprite (Ferrum/CDP)** — talks to Chrome directly over the
  Chrome DevTools Protocol, no WebDriver. Less flaky than Selenium and stays in
  Ruby; a strong fallback if the Playwright driver proves immature. Auto-waiting
  is weaker than Playwright's.
- **Capybara + Playwright driver** — Capybara API on Playwright's engine;
  best flakiness profile while staying Rails-idiomatic. Leaning choice.
- **Cypress / Playwright Test (Node)** — a separate JS/TS test stack with
  excellent auto-waiting and DX, but introduces a second test runner alongside
  Rails, with its own app-server/fixture management. Heavier; not idiomatic for
  a solo Rails project. Rejected for now.

## Consequences

- **Positive**: a system-test layer stable enough to keep as a CI gate;
  auto-waiting addresses the flakiness root cause; tests stay in the Capybara
  idiom; provides the missing safety net for runtime frontend upgrades.
- **Negative / accepted costs**: an extra dependency (Playwright browser
  binaries) to install and keep current in dev and CI; the Ruby Playwright
  driver is less ubiquitous than Selenium, so fewer ready answers exist.
- **Neutral**: does not affect domain code or non-browser tests.

## Open questions (Draft only)

- Is `capybara-playwright-driver` mature and maintained enough to commit to, or
  should Cuprite be the initial choice with Playwright as a later move?
- What is the CI cost of provisioning Playwright browser binaries, and does it
  fit the pipeline shaped in the #29 spike?
- Should a fast non-JS layer (`rack_test`) be kept for tests that do not need a
  browser, reserving the Playwright layer for genuinely JS-dependent flows?
- When exactly does the first system test land — alongside the M2 test
  framework, or earlier if a Hotwire-heavy feature arrives first?

## References

- `docs/conventions/code.md` (testing lands in M2).
- `docs/conventions/frontend-dependencies.md` (upgrade policy depends on this
  safety net).
- Issue #29 (CI pipeline composition spike).
