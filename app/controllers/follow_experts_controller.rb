class FollowExpertsController < ApplicationController
  def create
    if can_follow? and Supports::FollowExpert.create_follow_expert(follow_expert_params)
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if can_follow? and Supports::FollowExpert.delete_follow_expert(follow_expert_params)
      redirect_back(fallback_location: root_path)
    end    
  end

  private
  def follow_expert_params
    params.permit :user_display_id, :expert_display_id
  end

  def can_follow?
    current_user and current_user.user?
  end
end
