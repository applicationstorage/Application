class RenameColResearchProjectInItem < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :research_project, :is_research_project
  end
end
