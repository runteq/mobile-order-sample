FactoryBot.define do
  factory :order_item do
    order
    product
    qty { 1 }
    unit_price_cents { 350 }
  end
end
