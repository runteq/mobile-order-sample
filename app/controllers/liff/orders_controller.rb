module Liff
  class OrdersController < BaseController
    before_action :require_liff_user, only: [ :create ]

    def create
      if cart.empty?
        redirect_to liff_root_path, alert: "Your cart is empty"
        return
      end

      @order = current_user.orders.build(order_params)
      @order.status = :pending

      product_ids = cart.keys.map(&:to_i)
      products = Product.where(id: product_ids).index_by(&:id)

      cart.each do |product_id, qty|
        product = products[product_id.to_i]
        next unless product

        @order.order_items.build(
          product: product,
          qty: qty,
          unit_price_cents: product.price_cents
        )
      end

      @order.calculate_total!

      if @order.save
        clear_cart
        LineNotifier.new.order_created(@order)
        redirect_to complete_liff_order_path(@order)
      else
        redirect_to liff_checkout_path, alert: "Failed to create order"
      end
    end

    def complete
      @order = Order.find(params[:id])
    end

    private

    def order_params
      params.permit(:pickup_at, :note)
    end
  end
end
