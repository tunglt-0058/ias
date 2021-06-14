class Notification < ApplicationRecord
  belongs_to :recipient, class_name: User.name
  belongs_to :stock

  belongs_to :notiable, polymorphic: true
end
