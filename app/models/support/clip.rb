
require 'open-uri'
require 'nokogiri'
require 'nkf'

class Clip < ActiveRecord::Base
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
    parse_prop doc
    if self.description.nil?
      self.description = doc.xpath('//meta[@name="description"]/@content').text
    end
    return true
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

  def parse_prop(doc)
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
  end
end
