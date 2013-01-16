class EnergyMetricsTasksController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    @energy_metrics_task.status = params[:task_status] unless @energy_metrics_task.nil? || params[:task_status].nil?
    if @energy_metrics_task.update_attributes(params[:energy_metrics_task])
      redirect_to(footprint_report_page_path, :notice => 'Energy supplies successfully updated.')
    else
      render :action => "edit"
    end
  end

end
