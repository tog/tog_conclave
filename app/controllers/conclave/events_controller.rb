class Conclave::EventsController < ApplicationController
  
  def index
    get_events_by_date(["start_date >= ?", Date.today.to_time])
  end

  def show
    @event = Event.find params[:id]
  end
  
  def by_date
    @date = params[:date].to_date
    get_events_by_date(["start_date = ?", @date])
  end
  
  private
  
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
