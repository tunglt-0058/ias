class Supports::PricePast
  attr_reader :time
  attr_reader :price

  def initialize attributes
    @time  = attributes[:time].to_s(:month_and_year)
    @price = attributes[:price]
  end

  class << self
    def convert_price_pasts price_pasts
      sp_price_pasts = []
      price_pasts.each do |price_past|
        price_past_attr = {}
        price_past_attr[:time]  = price_past.time
        price_past_attr[:price] = price_past.price
        sp_price_pasts.push(Supports::PricePast.new(price_past_attr))
      end
      sp_price_pasts
    end
  end
end
