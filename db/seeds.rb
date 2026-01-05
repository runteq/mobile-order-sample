products = [
  { name: "RUNTEQ Coffee", price_cents: 350, sort_order: 1 },
  { name: "Cafe Latte", price_cents: 400, sort_order: 2 },
  { name: "Green Tea", price_cents: 300, sort_order: 3 },
  { name: "Chocolate Cookie", price_cents: 200, sort_order: 4 },
  { name: "Cheesecake", price_cents: 450, sort_order: 5 },
  { name: "Orange Juice", price_cents: 280, sort_order: 6 }
]

products.each do |product_attrs|
  Product.find_or_create_by!(name: product_attrs[:name]) do |product|
    product.price_cents = product_attrs[:price_cents]
    product.sort_order = product_attrs[:sort_order]
    product.is_active = true
  end
end

puts "Created #{Product.count} products"
