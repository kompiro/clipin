# encoding: utf-8

require_dependency 'support/web_loader'
require_dependency 'support/slide_tag_filter'
require_dependency 'support/og_type_tag_filter'

class Clip < ActiveRecord::Base

  has_many :taggings
  has_many :tags, :through => :taggings
  belongs_to :user
  belongs_to :url_info
  before_save :set_user_before_save
  #delegate :title,:url,:description,:image, :to => :url_info
  PAGE_CONTENT = 8

  scope :page,    lambda {|page_num = 1| includes(:tags).where(:user_id => User.current).where(:trash => false).order('updated_at DESC').limit(PAGE_CONTENT).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))}
  scope :search,    lambda {|query='',page_num = 1| where(:user_id => User.current).where(:trash => false).where('title like ?',"%#{query}%").order('updated_at DESC').limit(PAGE_CONTENT).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))}
  scope :pinned,  lambda { where(:user_id => User.current).where(:pin => true,:trash => false).order('updated_at DESC').limit(PAGE_CONTENT)}
  scope :trashed, lambda { where(:user_id => User.current).where(:trash => true).order('updated_at DESC').limit(PAGE_CONTENT)}

  def set_user_before_save
    if User.current.present?
      self.user = User.current
    end
  end

  def tagging
    filter = Support::OgTypeTagFilter.new self
    filter.filter
    filter = Support::SlideTagFilter.new self
    filter.filter
  end

  def load
    loader = Support::WebLoader.new(self)
    loader.load
  end

end
