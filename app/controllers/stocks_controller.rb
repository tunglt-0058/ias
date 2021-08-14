class StocksController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @stocks = Supports::Stock.get_stocks(params)
  end

  def show
    if current_user.nil?
      current_user_id = nil
    else
      current_user_id = current_user.id
    end
    @stock = Supports::Stock.get_stock(current_user_id, params[:display_id])
    if @stock.nil?
      redirect_to not_found_index_path
    end
  end
end
