class Supports::Search < Supports::Application
  attr_reader :stocks
  attr_reader :posts
  attr_reader :experts

  def initialize attributes
    @stocks  = attributes[:stocks]
    @posts   = attributes[:posts]
    @experts = attributes[:experts]
  end

  class << self
    def search params
      search      = params[:search]
      stock_page  = params[:stock_page] || 1
      post_page   = params[:post_page] || 1
      expert_page = params[:expert_page] || 1
      if !search.nil? and !search.empty?
        stocks  = Stock.includes(:posts, :sector, :industry)
                    .where("code LIKE ? OR company_name LIKE ?", "%#{search}%", "%#{search}%")
                    .paginate(page: stock_page, per_page: Settings.search_stock_size)
        posts   = Post.includes(:comments, :likes, :expert, :stock)
                    .where("title LIKE ?", "%#{search}%")
                    .paginate(page: post_page, per_page: Settings.search_post_size)
        experts = User.includes(expert: [:follow_experts]).expert
                    .where("name LIKE ?", "%#{search}%")
                    .paginate(page: expert_page, per_page: Settings.search_expert_size)
        sp_stocks  = object_paginate(stocks)
        sp_posts   = object_paginate(posts)
        sp_experts = object_paginate(experts)
        self.new({
          stocks:  sp_stocks,
          posts:   sp_posts,
          experts: sp_experts,
        })
      else
        self.new({
          stocks:  object_paginate([]),
          posts:   object_paginate([]),
          experts: object_paginate([]),
        })
      end
    end
  end
end
