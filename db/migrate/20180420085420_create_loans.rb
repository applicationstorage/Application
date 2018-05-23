class CreateLoans < ActiveRecord::Migration[5.1]
  def change
    create_table :loans do |t|
      t.date :request_date
      t.date :due_date
      t.boolean :approved
      t.boolean :returned

      t.timestamps
    end
  end
end
