class DelLoanRefToItems < ActiveRecord::Migration[5.1]
  def change
    remove_reference :items, :loan, foreign_key: true
  end
end
