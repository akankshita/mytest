class EmissionMetricsTasksController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    @emission_metrics_task.status = params[:task_status] unless @emission_metrics_task.nil? || params[:task_status].nil?

    if @emission_metrics_task.update_attributes(params[:emission_metrics_task])
      redirect_to(footprint_report_page_path, :notice => 'Report metric emissions were successfully updated.')
    else
      render :action => "edit"
    end
  end

end
