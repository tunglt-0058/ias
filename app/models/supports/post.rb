class Supports::Post < Supports::Application
  attr_reader :stock
  attr_reader :expert
  attr_reader :comments
  attr_reader :likes
  attr_reader :display_id
  attr_reader :title
  attr_reader :content
  attr_reader :target_price
  attr_reader :position
  attr_reader :updated_at
  attr_reader :user
  attr_reader :like
  attr_reader :error_messages
  attr_reader :positions

  def initialize attributes
    @stock          = attributes[:stock] || Supports::Stock.new({})
    @expert         = attributes[:expert]
    @comments       = attributes[:comments]
    @likes          = attributes[:likes]
    @display_id     = attributes[:display_id]
    @title          = attributes[:title]
    @content        = attributes[:content]
    @target_price   = attributes[:target_price]
    @position       = (attributes[:position] || "buy").to_sym
    @updated_at     = attributes[:updated_at].to_s(:no_zone) if attributes[:updated_at]
    @user           = attributes[:user]
    @like           = attributes[:like]
    @error_messages = attributes[:error_messages] || []
    @positions      = POSITIONS
  end

  class << self
    def get_post post_params
      post = Post.includes(:comments).find_by(display_id: post_params[:display_id])
      if !post.nil?
        attributes   = {}
        stock_attrs  = {}
        stock        = post.stock
        expert       = post.expert
        comments     = post.comments.includes(:user).order(updated_at: :desc)
        likes        = post.likes.includes(:user, :post)
        current_user = User.find_by(display_id: post_params[:user_display_id]) || User.new
        like         = post.likes.find_by(user_id: current_user.id)
        price_pasts  = stock.price_pasts.order(time: :asc).last(Settings.post_price_pasts_size)
        price_pasts  = price_pasts.push(PricePast.new({time: post.target_time, price: post.target_price}))
        stock_attrs[:display_id]    = stock.display_id
        stock_attrs[:company_name]  = stock.company_name
        stock_attrs[:code]          = stock.code
        stock_attrs[:exchange_name] = stock.exchange_name
        stock_attrs[:sector]        = stock.sector.name
        stock_attrs[:industry]      = stock.industry.name
        stock_attrs[:price_pasts]   = Supports::PricePast.convert_price_pasts(price_pasts)
        attributes[:stock]        = Supports::Stock.new(stock_attrs)
        attributes[:expert]       = Supports::Expert.convert_expert(current_user.id, expert)
        attributes[:comments]     = Supports::Comment.convert_comments(current_user.id, comments)
        attributes[:likes]        = Supports::Like.convert_likes(likes)
        attributes[:display_id]   = post.display_id
        attributes[:title]        = post.title
        attributes[:content]      = post.content
        attributes[:target_price] = post.target_price
        attributes[:position]     = post.position
        attributes[:updated_at]   = post.updated_at
        attributes[:user]         = Supports::User.convert_user(current_user)
        attributes[:like]         = Supports::Like.convert_like(current_user.id, like)
        self.new(attributes)
      else
        nil
      end
    end

    def create_post post_params
      stock  = Stock.find_by(code: post_params[:stock_code]) || Stock.new
      expert = Expert.find_by(display_id: post_params[:expert_display_id]) || Expert.new
      post   = Post.create({
        stock_id:     stock.id,
        expert_id:    expert.id,
        title:        post_params[:title],
        content:      post_params[:content],
        position:     post_params[:position],
        target_price: post_params[:target_price]
      })
      if post.errors.empty?
        forecast_prices = Supports::Stock.caculate_forecast_price(stock)
        stock.lowest_forecast_price  = forecast_prices[:lowest_price]
        stock.average_forecast_price = forecast_prices[:average_price]
        stock.highest_forecast_price = forecast_prices[:highest_price]
        stock.save
      end
      self.new({
        stock:          Supports::Stock.convert_stock(stock),
        position:       post.position,
        title:          post.title,
        content:        post.content,
        target_price:   post.target_price,
        display_id:     post.display_id,
        error_messages: post.errors.full_messages
      })
    end

    def update_post post_params
      stock  = Stock.find_by(code: post_params[:stock_code]) || Stock.new
      expert = Expert.find_by(display_id: post_params[:expert_display_id]) || Expert.new
      post   = Post.find_by(display_id: post_params[:display_id])
      if !(post.title == post_params[:title] || post_params[:title].nil? || post_params[:title].empty?)
        post.title = post_params[:title]
        post.caculate_display_id
      end
      post.stock_id     = stock.id
      post.expert_id    = expert.id
      post.title        = post_params[:title]
      post.content      = post_params[:content]
      post.position     = post_params[:position]
      post.target_price = post_params[:target_price]
      post.save
      if post.errors.empty?
        forecast_prices = Supports::Stock.caculate_forecast_price(stock)
        stock.lowest_forecast_price  = forecast_prices[:lowest_price]
        stock.average_forecast_price = forecast_prices[:average_price]
        stock.highest_forecast_price = forecast_prices[:highest_price]
        stock.save
      end      
      self.new({
        stock:          Supports::Stock.convert_stock(stock),
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
        .order(created_at: :desc)
      self.convert_posts(posts)
    end

    def list_popular_posts
      posts = Post.includes(:stock, [expert: :user], :comments, :likes)
        .left_joins(:comments)
        .group(:id)
        .order("COUNT(comments.id) DESC")
        .limit(Settings.popular_posts_size)
      popular_posts = self.convert_posts(posts)
      popular_posts.sort_by{|p| [p.comments.size, p.likes.size]}.reverse
    end

    def convert_posts posts
      sp_posts = []
      posts.each do |post|
        sp_posts.push(self.convert_post(post))
      end
      sp_posts      
    end

    def convert_post post
      attributes = {}
      comments = post.comments.includes(:user)
      likes    = post.likes.includes(:user, :post)        
      attributes[:stock]      = Supports::Stock.convert_stock(post.stock)
      attributes[:expert]     = Supports::Expert.convert_expert(post.expert)
      attributes[:comments]   = Supports::Comment.convert_comments(comments)
      attributes[:likes]      = Supports::Like.convert_likes(likes)
      attributes[:display_id] = post.display_id
      attributes[:title]      = post.title
      attributes[:updated_at] = post.updated_at
      self.new(attributes)
    end
  end
end
