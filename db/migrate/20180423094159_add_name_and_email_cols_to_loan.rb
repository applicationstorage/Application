class AddNameAndEmailColsToLoan < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :requestee_name, :string
    add_column :loans, :requestee_email, :string
  end
end
