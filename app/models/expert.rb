class Expert < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :users, :through => :follow_experts
end
