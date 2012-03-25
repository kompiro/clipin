class RenameTypeToClips < ActiveRecord::Migration
  def change
    rename_column :clips,:type,:og_type
  end

end
