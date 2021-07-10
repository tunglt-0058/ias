class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @newest_posts = Supports::Post.list_newest_posts
    @popular_posts = Supports::Post.list_popular_posts
  end

  def new
    if current_user.expert?
      @post = Supports::Post.new({})
      @stocks = Supports::Stock.get_stocks
    else
      redirect_to root_path
    end
  end

  def create
    if current_user.expert?
      @post = Supports::Post.create_post(post_params)
      if @post.error_messages.empty?
        redirect_to post_path @post.display_id
      else
        @stocks = Supports::Stock.get_stocks
        render :new
      end
    else
      redirect_to root_path
    end
  end

  def show
    @post = Supports::Post.get_post params[:display_id]
  end

  private
  def post_params
    params[:target_price] = params[:target_price].to_i
    params[:expert_id]    = current_user.expert.id
    params.permit :stock_code, :title, :content, :target_price, :position, :expert_id
  end  
end
