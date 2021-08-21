class Supports::FollowStock < Supports::Application
  attr_reader :stock_display_id
  attr_reader :user_display_id

  def initialize attributes
    @stock_display_id  = attributes[:stock_display_id]
    @user_display_id   = attributes[:user_display_id]
  end

  class << self
    def create_follow_stock follow_stock_params
      user          = User.find_by(display_id: follow_stock_params[:user_display_id]) || User.new
      stock         = Stock.find_by(display_id: follow_stock_params[:stock_display_id]) || Stock.new
      follow_stock  = FollowStock.find_by(user_id: user.id, stock_id: stock.id)
      if follow_stock.nil?
        return FollowStock.create(user_id: user.id, stock_id: stock.id)
      else
        return false
      end
    end

    def delete_follow_stock follow_stock_params
      user          = User.find_by(display_id: follow_stock_params[:user_display_id]) || User.new
      stock         = Stock.find_by(display_id: follow_stock_params[:stock_display_id]) || Stock.new
      follow_stock  = FollowStock.find_by(user_id: user.id, stock_id: stock.id)
      if follow_stock.nil?
        return false
      else
        return follow_stock.delete
      end
    end

    def convert_follow_stocks current_user_id=nil, follow_stocks
      sp_follow_stocks = []
      follow_stocks.each do |follow_stock|
        sp_follow_stocks.push(self.convert_follow_stock(current_user_id, follow_stock))
      end
      sp_follow_stocks
    end

    def convert_follow_stock current_user_id=nil, follow_stock
      attributes = {}
      if !(follow_stock.nil? or follow_stock.new_record?)
        attributes[:stock_display_id]  = follow_stock.stock.display_id
        attributes[:user_display_id]   = follow_stock.user.display_id
      end
      self.new(attributes)
    end
  end
end
