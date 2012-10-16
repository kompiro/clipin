class CreateUrlInfos < ActiveRecord::Migration
  def change
    create_table :url_infos do |t|
      t.string :title
      t.string :url
      t.string :og_type
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
