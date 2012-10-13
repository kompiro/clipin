class Tag < ActiveRecord::Base
  attr_accessor :page_num
  has_many :taggings
  has_many :clips, :through => :taggings,:order => "clips.updated_at DESC",:limit => 8
  PAGE_CONTENT = 8

  belongs_to :user

  def my_clips(page_num = 1)
    if User.current.nil?
      return
    end
    return clips.where(:user_id => User.current.id,:trash => false).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))
  end

end
