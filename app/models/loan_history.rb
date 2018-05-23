# == Schema Information
#
# Table name: loan_histories
#
#  id          :integer          not null, primary key
#  returned_on :date
#  late        :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  item_id     :integer
#  loan_id     :integer
#
# Indexes
#
#  index_loan_histories_on_item_id  (item_id)
#  index_loan_histories_on_loan_id  (loan_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (loan_id => loans.id)
#

class LoanHistory < ApplicationRecord
  belongs_to :item
  belongs_to :loan

end
