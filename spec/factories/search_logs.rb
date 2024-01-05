FactoryBot.define do
  factory :search_log do
    user
    query { Faker::Lorem.word }
  end
end
