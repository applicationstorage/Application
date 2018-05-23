class CreateLoanHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_histories do |t|
      t.date :returned_on
      t.boolean :late

      t.timestamps
    end
  end
end
