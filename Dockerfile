# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t rubedo .
# docker run -d -p 80:3000 -e RAILS_MASTER_KEY=<value from config/master.key> --name rubedo rubedo

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Keep versions in sync with .tool-versions (see .claude/rules/runtime-versions.md)
ARG RUBY_VERSION=4.0.9
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages; postgresql-client comes from the PostgreSQL apt repo
# so its major matches the server (Debian ships an older one).
ARG POSTGRES_MAJOR=18
ADD --chmod=644 --checksum=sha256:0144068502a1eddd2a0280ede10ef607d1ec592ce819940991203941564e8e76 \
    https://www.postgresql.org/media/keys/ACCC4CF8.asc /etc/apt/keyrings/postgresql.asc
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y ca-certificates curl libjemalloc2 && \
    . /etc/os-release && \
    echo "deb [signed-by=/etc/apt/keyrings/postgresql.asc] https://apt.postgresql.org/pub/repos/apt ${VERSION_CODENAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y "postgresql-client-${POSTGRES_MAJOR}" && \
    ln -s "/usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2" /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Set production environment variables and enable jemalloc for reduced memory usage and latency.
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Use bash with pipefail so piped commands fail the build on any error
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
            build-essential \
            git \
            libpq-dev \
            libyaml-dev \
            node-gyp \
            pkg-config \
            python-is-python3 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install JavaScript dependencies
# Yarn itself comes from "packageManager" in package.json (version + hash).
ARG NODE_VERSION=26.13.0
ARG NODE_BUILD_VERSION=5.4.62
# Node 25+ no longer ships Corepack; install a pinned version.
ARG COREPACK_VERSION=0.36.0
ENV PATH=/usr/local/node/bin:$PATH \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN curl -fsSL "https://github.com/nodenv/node-build/archive/refs/tags/v${NODE_BUILD_VERSION}.tar.gz" | tar xz -C /tmp/ && \
    "/tmp/node-build-${NODE_BUILD_VERSION}/bin/node-build" "${NODE_VERSION}" /usr/local/node && \
    rm -rf "/tmp/node-build-${NODE_BUILD_VERSION}" && \
    npm install -g "corepack@${COREPACK_VERSION}" && \
    corepack enable

# Install application gems
COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    # -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
    bundle exec bootsnap precompile -j 1 --gemfile

# Install node modules
COPY package.json yarn.lock .yarnrc.yml ./
RUN yarn install --immutable

# Copy application code
COPY . .

# Precompile bootsnap code (faster boot), precompile assets without requiring
# the secret RAILS_MASTER_KEY, then drop node_modules.
# -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
RUN bundle exec bootsnap precompile -j 1 app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile && \
    rm -rf node_modules

# Final stage for app image
FROM base

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000

# Copy built artifacts: gems, application
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
