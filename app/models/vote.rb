class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  enum vote: [:buy, :hold, :sell]

  validates :vote, presence: true
end
