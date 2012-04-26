class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :clips, :through => :taggings

  def save
    self.user = User.current
    super
  end
end
