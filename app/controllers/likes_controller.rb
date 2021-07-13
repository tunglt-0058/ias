class LikesController < ApplicationController
  def create
    if Supports::Like.create_like(like_params)
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if Supports::Like.delete_like(like_params)
      redirect_back(fallback_location: root_path)
    end    
  end

  private
  def like_params
    params.permit :post_display_id, :user_display_id    
  end
end
