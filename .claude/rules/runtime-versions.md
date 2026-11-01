---
paths:
  - ".tool-versions"
  - "Dockerfile"
  - ".qlty/qlty.toml"
  - ".rubocop.yml"
  - "package.json"
  - "docker-compose.yml"
---

# Runtime and toolchain versions

`.tool-versions` is the source of truth for Ruby and Node. The same versions
are repeated elsewhere and must move together, in the same commit:

| Version  | Also in                                                                                                                                     |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Ruby     | `Dockerfile` (`RUBY_VERSION`), `.qlty/qlty.toml` (`[runtimes.enabled]`), `README.md` badge; minor also `.rubocop.yml` (`TargetRubyVersion`) |
| Node     | `Dockerfile` (`NODE_VERSION`), `.qlty/qlty.toml` (`[runtimes.enabled]`), `README.md` badge                                                  |
| Yarn     | `package.json` (`packageManager`), `Dockerfile` (`YARN_VERSION`)                                                                            |
| Corepack | `Dockerfile` (`COREPACK_VERSION`), `README.md` setup, `~/.default-npm-packages` (outside the repo)                                          |
| Rails    | `Gemfile` (`~>` floor), `README.md` badge; minor also `config.load_defaults`, `lib/templates/**` (copied generator templates)               |
| Bundler  | `Gemfile.lock` (`BUNDLED WITH`)                                                                                                             |
| Postgres | `docker-compose.yml` (`image`), `Dockerfile` (`postgresql-client`), `README.md` badge, ADR-0003                                             |

This list goes stale. On every bump, also search the whole repository for
the old version string (e.g. `git grep -n "3\.4\.9"`, including comments and
docs) and fix or add any place not listed here — then update this table.
