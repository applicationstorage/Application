# == Schema Information
#
# Table name: loans
#
#  id               :integer          not null, primary key
#  request_date     :date
#  due_date         :date
#  approved         :boolean
#  returned         :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  amount_requested :integer
#  loan_token       :string
#  inventory_id     :integer
#  requestee_name   :string
#  requestee_email  :string
#  reason_for_loan  :text
#  in_basket        :boolean
#
# Indexes
#
#  index_loans_on_loan_token  (loan_token) UNIQUE
#

class Loan < ApplicationRecord
  has_many :items, :foreign_key => 'loan_token', :primary_key => 'loan_token'
  has_many :loan_histories, dependent: :destroy
end
