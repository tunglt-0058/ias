class Supports::Expert < Supports::Application
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
    def convert_expert expert
      attributes = {}
      attributes[:display_id]     = expert.display_id
      attributes[:expert_name]    = expert.user.name
      attributes[:follow_experts] = Supports::FollowExpert.convert_follow_experts(expert.follow_experts)
      self.new(attributes)
    end
  end
end
