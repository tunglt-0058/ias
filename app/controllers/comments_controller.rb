class CommentsController < ApplicationController
  def create
    if Supports::Comment.create_comment(comment_params)
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if Supports::Comment.update_comment(comment_params)
      redirect_back(fallback_location: root_path)
    end        
  end

  def destroy
    if Supports::Comment.delete_comment(comment_params)
      redirect_back(fallback_location: root_path)
    end    
  end

  private
  def comment_params
    params[:user_display_id] = current_user.display_id
    params.permit :user_display_id, :post_display_id, :content
  end
end
