# == Schema Information
#
# Table name: research_projects
#
#  id               :integer          not null, primary key
#  end_of_project   :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  researcher_name  :string
#  researcher_email :string
#

class ResearchProject < ApplicationRecord
  has_many :items
end
