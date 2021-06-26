class Sector < ApplicationRecord
  has_many :stocks

  before_save :to_display_id
  def to_param
    display_id
  end

  private
  def to_display_id
    self.display_id = self.name.parameterize.truncate(50, omission: "")
  end
end
