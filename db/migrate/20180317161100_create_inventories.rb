class CreateInventories < ActiveRecord::Migration[5.1]
  def change
    create_table :inventories do |t|
      t.integer :item_id
      t.string :item_name
      t.string :item_category
      t.integer :total_stock
      t.integer :total_available
      t.string :loan_time

      t.timestamps
    end
  end
end
