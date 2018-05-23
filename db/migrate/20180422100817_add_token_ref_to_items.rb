class AddTokenRefToItems < ActiveRecord::Migration[5.1]
  def change
    rename_column :loans, :token, :loan_token
    add_column :items, :loan_token, :string 
    add_index :loans, :loan_token, :unique => true
    add_foreign_key :items, :loans, column: :loan_token, primary_key: :loan_token
  end
end
