class ConfirmEnergySupplyTaskController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    @confirm_energy_supply_task.status = params[:task_status] unless params[:task_status].nil?

    if @confirm_energy_supply_task.update_attributes(params[:confirm_energy_supply_task])
       redirect_to(annual_reports_path, :notice => 'Energy supply successfully confirmed')
    else
       render :action => "edit" 
    end

  end
end
