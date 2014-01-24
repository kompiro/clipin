class Tag < ActiveRecord::Base
  attr_accessor :page_num
  has_many :taggings
  has_many :clips, -> {order('clips.updated_at DESC').limit(8)}, :through => :taggings
  PAGE_CONTENT = 8

  belongs_to :user

  def my_clips(user,page_num = 1)
    if user.nil?
      return
    end
    return clips.where(:user_id => user,:trash => false).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))
  end

end
