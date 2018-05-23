class AddInventoryRefToItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :inventory_id
    add_reference :items, :inventory, foreign_key: true
  end
end
