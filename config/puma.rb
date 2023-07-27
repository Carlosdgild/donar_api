# frozen_string_literal: true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
# Runs the block of code, but prefixes it with a nicely formatted +title+.

# Runs the block of code, but prefixes it with a nicely formatted +title+.
def run(_title)
  start = Time.current
  yield if block_given?
  Rails.logger.debug "✔ Done, took #{Time.current - start} seconds"
end

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port ENV.fetch('PORT', 3000)

# Specifies the `environment` that Puma will run in.
#
current_environment = ENV.fetch('RAILS_ENV', 'development')
environment current_environment

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
if %w[development test].include? current_environment
  timeout = ENV.fetch('WORKER_TIMEOUT', 36_000)
  timeout = Integer(timeout)
  timeout = 3600 if timeout < 3600

  run "Puma worker_timeout set to #{timeout} seconds" do
    worker_timeout Integer(timeout)
  end
end

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch('WEB_CONCURRENCY', 2)

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
preload_app!

# If using workers:
on_worker_boot do
  # Valid on Rails 4.1+ using the `config/database.yml` method of setting `pool` size
  ActiveRecord::Base.establish_connection
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
