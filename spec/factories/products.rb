FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price_cents { 350 }
    image_url { "https://placehold.co/200x200/8B4513/FFF?text=Test" }
    is_active { true }
    sort_order { 0 }
  end
end
