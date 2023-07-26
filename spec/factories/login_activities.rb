FactoryBot.define do
  factory :login_activity do
    user_agent { 'user_agent' }
    address_ip { '127.0.0.1' }
    user
  end
end
