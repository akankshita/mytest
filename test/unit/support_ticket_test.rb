require 'test_helper'

class SupportTicketTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert SupportTicket.new.valid?
  end
end
