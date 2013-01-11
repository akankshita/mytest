class DisclosureTasksController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    @disclosure_task.status = params[:task_status] unless params[:task_status].nil? || @disclosure_task.nil?

    if @disclosure_task.update_attributes(params[:disclosure_task])
      redirect_to(annual_reports_path, :notice => 'Additional disclosure information was successfully saved.')
    else
      render :action => "edit"
    end
  end
end
