class Supports::Like
  attr_reader :user_display_id
  attr_reader :post_display_id
  attr_reader :liked

  def initialize attributes
    @user_display_id = attributes[:user_display_id]
    @post_display_id = attributes[:post_display_id]
    @liked           = attributes[:liked]
  end

  class << self
    def create_like like_params
      user = User.find_by(display_id: like_params[:user_display_id]) || User.new
      post = Post.find_by(display_id: like_params[:post_display_id]) || Post.new
      like = Like.find_by(user_id: user.id, post_id: post.id)
      if like.nil?
        return Like.create(user_id: user.id, post_id: post.id)
      else
        return false
      end
    end

    def delete_like like_params
      user = User.find_by(display_id: like_params[:user_display_id]) || User.new
      post = Post.find_by(display_id: like_params[:post_display_id]) || Post.new
      like = Like.find_by(user_id: user.id, post_id: post.id)
      if like.nil?
        return false
      else
        return like.delete
      end
    end

    def convert_likes current_user_id=nil, likes
      sp_likes = []
      likes.each do |like|
        attributes = {}
        attributes[:user_display_id] = like.user.display_id
        attributes[:post_display_id] = like.post.display_id
        sp_likes.push(Supports::Like.new(attributes))
      end
      sp_likes
    end

    def convert_like current_user_id=nil, like
      attributes = {}
      attributes[:user_display_id] = (like.user || User.new).display_id
      attributes[:post_display_id] = (like.post || Post.new).display_id
      attributes[:liked]           = (like.user_id == current_user_id) && !like.user_id.nil?
      Supports::Like.new(attributes)
    end
  end
end
