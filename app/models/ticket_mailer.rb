class TicketMailer < ActionMailer::Base
  def ticket_opened(support_ticket)
    recipients    [support_ticket.user.email, "e-MissionManagement <support@e-missionmanagement.com>"]
    from          "e-MissionManagement <support@e-missionmanagement.com>"
    subject       "Support Ticket Opened"
    sent_on       TimeUtils.make_gmt(Time.now)
    body          :support_ticket => support_ticket
  end
end
