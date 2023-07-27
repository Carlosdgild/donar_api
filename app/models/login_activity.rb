# frozen_string_literal: true

# authtrail's [LoginActivity] class
class LoginActivity < ApplicationRecord
  # associations
  belongs_to :user
  has_one :donation, dependent: :nullify
end
