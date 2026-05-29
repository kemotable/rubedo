# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 8.1.2"

gem "pg",   "~> 1.6"
gem "puma", "~> 7.2"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "haml-rails"
gem "jsbundling-rails"
gem "propshaft"
gem "stimulus-rails"
gem "turbo-rails"
gem "view_component"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rubocop", require: false
  gem "rubocop-i18n", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end

group :development do
  gem "foreman"
  gem "haml_lint", require: false
  gem "pry"
  gem "pry-rails"
  gem "web-console"
end
