class SignificantGroupUndertakingsController < ApplicationController
  load_and_authorize_resource

  def index
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    @significant_group_undertakings_task = annual_report.significant_group_undertakings_task unless annual_report.nil?

    setup_for_index
  end

  def status
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    @significant_group_undertaking_task = annual_report.significant_group_undertakings_task unless annual_report.nil?
    @significant_group_undertaking_task.status = params[:task_status] unless @significant_group_undertaking_task.nil? && params[:task_status].nil?

    if (@significant_group_undertaking_task.save)
      flash[:notice] = "Significant group undertaking task status was successfully changed."
      redirect_to(:controller => "annual_reports", :action => "index")
    end
  end

  def show
  end


  def new
  end

  def edit
  end

  def create
    setup_for_index

    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    significant_group_undertakings_task = annual_report.significant_group_undertakings_task unless annual_report.nil?
    @significant_group_undertaking.significant_group_undertakings_task = significant_group_undertakings_task

    if @significant_group_undertaking.save
      redirect_to(significant_group_undertakings_path, :notice => 'Significant group undertaking was successfully recorded.')
    else
      render :action => "new"
    end
  end

  def update
    setup_for_index


    if @significant_group_undertaking.update_attributes(params[:significant_group_undertaking])
      redirect_to(significant_group_undertakings_path, :notice => 'Significant group undertaking was successfully edited.')
    else
      render :action => "edit"
      render :xml => @significant_group_undertaking.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    @significant_group_undertaking.destroy

    redirect_to(significant_group_undertakings_url)
  end

  def setup_for_index
    @significant_group_undertakings = Array.new
    annual_report = AnnualReport.first(:conditions => {:phase => 1})
    significant_group_undertakings_task = annual_report.significant_group_undertakings_task unless annual_report.nil?
    @significant_group_undertakings = significant_group_undertakings_task.significant_group_undertakings unless significant_group_undertakings_task.nil?
  end
end
