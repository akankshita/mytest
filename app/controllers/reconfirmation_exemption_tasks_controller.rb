class ReconfirmationExemptionTasksController < ApplicationController
  load_and_authorize_resource

  def edit
    #TODO: FL - must make the phases flexible after the first year (note: its probably a good idea to do a directory grep for "{:phase => 1}")

    footprint_report = FootprintReport.first(:conditions => {:phase => 1})
    @reconfirmation_exemption_task = footprint_report.reconfirmation_exemption_task
  end

  def update
    @reconfirmation_exemption_task.status = params[:task_status] unless @reconfirmation_exemption_task.nil? || params[:task_status].nil?
    if @reconfirmation_exemption_task.update_attributes(params[:reconfirmation_exemption_task])
      redirect_to(footprint_report_page_path, :notice => 'successfully reconfirmed CCA exemptions.')
    else
      render :action => "edit"
    end
  end

end
