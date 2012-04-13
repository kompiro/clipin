class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :clip, :null => false
      t.references :tag, :null => false
      t.timestamps
    end
  end

end
