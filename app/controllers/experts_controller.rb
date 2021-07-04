class ExpertsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @experts = Expert.paginate(page: params[:page], per_page: Settings.page_experts_size).order(score: :asc)
  end

  def show
  	@expert = Expert.find(params[:display_id])
  end
end
