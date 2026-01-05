require 'rails_helper'

RSpec.describe "Liff::Carts", type: :request do
  describe "GET /liff/cart" do
    it "returns http success" do
      get liff_cart_path
      expect(response).to have_http_status(:success)
    end

    it "displays cart contents" do
      product = create(:product, is_active: true, name: "Test Coffee")
      post liff_cart_items_path, params: { product_id: product.id }

      get liff_cart_path
      expect(response.body).to include("Test Coffee")
    end
  end
end
