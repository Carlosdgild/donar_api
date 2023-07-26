FactoryBot.define do
  factory :payment do
    amount { Faker::Number.number(digits: 2) }
    currency { "usd" }
    status { Payment::Status::PENDING }
    user
  end
end
