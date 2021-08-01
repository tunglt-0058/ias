class VotesController < ApplicationController
  def create
    if can_votes? and Supports::Vote.create_or_update_vote(vote_params)
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path
    end
  end

  private
  def vote_params
    params[:user_display_id] = current_user.display_id    
    params[:vote]            = params[:vote].to_i if params[:vote]
    params.permit :user_display_id, :stock_display_id, :vote
  end

  def can_votes?
    return current_user.user?
  end
end
