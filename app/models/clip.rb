# encoding: utf-8

require_dependency 'support/web_loader'

class Clip < ActiveRecord::Base

  has_many :taggings
  has_many :tags, :through => :taggings
  belongs_to :user
  before_save :set_user
  PAGE_CONTENT = 8

  scope :page,    lambda {|page_num = 1| includes(:tags).where(:user_id => User.current).where(:trash => false).order('updated_at DESC').limit(PAGE_CONTENT).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))}
  scope :search,    lambda {|query='',page_num = 1| where(:user_id => User.current).where(:trash => false).where('title like ?',"%#{query}%").order('updated_at DESC').limit(PAGE_CONTENT).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))}
  scope :pinned,  lambda { where(:user_id => User.current).where(:pin => true,:trash => false).order('updated_at DESC').limit(PAGE_CONTENT)}
  scope :trashed, lambda { where(:user_id => User.current).where(:trash => true).order('updated_at DESC').limit(PAGE_CONTENT)}

  def set_user
    self.user = User.current
  end

  def tagging
    if self.og_type.nil? or self.og_type.empty?
      return
    end
    tag = Tag.find_or_create_by_name self.og_type
    Tagging.create({:clip => self, :tag => tag})
  end

  def load
    loader = Support::WebLoader.new(self)
    loader.load
  end

end
