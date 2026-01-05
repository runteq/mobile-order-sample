module Liff
  class CartsController < BaseController
    def show
      @cart_items = load_cart_items
      @total = @cart_items.sum { |item| item[:product].price_cents * item[:qty] }
    end

    private

    def load_cart_items
      return [] if cart.empty?

      product_ids = cart.keys.map(&:to_i)
      products = Product.where(id: product_ids).index_by(&:id)

      cart.map do |product_id, qty|
        product = products[product_id.to_i]
        next unless product
        { product: product, qty: qty }
      end.compact
    end
  end
end
