class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :clips, :through => :taggings
  belongs_to :user

  def save
    self.user = User.current
    super
  end
end
