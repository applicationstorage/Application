class AddItemAndLoanRefsToLoanHistory < ActiveRecord::Migration[5.1]
  def change
    add_reference :loan_histories, :item, foreign_key: true
    add_reference :loan_histories, :loan, foreign_key: true
  end
end
