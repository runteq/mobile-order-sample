products = [
  { name: "RUNTEQ Coffee", price_cents: 350, sort_order: 1, image_url: "https://placehold.co/200x200/8B4513/FFF?text=Coffee" },
  { name: "Cafe Latte", price_cents: 400, sort_order: 2, image_url: "https://placehold.co/200x200/D2691E/FFF?text=Latte" },
  { name: "Green Tea", price_cents: 300, sort_order: 3, image_url: "https://placehold.co/200x200/228B22/FFF?text=Tea" },
  { name: "Chocolate Cookie", price_cents: 200, sort_order: 4, image_url: "https://placehold.co/200x200/8B4513/FFF?text=Cookie" },
  { name: "Cheesecake", price_cents: 450, sort_order: 5, image_url: "https://placehold.co/200x200/FFD700/333?text=Cake" },
  { name: "Orange Juice", price_cents: 280, sort_order: 6, image_url: "https://placehold.co/200x200/FFA500/FFF?text=Juice" }
]

products.each do |product_attrs|
  Product.find_or_create_by!(name: product_attrs[:name]) do |product|
    product.price_cents = product_attrs[:price_cents]
    product.sort_order = product_attrs[:sort_order]
    product.image_url = product_attrs[:image_url]
    product.is_active = true
  end
end

puts "Created #{Product.count} products"
