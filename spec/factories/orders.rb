FactoryBot.define do
  factory :order do
    user
    status { :pending }
    total_price_cents { 0 }
    pickup_at { nil }
    note { nil }
  end
end
