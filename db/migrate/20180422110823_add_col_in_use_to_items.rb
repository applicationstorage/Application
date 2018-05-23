class AddColInUseToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :in_use, :boolean
  end
end
