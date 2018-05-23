class DisposedsController < ApplicationController

  authorize_resource

  rescue_from CanCan::AccessDenied do
    redirect_to :home
  end

  def index
    # need all information about device bar loan or rp info
    @items = Item.all
    @inventories = Inventory.all
    @disposed = Disposed.all.order('date_disposed DESC')
  end

  def destroy
    # find both the item record and disposed record for deletion
    @disposed = Disposed.find(params[:id])
    @item = Item.find(@disposed.item_id)

    if @disposed.destroy && @item.destroy
      redirect_to disposeds_path, notice: 'Device deleted'
    else
      redirect_to disposeds_path, alert: 'Failed to delete'
    end
  end

end
