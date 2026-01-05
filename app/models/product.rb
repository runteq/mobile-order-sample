class Product < ApplicationRecord
  has_many :order_items, dependent: :restrict_with_error

  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(is_active: true) }
  scope :sorted, -> { order(sort_order: :asc, id: :asc) }

  def price_yen
    price_cents
  end
end
