class Supports::Post
  attr_reader :stock_display_id
  attr_reader :stock_company_name
  attr_reader :stock_code
  attr_reader :stock_exchange_name
  attr_reader :stock_sector
  attr_reader :stock_industry
  attr_reader :expert_id
  attr_reader :expert_name
  attr_reader :expert_avatar
  attr_reader :expert_follow_num
  attr_reader :display_id
  attr_reader :title
  attr_reader :content
  attr_reader :target_price
  attr_reader :position
  attr_reader :like_number
  attr_reader :comment_number
  attr_reader :updated_at
  attr_reader :comments
  attr_reader :price_pasts
  attr_reader :error_messages
  attr_reader :positions

  STR_POSITION = {buy: "MUA", hold: "GIỮ", sell: "BÁN"}

  def initialize attributes
    @stock_display_id    = attributes[:stock_display_id]
    @stock_company_name  = attributes[:stock_company_name]
    @stock_code          = attributes[:stock_code]
    @stock_exchange_name = attributes[:stock_exchange_name]
    @stock_sector        = attributes[:stock_sector]
    @stock_industry      = attributes[:stock_industry]
    @expert_id           = attributes[:expert_id]
    @expert_name         = attributes[:expert_name]
    @expert_avatar       = attributes[:expert_avatar]
    @expert_follow_num   = attributes[:expert_follow_num]
    @display_id          = attributes[:display_id]
    @title               = attributes[:title]
    @content             = attributes[:content]
    @target_price        = attributes[:target_price]
    @like_number         = attributes[:like_number]
    @comment_number      = attributes[:comment_number]
    @updated_at          = attributes[:updated_at]
    @comments            = attributes[:comments]
    @price_pasts         = attributes[:price_pasts]
    @position            = (attributes[:position] || "buy").to_sym
    @positions           = STR_POSITION
    @error_messages      = attributes[:error_messages] || []
  end

  class << self
    def get_post display_id
      post   = Post.includes(:comments).find_by(display_id: display_id)
      stock  = post.stock
      expert = post.expert
      attributes = {}
      attributes[:stock_display_id]    = stock.display_id
      attributes[:stock_company_name]  = stock.company_name
      attributes[:stock_code]          = stock.code
      attributes[:stock_exchange_name] = stock.exchange_name
      attributes[:stock_sector]        = stock.sector.name
      attributes[:stock_industry]      = stock.industry.name
      attributes[:expert_id]           = expert.id
      attributes[:expert_name]         = expert.user.name
      attributes[:expert_avatar]       = expert.user.avatar
      attributes[:expert_follow_num]   = expert.users.size
      attributes[:display_id]          = post.display_id
      attributes[:title]               = post.title
      attributes[:content]             = post.content
      attributes[:target_price]        = post.target_price
      attributes[:position]            = post.position
      attributes[:like_number]         = post.likes.size
      attributes[:comment_number]      = post.comments.size
      attributes[:updated_at]          = post.updated_at
      attributes[:comments]            = []
      attributes[:price_pasts]         = []
      post.comments.each do |comment|
        comment_attr = {}
        comment_attr[:user_name]       = comment.user.name
        comment_attr[:user_avatar]     = comment.user.avatar
        comment_attr[:user_display_id] = comment.user.display_id
        comment_attr[:content]         = comment.content
        comment_attr[:updated_at]      = comment.updated_at
        attributes[:comments].push(Supports::Comment.new(comment_attr))
      end
      stock.price_pasts
        .order(time: :asc)
        .last(Settings.post_price_pasts_size).each do |price_past|
        price_past_attr = {}
        price_past_attr[:time]  = price_past.time.to_s(:month_and_year)
        price_past_attr[:price] = price_past.price
        attributes[:price_pasts].push(Supports::PricePast.new(price_past_attr))
      end
      attributes[:price_pasts].push(Supports::PricePast.new({
        time: post.target_time.to_s(:month_and_year),
        price: post.target_price
      }))
      Supports::Post.new(attributes)
    end

    def create_post post_params
      stock = Stock.find_by(code: post_params[:stock_code]) || Stock.new
      post  = Post.create({
        stock_id:     stock.id,
        expert_id:    post_params[:expert_id],
        title:        post_params[:title],
        content:      post_params[:content],
        position:     post_params[:position],
        target_price: post_params[:target_price]
      })
      Supports::Post.new({
        stock_code:     stock.code,
        position:       post.position,
        title:          post.title,
        content:        post.content,
        target_price:   post.target_price,
        display_id:     post.display_id,
        error_messages: post.errors.full_messages
      })
    end

    def update_post post_params
      stock = Stock.find_by(code: post_params[:stock_code]) || Stock.new
      post  = Post.find_by(display_id: post_params[:display_id])
      if post.title != post_params[:title]
        post.title = post_params[:title]
        post.caculate_display_id
      end
      post.stock_id     = stock.id
      post.expert_id    = post_params[:expert_id]
      post.title        = post_params[:title]
      post.title        = post_params[:title]
      post.content      = post_params[:content]
      post.position     = post_params[:position]
      post.target_price = post_params[:target_price]
      post.save
      Supports::Post.new({
        stock_code:     stock.code,
        position:       post.position,
        title:          post.title,
        content:        post.content,
        target_price:   post.target_price,
        display_id:     post.display_id,
        error_messages: post.errors.full_messages
      })      
    end

    def list_newest_posts
      posts = Post.includes(:stock, [expert: :user], :comments, :likes)
        .limit(Settings.newest_posts_size)
        .order(updated_at: :desc)
      newest_posts = []
      posts.each do |post|
        stock  = post.stock
        expert = post.expert.user
        attributes = {}
        attributes[:stock_display_id]   = stock.display_id
        attributes[:stock_company_name] = stock.company_name
        attributes[:expert_name]        = expert.name
        attributes[:expert_avatar]      = expert.avatar
        attributes[:display_id]         = post.display_id
        attributes[:title]              = post.title
        attributes[:like_number]        = post.likes.size
        attributes[:comment_number]     = post.comments.size
        attributes[:updated_at]         = post.updated_at
        newest_posts.push(Supports::Post.new(attributes))
      end
      newest_posts
    end

    def list_popular_posts
      posts = Post.includes(:stock, [expert: :user], :comments, :likes)
        .left_joins(:comments, :likes)
        .group(:id)
        .order("COUNT(comments.id) DESC").order("COUNT(likes.id) DESC")
        .limit(Settings.popular_posts_size)
      popular_posts = []
      posts.each do |post|
        stock  = post.stock
        expert = post.expert.user
        attributes = {}
        attributes[:stock_display_id]   = stock.display_id
        attributes[:stock_company_name] = stock.company_name
        attributes[:expert_name]        = expert.name
        attributes[:expert_avatar]      = expert.avatar
        attributes[:display_id]         = post.display_id
        attributes[:title]              = post.title
        attributes[:like_number]        = post.likes.size
        attributes[:comment_number]     = post.comments.size
        attributes[:updated_at]         = post.updated_at
        popular_posts.push(Supports::Post.new(attributes))
      end
      popular_posts
    end
  end
end
