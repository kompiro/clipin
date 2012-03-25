require 'open-uri'
require 'nokogiri'

class Clip < ActiveRecord::Base
  def load
    return false if url.nil? or url.empty?
    return false unless url.start_with?('http:') or url.start_with?('https:')
    doc = Nokogiri::HTML(open(url))
    doc.css('meta').each do |m|
      prop = m.attribute('property')
      if prop
        if prop.to_s.match(/^og:title/i)
          self.title = m.attribute('content').to_s
        end
        if prop.to_s.match(/^og:type/i)
          self.og_type = m.attribute('content').to_s
        end
        if prop.to_s.match(/^og:image/i)
          self.image = m.attribute('content').to_s
        end
        if prop.to_s.match(/^og:url/i)
          self.url = m.attribute('content').to_s
        end
        if prop.to_s.match(/^og:description/i)
          self.description = m.attribute('content').to_s
        end
      end
    end
  end
end
