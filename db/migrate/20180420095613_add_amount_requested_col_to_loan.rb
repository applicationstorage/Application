class AddAmountRequestedColToLoan < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :amount_requested, :integer
  end
end
