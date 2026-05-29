# ADR-0005: Static Font Serving via Propshaft

- **Status**: Accepted
- **Date**: 2026-05-29
- **Deciders**: Tomasz Pietrzyk

## Context

The project uses Propshaft as the asset pipeline and `@tailwindcss/cli` + `cssbundling-rails` for CSS building. Web fonts need to be served with content-addressed fingerprinting (cache-busting). npm packages like `@fontsource-variable/inter` are the standard distribution mechanism for open-source fonts, but their CSS import mechanism (`@import "package/subset.css"`) generates `url()` references pointing to `node_modules/` — a path Propshaft has no visibility into.

## Decision

Copy WOFF2 files from the npm source package into `app/assets/fonts/`. Declare `@font-face` rules manually in `app/assets/stylesheets/application.tailwind.css` using Propshaft-native URL format (no `/assets/` prefix — Propshaft rewrites to digested path at serve time). Keep the source npm package as a `devDependency` to track provenance and simplify future updates.

## Alternatives considered

- **CDN (Google Fonts / Bunny Fonts)**: No build step, always up to date. Cons: external dependency, privacy implications (GDPR), unavailable offline, slower first load without preconnect.
- **Direct `@import` from npm package**: Zero manual work. Cons: WOFF2 paths in the package CSS point to `node_modules/`; Tailwind CLI does not bundle binary assets; Propshaft cannot resolve these paths. Does not work with this stack without additional tooling.
- **Manual copy to `app/assets/fonts/` (chosen)**: Works cleanly with Propshaft. Font files are fingerprinted and served correctly in production. Cons: manual `cp` step required on font version bumps.

## Consequences

- **Positive**: Font files are fingerprinted by Propshaft — correct cache-busting in production. No external runtime dependency. WOFF2 files are explicit in the git history.
- **Negative / accepted costs**: Updating a font requires: `yarn upgrade <package>` → locate new WOFF2 in `node_modules` → `cp` to `app/assets/fonts/` → commit. Manual, but infrequent. A `bin/update-fonts` script could automate this (tracked in backlog).
- **Neutral**: ~173 KB of WOFF2 files tracked in the repository.

## References

- Propshaft README — CSS asset compiler / `url()` rewriting behaviour
- Issue #11 — CSS & Frontend Foundation Setup
- `@fontsource-variable/inter` npm package
