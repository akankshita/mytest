class ResidualEmissionsController < ApplicationController
  before_filter :load_drop_downs

  load_and_authorize_resource

  def index
    #TODO BoD remove the reference to phase one
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    @residual_emissions_task = footprint_report.residual_emissions_task unless footprint_report.nil?
    @residual_emissions = @residual_emissions_task.residual_emissions unless @residual_emissions_task.nil?
  end

  def status
    #TODO BoD remove the reference to phase one
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    @residual_emissions_task = footprint_report.residual_emissions_task unless footprint_report.nil?
    @residual_emissions = @residual_emissions_task.residual_emissions unless @residual_emissions_task.nil?

    if (@residual_emissions_task.save)
      flash[:notice] = "flash[:notice] = Residual emissions task status was successfully changed."
      redirect_to residual_emissions_path
    end
  end

  # GET /residual_emissions/1
  def show

  end

  # GET /residual_emissions/new
  def new
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    @residual_emission = footprint_report.residual_emissions_task.residual_emissions.build

    @all_fuels = FuelList.all(:order => 'id desc')
  end

  # GET /residual_emissions/1/edit
  def edit
    @all_fuels = FuelList.all(:order => 'id desc')
  end

  # POST /residual_emissions
  def create
    #TODO BoD remove the reference to phase one
    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    residual_emissions_task = footprint_report.residual_emissions_task unless footprint_report.nil?


    @all_fuels = FuelList.all(:order => 'id desc')

    @residual_emission = residual_emissions_task.residual_emissions.build(params[:residual_emission])

    if @residual_emission.save
      redirect_to(@residual_emission, :notice => 'Residual Emission was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /residual_emissions/1
  def update
    @all_fuels = FuelList.all(:order => 'id desc')

    if @residual_emission.update_attributes(params[:residual_emission])
      redirect_to(@residual_emission, :notice => 'ResidualEmission was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /residual_emissions/1
  def destroy
    @residual_emission.destroy

    redirect_to(residual_emissions_url)
  end

  private

  def load_drop_downs
    if (params[:residual_emission][:fuel_list] != nil && params[:residual_emission][:fuel_list] != "")
       params[:residual_emission][:fuel_list] = FuelList.find(params[:residual_emission][:fuel_list])
     else
       params[:residual_emission][:fuel_list] = nil
     end unless params.nil? || params[:residual_emission].nil?
  end
end
