class User < ActiveRecord::Base
  has_many :interesting_pieces_of_data
  has_many :clips
  has_many :tags

  def self.create_with_omniauth(auth)
    begin
      create! do |user|
        user.provider = auth['provider']

        user.uid = auth['uid']
      end
    rescue Exception => e
      p e
      raise Exception, "cannot create user record"
    end
  end
end
