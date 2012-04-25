class User < ActiveRecord::Base

  def self.create_with_omniauth(auth)
    begin
      create! do |user|
        user.provider = auth['provider']

        user.uid = auth['uid']
        if auth['extra']['user_hash']
          user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name'] # Facebook
        end
      end
    rescue Exception
      raise Exception, "cannot create user record"
    end
  end
end
