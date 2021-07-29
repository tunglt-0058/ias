class Supports::FollowExpert < Supports::Application
  attr_reader :expert_display_id
  attr_reader :user_display_id

  def initialize attributes
    @expert_display_id = attributes[:expert_display_id]
    @user_display_id   = attributes[:user_display_id]
  end

  class << self
    def create_follow_expert follow_expert_params
      user          = User.find_by(display_id: follow_expert_params[:user_display_id]) || User.new
      expert        = Expert.find_by(display_id: follow_expert_params[:expert_display_id]) || Expert.new
      follow_expert = FollowExpert.find_by(user_id: user.id, expert_id: expert.id)
      if follow_expert.nil?
        return FollowExpert.create(user_id: user.id, expert_id: expert.id)
      else
        return false
      end
    end

    def delete_follow_expert follow_expert_params
      user          = User.find_by(display_id: follow_expert_params[:user_display_id]) || User.new
      expert        = Expert.find_by(display_id: follow_expert_params[:expert_display_id]) || Expert.new
      follow_expert = FollowExpert.find_by(user_id: user.id, expert_id: expert.id)
      if follow_expert.nil?
        return false
      else
        return follow_expert.delete
      end
    end

    def convert_follow_experts current_user_id=nil, follow_experts
      sp_follow_experts = []
      follow_experts.each do |follow_expert|
        sp_follow_experts.push(self.convert_follow_expert(current_user_id, follow_expert))
      end
      sp_follow_experts
    end

    def convert_follow_expert current_user_id=nil, follow_expert
      attributes = {}
      if !(follow_expert.nil? or follow_expert.new_record?)
        attributes[:expert_display_id] = follow_expert.expert.display_id
        attributes[:user_display_id]   = follow_expert.user.display_id
      end
      self.new(attributes)
    end
  end
end
