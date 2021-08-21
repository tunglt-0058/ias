class FollowStocksController < ApplicationController
  def create
    Supports::FollowStock.create_follow_stock(follow_stock_params)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    Supports::FollowStock.delete_follow_stock(follow_stock_params)
    redirect_back(fallback_location: root_path)
  end

  private
  def follow_stock_params
    params[:user_display_id] = current_user.display_id
    params.permit :user_display_id, :stock_display_id
  end
end
