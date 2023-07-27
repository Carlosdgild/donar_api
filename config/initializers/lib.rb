# frozen_string_literal: true

Dir[Rails.root.join('lib/**/*.rb')].sort.each { |extension| require extension }
