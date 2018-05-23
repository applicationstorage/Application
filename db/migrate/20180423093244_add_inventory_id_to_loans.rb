class AddInventoryIdToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :inventory_id, :bigint
  end
end
