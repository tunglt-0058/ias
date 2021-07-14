class Supports::Comment
  attr_reader :user_id
  attr_reader :user_name
  attr_reader :user_avatar
  attr_reader :user_display_id
  attr_reader :id
  attr_reader :content
  attr_reader :commented
  attr_reader :updated_at

  def initialize attributes
    @user_id         = attributes[:user_id]
    @user_name       = attributes[:user_name]
    @user_avatar     = attributes[:user_avatar]
    @user_display_id = attributes[:user_display_id]
    @id              = attributes[:id]
    @content         = attributes[:content]
    @commented       = attributes[:commented]
    @updated_at      = attributes[:updated_at].to_s(:no_zone)
  end

  class << self
    def create_comment comment_params
      user = User.find_by(display_id: comment_params[:user_display_id]) || User.new
      post = Post.find_by(display_id: comment_params[:post_display_id]) || Post.new
      return Comment.create(user_id: user.id, post_id: post.id, content: comment_params[:content])
    end

    def update_comment comment_params
      user = User.find_by(display_id: comment_params[:user_display_id]) || User.new
      post = Post.find_by(display_id: comment_params[:post_display_id]) || Post.new
      comment = Comment.find_by(user_id: user.id, post_id: post.id)
      if comment.nil?
        return false
      else
        comment.content = comment_params[:content]
        return comment.save
      end
    end    

    def delete_comment comment_params
      user = User.find_by(display_id: comment_params[:user_display_id]) || User.new
      post = Post.find_by(display_id: comment_params[:post_display_id]) || Post.new
      comment = Comment.find_by(user_id: user.id, post_id: post.id)
      if comment.nil?
        return false
      else
        return comment.delete
      end
    end

    def convert_comments current_user_id=nil, comments
      sp_comments = []
      comments.each do |comment|
        comment_attr = {}
        comment_attr[:user_name]       = comment.user.name
        comment_attr[:user_avatar]     = comment.user.avatar
        comment_attr[:user_display_id] = comment.user.display_id
        comment_attr[:id]              = comment.id
        comment_attr[:content]         = comment.content
        comment_attr[:commented]       = comment.user_id == current_user_id
        comment_attr[:updated_at]      = comment.updated_at
        sp_comments.push(Supports::Comment.new(comment_attr))
      end
      sp_comments     
    end

    def get_comment comment_params
      user = User.find_by(display_id: comment_params[:user_display_id]) || User.new
      post = Post.find_by(display_id: comment_params[:post_display_id]) || Post.new
      comment = Comment.find_by(user_id: user.id, post_id: post.id) || Comment.new
      Supports::Comment.new({
        user_id:         user.id, 
        user_name:       user.name,
        user_avatar:     user.avatar,
        user_display_id: user.display_id,
        id:              comment.id,
        content:         comment.content,
        updated_at:      comment.updated_at
      })
    end
  end
end
