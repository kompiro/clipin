
require 'open-uri'
require 'nokogiri'
require 'nkf'

class WebLoader

  def initialize(clip)
    @clip = clip
    @url = @clip.url
  end

  def load
    if @url.nil? or @url.empty?
      @clip.errors.add :url, "url can't be empty"
      return false
    end
    unless @url.start_with?('http:') or @url.start_with?('https:')
      @clip.errors.add :url, "url should start with 'http:' or 'https:'"
      return false
    end
    recover_url
    doc = create_doc
    @clip.title = doc.xpath('//title/text()').text
    begin
      @clip.title = @clip.title.strip
    rescue ArgumentError
    end
    @clip.url = @url
    parse_prop doc
    if @clip.description.nil?
      @clip.description = doc.xpath('//meta[@name="description"]/@content').text
    end
    return true
  end

  private

  def recover_url
    if @url.start_with?('http:')
      @url = 'http://' + @url.scan(/http:\/\/?(.*)/)[0][0]
    end
    if @url.start_with?('https:')
      @url = 'https://' + @url.scan(/https:\/\/?(.*)/)[0][0]
    end
  end

  def create_doc
    io = open(@url)
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
          @clip.og_type = value
        end
        if prop.to_s.match(/^og:image/i)
          @clip.image = value
        end
        if prop.to_s.match(/^og:description/i)
          @clip.description = value
        end
      end
    end
  end
end
