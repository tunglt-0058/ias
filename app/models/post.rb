class Post < ApplicationRecord
  belongs_to :expert
  belongs_to :stock
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :votes, dependent: :destroy

  enum position: [:buy, :hold, :sell]

  validates :expert, presence: true
  validates :stock, presence: true
  validates :position, presence: true
  validates :target_price, presence: true
  validates :title, presence: true
  validates :content, presence: true

  before_create :caculate_display_id
  before_create :caculate_target_time

  def caculate_display_id
    display_str = self.expert_id.to_s + self.stock_id.to_s + Time.now.strftime("%d/%m/%Y %H:%M:%S")
    self.display_id = self.title.gsub(" ", "-") + "-" + Digest::SHA2.hexdigest(display_str)
  end

  private
  def caculate_target_time
    self.target_time = Time.now.next_year
  end
end
