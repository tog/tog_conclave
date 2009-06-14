namespace(:conclave) do |conclave|
  conclave.resources :events, :member => {:map => :get, :attendees => :get}
end

with_options(:controller => 'conclave/events') do |event|
  event.tag_conclave_events   '/conclave/events/tag/:tag', :action => 'tag'
  event.calendar_navigation   '/conclave/events/cal/:year/:month', :action => 'calendar_navigation'
  event.with_options(:action => 'date', :conditions => { :method => :get }) do |date|
     date.daily_conclave_events   '/conclave/events/date/:year/:month/:day', :action => 'date'
     date.monthly_conclave_events '/conclave/events/date/:year/:month', :day => nil, :action => 'date'
  end  
end

namespace(:member) do |member|
  member.namespace(:conclave) do |conclave|
    conclave.attendances "/events/attendances", :controller => "attendances", :action => "index"
    conclave.resources :events, :member => {:attendees => :get } do |event|
      event.resources :attendances
    end
  end
end

namespace(:admin) do |admin|
  admin.namespace(:conclave) do |conclave|
    conclave.resources :events
  end
end
