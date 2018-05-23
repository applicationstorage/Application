class AddReasonForLoanColToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :reason_for_loan, :text
  end
end
