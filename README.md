# Rubedo

![Ruby](https://img.shields.io/badge/ruby-3.4.12-CC342D?style=flat&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/rails-8.1.4-CC0000?style=flat&logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/postgresql-18-4169E1?style=flat&logo=postgresql&logoColor=white)
![Node](https://img.shields.io/badge/node-24.16.0-339933?style=flat&logo=nodedotjs&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue?style=flat)

Personal finance application built as a long-term, portfolio-grade Rails project.
Focus on domain modelling, pragmatic event-driven architecture, and conscious
trade-offs.

Status: early development. See [GitHub Milestones](../../milestones) for current scope.

## For developers / agents

Read [`CLAUDE.md`](./CLAUDE.md) for repository navigation and project character.

## Tech

Hotwire · Propshaft · HAML · Tailwind v4 · daisyUI v5 · ViewComponent

## Setup

**Prerequisites:** [asdf](https://asdf-vm.com), [Docker](https://www.docker.com),
[overmind](https://github.com/DarthSim/overmind) >= 2.5 (`brew install overmind`,
pulls in tmux)

```bash
$ asdf install
$ corepack enable
$ bin/setup
```

`bin/setup` installs gems and JS packages, creates `.env` from `.env.example`,
starts the Postgres container, prepares the database and runs `bin/dev`.
Afterwards, `bin/dev` alone starts the app (database container included).
Attach to a process with `overmind connect web` (or `js`, `css`), e.g. when
stopped at a `debugger` call.

## License

See [`LICENSE`](./LICENSE).
