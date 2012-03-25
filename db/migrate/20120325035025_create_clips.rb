class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.text :title
      t.string :type
      t.text :image
      t.text :url
      t.text :description
      t.text :audio
      t.text :video

      t.timestamps
    end
  end
end
