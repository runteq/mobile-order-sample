class Product < ApplicationRecord
  has_one_attached :image
  has_many :order_items, dependent: :restrict_with_error

  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image, content_type: { in: %w[image/png image/jpeg image/webp], message: "must be PNG, JPEG or WebP" },
                    size: { less_than: 5.megabytes, message: "must be less than 5MB" }

  scope :active, -> { where(is_active: true) }
  scope :sorted, -> { order(sort_order: :asc, id: :asc) }

  def price_yen
    price_cents
  end
end
