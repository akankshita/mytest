class ReportOtherFuelsTasksController < ApplicationController
  load_and_authorize_resource

  def edit

    end

  def update
    @report_other_fuels_task.status = params[:task_status] unless params[:task_status].nil? || @report_other_fuels_task.nil?

    if @report_other_fuels_task.update_attributes(params[:report_other_fuels_task])
      redirect_to(annual_reports_path, :notice => 'Successfully saved other fuels used')
    else
      render :action => "edit"
    end
  end

end
