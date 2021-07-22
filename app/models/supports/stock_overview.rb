class Supports::StockOverview
  attr_reader :revenue
  attr_reader :year_range
  attr_reader :eps
  attr_reader :volume
  attr_reader :market_cap
  attr_reader :dividend_yield
  attr_reader :average_vol_3m
  attr_reader :pe_ratio
  attr_reader :beta
  attr_reader :year_change
  attr_reader :shares_outstanding
  attr_reader :next_earnings_date

  def initialize attributes
    @revenue            = attributes[:revenue]
    @year_range         = attributes[:year_range]
    @eps                = attributes[:eps]
    @volume             = attributes[:volume]
    @market_cap         = attributes[:market_cap]
    @dividend_yield     = attributes[:dividend_yield]
    @average_vol_3m     = attributes[:average_vol_3m]
    @pe_ratio           = attributes[:pe_ratio]
    @beta               = attributes[:beta]
    @year_change        = attributes[:year_change]
    @shares_outstanding = attributes[:shares_outstanding]
    @next_earnings_date = attributes[:next_earnings_date].to_s(:day_month_year)
  end

  class << self
    def load_overview_info stock
      stock_overview = StockOverview.find_by(stock_id: stock.id)
      attributes = {}
      attributes[:revenue]                = stock_overview.revenue
      attributes[:year_range]             = stock_overview.year_range
      attributes[:eps]                    = stock_overview.eps
      attributes[:volume]                 = stock_overview.volume
      attributes[:market_cap]             = stock_overview.market_cap
      attributes[:dividend_yield]         = stock_overview.dividend_yield
      attributes[:average_vol_3m]         = stock_overview.average_vol_3m
      attributes[:pe_ratio]               = stock_overview.pe_ratio
      attributes[:beta]                   = stock_overview.beta
      attributes[:year_change]            = stock_overview.year_change
      attributes[:shares_outstanding]     = stock_overview.shares_outstanding
      attributes[:next_earnings_date]     = stock_overview.next_earnings_date

      Supports::StockOverview.new(attributes)
    end
  end
end
