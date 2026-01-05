require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "requires line_user_id" do
      user = build(:user, line_user_id: nil)
      expect(user).not_to be_valid
      expect(user.errors[:line_user_id]).to include("can't be blank")
    end

    it "requires unique line_user_id" do
      create(:user, line_user_id: "U123")
      user = build(:user, line_user_id: "U123")
      expect(user).not_to be_valid
      expect(user.errors[:line_user_id]).to include("has already been taken")
    end
  end

  describe "associations" do
    it "has many orders" do
      user = create(:user)
      order = create(:order, user: user)
      expect(user.orders).to include(order)
    end

    it "destroys associated orders when destroyed" do
      user = create(:user)
      create(:order, user: user)
      expect { user.destroy }.to change(Order, :count).by(-1)
    end
  end
end
