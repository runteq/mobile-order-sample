require 'rails_helper'

RSpec.describe "Admin::Products", type: :request do
  let(:valid_headers) do
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials("admin", "password")
    { "HTTP_AUTHORIZATION" => credentials }
  end

  describe "GET /admin/products" do
    it "requires authentication" do
      get admin_products_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http success with valid credentials" do
      get admin_products_path, headers: valid_headers
      expect(response).to have_http_status(:success)
    end

    it "displays products" do
      product = create(:product, name: "Admin Test Product")
      get admin_products_path, headers: valid_headers
      expect(response.body).to include("Admin Test Product")
    end
  end

  describe "GET /admin/products/new" do
    it "returns http success" do
      get new_admin_product_path, headers: valid_headers
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/products" do
    it "creates a new product" do
      expect {
        post admin_products_path, params: {
          product: { name: "New Product", price_cents: 500, is_active: true }
        }, headers: valid_headers
      }.to change(Product, :count).by(1)
    end

    it "redirects to products index" do
      post admin_products_path, params: {
        product: { name: "New Product", price_cents: 500 }
      }, headers: valid_headers
      expect(response).to redirect_to(admin_products_path)
    end
  end

  describe "GET /admin/products/:id/edit" do
    let(:product) { create(:product) }

    it "returns http success" do
      get edit_admin_product_path(product), headers: valid_headers
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /admin/products/:id" do
    let(:product) { create(:product, name: "Old Name") }

    it "updates the product" do
      patch admin_product_path(product), params: {
        product: { name: "New Name" }
      }, headers: valid_headers
      product.reload
      expect(product.name).to eq("New Name")
    end
  end

  describe "DELETE /admin/products/:id" do
    let!(:product) { create(:product) }

    it "deletes the product" do
      expect {
        delete admin_product_path(product), headers: valid_headers
      }.to change(Product, :count).by(-1)
    end
  end
end
