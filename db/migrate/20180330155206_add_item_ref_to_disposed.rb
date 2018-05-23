class AddItemRefToDisposed < ActiveRecord::Migration[5.1]
  def change
    add_reference :disposeds, :item, foreign_key: true 
  end
end
