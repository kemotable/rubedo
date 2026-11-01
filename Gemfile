# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 8.1.3"

gem "pg"
gem "puma"

gem "bootsnap", require: false
gem "haml-rails"
gem "propshaft"
gem "view_component"

# Rails half of an npm package: bump together with its package.json
# counterpart (see docs/conventions/frontend-dependencies.md).
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "stimulus-rails"
gem "turbo-rails"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "dotenv"
  gem "rubocop", require: false
  gem "rubocop-i18n", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end

group :development do
  gem "haml_lint", require: false
  gem "pry"
  gem "pry-rails"
  gem "web-console"
end
