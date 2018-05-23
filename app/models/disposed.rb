# == Schema Information
#
# Table name: disposeds
#
#  id            :integer          not null, primary key
#  date_disposed :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  item_id       :integer
#
# Indexes
#
#  index_disposeds_on_item_id  (item_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#

class Disposed < ApplicationRecord
  belongs_to :item
end
