module Conclave
  module EventsHelper

    def write_date(year, month, day)
      @monthnames = I18n.t("tog_conclave.calendar.monthnames").split if !@monthnames
      month_name = @monthnames[month - 1]
      if day && day > 0
        "#{day} de #{month_name} #{year}"
      else
        "#{month_name} #{year}"
      end
    end
    
    def dates_with_events()
      events = Conclave::Event.find(:all)
      dates = Array.new
      events.each{|event|
        dates[dates.size] = event.start_date if !dates.include?(event.start_date)
      }
      return dates
    end

    def events_for_month(year, month)
      month_first_day = Date.civil(year, month, 1)
      month_last_day = Date.civil(year, month, -1)
      events = Event.find(:all,
                          :conditions => ['(start_date >= ? and start_date <= ?) or (end_date >= ? and end_date <= ?)', 
                                          month_first_day, month_last_day, month_first_day, month_last_day], 
                          :order => "start_date asc, start_time asc")      
    end
    
    def conclave_calendar(year, month, events=nil, week_start=1)
      @monthnames = I18n.t("tog_conclave.calendar.monthnames").split if !@monthnames
      @abbr_daynames = I18n.t("tog_conclave.calendar.abbr_daynames").split if !@abbr_daynames
      month_name = @monthnames[month - 1]
      
      month_first_day = Date.civil(year, month, 1)
      month_last_day = Date.civil(year, month, -1)      
      
      result = "<table><tbody>"
      result << "<tr><td>"
      nav_month = month_first_day - 1.month
      result << link_to_remote("<<", :update => "conclave_calendar", 
                                     :url => calendar_navigation_path(nav_month.year, nav_month.month))
      result << "</td><td colspan=\"5\" align=\"center\">"
      link = link_to("#{month_name} #{year}", monthly_conclave_events_path(year, month))
      result << link
      result << "</td><td>"
      nav_month = month_first_day + 1.month
      result << link_to_remote(">>", :update => "conclave_calendar", 
                                     :url => calendar_navigation_path(nav_month.year, nav_month.month))
      result << "</td></tr>"

      calendar_starts = calendar_start_date(month_first_day, week_start)
      calendar_ends = calendar_end_date(month_last_day, week_start)
      
      day_names = @abbr_daynames.dup
      week_start.times do
        day_names.push(day_names.shift)
      end   
      result << "<tr>"
      day_names.each do |d|
        result << "<th scope=\"col\"><abbr title=\"#{d}\">#{d[0..1]}</abbr></th>"        
      end    
      result << "</td>"   
            
      counter = 0
      calendar_starts.upto(calendar_ends) do |day|
        if counter == 0
          result << "<tr>" 
          counter = 0
        end
        counter += 1
        
        if has_event?(day, events)
          link = link_to(day.mday, 
                         daily_conclave_events_path(day.year, day.month, day.day))
          result << "<td>#{link}</td>"
        else
          result << "<td>#{day.mday}</td>"
        end
        
        if counter == 7
          result << "</tr>" 
          counter = 0
        end
      end
      result << "</table>"
      result 

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
    
      def calendar_start_date(date, week_start)
        weekday = date.wday
        if weekday >= week_start
          date - (weekday - week_start).days 
        else
          date - (7 - week_start + weekday).days 
        end      
      end
        
      def calendar_end_date(date, week_start)
        weekday = date.wday
        if weekday >= week_start
          date + (6 - weekday + week_start).days
        else
          date + (week_start - weekday - 1).days
        end      
      end
        
  end
  
end
