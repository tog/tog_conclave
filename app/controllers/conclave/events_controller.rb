class Conclave::EventsController < ApplicationController
  include GG
  layout "application", :except => :map
  before_filter :find_event, :only => [:show, :map]
  before_filter :set_dates_for_navigation, :except => [:map]
  
  def index
    @page = params[:page] || '1'
    @asc = params[:asc] || 'asc'
    @events = Event.upcoming.paginate :per_page => 10, :page => @page
  end

  def show
    generate_map
  end
  
  def attendees
    @order = params[:order] || 'login'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'asc'
    @attendees = @event.attendees.paginate :per_page => 10,
                                           :page => @page,
                                           :order => @order + " " + @asc    
  end  
  
  def date    
    month_first_day = Date.civil(@year, @month, @day > 0 ? @day : 1)
    month_last_day = Date.civil(@year, @month, @day)      
    get_events_by_date(['(start_date >= ? and start_date <= ?) or (end_date >= ? and end_date <= ?) or (start_date <= ? and end_date >= ?)', 
                         month_first_day, month_last_day, month_first_day, month_last_day, month_first_day, month_last_day])
  end
  
  def calendar_navigation
    respond_to do |format| 
      format.html { render :partial => "calendar", :locals => {:year => @year, :month => @month}}
    end
  end  
  
  def tag
    @tag  =  params[:tag]
    @events = Event.find_tagged_with(params[:tag])
  end

  def map
    generate_map
  end 
  
  private
  
    def generate_map
      return if !@event.venue_address || @event.venue_address == ''
      loc = gg.locate @event.venue_address
      @map = GMap.new("map_div_id")
      @map.control_init(:large_map => true, :map_type => true)
      @map.center_zoom_init([loc.latitude, loc.longitude],14)
      marker = GMarker.new([loc.latitude,loc.longitude],
               :title => @event.title,
               :info_window => (@event.venue_address ? loc.address : "#{loc.address} *specified address unknown")) 
      @map.overlay_init(marker)
      
    rescue
      @map = nil
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
                           :order => @order + " " + @asc + ', start_time asc').paginate :per_page => 10,
                                                                                        :page => @page
    end
    
    private
      def set_dates_for_navigation
        @year  = params[:year]  ? params[:year].to_i  : Date.today.year
        @month = params[:month] ? params[:month].to_i : Date.today.month
        @day   = params[:day]   ? params[:day].to_i   : -1
      end
end
