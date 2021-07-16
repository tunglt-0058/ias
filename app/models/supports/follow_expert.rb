class Supports::FollowExpert
  attr_reader :user_display_id
  attr_reader :expert_display_id
  attr_reader :followed

  def initialize attributes
    @user_display_id   = attributes[:user_display_id]
    @expert_display_id = attributes[:expert_display_id]
    @followed          = attributes[:followed]
  end

  class << self
    def create_follow_expert follow_expert_params
      user   = User.find_by(display_id: follow_expert_params[:user_display_id])
      expert = Expert.find_by(display_id: follow_expert_params[:expert_display_id])
      follow_expert = FollowExpert.find_by(user_id: user.id, expert_id: expert.id)
      if follow_expert.nil?
        return FollowExpert.create(user_id: user.id, expert_id: expert.id)
      else
        return false
      end
    end

    def delete_follow_expert follow_expert_params
      user   = User.find_by(display_id: follow_expert_params[:user_display_id])
      expert = Expert.find_by(display_id: follow_expert_params[:expert_display_id])      
      follow_expert = FollowExpert.find_by(user_id: user.id, expert_id: expert.id)
      if follow_expert.nil?
        return false
      else
        return follow_expert.delete
      end
    end

    def convert_follow_experts follow_experts
      sp_follow_experts = []
      follow_experts.each do |follow_expert|
        sp_follow_experts.push(self.convert_follow_expert(follow_expert))
      end
      sp_follow_experts
    end

    def convert_follow_expert current_user_id=nil, follow_expert
      attributes = {}
      attributes[:user_display_id]   = (follow_expert.user || User.new).display_id
      attributes[:expert_display_id] = (follow_expert.expert || Expert.new).display_id
      attributes[:followed]          = (follow_expert.user_id == current_user_id) && !follow_expert.user_id.nil?
      Supports::FollowExpert.new(attributes)
    end
  end
end
