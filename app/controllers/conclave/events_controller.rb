class Conclave::EventsController < ApplicationController
  
  def index
    
  end

  def show
    @event = Event.find params[:id]
  end
  
  def by_date
    @date = params[:date].to_date
    @order = params[:order] || 'start_time'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'asc'
    @events = Event.find(:all,
                         :conditions =>["start_date = ?", @date], 
                         :order => @order + " " + @asc).paginate :per_page => 100,
                                                                 :page => @page
                                        
  end
end
