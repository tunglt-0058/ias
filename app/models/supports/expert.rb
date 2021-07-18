class Supports::Expert
  attr_reader :display_id
  attr_reader :expert_name
  attr_reader :expert_avatar
  attr_reader :follow_experts
  attr_reader :follow_expert

  def initialize attributes
    @display_id     = attributes[:display_id]
    @code           = attributes[:code]
    @expert_name    = attributes[:expert_name]
    @expert_avatar  = attributes[:expert_avatar]
    @follow_experts = attributes[:follow_experts]
    @follow_expert  = attributes[:follow_expert]
  end

  class << self
    def get_stocks
      all_stocks = Stock.all.order(code: :asc)
      stocks = []
      all_stocks.each do |stock|
        stock_attr = {}
        stock_attr[:code]              = stock.code
        stock_attr[:company_name]      = stock.company_name
        stock_attr[:option_display_id] = stock.code + " | " + stock.company_name
        stocks.push(Supports::Stock.new(stock_attr))
      end      
      stocks
    end

    def convert_expert expert
      attributes = {}
      attributes[:display_id]     = expert.display_id
      attributes[:expert_name]    = expert.user.name
      attributes[:follow_experts] = Supports::FollowExpert.convert_follow_experts(expert.follow_experts)
      Supports::Expert.new(attributes)
    end
  end
end
