# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #check_authorization
before_filter :menu



  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  def menu
    if (params[:controller] == "gas_readings" or params[:controller] == "gas_uploads" or params[:controller] == "electricity_readings" or params[:controller] == "electricity_uploads" )
      @hback = ''
      @uback = 'background:#37910E;margin-top:2px;height:36px;'
      @rback = ''
      @dback = ''
      @gback = ''
      @aback = ''
      @helpback = ''
    elsif(params[:controller] == "annual_reports" or params[:controller] == "footprint_report_page")
      @hback = ''
      @uback = ''
      @rback = 'background:#37910E;margin-top:2px;height:36px;'
      @dback = ''
      @gback = ''
      @aback = ''
      @helpback = ''
    elsif(params[:controller] == "document_uploads" )
      @hback = ''
      @uback = ''
      @rback = ''
      @dback = 'background:#37910E;margin-top:2px;height:36px;'
      @gback = ''
      @aback = ''
      @helpback = ''
    elsif(params[:controller] == "status_home" or params[:controller] == "electricity_summary" or params[:controller] == "gas_summary" or params[:controller] == "electricity_detail" or params[:controller] == "gas_detail" or params[:controller] == "profiles")
      @hback = ''
      @uback = ''
      @rback = ''
      @dback = ''
      @gback = 'background:#37910E;margin-top:2px;height:36px;'
      @aback = ''
      @helpback = ''
    elsif(params[:controller] == "users" or params[:controller] == "conversion_factors" or params[:controller] == "source_manager" or params[:controller] == "activity_logs")
      @hback = ''
      @uback = ''
      @rback = ''
      @dback = ''
      @gback = ''
      @aback = 'background:#37910E;margin-top:2px;height:36px;'
      @helpback = ''
    elsif(params[:controller] == "welcome" or params[:controller] == "support_tickets" )
      @hback = ''
      @uback = ''
      @rback = ''
      @dback = ''
      @gback = ''
      @aback = ''
      @helpback = 'background:#37910E;margin-top:2px;height:36px;'
    else
      @hback = 'background:#37910E;margin-top:2px;height:36px;'
      @uback = ''
      @rback = ''
      @dback = ''
      @gback = ''
      @aback = ''
      @helpback = ''
    end
    #render :text => params.inspect
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = "Access Denied.  Please log in"
    redirect_to root_url
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    if(current_user.nil?)
      flash[:notice] = "Access Denied.  Please log in"
      redirect_to root_url
#    else
#      throw exception
    end
  end


  helper_method :format_decimal, :current_user, :graph_max_points, :crc_enabled, :gas_enabled, :compare_meters_enabled

  private
    def format_decimal(decimal)
      format("%.2f",decimal)
    end

    def graph_max_points
      750 #DEBT: should be a config value in db perhaps base on the browser/platform being used. 
    end

   def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  #used for app customization
  def crc_enabled
    app_config = AppConfig.first
    if(app_config.nil?)
      return true
    end
    return app_config.crc?
  end

  def gas_enabled
    app_config = AppConfig.first
    if(app_config.nil?)
      return true
    end
    return app_config.gas?
  end
  
  def compare_meters_enabled
     app_config = AppConfig.first
     if(app_config.nil?)
       return true
     end
     return app_config.compare_meters?
   end

end
