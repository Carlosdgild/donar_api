FactoryBot.define do
  factory :donation do
    amount { 10 }
    description { Faker::Quotes::Shakespeare.hamlet_quote }
    currency { "usd" }
    status { Donation::Status::PENDING }
    instructions { Faker::Quotes::Shakespeare.hamlet_quote }
    user
    login_activity

    trait :payment do
      payment
    end
  end
end
