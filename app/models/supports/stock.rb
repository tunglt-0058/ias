class Supports::Stock
  attr_reader :display_id
  attr_reader :company_name
  attr_reader :code
  attr_reader :exchange_name
  attr_reader :sector
  attr_reader :industry
  attr_reader :price_pasts
  attr_reader :option_display_id

  def initialize attributes
    @display_id        = attributes[:display_id]
    @company_name      = attributes[:company_name]
    @code              = attributes[:code]
    @exchange_name     = attributes[:exchange_name]
    @sector            = attributes[:sector]
    @industry          = attributes[:industry]
    @price_pasts       = attributes[:price_pasts]
    @option_display_id = attributes[:option_display_id]
  end

  class << self
    def get_stocks
      all_stocks = Stock.all.order(code: :asc)
      stocks = []
      all_stocks.each do |stock|
        stock_attr = {}
        stock_attr[:code]              = stock.code
        stock_attr[:company_name]      = stock.company_name
        stock_attr[:option_display_id] = stock.code + " | " + stock.company_name
        stocks.push(Supports::Stock.new(stock_attr))
      end      
      stocks
    end

    def convert_stocks stocks
      sp_stocks = []
      stocks.each do |stock|
        sp_stocks.push(self.convert_stock(stock))
      end
      sp_stocks
    end

    def convert_stock stock
      attributes = {}
      attributes[:display_id]    = stock.display_id
      attributes[:company_name]  = stock.company_name
      attributes[:code]          = stock.code
      attributes[:exchange_name] = stock.exchange_name
      attributes[:sector]        = stock.sector.name
      attributes[:industry]      = stock.industry.name
      Supports::Stock.new(attributes)
    end
  end
end
