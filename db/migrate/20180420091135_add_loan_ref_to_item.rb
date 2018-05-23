class AddLoanRefToItem < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :loan, foreign_key: true
  end
end
