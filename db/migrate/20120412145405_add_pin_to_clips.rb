class AddPinToClips < ActiveRecord::Migration
  def change
    add_column :clips, :pin, :boolean

  end
end
