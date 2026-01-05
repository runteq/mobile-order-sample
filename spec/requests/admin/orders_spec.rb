require 'rails_helper'

RSpec.describe "Admin::Orders", type: :request do
  let(:valid_headers) do
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials("admin", "password")
    { "HTTP_AUTHORIZATION" => credentials }
  end

  describe "GET /admin/orders" do
    it "requires authentication" do
      get admin_orders_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with valid credentials" do
      get admin_orders_path, headers: valid_headers
      expect(response).to have_http_status(:success)
    end

    it "displays orders" do
      user = create(:user, display_name: "Test Customer")
      create(:order, user: user, status: :pending)
      get admin_orders_path, headers: valid_headers
      expect(response.body).to include("pending")
    end

    it "filters by status" do
      user = create(:user)
      pending_order = create(:order, user: user, status: :pending)
      ready_order = create(:order, user: user, status: :ready)

      get admin_orders_path, params: { status: "ready" }, headers: valid_headers
      expect(response.body).to include(ready_order.id.to_s)
    end
  end

  describe "GET /admin/orders/:id" do
    let(:order) { create(:order) }

    it "returns http success" do
      get admin_order_path(order), headers: valid_headers
      expect(response).to have_http_status(:success)
    end

    it "displays order details" do
      product = create(:product, name: "Test Item")
      create(:order_item, order: order, product: product, qty: 2)

      get admin_order_path(order), headers: valid_headers
      expect(response.body).to include("Test Item")
    end
  end

  describe "PATCH /admin/orders/:id/update_status" do
    let(:order) { create(:order, status: :pending) }

    it "updates order status" do
      patch update_status_admin_order_path(order), params: { status: "accepted" }, headers: valid_headers
      order.reload
      expect(order.status).to eq("accepted")
    end

    it "redirects back to order" do
      patch update_status_admin_order_path(order), params: { status: "accepted" }, headers: valid_headers
      expect(response).to redirect_to(admin_order_path(order))
    end

    it "shows success notice" do
      patch update_status_admin_order_path(order), params: { status: "ready" }, headers: valid_headers
      expect(response).to redirect_to(admin_order_path(order))
      get admin_order_path(order), headers: valid_headers
      expect(response.body).to include("Status updated")
    end
  end
end
