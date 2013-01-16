class DesignatedChangesController < ApplicationController
  load_and_authorize_resource

  def edit
    @formatted_date_string = TimeUtils.to_uk_date_s(@designated_change.date_of_change)
  end
    
  def update
    @designated_change.designated_changes_task.status = params[:task_status] unless params[:task_status].nil? || @designated_change.designated_changes_task.nil?

    params[:designated_change][:date_of_change] = TimeUtils.parse_european_date(params[:designated_change][:date_of_change]) unless params[:designated_change][:date_of_change].nil? || params[:designated_change][:date_of_change] == ""

    if @designated_change.update_attributes(params[:designated_change])

      @designated_change.designated_changes_task.save unless @designated_change.designated_changes_task.nil?
      redirect_to(footprint_report_page_path, :notice => 'Report designated changes were successfully updated.')
    else
      render :action => "edit"
    end
  end
  
end
