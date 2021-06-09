class FollowExpert < ApplicationRecord
  belongs_to :user
  belongs_to :expert
end
