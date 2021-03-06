class FollowStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :user, presence: true
  validates :stock, presence: true 
end
