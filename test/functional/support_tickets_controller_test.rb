require 'test_helper'

class SupportTicketsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    SupportTicket.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    SupportTicket.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
end
