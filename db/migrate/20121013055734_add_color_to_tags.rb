class AddColorToTags < ActiveRecord::Migration
  def change
    add_column :tags, :color, :integer, :default => 0

    Tag.reset_column_information
    Tag.all.each do |tag|
      tag.color = tag.id % 8
      tag.save
    end
  end
end
