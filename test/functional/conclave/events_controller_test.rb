require File.dirname(__FILE__) + '/../../test_helper'

require File.dirname(__FILE__) + '/../../../../tog_user/lib/authenticated_test_helper'
class Conclave::EventsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  def setup
    @admin_user = Factory(:user, :login => 'admin_user', :admin => true)
    @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
    @event = Factory(:event, :owner => @admin_user)
  end
    
  def test_should_get_index_with_one_event
    get :index
    assert_response :success
    assert_not_nil assigns["events"]
    assert_equal 1, assigns["events"].length
  end

  def test_should_have_zero_attendees
    get :show, :id => @event.id    
    assert_response :success
    assert_not_nil assigns["event"]
    assert_equal 0, assigns["event"].attendees.length
  end
  
end
