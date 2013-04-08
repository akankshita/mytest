class UserSessionsController < ApplicationController
  def new

    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      flash[:notice] = 'Successfully logged in'

      #record in login in db
      Record.stamp(Activity.action('logon'), current_user.id, LoggingUtils.get_ip(request.env))

      redirect_to root_url
    else
      #record the failed attempt
      Record.stamp(Activity.action('failed_logon'), -1, LoggingUtils.get_ip(request.env))

      render :action => "new"
    end
  end

  def destroy
    Record.stamp( Activity.action('logoff'), current_user.id, LoggingUtils.get_ip(request.env) )
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = 'Successfully logged out'
    redirect_to root_url
  end
end
