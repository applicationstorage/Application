class AddAuthenTokenColToLoan < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :token, :string
  end
end
