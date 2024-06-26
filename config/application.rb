# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DonarApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: false,
                       view_specs: false,
                       helper_specs: false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Adding manually some middlewares needed
    # https://guides.rubyonrails.org/api_app.html#using-session-middlewares
    # This also configures session_options for use below
    config.session_store :cookie_store, key: '_donar_api_session'
    # Required for all session management (regardless of session_store)
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
  end
end
