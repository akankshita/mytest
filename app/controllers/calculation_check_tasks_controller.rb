class CalculationCheckTasksController < ApplicationController
  load_and_authorize_resource

  # GET /calculation_check_tasks/1/edit
  def edit
      end

  # PUT /calculation_check_tasks/1
  def update
      if @calculation_check_task.update_attributes(params[:calculation_check_task])
        redirect_to(footprint_report_page_path, :notice => 'Calculation check task was successfully updated.') 
      else
        render :action => "edit" 
      end
  end

end
