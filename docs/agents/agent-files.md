# Agent entry points

Rubedo supports two agents permanently: Codex and Claude Code. Both agents share the same skills and conventions.

`AGENTS.md` and `CLAUDE.md` are intentionally kept aligned at a high level so each agent starts from the same project context.

## Agent skills

The canonical location for all agent skills is `.agents/skills/`. Every skill that exists for any agent lives here as the single source of truth.

Claude Code accesses skills via `.claude/skills`, which is a symlink to `.agents/skills/`. When adding a new skill, place it in `.agents/skills/<skill-name>/` — no additional steps required.

## Entry point files

- Do not treat either file as canonical yet.
- When proposing repo-wide agent guidance, prefer moving stable details into shared files under `docs/agents/` or `docs/conventions/`.
- Keep the entry point files short and mostly navigational to reduce drift.
