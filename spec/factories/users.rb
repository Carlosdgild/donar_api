# frozen_string_literal: true

FactoryBot.define do
  sequence :user_unique_email do |n|
    "spec#{n}_#{Faker::Internet.safe_email}"
  end

  factory :user do
    name { Faker::Name.name }
    last_name { Faker::Name.last_name }
    email { generate :user_unique_email }
    password { '12345678' }
    password_confirmation { '12345678' }

    trait :admin do
      role { User::Role::ADMIN }
    end
  end
end
