class AdminSummariesController < ApplicationController
  before_action :find_items_from_params, only: [:destroy]
  before_action :find_loans_from_params, only: [:edit, :update]

  authorize_resource Loan

  rescue_from CanCan::AccessDenied do
    redirect_to :home
  end

  def index
    # only want to show devices currently on loan
    # also do not include devices that are on research projects
    @loans = Loan.where.not(:loan_token => "not_loaned").where(:approved => true).where(:returned => false).order('due_date ASC')
    @items = Item.where(:disposed_of => false).where(:is_research_project => false).where(:in_use => true)
    @inventories = Inventory.all
  end

  def edit; end

  def update
    if @loan.update(loan_params)
      # if approved, it is already on summaries page, so redirect here
      # otherwise redirect to loan approval
      if @loan.approved
        LoansMailer.loan_updated(@loan.id).deliver_now
        redirect_to admin_summaries_path, notice: 'Loan updated'
      else
        redirect_to loans_path, notice: 'Loan updated'
      end
    else
      redirect_to loans_path, alert: 'Failed to update'
    end
  end

  def destroy
    @loan = Loan.where(:loan_token => @item.loan_token).first
    @inventory = Inventory.find(@item.inventory_id)

    # if there is more than one device associated to the loan
    # the loan will not be completed yet
    if @loan.amount_requested <= 1
      @loan.returned = true
    end

    # update various attributes
    @loan.amount_requested = (@loan.amount_requested - 1)
    @item.in_use = false
    @item.loan_token = "not_loaned"
    @inventory.total_available = (@inventory.total_available + 1)

    # check whether device was returned late
    retLate = false
    if @loan.due_date < Date.today
      retLate = true
    end

    # make this loan a record in loan history table
    @loan_history = LoanHistory.new(:returned_on => Date.today, :late => retLate, :item_id => @item.id, :loan_id => @loan.id)

    if @loan.save && @loan_history.save && @item.save && @inventory.save
      # email confirmation and redirect to summary page
      LoansMailer.item_returned(@loan_history.id).deliver_now
      redirect_to admin_summaries_path, notice: 'Confirmed device return'
    else
      flash.now[:alert] = "Failed to update"
      redirect_to admin_summaries_path
    end
  end



  private
    def find_items_from_params
      @item = Item.find(params[:id])
    end

    def find_loans_from_params
      @loan = Loan.find(params[:id])
    end

    def loan_params
      params.require(:loan).permit(:due_date, :amount_requested)
    end
end
