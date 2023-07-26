class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :charge_id, :fingerprint, :receipt_url
end
