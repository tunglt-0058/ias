class Supports::Stock < Supports::Application
  attr_reader :sector
  attr_reader :industry
  attr_reader :stock_overview
  attr_reader :price_pasts
  attr_reader :display_id
  attr_reader :code
  attr_reader :company_name
  attr_reader :exchange_name
  attr_reader :current_price
  attr_reader :lowest_price
  attr_reader :average_price
  attr_reader :highest_price
  attr_reader :option_display_id
  attr_reader :related_stocks
  attr_reader :analyst_consensus
  attr_reader :positions
  attr_reader :number_of_posts

  def initialize attributes
    @sector            = attributes[:sector]
    @industry          = attributes[:industry]
    @stock_overview    = attributes[:stock_overview]
    @price_pasts       = attributes[:price_pasts]
    @display_id        = attributes[:display_id]
    @code              = attributes[:code]
    @company_name      = attributes[:company_name]
    @exchange_name     = attributes[:exchange_name]
    @current_price     = attributes[:current_price]
    @lowest_price      = attributes[:lowest_price]
    @average_price     = attributes[:average_price]
    @highest_price     = attributes[:highest_price]
    @option_display_id = attributes[:option_display_id]
    @related_stocks    = attributes[:related_stocks]
    @analyst_consensus = attributes[:analyst_consensus]
    @positions         = attributes[:positions]
    @number_of_posts   = attributes[:number_of_posts]
  end

  class << self
    def get_stock code
      stock = Stock.find_by_display_id(code.upcase)
      if !stock.nil?
        attributes = {}
        stock_overview  = stock.stock_overview
        price_pasts     = stock.price_pasts.order(time: :asc).last(Settings.post_price_pasts_size)
        price_pasts     = price_pasts.push(PricePast.new({time: price_pasts.last.time.since(1.years), price: 0}))
        related_stocks  = Stock.includes(:sector, :industry, :posts).where(sector_id: stock.sector_id, industry_id: stock.industry_id)
        positions       = [stock.posts.buy.size, stock.posts.hold.size, stock.posts.sell.size]
        attributes[:sector]            = stock.sector.name
        attributes[:industry]          = stock.industry.name
        attributes[:stock_overview]    = Supports::StockOverview.convert_stock_overview(stock_overview)
        attributes[:price_pasts]       = Supports::PricePast.convert_price_pasts(price_pasts)
        attributes[:display_id]        = stock.display_id
        attributes[:code]              = stock.code
        attributes[:company_name]      = stock.company_name
        attributes[:exchange_name]     = stock.exchange_name
        attributes[:current_price]     = stock.current_price
        attributes[:lowest_price]      = stock.lowest_forecast_price
        attributes[:average_price]     = stock.average_forecast_price
        attributes[:highest_price]     = stock.highest_forecast_price
        attributes[:related_stocks]    = self.convert_stocks(related_stocks)
        attributes[:analyst_consensus] = self.caculate_analyst_consensus(stock)
        attributes[:positions]         = positions
        self.new(attributes)
      else
        nil
      end
    end

    def get_stocks params=nil
      stocks = []
      if params.nil?
        all_stocks = Stock.includes(:posts, :sector, :industry).order(code: :asc)
        stocks     = self.convert_stocks(all_stocks)
      else
        all_stocks = Stock.includes(:posts, :sector, :industry).paginate(page: params[:page], per_page: Settings.page_stocks_size)
        stocks     = object_paginate(all_stocks)
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
      if !(stock.nil? or stock.new_record?)
        attributes[:sector]            = stock.sector.name
        attributes[:industry]          = stock.industry.name
        attributes[:display_id]        = stock.display_id
        attributes[:company_name]      = stock.company_name
        attributes[:code]              = stock.code
        attributes[:exchange_name]     = stock.exchange_name
        attributes[:current_price]     = stock.current_price
        attributes[:lowest_price]      = stock.lowest_forecast_price
        attributes[:average_price]     = stock.average_forecast_price
        attributes[:highest_price]     = stock.highest_forecast_price
        attributes[:analyst_consensus] = self.caculate_analyst_consensus(stock)
        attributes[:option_display_id] = "#{stock.code} | #{stock.company_name}"
        attributes[:number_of_posts]   = stock.posts.size
      end
      self.new(attributes)
    end

    def caculate_forecast_price stock
      posts           = stock.posts
      post_prices     = posts.pluck(:target_price)
      forecast_prices = {}
      forecast_prices[:lowest_price]  = post_prices.min
      forecast_prices[:highest_price] = post_prices.max
      sum_price = 0
      sum_score = 0
      posts.each do |post|
        sum_price += post.target_price * post.expert.score
        sum_score += post.expert.score
      end
      if sum_score == 0
        forecast_prices[:average_price] = stock.current_price
      else
        forecast_prices[:average_price] = sum_price / sum_score
      end
      forecast_prices
    end

    private
    def caculate_analyst_consensus stock
      current_price = stock.current_price
      average_price = stock.average_forecast_price || current_price
      lower_limit_price = current_price*0.99
      upper_limit_price = current_price*1.01
      if average_price > upper_limit_price
        self::POSITIONS[:buy]
      elsif average_price < lower_limit_price
        self::POSITIONS[:sell]
      else
        self::POSITIONS[:hold]
      end
    end
  end
end
