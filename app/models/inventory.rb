# == Schema Information
#
# Table name: inventories
#
#  id              :integer          not null, primary key
#  item_name       :string
#  item_category   :string
#  total_stock     :integer
#  total_available :integer
#  loan_time       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Inventory < ApplicationRecord
  has_many :items, dependent: :destroy

    def self.to_csv
      attributes = %w{id item_name item_category total_stock total_available loan_time}

      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.each do |inventory|
          csv << inventory.attributes.values_at(*attributes)
        end
      end
    end
  end
