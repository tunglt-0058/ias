class Post < ApplicationRecord
  belongs_to :expert
  belongs_to :stock
  has_many :comments, dependent: :destroy

  validates :expert, presence: true
  validates :stock, presence: true
  validates :content, presence: true
  validates :position, presence: true
  validates :target_price, presence: true

  before_save :to_display_id

  def to_param
    display_id
  end

  private
  def to_display_id
    if self.position == 0
      position = "Buy "
    elsif self.position == 1
      position = "Hold "
    else
      position = "Sell "
    end
    title = position + self.stock.code + " 's Stock with " + self.target_price.to_s + " Price Target"
    self.display_id = title.parameterize.truncate(50, omission: "") + "-" + SecureRandom.uuid
  end
end
