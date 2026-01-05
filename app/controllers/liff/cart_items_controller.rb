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

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("cart", partial: "liff/carts/cart") }
        format.html { redirect_to liff_cart_path }
      end
    end

    def destroy
      cart.delete(params[:product_id])

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("cart", partial: "liff/carts/cart") }
        format.html { redirect_to liff_cart_path }
      end
    end
  end
end
