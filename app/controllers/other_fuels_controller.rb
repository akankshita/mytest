class OtherFuelsController < ApplicationController
  before_filter :load_drop_downs

  load_and_authorize_resource

  # GET /other_fuels
  def index
    #TODO BoD remove the reference to phase one
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    @other_fuels_task = footprint_report.other_fuels_task unless footprint_report.nil?
    @other_fuels = @other_fuels_task.other_fuels unless @other_fuels_task.nil?
  end


  def status
    #TODO BoD remove the reference to phase one
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    @other_fuels_task = footprint_report.other_fuels_task unless footprint_report.nil?
    @other_fuels = @other_fuels_task.other_fuels unless @other_fuels_task.nil?

    @other_fuels_task.status = params[:task_status] unless params[:task_status].nil?

    if(@other_fuels_task.save)
      flash[:notice] = "Other fuels task status was successfully changed."
      redirect_to cca_exemptions_path
    end
  end

  # GET /other_fuels/1
  def show
  end

  # GET /other_fuels/new
  def new
  	@all_units = Unit.all(:order => 'id desc')
  
    footprint_report = FootprintReport.first(:conditions => {:phase => 1}) 
    @other_fuel = footprint_report.other_fuels_task.other_fuels.build

  end

  # GET /other_fuels/1/edit
  def edit
    @all_units = Unit.all(:order => 'id desc')
  end

  # POST /other_fuels
  def create
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    other_fuels_task = footprint_report.other_fuels_task unless footprint_report.nil?
    @all_units = Unit.all(:order => 'id desc')

    @other_fuel = other_fuels_task.other_fuels.build(params[:other_fuel])

      if @other_fuel.save
       redirect_to(@other_fuel, :notice => 'Other Fuel was successfully created.') 
      else
       render :action => "new" 
      end
      
  end

  # PUT /other_fuels/1
  def update

    params[:other_fuel][:unit] = Unit.find(params[:other_fuel][:unit])
    @all_units = Unit.all(:order => 'id desc')

      if @other_fuel.update_attributes(params[:other_fuel])
        redirect_to(@other_fuel, :notice => 'Other Fuel was successfully updated.') 
      else
        render :action => "edit" 
      end
  end

  # DELETE /other_fuels/1
  def destroy
    @other_fuel.destroy

    redirect_to(other_fuels_url)
  end

  private

  def load_drop_downs
    if (params[:other_fuel][:unit] != nil && params[:other_fuel][:unit] != "")
        params[:other_fuel][:unit] = Unit.find(params[:other_fuel][:unit])
      else
        params[:other_fuel][:unit] = nil
      end unless params.nil? || params[:other_fuel].nil?
  end

end
