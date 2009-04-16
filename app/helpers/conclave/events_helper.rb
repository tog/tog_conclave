module Conclave
  module EventsHelper
    
    def write_event_date(event)
      if (event.start_date != event.end_date)
        "#{I18n.t('tog_conclave.site.from')} #{event.starting_date} #{I18n.t('tog_conclave.site.to')} #{event.ending_date}"
      else
        event.starting_date
      end
    end
    
    def write_date(year, month, day=-1)
      date = Date.civil(year, month, day)
      if day && day > 0
        I18n.l(date, :format => :long)
      else
        I18n.l(date, :format => "%B %Y")
      end
    end

    def events_for_month(year, month)
      year = Date.today.year if !year
      month = Date.today.month if !month
      
      month_first_day = Date.civil(year, month, 1)
      month_last_day = Date.civil(year, month, -1)
      events = Event.find(:all,
                          :conditions => ['(start_date >= ? and start_date <= ?) or (end_date >= ? and end_date <= ?)', 
                                          month_first_day, month_last_day, month_first_day, month_last_day], 
                          :order => "start_date asc, start_time asc")      
    end
    
    def calendar_events_proc(events)
      lambda do |day|
        if has_event?(day, events)
          [link_to(day.day, daily_conclave_events_path(day.year, day.month, day.day)), { :class => "with_events" }]
        else
          day.day
        end
      end
    end

    def tag_cloud_events(classes)
      tags = Event.tag_counts
      return if tags.empty?
      max_count = tags.sort_by(&:count).last.count.to_f
      tags.each do |tag|
        index = ((tag.count / max_count) * (classes.size - 1)).round
        yield tag, classes[index]
      end
    end

    private
    
      def has_event?(date, events)
        !events.select{|e| e.start_date <= date && e.end_date >= date}.blank?
      end
    
  end
  
end
