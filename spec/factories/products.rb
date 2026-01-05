FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price_cents { 350 }
    is_active { true }
    sort_order { 0 }
  end
end
