class ResearchProjectsController < ApplicationController
  before_action :find_research_project_from_params, only: [:edit, :update, :destroy]

  authorize_resource

  rescue_from CanCan::AccessDenied do
    redirect_to :home
  end

  def index
    @items = Item.where(:is_research_project => true).order('end_of_project ASC')
    # ResearchProject id:1 is not a project so dont show this
    @research_projects = ResearchProject.where.not(:researcher_email => [nil, ""])
  end

  def edit
    @items = Item.where(:research_project_id => @research_project.id)
    @inventories = Inventory.all.order('item_category DESC').order('item_name DESC')
  end

  def update
    passed_tests = update_tests(research_project_params)

    # updating information name, email and end date only
    if !passed_tests
      flash.now[:alert] = "Failed to update: Invalid inputs"
      @items = Item.where(:research_project_id => @research_project.id)
      @inventories = Inventory.all.order('item_category DESC').order('item_name DESC')
      render :edit
    elsif @research_project.update(research_project_params)
      redirect_to edit_research_project_path(@research_project), notice: 'Project updated successfully'
    else
      flash.now[:alert] = "Failed to update"
      @items = Item.where(:research_project_id => @research_project.id)
      @inventories = Inventory.all.order('item_category DESC').order('item_name DESC')
      render :edit
    end
  end

  def destroy
    # ending a project - resetting project id in items table
    @items = Item.where(:research_project_id => @research_project.id)

    # update inventory available values
    @items.each do |item|
      @inventory = Inventory.find(item.inventory_id)
      @inventory.total_available = (@inventory.total_available + 1)
      @inventory.save
    end

    if @items.update_all(:research_project_id => 1, :is_research_project => false) && @research_project.destroy
      redirect_to research_projects_path, notice: 'Project Ended Successfully'
    else
      flash.now[:alert] = "Failed to end project"
      render :edit
    end
  end

  private
    def update_tests(rp_params)
      passed = true

      if !rp_params[:researcher_name].present?
        passed = false
      elsif !rp_params[:researcher_email].present?
        passed = false
      elsif !rp_params[:end_of_project].present?
        passed = false
      end

      return passed
    end

    def research_project_params
      params.require(:research_project).permit(:researcher_name, :researcher_email, :end_of_project)
    end

    def find_research_project_from_params
      @research_project = ResearchProject.find(params[:id])
    end

end
