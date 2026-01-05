require 'rails_helper'

RSpec.describe "Liff::Checkouts", type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product, is_active: true, name: "Test Coffee", price_cents: 350) }

  before do
    post liff_session_path, params: { line_user_id: user.line_user_id }, as: :json
    post liff_cart_items_path, params: { product_id: product.id }
  end

  describe "GET /liff/checkout" do
    it "returns http success" do
      get liff_checkout_path
      expect(response).to have_http_status(:success)
    end

    it "displays checkout form with cart items" do
      get liff_checkout_path
      expect(response.body).to include("Test Coffee")
      expect(response.body).to include("350")
    end
  end
end
