FactoryBot.define do
  factory :article do
    sequence(:name) { |n| "Article #{n}" }
  end
end