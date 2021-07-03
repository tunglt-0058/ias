class PostsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @newest_posts = Supports::Post.list_newest_posts
    @popular_posts = Supports::Post.list_popular_posts
  end

  def show
    @post = Supports::Post.get_post params[:display_id]
  end
end
