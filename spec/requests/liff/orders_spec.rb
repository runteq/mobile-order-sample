require 'rails_helper'

RSpec.describe "Liff::Orders", type: :request do
  describe "POST /liff/orders" do
    let(:user) { create(:user) }
    let(:product) { create(:product, is_active: true, price_cents: 350) }

    before do
      post liff_session_path, params: { line_user_id: user.line_user_id }, as: :json
    end

    context "with items in cart" do
      before do
        post liff_cart_items_path, params: { product_id: product.id }
      end

      it "creates an order" do
        expect {
          post liff_orders_path, params: { note: "No sugar" }
        }.to change(Order, :count).by(1)
      end

      it "redirects to complete page" do
        post liff_orders_path, params: { note: "No sugar" }
        expect(response).to redirect_to(complete_liff_order_path(Order.last))
      end

      it "creates order items" do
        expect {
          post liff_orders_path
        }.to change(OrderItem, :count).by(1)
      end

      it "clears the cart after order" do
        post liff_orders_path
        get liff_cart_path
        expect(response.body).to include("empty")
      end
    end

    context "with empty cart" do
      it "redirects to products page" do
        post liff_orders_path
        expect(response).to redirect_to(liff_root_path)
      end
    end
  end

  describe "GET /liff/orders/:id/complete" do
    let(:order) { create(:order, total_price_cents: 500) }

    it "returns http success" do
      get complete_liff_order_path(order)
      expect(response).to have_http_status(:success)
    end

    it "displays order number" do
      get complete_liff_order_path(order)
      expect(response.body).to include(order.id.to_s)
    end
  end
end
