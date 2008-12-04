class Conclave::EventsController < ApplicationController
  include GG
  layout "application", :except => :map
  before_filter :find_event, :only => [:show, :map]
  def index
    today = Date.today
    @year  = today.year
    @month = today.month    
    get_events_by_date(["start_date >= ?", today])
  end

  def show
    generate_map
  end
  
  def date
    @year  = params[:year].to_i
    @month = params[:month].to_i
    @day   = params[:day]
    
    if @day.nil?
      month_first_day = Date.civil(@year, @month, 1)
      month_last_day = Date.civil(@year, @month, -1) 
    else
      month_first_day = Date.civil(@year, @month, @day.to_i)
      month_last_day = Date.civil(@year, @month, @day.to_i)      
    end   
    get_events_by_date(['(start_date >= ? and start_date <= ?) or (end_date >= ? and end_date <= ?)', 
                         month_first_day, month_last_day, month_first_day, month_last_day])
  end
  
  def calendar_navigation
    year  = params[:year].to_i
    month = params[:month].to_i
    respond_to do |format| 
      format.html { render :partial => "calendar", :locals => {:year => year, :month => month}}
    end
  end  
  
  def map
    generate_map
  end 


  
  private
  
    def generate_map
      loc = gg.locate @event.venue_address
      @map = GMap.new("map_div_id")
      @map.control_init(:large_map => true, :map_type => true)
      @map.center_zoom_init([loc.latitude, loc.longitude],14)
      marker = GMarker.new([loc.latitude,loc.longitude],
               :title => @event.title,
               :info_window => (@event.venue_address ? loc.address : "#{loc.address} *specified address unknown")) 
      @map.overlay_init(marker)
    end
  
    def find_event
      @event = Event.find params[:id] rescue nil
      if @event.nil?
        flash[:error] = I18n.t("tog_conclave.page_not_found")
        redirect_to conclave_events_path
      end
    end
    
    def get_events_by_date(conditions)
      @order = params[:order] || 'start_date'
      @page = params[:page] || '1'
      @asc = params[:asc] || 'asc'
      @events = Event.find(:all,
                           :conditions => conditions, 
                           :order => @order + " " + @asc + ', start_time asc').paginate :per_page => 100,
                                                                                        :page => @page
    end
end
