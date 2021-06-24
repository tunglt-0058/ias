class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :load_top_experts, only: :show

  def show
    if valid_page?
      render "static_pages/#{params[:page]}"
    else
      render file: "public/404.html", status: :not_found
    end
  end

  private
  def load_top_experts
    @top_experts = Expert.limit(Settings.top_experts_size).order(score: :asc)
    @experts_count = Expert.count
  end

  def valid_page?
    File.exist? Pathname.new(Rails.root +
      "app/views/static_pages/#{params[:page]}.html.erb")
  end
end
