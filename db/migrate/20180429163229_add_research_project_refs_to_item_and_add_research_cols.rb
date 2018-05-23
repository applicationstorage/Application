class AddResearchProjectRefsToItemAndAddResearchCols < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :research_project, foreign_key: true
    add_column :research_projects, :researcher_name, :string
    add_column :research_projects, :researcher_email, :string
  end
end
