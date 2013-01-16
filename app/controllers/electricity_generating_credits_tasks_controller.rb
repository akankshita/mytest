class ElectricityGeneratingCreditsTasksController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
      @electricity_generating_credits_task.status = params[:task_status] unless params[:task_status].nil? || @electricity_generating_credits_task.nil?

      if @electricity_generating_credits_task.update_attributes(params[:electricity_generating_credits_task])
        redirect_to(annual_reports_path, :notice => 'Electricity generating credits successfully reported')
      else
        render :action => "edit"
      end
      
    end
end
