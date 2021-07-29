class Supports::User < Supports::Application
  attr_reader :expert
  attr_reader :account_type
  attr_reader :avatar
  attr_reader :display_id
  attr_reader :id
  attr_reader :name

  def initialize attributes
    @expert       = attributes[:expert]
    @account_type = attributes[:account_type]
    @avatar       = attributes[:avatar]
    @display_id   = attributes[:display_id]
    @id           = attributes[:id]
    @name         = attributes[:name]
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
      attributes[:expert]       = Supports::Expert.convert_expert(user.expert) if user.expert?
      attributes[:account_type] = user.account_type
      attributes[:avatar]       = user.avatar
      attributes[:display_id]   = user.display_id
      attributes[:id]           = user.id
      attributes[:name]         = user.name
      self.new(attributes)
    end
  end
end
