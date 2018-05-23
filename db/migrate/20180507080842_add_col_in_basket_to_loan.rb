class AddColInBasketToLoan < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :in_basket, :boolean
  end
end
