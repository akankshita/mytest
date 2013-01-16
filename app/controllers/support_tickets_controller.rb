class SupportTicketsController < ApplicationController
  load_and_authorize_resource

  def new

  end

  def create
    @support_ticket.user = current_user
    if @support_ticket.save
      TicketMailer.deliver_ticket_opened(@support_ticket)
      flash[:notice] = "Successfully created support ticket."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
end
