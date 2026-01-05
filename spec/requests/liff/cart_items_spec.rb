require 'rails_helper'

RSpec.describe "Liff::CartItems", type: :request do
  let(:product) { create(:product, is_active: true) }

  describe "POST /liff/cart_items" do
    it "adds product to cart" do
      post liff_cart_items_path, params: { product_id: product.id }
      expect(response).to redirect_to(liff_root_path)
    end

    it "returns successful response when turbo_stream requested" do
      post liff_cart_items_path, params: { product_id: product.id }, headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response).to have_http_status(:success).or have_http_status(:redirect)
    end
  end

  describe "PATCH /liff/cart_items/:product_id" do
    before do
      post liff_cart_items_path, params: { product_id: product.id }
    end

    it "updates quantity in cart" do
      patch liff_cart_item_path(product.id), params: { qty: 3 }
      expect(response).to redirect_to(liff_cart_path)
    end
  end

  describe "DELETE /liff/cart_items/:product_id" do
    before do
      post liff_cart_items_path, params: { product_id: product.id }
    end

    it "removes product from cart" do
      delete liff_cart_item_path(product.id)
      expect(response).to redirect_to(liff_cart_path)
    end
  end
end
