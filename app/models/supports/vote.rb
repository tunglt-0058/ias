class Supports::Vote < Supports::Application
  attr_reader :stock_display_id
  attr_reader :user_display_id
  attr_reader :vote

  def initialize attributes
    @stock_display_id = attributes[:stock_display_id]
    @user_display_id  = attributes[:user_display_id]
    @vote             = attributes[:vote]
  end

  class << self
    def create_or_update_vote vote_params
      stock = Stock.find_by(display_id: vote_params[:stock_display_id]) || Stock.new
      user  = User.find_by(display_id: vote_params[:user_display_id]) || User.new
      vote  = Vote.find_by(user_id: user.id, stock_id: stock.id)
      if vote.nil?
        return Vote.create(user_id: user.id, stock_id: stock.id, vote: vote_params[:vote])
      else
        vote.vote = vote_params[:vote] if Vote.votes.values.include?(vote_params[:vote])
        return vote.save
      end
    end

    def convert_votes current_user_id=nil, votes
      sp_votes = []
      votes.each do |vote|
        sp_votes.push(self.convert_vote(current_user_id, vote))
      end
      sp_votes
    end

    def convert_vote current_user_id=nil, vote
      attributes = {}
      if !(vote.nil? or vote.new_record?)
        attributes[:stock_display_id] = vote.stock.display_id
        attributes[:user_display_id]  = vote.user.display_id
        attributes[:vote]             = vote.vote
      end
      self.new(attributes)
    end
  end
end
