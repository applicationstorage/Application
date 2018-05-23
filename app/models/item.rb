# == Schema Information
#
# Table name: items
#
#  id                      :integer          not null, primary key
#  model_type              :string
#  serial_equipment_number :string
#  purchase_price          :float
#  purchase_date           :date
#  item_location           :string
#  is_research_project     :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  inventory_id            :integer
#  disposed_of             :boolean
#  loan_token              :string
#  in_use                  :boolean
#  research_project_id     :integer
#
# Indexes
#
#  index_items_on_inventory_id             (inventory_id)
#  index_items_on_research_project_id      (research_project_id)
#  index_items_on_serial_equipment_number  (serial_equipment_number) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (inventory_id => inventories.id)
#  fk_rails_...  (loan_token => loans.loan_token)
#  fk_rails_...  (research_project_id => research_projects.id)
#

class Item < ApplicationRecord
  belongs_to :inventory
  belongs_to :loan, :foreign_key => 'loan_token', :primary_key => 'loan_token'
  belongs_to :research_project
  has_many :disposed, dependent: :destroy
  has_many :loan_histories, dependent: :destroy
  accepts_nested_attributes_for :loan
  accepts_nested_attributes_for :research_project

  def self.to_csv
    attributes = %w{id model_type serial_equipment_number purchase_price
    purchase_date item_location is_research_project inventory_id
    disposed_of loan_token in_use research_project_id}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |item|

        csv << item.attributes.values_at(*attributes)
      end
    end
  end

  def self.to_csv2
    attributes = %w{id model_type serial_equipment_number purchase_price
    purchase_date item_location is_research_project inventory_id
    disposed_of loan_token in_use research_project_id}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |item|
        if item.is_research_project == true
          csv << item.attributes.values_at(*attributes)
        end
      end
    end
  end
end
