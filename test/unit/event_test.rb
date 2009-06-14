require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  
  should_have_many :attendances
  should_belong_to :owner
  
  should_validate_presence_of :title, :description, :venue, :start_date, :end_date, :start_time, :end_time
    
  
  context "An event" do
    
    setup do
      @event = Factory(:event)
    end
        
  end
end