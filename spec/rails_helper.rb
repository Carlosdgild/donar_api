# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'

ENV['SKIP_COVERAGE'] ||= 'true'

unless ENV.fetch('SKIP_COVERAGE', nil) == 'true'
  require 'simplecov'

  SimpleCov.minimum_coverage_by_file line: 80

  SimpleCov.start 'rails' do
    add_filter 'bin/'
    add_filter 'db/'
    add_filter 'app/models/application_record.rb'
    add_filter 'app/helpers/'
    add_filter 'app/controllers/api_controller.rb'
    add_filter 'lib/pagination/'
    add_filter 'lib/rendering/'
    add_filter 'spec/' # for rspec
    add_filter 'test/' # for minitest
    add_filter 'serializers/'
  end
end

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require 'shoulda/matchers'
require 'database_cleaner'
require 'pundit/matchers'
require 'pundit/rspec'
require 'sidekiq/testing'
Sidekiq::Testing.fake!
require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort('✗ The Rails environment is running in production mode!') if Rails.env.production?

if Rails.configuration.eager_load
  puts 'CI mode enabled!'
else
  puts 'CI mode disabled!'
end

require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # include RequestSpecHelper
  config.include RequestSpecHelper
  # VCR config
  VCR.configure do |configuration|
    configuration.cassette_library_dir = 'spec/vcr_cassettes'
    configuration.hook_into :webmock

    # Stripe API
    configuration
      .register_request_matcher :stripe_api do |real_request, recorded_request|
      url_regex = /^https:\/\/api\.stripe\.com\/v1\.*$/
      real_request.uri == recorded_request.uri ||
        (
          url_regex.match(real_request.uri) &&
          url_regex.match(recorded_request.uri)
        )
    end
  end

  # Helpers
  config.include DeviseHelpers, type: :request

  config.include ActiveJob::TestHelper
  config.before(:each, type: :job) do
    ActiveJob::Base.queue_adapter = :test
  end
end
