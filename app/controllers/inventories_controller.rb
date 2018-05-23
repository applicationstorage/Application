class InventoriesController < ApplicationController
  before_action :find_inventory_from_params, only: [:edit, :update, :destroy]

  authorize_resource

  rescue_from CanCan::AccessDenied do
    redirect_to :home
  end

  def index
    # all inventory info needed
    @inventories = Inventory.all.order('item_category ASC').order('item_name ASC')

    # for producing the csv file
    respond_to do |format|
      format.html
      format.csv { send_data @inventories.to_csv }
    end
  end

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)

    # fresh inventory will have no stock
    @inventory.total_stock = 0
    @inventory.total_available = 0

    # fields that need required input
    @requiredItem = @inventory.item_name.present?
    @requiredLoan = @inventory.loan_time.present?

    # if these fields are not input render :new
    if !@requiredItem or !@requiredLoan
      flash.now[:alert] = "Failed: Some fields with required input * were not filled!"
      render :new
    elsif @inventory.save
      redirect_to inventories_path, notice: 'Created new item'
    else
      flash.now[:alert] = "Failed to save"
      render :new
    end
  end

  def edit; end

  def update
    # check item name is not empty
    @requiredItem = inventory_params[:item_name].present?

    # error if item name is empty
    if @requiredItem
      if @inventory.update(inventory_params)
        redirect_to inventories_path, notice: 'Item updated successfully'
      else
        flash.now[:alert] = "Failed to update"
        render :edit
      end
    else
      flash.now[:alert] = "Failed to update, not filled in required fields"
      render :edit
    end
  end

  def destroy
    if @inventory.destroy
      redirect_to inventories_path, notice: 'Item table destroyed'
    else
      redirect_to inventories_path, alert: 'Failed to destroy'
    end
  end

  private
    def inventory_params
      params.require(:inventory).permit(:item_name, :item_category, :loan_time)
    end

    def find_inventory_from_params
      @inventory = Inventory.find(params[:id])
    end
end
