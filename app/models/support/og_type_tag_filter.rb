
module Support
  class OgTypeTagFilter

    def initialize(clip)
      @clip = clip
    end

    def filter
      if @clip.og_type.nil? or @clip.og_type.empty?
        return
      end
      tag = Tag.find_or_create_by_name_and_user_id @clip.og_type, @clip.user.id
      Tagging.create({:clip => @clip, :tag => tag})
    end
  end
end
