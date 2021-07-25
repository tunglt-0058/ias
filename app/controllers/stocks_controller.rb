class StocksController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @stocks = Supports::Stock.get_stocks(params)
  end

  def show
    @stock = Supports::Stock.get_stock(params[:display_id])
    if @stock.nil?
      redirect_to not_found_index_path
    end
  end
end
