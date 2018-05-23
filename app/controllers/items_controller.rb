class ItemsController < ApplicationController
  before_action :find_items_from_params, only: [:edit, :update, :destroy]
  #before_action :set_loan_token, only: [:create, :update]

  authorize_resource

  rescue_from CanCan::AccessDenied do
    redirect_to :home
  end

  # ---INDEX-----------------------------------------------------------------------------
  def index
    @items = Item.all.order('purchase_date DESC').order('serial_equipment_number DESC')
    @loans = Loan.all
    @research_projects = ResearchProject.all
    if params[:id] != nil
      @inventory = Inventory.find(params[:id])
      @inventories = params[:id]
    end

    respond_to do |format|
      format.html
      format.csv { send_data @items.to_csv }
    end
  end

  # ---NEW-----------------------------------------------------------------------------
  def new
    @item = Item.new
    # build nested form attributes
    @item.build_loan
    @item.build_research_project
    @inventories = params[:id]
  end

  # ---CREATE-----------------------------------------------------------------------------
  def create
    @item = Item.new(item_params.except(:loan_attributes, :research_project_attributes))

    # initialise
    @item.disposed_of = false
    @item.loan_token = "not_loaned"
    @item.research_project_id = 1
    @inventories = @item.inventory_id
    passedTests = create_tests(@item, item_params)

    # if an item is in use, a record of this must be in Loan table
    if @item.in_use && passedTests
      @item.is_research_project = false

      name = item_params[:loan_attributes][:requestee_name]
      email = item_params[:loan_attributes][:requestee_email]
      ret_date = item_params[:loan_attributes][:due_date]

      @item.loan_token = set_loan_token

      @loan = Loan.new(:approved => true, :returned => false, :amount_requested => 1, :request_date => Date.today, :inventory_id => @item.inventory_id, :requestee_name => name, :requestee_email => email, :due_date => ret_date, :loan_token => @item.loan_token, :in_basket => false)

      if !@loan.save
        flash.now[:alert] = "Failed to save"
        @inventories = @item.inventory_id
        render :new
      end
      LoansMailer.admin_loan_user(@loan.id).deliver_now
    end

    # if an item is on a research project, record this
    if @item.is_research_project && passedTests
      researcherName = item_params[:research_project_attributes][:researcher_name]
      researcherEmail = item_params[:research_project_attributes][:researcher_email]

      if ResearchProject.where.not(:researcher_email => [nil, ""]).where(:researcher_email => researcherEmail).count >= 1
        @item.research_project_id = ResearchProject.where(:researcher_email => researcherEmail).first.id
      else
        @research_project = ResearchProject.new(:researcher_name => researcherName, :researcher_email => researcherEmail, :end_of_project => Date.today)

        if !@research_project.save
          flash.now[:alert] = "Failed to save"
          @inventories = @item.inventory_id
          render :new
        end

        @item.research_project_id = @research_project.id
      end
    end

    # sort out the inventories number count
    @inventory = Inventory.find(@item.inventory_id)
    if !@item.in_use && !@item.is_research_project
      @inventory.total_available = (@inventory.total_available + 1)
    end
    @inventory.total_stock = (@inventory.total_stock + 1)

    # tests not passed means invalid input
    if !passedTests
      flash.now[:alert] = "Failed: certain fields not filled in correctly"
      @inventories = @item.inventory_id
      render :new
    elsif @item.save && @inventory.save
      redirect_to items_path(:id => @item.inventory_id), notice: 'Added new device'
    else
      puts @item.errors.inspect
      puts @inventory.errors.inspect
      flash.now[:alert] = "Failed to save"
      @inventories = @item.inventory_id
      render :new
    end
  end

  # ---EDIT-----------------------------------------------------------------------------
  def edit
    @inventories = @item.inventory_id
  end

  # ---UPDATE-----------------------------------------------------------------------------
  def update
    i_params = item_params
    passedTests = update_tests(i_params, @item)

    # need to get param data to check new params against old attributes
    inUseVal = i_params[:in_use]
    isResearchProjectVal = i_params[:is_research_project]
    loanTokenVal = @item.loan_token
    inventoryIdVal = i_params[:inventory_id]
    @inventory = Inventory.find(inventoryIdVal)

    if (inUseVal == "1") || (isResearchProjectVal == "1")
      userNameVal =  i_params[:loan_attributes][:requestee_name]
      userEmailVal = i_params[:loan_attributes][:requestee_email]
      dueDate = i_params[:loan_attributes][:due_date]
      # use the below for date if not using html5 calender
      # Date.parse("#{i_params['loan_attributes']['due_date(3i)']}-#{i_params['loan_attributes']['due_date(2i)']}-#{i_params['loan_attributes']['due_date(1i)']}")

      inventoryIdVal = i_params[:inventory_id]
      researcherNameVal = i_params[:research_project_attributes][:researcher_name]
      researcherEmailVal = i_params[:research_project_attributes][:researcher_email]
      loanDel = false
      researchDel = false
    end

    # if item now in use, need new loan
    # elsif item was already in use and still is, update loan record
    # elsif item not in use now but it was, destroy loan record
    if (inUseVal == "1") && (loanTokenVal == "not_loaned") && passedTests
      puts 'Reached1'
      @item.loan_token = set_loan_token
      @loan = Loan.new(:approved => true, :returned => false, :inventory_id => inventoryIdVal, :requestee_name => userNameVal, :requestee_email => userEmailVal, :due_date => dueDate, :loan_token => @item.loan_token, :amount_requested => 1, :request_date => Date.today, :in_basket => false)

      # sort out the inventories number count
      @inventory.total_available = (@inventory.total_available - 1)

      if !@loan.save
        flash.now[:alert] = "Failed to update"
        @inventories = inventoryIdVal
        render :edit
      end

      LoansMailer.admin_loan_user(@loan.id).deliver_now
    elsif (inUseVal == "1") && (loanTokenVal != "not_loaned") && passedTests
      puts 'reached2'
      @loan = Loan.where(:loan_token => loanTokenVal).first
      if !@loan.update(:requestee_name => userNameVal, :requestee_email => userEmailVal, :due_date => dueDate)
        flash.now[:alert] = "Failed to update"
        @inventories = inventoryIdVal
        render :edit
      end
    elsif (inUseVal == "0") && (loanTokenVal != "not_loaned") && passedTests
      puts 'reached3'
      puts inUseVal
      puts loanTokenVal
      @loan = Loan.where(:loan_token => loanTokenVal).first

      retLate = false
      if @loan.due_date < Date.today
        retLate = true
      end
      @loan_history = LoanHistory.new(:returned_on => Date.today, :late => retLate, :item_id => @item.id, :loan_id => @loan.id)
      if !@loan_history.save
        flash.now[:alert] = "Failed to update"
        @inventories = inventoryIdVal
        render :edit
      end

      # can't delete loan if more items are still reffed to the same loan
      if @loan.amount_requested <= 1
        @loan.amount_requested = (@loan.amount_requested - 1)
        loanDel = true
      else
        @loan.amount_requested = (@loan.amount_requested - 1)
        if !@loan.save
          flash.now[:alert] = "Failed to save"
          @inventories = inventoryIdVal
          render :edit
        end
      end

      @item.loan_token = "not_loaned"
      @inventory.total_available = (@inventory.total_available + 1)
    end

    # if item now research project, check projects for email, otherwise new rp
    # elsif item has current project, check emails are same and update name, otherwise new rp
    # elsif item is now not project, check if this is last item on project
    if (isResearchProjectVal == "1") && (@item.research_project_id == 1) && passedTests
      if ResearchProject.where.not(:researcher_email => "NO EMAIL").where(:researcher_email => researcherEmailVal).count >= 1
        @item.research_project_id = ResearchProject.where(:researcher_email => researcherEmailVal).first.id
      else
        @research_project = ResearchProject.new(:researcher_name => researcherNameVal, :researcher_email => researcherEmailVal, :end_of_project => Date.today)

        if !@research_project.save
          flash.now[:alert] = "Failed to save"
          @inventories = inventoryIdVal
          render :edit
        end

        @item.research_project_id = @research_project.id

      end
      @inventory.total_available = (@inventory.total_available - 1)
    elsif (isResearchProjectVal == "1") && (@item.research_project_id != 1) && passedTests
      @current_project = ResearchProject.find(@item.research_project_id)

      if researcherEmailVal == @current_project.researcher_email
        if !@current_project.update(:researcher_name => researcherNameVal)
          flash.now[:alert] = "Failed to update"
          @inventories = inventoryIdVal
          render :edit
        end
      elsif researcherEmailVal != @current_project.researcher_email
        if ResearchProject.where.not(:researcher_email => "NO EMAIL").where(:researcher_email => researcherEmailVal).count >= 1
          @item.research_project_id = ResearchProject.where(:researcher_email => researcherEmailVal).first.id
        else
          @research_project = ResearchProject.new(:researcher_name => researcherNameVal, :researcher_email => researcherEmailVal, :end_of_project => Date.today)

          if !@research_project.save
            flash.now[:alert] = "Failed to save"
            @inventories = inventoryIdVal
            render :edit
          end

          @item.research_project_id = @research_project.id
        end
      end
    elsif (isResearchProjectVal == "0") && (@item.research_project_id != 1) && passedTests
      if Item.where(:research_project_id => @item.research_project_id).count <= 1
        @research_project = ResearchProject.find(@item.research_project_id)
        researchDel = true
      end
      @item.research_project_id = 1
      @inventory.total_available = (@inventory.total_available + 1)
    end

    # updating database
    if !passedTests
      flash.now[:alert] = "Failed: certain fields not filled correctly"
      @inventories = @item.inventory_id
      render :edit
    elsif loanDel
      if @item.update(i_params.except(:loan_attributes, :research_project_attributes)) && @loan.update_attributes(:returned => true) && @inventory.save
        redirect_to items_path(:id => @item.inventory_id), notice: 'Device updated successfully'
      else
        flash.now[:alert] = "Failed to update"
        @inventories = @item.inventory_id
        render :edit
      end
    elsif researchDel
      if @item.update(i_params.except(:loan_attributes, :research_project_attributes)) && @research_project.destroy && @inventory.save
        redirect_to items_path(:id => @item.inventory_id), notice: 'Device updated successfully'
      else
        flash.now[:alert] = "Failed to update"
        @inventories = @item.inventory_id
        render :edit
      end
    elsif @item.update(item_params.except(:loan_attributes, :research_project_attributes)) && @inventory.save
      redirect_to items_path(:id => @item.inventory_id), notice: 'Device updated successfully'
    else
      flash.now[:alert] = "Failed to update"
      @inventories = @item.inventory_id
      render :edit
    end

  end

  # ---DESTROY-----------------------------------------------------------------------------
  def destroy
    onLoan = false
    if @item.loan_token != "not_loaned" && !@item.is_research_project
      onLoanOrProject = true
    end

    # sort out inventory values
    @inventoryId = @item.inventory_id
    @inventory = Inventory.find(@inventoryId)
    @inventory.total_available = (@inventory.total_available - 1)
    @inventory.total_stock = (@inventory.total_stock - 1)

    # dont actually 'destroy' but dispose
    if !onLoanOrProject
      if @item.update_attributes(:disposed_of => true)  && @inventory.save && Disposed.create(:item_id => @item.id, :date_disposed => Time.now)
        redirect_to items_path(:id => @inventoryId), notice: 'Device disposed'
      else
        redirect_to items_path(:id => @inventoryId), alert: 'Failed to dispose'
      end
    else
      redirect_to items_path(:id => @inventoryId), alert: 'Cannot dispose of a device currently being used!'
    end
  end

  # ---PRIVATE-----------------------------------------------------------------------------
  private

    def create_tests(item, i_params)
      passed = true

      if !item.serial_equipment_number.present?
        passed = false
      elsif Item.where(serial_equipment_number: item.serial_equipment_number).count >= 1
        passed = false
      elsif !item.model_type.present?
        passed = false
      elsif !item.purchase_date.present?
        passed = false
      elsif item.purchase_date > Date.today
        passed = false
      elsif item.in_use && @item.is_research_project
        passed = false
      elsif item.in_use
        if !i_params[:loan_attributes][:requestee_name].present? || !i_params[:loan_attributes][:requestee_email].present? || !i_params[:loan_attributes][:due_date].present?
          passed = false
        end
      elsif item.is_research_project
        if !i_params[:research_project_attributes][:researcher_email].present?
          passed = false
        end
      end

      return passed
    end

    def update_tests(i_params, item)
      passed = true

      if !i_params[:serial_equipment_number].present?
        passed = false
      elsif Item.where(serial_equipment_number: i_params[:serial_equipment_number]).count > 1
        passed = false
      elsif !i_params[:model_type].present?
        passed = false
      elsif !i_params[:purchase_date].present?
        passed = false
      elsif Date.parse("#{i_params[:purchase_date]}") > Date.today
        passed = false
      elsif item.in_use && (i_params[:is_research_project] == "1")
        passed = false
      elsif item.is_research_project && (iparams[:in_use] == "1")
        passed = false
      elsif (i_params[:is_research_project] == "1") && (i_params[:in_use] == "1")
        passed = false
      elsif i_params[:in_use] == "1"
        if !i_params[:loan_attributes][:requestee_name].present? || !i_params[:loan_attributes][:requestee_email].present? || !i_params[:loan_attributes][:due_date].present?
          passed = false
        end
      elsif i_params[:is_research_project] == "1"
        if !i_params[:research_project_attributes][:researcher_email].present?
          passed = false
        end
      end

      return passed
    end

    def item_params
      params.require(:item).permit(:model_type, :serial_equipment_number, :purchase_price, :purchase_date, :is_research_project, :inventory_id, :item_location,:in_use, :loan_attributes => [:requestee_name, :requestee_email, :due_date, :id], :research_project_attributes => [:researcher_name, :researcher_email, :id])
    end

    def find_items_from_params
      @item = Item.find(params[:id])
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
