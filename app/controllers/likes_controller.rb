class LikesController < ApplicationController
  def create
    if Supports::Like.create_like(like_params)
      redirect_to post_path like_params[:post_display_id]
    end
  end

  def destroy
    if Supports::Like.delete_like(like_params)
      redirect_to post_path like_params[:post_display_id]
    end    
  end

  private
  def like_params
    params.permit :post_display_id, :user_display_id    
  end
end
