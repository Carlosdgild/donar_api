# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2.3'
# Use Puma as the app server
gem 'puma', '~> 5.5.2', '>= 5.1.1'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.9.3', require: false
# Serializers
gem 'active_model_serializers', '~> 0.10.0'
# Kimari
gem 'kaminari', '~> 1.2', '>= 1.2.2'
# use sidekiq for background jobs
gem 'sidekiq', '~> 5.2.7'
# use sidekiq-cron for cron jobs
gem 'sidekiq-cron', '~> 1.2.0'
# Windows does not include zone info files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2022', '>= 1.2022.1', platforms: %i[mingw mswin x64_mingw jruby]
# Stripe SDK
gem 'stripe', '~> 7.1.0'
# User paranoia gem to provide safe/virtual deletion to selected models
gem 'paranoia', '~> 2.4.2'
# Devise gem
gem 'devise', '~> 4.7.1'
# user device_detector for user agent detection
gem 'device_detector', '~> 1.0.4'
# pundit for authorization
gem 'pundit', '~> 2.3', '>= 2.3.1'
# redis
gem 'redis', '~> 4.6.0'
gem 'redis_dashboard', '~> 0.3.0'

group :development, :test do
  gem 'byebug', '~> 11.1', '>= 11.1.3', platforms: %i[mri mingw x64_mingw]

  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'

  gem 'factory_bot_rails', '~> 6.2'

  gem 'faker', '~> 2.20'

  gem 'pry', '~> 0.14.1'

  gem 'rspec', '~> 3.11'

  gem 'rspec-rails', '~> 5.1', '>= 5.1.1'

  gem 'rswag-specs', '~> 2.5', '>= 2.5.1'

  gem 'rubocop', '~> 1.27', require: false

  gem 'rubocop-performance', '~> 1.13', '>= 1.13.3', require: false

  gem 'rubocop-rails', '~> 2.14', '>= 2.14.2', require: false

  gem 'rubocop-rspec', '~> 2.9', require: false

  gem 'shoulda-matchers', '~> 5.1'
end

group :development do
  gem 'annotate', '~> 3.2'

  gem 'better_errors', '~> 2.9', '>= 2.9.1'

  gem 'binding_of_caller', '~> 1.0'

  gem 'listen', '~> 3.7', '>= 3.7.1'

  gem 'rack-mini-profiler', '~> 3.0', require: false

  gem 'sql_queries_count', '~> 0.0.1'

  # For memory profiling

  gem 'memory_profiler', '~> 1.0'
end

group :test do
  # use pundit-matchers to enforce unit test within policies
  gem 'pundit-matchers', '~> 1.6.0'
  # use database_cleaner to truncate the contents of the database in every
  # example run
  gem 'database_cleaner', '~> 1.8.5'
  # enable mocks within context examples
  gem 'webmock', '~> 3.8.3'
  # use VCR for remote API interactions
  gem 'vcr', '~> 6.0.0'
end
