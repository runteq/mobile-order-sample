require 'rails_helper'

RSpec.describe "Liff::Products", type: :request do
  describe "GET /liff" do
    before do
      @active_product = create(:product, is_active: true, sort_order: 1)
      @inactive_product = create(:product, is_active: false)
    end

    it "returns http success" do
      get liff_root_path
      expect(response).to have_http_status(:success)
    end

    it "displays active products" do
      get liff_root_path
      expect(response.body).to include(@active_product.name)
    end

    it "does not display inactive products" do
      get liff_root_path
      expect(response.body).not_to include(@inactive_product.name)
    end
  end
end
