require File.dirname(__FILE__) + '/../../../test_helper'

require File.dirname(__FILE__) + '/../../../../../tog_user/lib/authenticated_test_helper'
class Member::Conclave::EventsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  def setup
    @admin_user = Factory(:user, :login => 'admin_user', :admin => true)
    @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
    @attendee_user = Factory(:user, :login => 'attendee_user', :admin => false)    
    @event = Factory(:event, :owner => @admin_user)
    @event.register(@attendee_user)
  end

  def test_should_get_index_with_zero_events
    @request.session[:user_id] = @normal_user
    get :index
    assert_response :success
    assert_not_nil assigns["events"]
    assert_equal 0, assigns["events"].length
  end
      
  def test_should_get_index_with_one_event
    @request.session[:user_id] = @attendee_user
    get :index
    assert_response :success
    assert_not_nil assigns["events"]
    assert_equal 1, assigns["events"].length
  end

  def test_should_be_added_as_attendee
    @request.session[:user_id] = @normal_user
    get :register, :id => @event.id    
    _event = assigns["event"]
    assert_not_nil _event
    assert_equal 2, _event.attendees.length
  end
    
  def test_should_be_removed_as_attendee
    @request.session[:user_id] = @attendee_user
    get :unregister, :id => @event.id    
    _event = assigns["event"]
    assert_not_nil _event
    assert_equal 0, _event.attendees.length
  end
  
end
