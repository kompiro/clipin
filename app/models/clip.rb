# encoding: utf-8

require 'open-uri'
require 'nokogiri'
require 'nkf'

class Clip < ActiveRecord::Base

  has_many :taggings
  has_many :tags, :through => :taggings
  belongs_to :user
  before_save :set_user
  PAGE_CONTENT = 8

  scope :page,    lambda {|page_num = 1| where(:user_id => User.current).where(:trash => false).order('created_at DESC').limit(PAGE_CONTENT).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))}
  scope :pinned,  lambda { where(:user_id => User.current).where(:pin => true,:trash => false).order('updated_at DESC').limit(PAGE_CONTENT)}
  scope :trashed, lambda { where(:user_id => User.current).where(:trash => true).order('updated_at DESC').limit(PAGE_CONTENT)}

  def set_user
    self.user = User.current
  end

  def load
    if url.nil? or url.empty?
      errors.add :url, "can't be blank"
      return false
    end
    unless url.start_with?('http:') or url.start_with?('https:')
      errors.add :url, "should start with 'http:' or 'https:'"
      return false
    end
    doc = create_doc url
    self.title = doc.xpath('//title/text()').text
    begin
      self.title = self.title.strip
    rescue ArgumentError
    end
    self.url = url
    doc.css('meta').each do |m|
      prop = m.attribute('property')
      if prop
        content = m.attribute('content')
        if content.nil?
          next
        end
        value = content.text
        if prop.to_s.match(/^og:type/i)
          self.og_type = value
        end
        if prop.to_s.match(/^og:image/i)
          self.image = value
        end
        if prop.to_s.match(/^og:description/i)
          self.description = value
        end
      end
    end
    if self.description.nil?
      self.description = doc.xpath('//meta[@name="description"]/@content').text
    end
    return true
  end
  def tagging
    if self.og_type.nil? or self.og_type.empty?
      return
    end
    tag = Tag.find_or_create_by_name self.og_type
    Tagging.create({:clip => self, :tag => tag})
  end

  private

  def create_doc(url)
    io = open(url)
    charset = io.charset
    read = io.read
    if charset.downcase != 'utf-8'
      read = NKF.nkf('-w', read)
    else
      read = read.encode("UTF-8", "UTF-8", :invalid => :replace, :undef => :replace)
    end
    doc = Nokogiri.HTML(read)
  end
end
