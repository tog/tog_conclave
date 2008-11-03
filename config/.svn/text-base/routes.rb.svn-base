namespace(:conclave) do |conclave|
  conclave.resources :events
end

with_options(:controller => 'conclave/events', :conditions => { :method => :get }) do |event|
  event.by_date_conclave_events      '/conclave/events/by_date/:date', :action => 'by_date'  
end

namespace(:member) do |member|
  member.namespace(:conclave) do |conclave|
    conclave.register "/events/register/:id", :controller => "events", :action => "register"
    conclave.unregister "/events/unregister/:id", :controller => "events", :action => "unregister"
    conclave.resources :events
  end
end

namespace(:admin) do |admin|
  admin.namespace(:conclave) do |conclave|
    conclave.resources :events
  end
end