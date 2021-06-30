class PostsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @posts = Post.paginate(page: params[:page], per_page: Settings.page_posts_size).order(id: :asc)
  end
end
