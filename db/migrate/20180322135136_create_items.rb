class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.integer :device_id
      t.integer :item_id
      t.string :model_type
      t.string :serial_equipment_number
      t.string :user_name
      t.string :user_email
      t.float :purchase_price
      t.date :purchase_date
      t.string :item_location
      t.boolean :research_project

      t.timestamps
    end
  end
end
