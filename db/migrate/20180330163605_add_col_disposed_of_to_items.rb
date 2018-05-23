class AddColDisposedOfToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :disposed_of, :boolean
  end
end
