class LoansController < ApplicationController
  before_action :find_loans_from_params, only: [:destroy, :update]
  before_action :set_loan_token, only: [:create, :update]

  def index
    @loans = Loan.where(:approved => false).order('request_date ASC')
    @inventories = Inventory.all
  end

  def new
    # information needed
    @this_user_email = current_user.email
    @this_user_name = current_user.givenname
    @loan = Loan.new
    @today_date = Date.today
    @inventory = params[:id]
    @item_name = Inventory.find(@inventory)
  end

  def create
    @loan = Loan.new(loan_params)
    @loan.loan_token = set_loan_token
    @loan.in_basket = false

    # make sure setting the loan is validated first
    passedTests = loan_create_tests(@loan)

    # if validation fails, loan is not set
    if !passedTests
      flash.now[:alert] = "Failed to request: invalid inputs"
      # information needed
      @this_user_email = current_user.email
      @this_user_name = current_user.givenname
      @today_date = Date.today
      @inventory = @loan.inventory_id
      @item_name = Inventory.find(@inventory)
      render :new
    elsif @loan.save
      LoansMailer.notify_user(@loan.id).deliver_now
      redirect_to home_path, notice: 'Success: You will recieve email confirmation of your loan.'
    else
      flash.now[:alert] = "Failed to request"
      # information needed
      @this_user_email = current_user.email
      @this_user_name = current_user.givenname
      @today_date = Date.today
      @inventory = @loan.inventory_id
      @item_name = Inventory.find(@inventory)
      render :new
    end
  end

  def update
    @inventory = Inventory.find(@loan.inventory_id)
    amountRequested = @loan.amount_requested

    # if there are devices in stock, can complete this loan
    if @inventory.total_available >= amountRequested
      # get the specified amount of items
      @items = Item.where(:in_use => false).where(:is_research_project => false).where(:loan_token => "not_loaned").where(:inventory_id => @inventory.id).limit(amountRequested)

      # set information for each device
      @items.each do |item|
        item.in_use = true
        item.loan_token = @loan.loan_token
        item.save
      end

      @loan.approved = true
      @loan.in_basket = false
      @inventory.total_available = (@inventory.total_available - amountRequested)

      if @loan.save && @inventory.save
        redirect_to loans_path, notice: 'Loan Accepted'
        LoansMailer.loan_accepted(@loan.id).deliver_now
      else
        redirect_to loans_path, alert: 'Accepting loan failed'
      end

    else
      # not enough stock
      redirect_to loans_path, alert: 'No device available to loan'
    end
  end

  def destroy
    if @loan.destroy
      LoansMailer.loan_rejected(@loan).deliver_now
      redirect_to loans_path, notice: 'Loan Rejected'
    else
      redirect_to loans_path, alert: 'Failed to reject loan'
    end
  end

  private
    def loan_create_tests(loan)
      passed = true

      if !loan.due_date.present?
        passed = false
      elsif loan.due_date <= Date.today
        passed = false
      elsif !loan.reason_for_loan.present?
        passed = false
      end

      return passed
    end

    def loan_params
      params.require(:loan).permit(:request_date, :approved, :returned, :due_date, :inventory_id, :amount_requested, :requestee_name, :requestee_email, :reason_for_loan)
    end

    def find_loans_from_params
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
