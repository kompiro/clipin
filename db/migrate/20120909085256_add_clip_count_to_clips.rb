class AddClipCountToClips < ActiveRecord::Migration
  def change
    add_column :clips, :clip_count, :integer,:default => 1
  end
end
