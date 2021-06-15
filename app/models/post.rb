class Post < ApplicationRecord
  belongs_to :expert
  belongs_to :stock
  has_many :comments, dependent: :destroy

  validates :expert, presence: true
  validates :stock, presence: true
  validates :content, presence: true
  validates :position, presence: true
  validates :target_price, presence: true
end
