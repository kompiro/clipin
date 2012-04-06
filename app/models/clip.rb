require 'open-uri'
require 'nokogiri'

class Clip < ActiveRecord::Base

  PAGE_CONTENT = 8

  scope :page, lambda {|page_num = 1| order('created_at DESC').limit(PAGE_CONTENT).offset(PAGE_CONTENT * ([page_num.to_i, 1].max - 1))}

  def load
    return false if url.nil? or url.empty?
    return false unless url.start_with?('http:') or url.start_with?('https:')
    doc = Nokogiri::HTML(open(url))
    self.title = doc.xpath('//title/text()').to_s.encode('utf-8')
    self.url = url
    doc.css('meta').each do |m|
      prop = m.attribute('property')
      if prop
        content = m.attribute('content').to_s.encode('utf-8')
        if prop.to_s.match(/^og:type/i)
          self.og_type = content
        end
        if prop.to_s.match(/^og:image/i)
          self.image = content
        end
        if prop.to_s.match(/^og:description/i)
          self.description = content
        end
      end
    end
    if self.description.nil?
      self.description = doc.xpath('//meta[@name="description"]/@content').to_s.encode('utf-8')
    end
  end
end
