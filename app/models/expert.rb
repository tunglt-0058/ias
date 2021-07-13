class Expert < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :follow_experts, dependent: :destroy
  has_many :users, through: :follow_experts
  belongs_to :user

  validates :user, presence: true

  before_create :caculate_display_id

  private
  def caculate_display_id
    self.display_id = self.user.name.gsub(" ", "-") + "-" + 
      Digest::SHA2.hexdigest(self.user_id.to_s)
  end    
end
