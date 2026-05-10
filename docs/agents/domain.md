# Agent domain docs

When working in Rubedo, read the repository guidance in this order:

1. `AGENTS.md` or `CLAUDE.md` for the project character and repo entry points
2. `docs/conventions/domain.md` for domain and data-handling rules
3. `docs/conventions/code.md` for binding code conventions
4. `docs/conventions/workflow.md` for issue, PR, and release-process rules
5. `docs/adr/` entries that touch the area being changed

`docs/CONTEXT.md` does not exist yet by design. Until it appears, agents
should treat `docs/conventions/domain.md` plus accepted ADRs as the current
domain-language source.
