class AddIndexToSerialEquipmentNumber < ActiveRecord::Migration[5.1]
  def change
    add_index :items, :serial_equipment_number, unique: true
  end
end
