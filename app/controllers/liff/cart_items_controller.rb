module Liff
  class CartItemsController < BaseController
    def create
      product = Product.active.find(params[:product_id])
      cart[product.id.to_s] ||= 0
      cart[product.id.to_s] += 1

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to liff_root_path }
      end
    end

    def update
      product_id = params[:product_id]
      qty = params[:qty].to_i

      if qty > 0
        cart[product_id] = qty
      else
        cart.delete(product_id)
      end

      load_cart_items

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to liff_cart_path }
      end
    end

    def destroy
      cart.delete(params[:product_id])

      load_cart_items

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to liff_cart_path }
      end
    end

    private

    def load_cart_items
      if cart.empty?
        @cart_items = []
        @total = 0
        return
      end

      product_ids = cart.keys.map(&:to_i)
      products = Product.where(id: product_ids).index_by(&:id)

      @cart_items = cart.map do |product_id, qty|
        product = products[product_id.to_i]
        next unless product
        { product: product, qty: qty }
      end.compact

      @total = @cart_items.sum { |item| item[:product].price_cents * item[:qty] }
    end
  end
end
