class Supports::PricePast
  attr_reader :time
  attr_reader :price

  def initialize attributes
    @time  = attributes[:time]
    @price = attributes[:price]
  end
end
