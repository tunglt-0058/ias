class FollowExpert < ApplicationRecord
  belongs_to :user
  belongs_to :expert

  validates :user, presence: true
  validates :expert, presence: true
end
