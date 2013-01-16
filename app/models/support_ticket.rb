class SupportTicket < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :subject, :message
end
