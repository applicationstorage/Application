class RequestBasketsController < ApplicationController
  before_action :this_user_email, only: [:index, :new, :create]
  before_action :this_user_name, only: [:create]
  before_action :find_loan_from_params, only: [:update, :destroy]
  before_action :alter_loan_params, only: [:update]
  before_action :set_loan_token, only: [:create]

  def index
    @loans = Loan.where(:requestee_email => @this_user_email, :in_basket => true)
    @inventories = Inventory.all.order('item_category DESC').order('item_name DESC')
  end

  # for requesting all items in basket
  def new
    @loans = Loan.where(:requestee_email => @this_user_email, :in_basket => true)
    @inventories = Inventory.all.order('item_category DESC').order('item_name DESC')
  end

  def create
    # get all the loans in the request basket for this user
    @loans = Loan.where(:requestee_email => @this_user_email, :in_basket => true)

    # process all separate additions to basket as separate loans
    complete = true
    @loans.each do |loan|
      loan.requestee_name = @this_user_name
      loan.approved = false
      loan.returned = false
      loan.request_date = Date.today
      loan.loan_token = set_loan_token
      loan.in_basket = false

      if !loan.save
        complete = false
      end
    end

    # if no problems
    if complete
      LoansMailer.notify_basket_user(@loans).deliver_now
      redirect_to request_baskets_path, notice: 'All items requested!'
    else
      redirect_to request_baskets_path, alert: 'Failed to request items'
    end
  end

  # for updating singular items in basket
  def update
    if @loan.update(alter_loan_params)
      redirect_to request_baskets_path, notice: 'Item changes saved'
    else
      redirect_to request_baskets_path, alert: 'Failed to save item changes'
    end
  end

  # for removing an item from your basket
  def destroy
    if @loan.delete
      redirect_to request_baskets_path, notice: 'Item removed'
    else
      redirect_to request_baskets_path, alert: 'Failed to remove'
    end
  end

  private
    def this_user_email
      @this_user_email = current_user.email
    end

    def this_user_name
      @this_user_name = current_user.givenname
    end

    def alter_loan_params
      params.require(:loan).permit(:due_date, :inventory_id, :amount_requested, :reason_for_loan)
    end

    def find_loan_from_params
      @loan = Loan.find(params[:id])
    end

    def set_loan_token
      generate_token
    end

    def generate_token
      loop do
        token = SecureRandom.hex(10)
        break token unless Item.where(loan_token: token).exists?
      end
    end
end
