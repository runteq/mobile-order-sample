require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      order_item = build(:order_item)
      expect(order_item).to be_valid
    end

    it "requires qty" do
      order_item = build(:order_item, qty: nil)
      expect(order_item).not_to be_valid
    end

    it "requires qty to be positive" do
      order_item = build(:order_item, qty: 0)
      expect(order_item).not_to be_valid
    end

    it "requires unit_price_cents" do
      order_item = build(:order_item, unit_price_cents: nil)
      expect(order_item).not_to be_valid
    end

    it "requires unique product per order" do
      order = create(:order)
      product = create(:product)
      create(:order_item, order: order, product: product)
      duplicate = build(:order_item, order: order, product: product)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:product_id]).to include("has already been taken")
    end
  end

  describe "associations" do
    it "belongs to order" do
      order = create(:order)
      order_item = create(:order_item, order: order)
      expect(order_item.order).to eq(order)
    end

    it "belongs to product" do
      product = create(:product)
      order_item = create(:order_item, product: product)
      expect(order_item.product).to eq(product)
    end
  end

  describe "#subtotal" do
    it "calculates qty * unit_price_cents" do
      order_item = build(:order_item, qty: 3, unit_price_cents: 200)
      expect(order_item.subtotal).to eq(600)
    end
  end
end
