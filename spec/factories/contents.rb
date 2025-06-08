FactoryBot.define do
  factory :content do
    association :site
    sequence(:path) { |n| "page#{n}.html" }
    content { "<html><body><h1>テストページ</h1></body></html>" }
  end
end
