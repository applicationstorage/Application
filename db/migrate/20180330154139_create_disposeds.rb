class CreateDisposeds < ActiveRecord::Migration[5.1]
  def change
    create_table :disposeds do |t|
      t.date :date_disposed

      t.timestamps
    end
  end
end
