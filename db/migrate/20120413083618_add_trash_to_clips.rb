class AddTrashToClips < ActiveRecord::Migration
  def change
    add_column :clips, :trash, :boolean, :default => false

  end
end
