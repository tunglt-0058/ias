class Supports::Comment
  attr_reader :user_name
  attr_reader :user_avatar
  attr_reader :user_display_id
  attr_reader :content
  attr_reader :updated_at

  def initialize attributes
    @user_name       = attributes[:user_name]
    @user_avatar     = attributes[:user_avatar]
    @user_display_id = attributes[:user_display_id]
    @content         = attributes[:content]
    @updated_at      = attributes[:updated_at]
  end
end
