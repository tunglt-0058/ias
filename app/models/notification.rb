class Notification < ApplicationRecord
  belongs_to :recipient, class_name: User.name
  belongs_to :stock
  belongs_to :post

  validates :recipient, presence: true
  validates :stock, presence: true
  validates :post, presence: true
  validates :content, presence: true

  enum notiable_type: [:info, :warning, :alert]  
end
