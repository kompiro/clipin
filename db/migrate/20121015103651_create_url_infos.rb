class CreateUrlInfos < ActiveRecord::Migration
  def change
    create_table :url_infos do |t|
      t.text :title
      t.text :url
      t.string :og_type
      t.text :description
      t.text :image

      t.timestamps
    end
  end
end
