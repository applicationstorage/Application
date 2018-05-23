class LoanHistoriesController < ApplicationController
  before_action :find_loan_history_from_params, only: [:destroy]

  def index
    @loan_histories = LoanHistory.all.order('returned_on DESC')
    @items = Item.all
    @loans = Loan.all
  end

  def destroy
    # find loan associated with history
    @loan = Loan.find(@loan_history.loan_id)

    # check if there is still other history associated with this loan
    if LoanHistory.where(:loan_id => @loan.id).count > 1
      if @loan.returned && @loan_history.delete
        redirect_to loan_histories_path(), notice: 'History information removed'
      else
        redirect_to loan_histories_path(), alert: 'Failed to remove information. Possibly trying to remove a loan that still has some devices not returned.'
      end
    elsif @loan.returned && @loan_history.delete && @loan.delete
      redirect_to loan_histories_path(), notice: 'History information removed'
    else
      redirect_to loan_histories_path(), alert: 'Failed to remove information. Possibly trying to remove a loan that still has some devices not returned.'
    end
  end

  private
    def find_loan_history_from_params
      @loan_history = LoanHistory.find(params[:id])
    end
end
