FactoryBot.define do
  factory :site do
    sequence(:name) { |n| "テストサイト#{n}" }
    description { "テスト用のサイトです" }
    sequence(:subdomain) { |n| "test-site-#{n}" }
  end
end