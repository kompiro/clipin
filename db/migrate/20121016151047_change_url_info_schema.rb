class ChangeUrlInfoSchema < ActiveRecord::Migration
  def change
    change_column :url_infos,:title,:text
    change_column :url_infos,:description,:text
    change_column :url_infos,:url,:text
    change_column :url_infos,:image,:text
  end
end
