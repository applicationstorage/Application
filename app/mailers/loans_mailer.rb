class LoansMailer < ApplicationMailer
    def notify_user(loan)
        @loan = Loan.find(loan)
        @inventories = Inventory.all
        mail(to: @loan.requestee_email, subject: "Loan requested")

    end

    def admin_loan_user(loan)
        @loan = Loan.find(loan)
        @inventories = Inventory.all
        mail(to: @loan.requestee_email, subject: "Admin has loaned you an item")

    end

    def notify_basket_user(loans)
        @loans = loans
        @inventories = Inventory.all
        mail(to: @loans.first.requestee_email, subject: "Loans requested")

    end

    def remind_user(loan)
        @loan = loan
        @items = Item.where( :loan_token => @loan.loan_token)
        @inventories = Inventory.all
        mail(to: @loan.requestee_email, subject: "Loan deadline reminder")
    end

    def item_returned(loan)
        @loan_history = LoanHistory.find(loan)
        @loan = Loan.find(@loan_history.loan_id)
        @item = Item.find(@loan_history.item_id)
        @inventory = Inventory.find(@item.inventory_id)
        mail(to: @loan.requestee_email, subject: "Item returned")
    end

    def loan_accepted(loan)
        @loan = Loan.find(loan)
        @inventories = Inventory.all
        mail(to: @loan.requestee_email, subject: "Loan Accepted")
    end

    def loan_rejected(loan)
        @loan = loan
        @inventories = Inventory.all
        mail(to: @loan.requestee_email, subject: "Loan Rejected")
    end

    def loan_updated(loan)
        @loan = Loan.find(loan)
        @item = Item.where( :loan_token => @loan.loan_token)
        @inventories = Inventory.find(@item.first.inventory_id)
        mail(to: @loan.requestee_email, subject: "Loan deadline updated")
    end
end
