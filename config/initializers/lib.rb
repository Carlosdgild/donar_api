# frozen_string_literal: true

Dir[Rails.root.join("lib/**/*.rb")].each { |extension| require extension }
