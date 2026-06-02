# Rubedo

![Ruby](https://img.shields.io/badge/ruby-3.4.8-CC342D?style=flat&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/rails-8.1.2-CC0000?style=flat&logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/postgresql-18-4169E1?style=flat&logo=postgresql&logoColor=white)
![Node](https://img.shields.io/badge/node-24.13.1-339933?style=flat&logo=nodedotjs&logoColor=white)
![License](https://img.shields.io/github/license/kemotable/rubedo?style=flat)

Personal finance application built as a long-term, portfolio-grade Rails project.
Focus on domain modelling, pragmatic event-driven architecture, and conscious
trade-offs.

Status: early development. See [GitHub Milestones](../../milestones) for current scope.

## For developers / agents

Read [`CLAUDE.md`](./CLAUDE.md) for repository navigation and project character.

## Tech

Hotwire · Propshaft · HAML · Tailwind v4 · daisyUI v5 · ViewComponent

## Setup

**Prerequisites:** [asdf](https://asdf-vm.com), [Docker](https://www.docker.com)

```bash
$ asdf install
$ docker compose up -d
$ bundle install
$ corepack enable
$ yarn install
$ bin/rails db:setup
$ bin/dev
```

## License

See [`LICENSE`](./LICENSE).
