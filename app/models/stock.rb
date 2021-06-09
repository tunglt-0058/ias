class Stock < ApplicationRecord
  has_many :users, :through => :follow_stocks
  has_many :posts, dependent: :destroy
end
