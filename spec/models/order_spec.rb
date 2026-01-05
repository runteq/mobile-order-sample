require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      order = build(:order)
      expect(order).to be_valid
    end

    it "requires status" do
      order = build(:order, status: nil)
      expect(order).not_to be_valid
    end

    it "requires total_price_cents" do
      order = build(:order, total_price_cents: nil)
      expect(order).not_to be_valid
    end

    it "requires total_price_cents to be non-negative" do
      order = build(:order, total_price_cents: -1)
      expect(order).not_to be_valid
    end

    it "limits note to 140 characters" do
      order = build(:order, note: "a" * 141)
      expect(order).not_to be_valid
      expect(order.errors[:note]).to be_present
    end
  end

  describe "associations" do
    it "belongs to user" do
      user = create(:user)
      order = create(:order, user: user)
      expect(order.user).to eq(user)
    end

    it "has many order_items" do
      order = create(:order)
      product = create(:product)
      order_item = create(:order_item, order: order, product: product)
      expect(order.order_items).to include(order_item)
    end

    it "destroys associated order_items when destroyed" do
      order = create(:order)
      product = create(:product)
      create(:order_item, order: order, product: product)
      expect { order.destroy }.to change(OrderItem, :count).by(-1)
    end
  end

  describe "enum status" do
    it "defines status values" do
      expect(Order.statuses).to eq({
        "pending" => 0,
        "accepted" => 1,
        "preparing" => 2,
        "ready" => 3,
        "completed" => 4,
        "canceled" => 5
      })
    end

    it "can change status" do
      order = create(:order, status: :pending)
      order.accepted!
      expect(order.accepted?).to be true
    end
  end

  describe "#calculate_total!" do
    it "calculates total from order items" do
      order = create(:order)
      product1 = create(:product, price_cents: 100)
      product2 = create(:product, price_cents: 200)
      create(:order_item, order: order, product: product1, qty: 2, unit_price_cents: 100)
      create(:order_item, order: order, product: product2, qty: 1, unit_price_cents: 200)
      order.reload
      order.calculate_total!
      expect(order.total_price_cents).to eq(400)
    end
  end

  describe "#total_price_yen" do
    it "returns total_price_cents value" do
      order = build(:order, total_price_cents: 1000)
      expect(order.total_price_yen).to eq(1000)
    end
  end
end
