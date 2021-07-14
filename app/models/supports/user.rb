class Supports::User
  attr_reader :id
  attr_reader :display_id
  attr_reader :account_type
  attr_reader :expert

  def initialize attributes
    @id           = attributes[:id]
    @display_id   = attributes[:display_id]
    @account_type = attributes[:account_type]
    @expert       = attributes[:expert]
  end

  class << self
    def convert_user user
      attributes = {}
      attributes[:id]           = user.id
      attributes[:display_id]   = user.display_id
      attributes[:account_type] = user.account_type
      if user.expert
        attributes[:expert] = Supports::Expert.convert_expert(user.expert)
      end
      Supports::User.new(attributes)
    end
  end
end
