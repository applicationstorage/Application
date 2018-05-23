class UpdateAllCurrentTables < ActiveRecord::Migration[5.1]
  def change
    remove_column :inventories, :inventory_id
    remove_column :items, :device_id
  end
end
