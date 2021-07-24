class Supports::User < Supports::Application
  attr_reader :id
  attr_reader :display_id
  attr_reader :account_type
  attr_reader :name
  attr_reader :expert

  def initialize attributes
    @id           = attributes[:id]
    @display_id   = attributes[:display_id]
    @account_type = attributes[:account_type]
    @name         = attributes[:name]
    @expert       = attributes[:expert]
  end

  class << self
    def convert_users users
      sp_users = []
      users.each do |user|
        sp_users.push(self.convert_user(user))
      end
      sp_users
    end

    def convert_user user
      attributes = {}
      attributes[:id]           = user.id
      attributes[:display_id]   = user.display_id
      attributes[:account_type] = user.account_type
      attributes[:name]         = user.name
      if user.expert
        attributes[:expert] = Supports::Expert.convert_expert(user.expert)
      end
      self.new(attributes)
    end
  end
end
