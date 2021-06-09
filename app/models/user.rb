class User < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :groups, :through => :group_users
end
