# frozen_string_literal: true

# +PaymentStatusable+ module
module PaymentStatusable
  extend ActiveSupport::Concern

  # enums
  module Status
    SUCCEEDED = :succeeded
    FAILED = :failed
    PENDING = :pending
    REFOUND = :refound
    LIST = {
      SUCCEEDED => 0,
      FAILED => 1,
      PENDING => 2,
      REFOUND => 3
    }.freeze
  end

  included do
    enum status: Status::LIST
  end
end
