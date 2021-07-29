class Supports::Expert < Supports::Application
  attr_reader :follow_experts
  attr_reader :display_id
  attr_reader :expert_avatar
  attr_reader :expert_name
  attr_reader :followed

  def initialize attributes
    @follow_experts = attributes[:follow_experts]
    @display_id     = attributes[:display_id]
    @expert_avatar  = attributes[:expert_avatar]
    @expert_name    = attributes[:expert_name]
    @followed       = attributes[:followed] || false
  end

  class << self
    def convert_expert current_user_id=nil, expert
      attributes = {}
      if !(expert.nil? or expert.new_record?)
        attributes[:follow_experts] = Supports::FollowExpert.convert_follow_experts(expert.follow_experts.includes(:user, :expert))
        attributes[:display_id]     = expert.display_id
        attributes[:expert_avatar]  = expert.user.avatar
        attributes[:expert_name]    = expert.user.name
        attributes[:followed]       = !expert.follow_experts.find_by(user_id: current_user_id).nil?
      end
      self.new(attributes)
    end
  end
end
