class Supports::Comment < Supports::Application
  attr_reader :user
  attr_reader :id
  attr_reader :content
  attr_reader :updated_at
  attr_reader :commented

  def initialize attributes
    @user       = attributes[:user]
    @id         = attributes[:id]
    @content    = attributes[:content]
    @updated_at = attributes[:updated_at].to_s(:no_zone) if attributes[:updated_at]
    @commented  = attributes[:commented] || false
  end

  class << self
    def create_comment comment_params
      user = User.find_by(display_id: comment_params[:user_display_id]) || User.new
      post = Post.find_by(display_id: comment_params[:post_display_id]) || Post.new
      return Comment.create(user_id: user.id, post_id: post.id, content: comment_params[:content])
    end

    def update_comment comment_params
      user    = User.find_by(display_id: comment_params[:user_display_id]) || User.new
      post    = Post.find_by(display_id: comment_params[:post_display_id]) || Post.new
      comment = Comment.find_by(user_id: user.id, post_id: post.id)
      if comment.nil?
        return false
      else
        comment.content = comment_params[:content]
        return comment.save
      end
    end    

    def delete_comment comment_params
      user    = User.find_by(display_id: comment_params[:user_display_id]) || User.new
      post    = Post.find_by(display_id: comment_params[:post_display_id]) || Post.new
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
        sp_comments.push(self.convert_comment(current_user_id, comment))
      end
      sp_comments     
    end

    def convert_comment current_user_id=nil, comment
      comment_attr = {}
      if !(comment.nil? or comment.new_record?)
        comment_attr[:user]       = Supports::User.convert_user(comment.user)
        comment_attr[:content]    = comment.content
        comment_attr[:id]         = comment.id
        comment_attr[:updated_at] = comment.updated_at
        comment_attr[:commented]  = comment.user_id == current_user_id
      end
      self.new(comment_attr)
    end
  end
end
