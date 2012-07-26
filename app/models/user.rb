class User < ActiveRecord::Base
  has_many :interesting_pieces_of_data
  has_many :clips

  def self.create_with_omniauth(auth)
    begin
      create! do |user|
        user.provider = auth['provider']

        user.uid = auth['uid']
        if auth['extra']['user_hash']
          user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name'] # Facebook
        end
      end
    rescue Exception => e
      p e
      raise Exception, "cannot create user record"
    end
  end
  def self.current=(user)
    @current_user = user
  end
  def self.current
    @current_user
  end
end
