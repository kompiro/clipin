class Tag < ActiveRecord::Base
  attr_accessor :page_num
  has_many :taggings
  has_many :clips, :through => :taggings, :conditions => {:user_id => User.current.id,:trash => false},:order => "clips.created_at DESC",:limit => 8
  PAGE_CONTENT = 8

  belongs_to :user

  def my_clips(page_num = 1)
    return clips.offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))
  end

  def save
    self.user = User.current
    super
  end
end
