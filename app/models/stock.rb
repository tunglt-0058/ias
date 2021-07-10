class Stock < ApplicationRecord
  belongs_to :sector
  belongs_to :industry
  has_many :follow_stocks, dependent: :destroy
  has_many :users, through: :follow_stocks
  has_many :posts, dependent: :destroy
  has_many :notifications, dependent: :destroy, as: :notiable
  has_many :price_pasts, dependent: :destroy
  has_many :votes, dependent: :destroy

  before_save :to_display_id

  def analyst_consensus
    positions = ["MUA", "GIỮ", "BÁN"]
    analysts = []
    buy  = self.posts.where(position: 0).size
    hold = self.posts.where(position: 1).size
    sell = self.posts.where(position: 2).size
    analysts.push(buy, hold, sell)
    return positions[analysts.index(analysts.max) || 0]
  end

  private
  def to_display_id
    self.display_id = self.code
  end
end
