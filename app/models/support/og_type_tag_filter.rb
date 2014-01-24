
module Support
  class OgTypeTagFilter

    def initialize(clip)
      @clip = clip
    end

    def filter
      if @clip.og_type.nil? or @clip.og_type.empty?
        return
      end
      tag = Tag.find_or_create_by(name: @clip.og_type, user_id: @clip.user.id)
      Tagging.create({:clip => @clip, :tag => tag})
    end
  end
end
