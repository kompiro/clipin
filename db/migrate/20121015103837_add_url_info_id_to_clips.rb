class AddUrlInfoIdToClips < ActiveRecord::Migration
  def change
    add_column :clips, :url_info_id, :integer
    Clip.reset_column_information
    Clip.all.each do |clip|
      info = UrlInfo.create({
        :url => clip.url,
        :title => clip.title,
        :image => clip.image,
        :og_type => clip.og_type,
        :description => clip.description
      })
      clip.url_info = info
      clip.save
    end
  end
end
