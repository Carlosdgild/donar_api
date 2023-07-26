class Payment < ApplicationRecord
  acts_as_paranoid
  # associations
  belongs_to :user
  has_one :donation
  # concerns
  include PaymentStatusable
  # Validations
  validates :amount, numericality: { greater_than: 0 }
end
