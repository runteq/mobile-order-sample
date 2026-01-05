require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      product = build(:product)
      expect(product).to be_valid
    end

    it "requires name" do
      product = build(:product, name: nil)
      expect(product).not_to be_valid
      expect(product.errors[:name]).to be_present
    end

    it "requires price_cents" do
      product = build(:product, price_cents: nil)
      expect(product).not_to be_valid
    end

    it "requires price_cents to be non-negative" do
      product = build(:product, price_cents: -1)
      expect(product).not_to be_valid
    end
  end

  describe "scopes" do
    before do
      @active1 = create(:product, is_active: true, sort_order: 2, name: "B")
      @active2 = create(:product, is_active: true, sort_order: 1, name: "A")
      @inactive = create(:product, is_active: false, sort_order: 0)
    end

    it ".active returns only active products" do
      expect(Product.active).to include(@active1, @active2)
      expect(Product.active).not_to include(@inactive)
    end

    it ".sorted orders by sort_order then id" do
      sorted = Product.active.sorted
      expect(sorted.first).to eq(@active2)
      expect(sorted.last).to eq(@active1)
    end
  end

  describe "#price_yen" do
    it "returns price_cents value" do
      product = build(:product, price_cents: 500)
      expect(product.price_yen).to eq(500)
    end
  end
end
