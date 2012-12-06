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

  scope :page,    ->(page_num=1) {
    order(arel_table[:updated_at].desc).includes(:tags).includes(:url_info).limit(PAGE_CONTENT).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))}
  scope :user,    ->(user) {where(:user_id => user)}
  scope :tag,     ->(tag) {
    taggings_table = Tagging.arel_table
    joins(:taggings).where(taggings_table[:tag_id].eq(tag.id))}
  scope :search,  ->(query='') {
    url_infos_table = UrlInfo.arel_table
    where(:trash => false).where(url_infos_table[:title].matches("%#{query}%"))
  }
  scope :updated_at,  ->(time) {
    begin_date = time.beginning_of_day
    end_date = time.tomorrow.beginning_of_day
    where(:updated_at => begin_date..end_date)
  }
  scope :pinned,  -> {where(:pin => true)}
  scope :trashed, -> {where(:trash => true)}
  scope :not_trashed, -> {where(:trash => false)}

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
