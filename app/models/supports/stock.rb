class Supports::Stock
  attr_reader :code
  attr_reader :company_name
  attr_reader :option_display_id

  def initialize attributes
    @code              = attributes[:code]
    @company_name      = attributes[:company_name]
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
  end  
end
