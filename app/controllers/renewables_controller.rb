class RenewablesController < ApplicationController
  load_and_authorize_resource

  def edit

  end

  def update
    renewable_task = @renewable.renewable_task;
    renewable_task.status = params[:task_status] unless params[:task_status].nil? || renewable_task.nil?

    if @renewable.update_attributes(params[:renewable])
        renewable_task.save
       redirect_to(edit_renewable_path, :notice => 'Renewable was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
end
