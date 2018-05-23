class ChangeResearchProjectReferences < ActiveRecord::Migration[5.1]
  def change
    remove_reference :research_projects, :item, foreign_key: true
  end
end
