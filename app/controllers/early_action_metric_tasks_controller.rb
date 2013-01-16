class EarlyActionMetricTasksController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if(params[:early_action_metric_task][:scheme_provider] != nil && params[:early_action_metric_task][:scheme_provider] != "")
        params[:early_action_metric_task][:scheme_provider] = SchemeProvider.find(params[:early_action_metric_task][:scheme_provider])
    else 
        params[:early_action_metric_task][:scheme_provider] = nil
    end

    @early_action_metric_task.status = params[:task_status] unless params[:task_status].nil? || @early_action_metric_task.nil?

    if @early_action_metric_task.update_attributes(params[:early_action_metric_task])
      redirect_to annual_reports_path, :notice => 'Early action metric was successfully saved.'
    else
      render :action => "edit" 
    end
  end
end
