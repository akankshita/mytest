class GrowthMetricTasksController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    @growth_metric_task.status = params[:task_status] unless params[:task_status].nil? || @growth_metric_task.nil?

    if @growth_metric_task.update_attributes(params[:growth_metric_task])
      redirect_to(annual_reports_path, :notice => 'Growth metric data was successfully updated.') 
    else
      render :action => "edit"
    end
  end
end
