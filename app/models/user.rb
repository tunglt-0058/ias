class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :votes, dependent: :destroy
  has_many :notifications, dependent: :destroy, foreign_key: :recipient_id
  has_one :expert

  enum account_type: [:user, :expert, :admin]

  validates :email, presence: true, length: {maximum: 255},
    format: {with: Devise.email_regexp}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {within: Devise.password_length}, allow_nil: true
  validates :name, presence: true, length: {maximum: 64}

  before_save :to_display_id

  private
  def to_display_id
    self.display_id = self.name.gsub(" ", "-") + "-" + Digest::SHA2.hexdigest(self.email)
  end  
end
