namespace :remind_users do
    desc "Send email reminders to users"
    task send_reminders: :environment do
        @loans = Loan.where.not(:loan_token => "not_loaned").where(:approved => true).where(:returned => false).order('due_date ASC')
        @loans.each do |loan|
            if loan.due_date < (Date.today + 1)
                LoansMailer.remind_user(loan).deliver_now
            end
        end
    end
end