class CommentsController < ApplicationController
  def create
    if Supports::Comment.create_comment(comment_params)
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if is_comment_owner? and Supports::Comment.update_comment(comment_params)
      redirect_back(fallback_location: root_path)
    end        
  end

  def destroy
    if is_comment_owner? and Supports::Comment.delete_comment(comment_params)
      redirect_back(fallback_location: root_path)
    end    
  end

  private
  def comment_params
    params[:user_display_id] = current_user.display_id
    params.permit :user_display_id, :post_display_id, :content
  end

  def is_comment_owner?
    comment = Supports::Comment.get_comment comment_params
    return comment && (current_user.id == comment.user_id)
  end
end
