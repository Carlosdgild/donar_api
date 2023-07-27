# frozen_string_literal: true

class DonationSerializer < ActiveModel::Serializer
  attributes :id, :amount, :currency, :status, :instructions, :created_at, :deleted_at

  attribute :payment

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end

  def payment
    object_payment = object.payment
    return if object_payment.blank?

    PaymentSerializer.new(object_payment).as_json
  end
end
