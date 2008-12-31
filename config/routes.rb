namespace(:conclave) do |conclave|
  conclave.resources :events, :member => {:map => :get}, :collection => {:tag => :get}
end

with_options(:controller => 'conclave/events') do |event|
  event.calendar_navigation   '/conclave/events/cal/:year/:month', :action => 'calendar_navigation'
  event.with_options(:action => 'date', :conditions => { :method => :get }) do |date|
     date.daily_conclave_events   '/conclave/events/date/:year/:month/:day', :action => 'date'
     date.monthly_conclave_events '/conclave/events/date/:year/:month', :day => nil, :action => 'date'
  end  
end

namespace(:member) do |member|
  member.namespace(:conclave) do |conclave|
    conclave.register "/events/register/:id", :controller => "events", :action => "register"
    conclave.unregister "/events/unregister/:id", :controller => "events", :action => "unregister"
    conclave.attendees "/events/attendees/:id", :controller => "events", :action => "attendees"
    conclave.resources :events
  end
end

namespace(:admin) do |admin|
  admin.namespace(:conclave) do |conclave|
    conclave.resources :events
  end
end
