class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum :status, {
    pending: 0,
    accepted: 1,
    preparing: 2,
    ready: 3,
    completed: 4,
    canceled: 5
  }

  validates :status, presence: true
  validates :total_price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :note, length: { maximum: 140 }

  def total_price_yen
    total_price_cents
  end

  def calculate_total!
    self.total_price_cents = order_items.sum { |item| item.qty * item.unit_price_cents }
  end
end
