require 'securerandom'
class Expert < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :users, :through => :follow_experts

  before_save :to_display_id
  def to_param
    display_id
  end

  private
  def to_display_id
    user = User.find self.user_id
    self.display_id = user.name.parameterize.truncate(50, omission: "")+ "-" + SecureRandom.uuid
  end
end
