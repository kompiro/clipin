# encoding: utf-8

require_dependency 'support/web_loader'
require_dependency 'support/slide_tag_filter'
require_dependency 'support/og_type_tag_filter'

class Clip < ActiveRecord::Base

  has_many :taggings
  has_many :tags, :through => :taggings
  belongs_to :user
  belongs_to :url_info
  delegate :title, :title=, :url, :url=, :description, :description=, :image, :image=, :og_type, :og_type=, :to => :url_info
  PAGE_CONTENT = 8

  scope :page,    lambda {|user,page_num = 1| includes(:tags).includes(:url_info).where(:user_id => user).where(:trash => false).order('updated_at DESC').limit(PAGE_CONTENT).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))}
  scope :search,  lambda {|user,query='',page_num = 1| joins(:url_info).where(:user_id => user).where(:trash => false).where('url_infos.title like ?',"%#{query}%").order('updated_at DESC').limit(PAGE_CONTENT).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))}
  scope :pinned,  lambda {|user| where(:user_id => user).where(:pin => true,:trash => false).order('updated_at DESC').limit(PAGE_CONTENT)}
  scope :trashed, lambda {|user| where(:user_id => user).where(:trash => true).order('updated_at DESC').limit(PAGE_CONTENT)}

  def initialize(*args)
    super()
    self.url_info = UrlInfo.new()
    return if args.length == 0

    self.url_info.url = args[0][:url]
    self.url_info.title = args[0][:title]
    self.url_info.image = args[0][:image]
    self.url_info.og_type = args[0][:og_type]
    self.url_info.description = args[0][:description]
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
