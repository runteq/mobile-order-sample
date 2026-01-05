module Liff
  class CheckoutsController < BaseController
    before_action :require_liff_user
    before_action :require_cart_items

    def show
      @cart_items = load_cart_items
      @total = @cart_items.sum { |item| item[:product].price_cents * item[:qty] }
    end

    private

    def require_cart_items
      if cart.empty?
        redirect_to liff_root_path, alert: "Your cart is empty"
      end
    end

    def load_cart_items
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
