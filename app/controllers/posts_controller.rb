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
    @post = Supports::Post.get_post post_params
    if @post.nil?
      redirect_to not_found_index_path      
    end
  end

  def edit
    if is_post_owner?
      @stocks = Supports::Stock.get_stocks
    else
      redirect_to root_path
    end    
  end

  def update
    if is_post_owner?
      @post = Supports::Post.update_post(post_params)
      if @post.error_messages.empty?
        redirect_to post_path @post.display_id
      else
        @stocks = Supports::Stock.get_stocks
        render :edit
      end
    else
      redirect_to root_path
    end
  end

  private
  def post_params
    params[:target_price]      = params[:target_price].to_i
    params[:user_display_id]   = current_user.display_id if current_user
    params[:expert_display_id] = current_user.expert.display_id if current_user && current_user.expert?
    params.permit :stock_code, :title, :content, :target_price, :position, 
      :display_id, :user_display_id, :expert_display_id
  end

  def is_post_owner?
    @post = Supports::Post.get_post post_params
    return current_user.expert? && @post &&
      current_user.expert.display_id == @post.expert.display_id
  end
end
