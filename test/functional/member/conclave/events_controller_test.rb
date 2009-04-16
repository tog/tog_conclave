require File.dirname(__FILE__) + '/../../../test_helper'

class Member::Conclave::EventsControllerTest < ActionController::TestCase
  
  context "Events controller in member's area" do
  
    context "without a logged user" do
      setup do
        get :new
      end
      should_redirect_to "new_session_path"
    end
  
    context "with a logged user" do
      setup do
        @chavez = Factory(:user, :login => 'chavez')
        @request.session[:user_id] = @chavez.id
      end
    
      context "on GET to :new" do
        setup do
          get :new
        end
        should_respond_with :success
        should_assign_to :event
        should_render_template :new
        should "create a passive event" do
          assert_equal true, assigns(:event).new_record?             
        end
      end 
      
      context "on POST to :create with correct data" do
        setup do
          @estart = Time.now + 1.day
          @eend = Time.now + 2.day + 3.hour
          post :create, :event => { :title => 'Party at home',
                                    :description => 'Party at home',
                                    :venue => 'home',
                                    :start_date => @estart, :start_time => @estart,
                                    :end_date => @eend, :end_time => @eend
                                  }
        end

        should_assign_to :event
        should_set_the_flash_to /created/i
        should_redirect_to "member_conclave_events_path"
        should "create an event" do
          @event = Event.find(assigns(:event).id)
          assert @event
          assert_contains @chavez.events, @event
          assert_equal false, assigns(:event).site_wide
          assert_equal @estart, assigns(:event).start_time
          assert_equal @eend, assigns(:event).end_time
          assert_equal 'Party at home', assigns(:event).title
        end       
      end      
          
    end  
    
  end
end