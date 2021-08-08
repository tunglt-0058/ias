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
    def caculate_expert expert_ids
      experts = Expert.find(expert_ids)
      experts.each do |expert|
        self.caculate_rate_of_expert(expert)
      end
    end

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

    private
    def div_with_round x, y
      if y == 0
        return 0
      else
        return (x.to_f / y).round(2)
      end
    end

    def caculate_rate_of_expert expert
      if !(expert.nil? or expert.new_record?)
        posts     = expert.posts
        posts_num = posts.size

        # Caculate success rate
        hitted_posts_num = posts.where(hit: true).size
        expert.success_rate = self.div_with_round(hitted_posts_num, posts_num)

        # Caculate average return
        total_return = 0
        posts.each do |post|
          hit           = [false, true].index(post.hit)
          current_price = post.stock.current_price
          total_return += ((post.target_price - current_price).abs.to_f / current_price) * hit * 100
        end
        expert.average_return = self.div_with_round(total_return, posts_num)

        # Caculate score
        total_score = 0
        posts.each do |post|
          hit  = [false, true].index(post.hit)
          time = (Time.now - post.created_at) / 86400
          total_score += 10 * (1 - time / 365) * hit
        end
        expert.score = total_score

        # Save
        return expert.save
      else
        return false
      end      
    end
  end
end
