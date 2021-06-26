class Stock < ApplicationRecord
  belongs_to :sector
  belongs_to :industry
  has_many :users, :through => :follow_stocks
  has_many :posts, dependent: :destroy
  has_many :notifications, dependent: :destroy, as: :notiable
  has_many :price_pasts, dependent: :destroy
  has_many :votes, dependent: :destroy

  before_save :to_display_id
  def to_param
    display_id
  end

  private
  def to_display_id
    self.display_id = self.code
  end
end
