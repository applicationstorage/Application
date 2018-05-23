class PagesController < ApplicationController

  # user loan history page
  def loanHistory
    @this_user_email = current_user.email

    @inventories = Inventory.all
    @items = Item.all
    @loan_histories = LoanHistory.all.order('returned_on DESC')
    @loans = Loan.where(:requestee_email => @this_user_email)
  end

  # for adding to the request basket
  def create
    @this_user_email = current_user.email
    @today_date = Date.today
    @inventory = params[:id]
    @item_name = Inventory.find(@inventory)

    # when in basket loan is not approved
    @loan = Loan.new(:requestee_email => @this_user_email, :in_basket => true, :inventory_id => @inventory, :amount_requested => 1)

    if @loan.save
      redirect_to home_path, notice: 'Device added to basket.'
    else
      flash.now[:alert] = "Failed to add to basket"
      @inventory = @loan.inventory_id
      redirect_to home_path
    end
  end
end
