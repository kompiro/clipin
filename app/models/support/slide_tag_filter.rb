require 'open-uri'
require 'addressable/uri'

module Support
  class SlideTagFilter

    def initialize(clip)
      @clip = clip
    end

    def filter
      if @clip.og_type == 'slideshare:presentation'
        tag = Tag.find_or_create_by_name_and_user_id 'slide',@clip.user.id
        Tagging.create({:clip => @clip, :tag => tag})
      end
    end
  end
end
