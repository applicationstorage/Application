class AddItemRefToResearchProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :research_projects, :item, foreign_key: true
  end
end
