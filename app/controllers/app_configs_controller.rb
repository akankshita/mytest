class AppConfigsController < ApplicationController
  def show
    @app_config = AppConfig.first
  end

  def edit
    @app_config = AppConfig.first
  end
  
  def update
    
    if AppConfig.first.update_attributes(params[:app_config])
      flash[:notice] = "Successfully updated app config."
      redirect_to AppConfig.first
    else
      render :action => 'edit'
    end
  end
end
