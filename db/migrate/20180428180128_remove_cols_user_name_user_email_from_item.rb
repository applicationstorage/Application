class RemoveColsUserNameUserEmailFromItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :user_name
    remove_column :items, :user_email
  end
end
