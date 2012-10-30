require 'zlib'
require 'open-uri'
require 'addressable/uri'
require 'nokogiri'
require 'nkf'

module Support
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
      until @clip.image.nil?
        @clip.title = @clip.image.split('/').last
        @clip.description = "clip from #{@clip.url}"
        return true
      end
      begin
        io = open(@url,'r:binary')
      rescue OpenURI::HTTPError => e
        @clip.errors.add :url, "access '#{@url}' error : #{e.message}"
        return false
      end
      if io.meta['content-type'].include? 'text/html'
        load_html io
      elsif io.meta['content-type'].include? 'image'
        load_image io
      end
      return true
    end

    private

    def load_html(io)
      doc = create_doc io
      @clip.title = doc.xpath('//title/text()').text
      begin
        @clip.title = @clip.title.strip
      rescue ArgumentError
      end
      @clip.url = io.base_uri.to_s
      parse_prop doc
      if @clip.description.nil?
        @clip.description = doc.xpath('//meta[@name="description"]/@content').text
      end
    end

    def load_image(io)
      @clip.url = @url
      @clip.image = @url
      @clip.title = io.base_uri.path.split('/').last
    end

    def recover_url
      uri = Addressable::URI.parse(@url)
      if @url.start_with?('http:')
        @url = 'http://' + @url.scan(/http:\/\/?(.*)/)[0][0]
      end
      if @url.start_with?('https:')
        @url = 'https://' + @url.scan(/https:\/\/?(.*)/)[0][0]
      end
      if uri.host.present? and uri.host.include?('google')
        if uri.query_values.present? and uri.query_values['url'].present?
          @url = uri.query_values['url']
        end
      end
    end

    def create_doc(io)
      charset = io.charset
      if charset.present? and charset.downcase != 'utf-8'
        read = open(@url,"r:binary").read
        read = NKF.nkf('-w', read)
      else
        unless io.content_encoding.empty?
          read = Zlib::GzipReader.new(io).read
        else
          read = io.read
        end
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
end
