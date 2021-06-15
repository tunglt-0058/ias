class Stock < ApplicationRecord
  belongs_to :category
  has_many :users, :through => :follow_stocks
  has_many :posts, dependent: :destroy
  has_many :notifications, dependent: :destroy, as: :notiable
  has_many :price_pasts, dependent: :destroy
  has_many :votes, dependent: :destroy
end
