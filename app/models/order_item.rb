class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :qty, presence: true, numericality: { greater_than: 0 }
  validates :unit_price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :product_id, uniqueness: { scope: :order_id }

  def subtotal
    qty * unit_price_cents
  end
end
