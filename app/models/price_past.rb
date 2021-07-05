class PricePast < ApplicationRecord
  belongs_to :stock

  validates :time, presence: true
end
