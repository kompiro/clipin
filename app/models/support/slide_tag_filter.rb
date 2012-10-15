require 'open-uri'
require 'addressable/uri'

module Support
  class SlideTagFilter

    def initialize(clip)
      @clip = clip
    end

    def filter
      if @clip.og_type == 'slideshare:presentation'
        create_tag
        return
      end
      uri = Addressable::URI.parse(@clip.url)
      if uri.host.include? 'speakerdeck.com' and uri.path.start_with? '/u/'
        create_tag
      end
    end

    private

    def create_tag
      tag = Tag.find_or_create_by_name_and_user_id 'slide',@clip.user.id
      Tagging.create({:clip => @clip, :tag => tag})
    end
  end
end
