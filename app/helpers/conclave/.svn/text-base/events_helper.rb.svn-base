module Conclave
  module EventsHelper

    def dates_with_events()
      events = Conclave::Event.find(:all)
      dates = Array.new
      events.each{|event|
        dates[dates.size] = event.start_date if !dates.include?(event.start_date)
      }
      return dates
    end
      
  end
  
end
