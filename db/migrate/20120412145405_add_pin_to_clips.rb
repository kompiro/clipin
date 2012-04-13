class AddPinToClips < ActiveRecord::Migration
  def change
    add_column :clips, :pin, :boolean, :default => false

  end
end
