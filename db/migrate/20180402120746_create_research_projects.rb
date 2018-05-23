class CreateResearchProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :research_projects do |t|
      t.date :end_of_project
        
      t.timestamps
    end
  end
end
