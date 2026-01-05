class User < ApplicationRecord
  has_many :orders, dependent: :destroy

  validates :line_user_id, presence: true, uniqueness: true
end
