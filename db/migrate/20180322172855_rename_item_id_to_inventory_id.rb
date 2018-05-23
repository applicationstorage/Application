class RenameItemIdToInventoryId < ActiveRecord::Migration[5.1]
  def change
    rename_column :inventories, :item_id, :inventory_id
    rename_column :items, :item_id, :inventory_id
  end
end
