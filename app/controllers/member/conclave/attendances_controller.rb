class Member::Conclave::AttendancesController < Member::BaseController
  
  before_filter :find_event, :except => [:index]
  before_filter :find_attendance, :only => [:accept, :reject]
  before_filter :check_moderator, :only => [:accept, :reject]
    
  def index
    @order = params[:order] || 'created_at'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'
    @attendances = current_user.attendances.paginate :per_page => 10,
                                                     :page => @page,
                                                     :order => @order + " " + @asc    
  end
    
  def create
    if @event.places_left?
      att = @event.register(current_user)
      if att.accepted? 
        flash[:ok] = I18n.t("tog_conclave.member.registered", :title => @event.title)
      else
        flash[:ok] = I18n.t("tog_conclave.member.registered_pending", :title => @event.title)
      end
    else
      flash[:error] = I18n.t("tog_conclave.member.not_available", :title => @event.title)
    end
    redirect_to(conclave_event_path(@event))
  end
  
  def destroy
    @event.unregister(current_user)
    flash[:ok] = I18n.t("tog_conclave.member.unregistered", :title => @event.title)
    redirect_to(conclave_event_path(@event))
  end
  
  def accept
    @attendance.accept!
    Message.new(
      :from => current_user,
      :to   => @attendance.user,
      :subject => "You've been accepted to attend #{@event.title}",
      :content => "Hi #{@attendance.user.profile.name},<br/><br/>" +
                  "You have been accepted to event <a href=\"#{conclave_event_url(@event)}\">#{@event.title}<a>.<br/>" +
                  "Enjoy it!.<br/><br/>"
    ).dispatch!
    flash[:ok] = "User has been accepted"
    redirect_to :back
  end
  
  def reject
    if @attendance.pending?
      @attendance.reject!
      Message.new(
        :from => current_user,
        :to   => @attendance.user,
        :subject => "You've been rejected for attending #{@event.title}",
        :content => "Hi #{@attendance.user.profile.name},<br/><br/>" +
                    "Unfprtunatly your request for attending <a href=\"#{conclave_event_url(@event)}\">#{@event.title}<a> has been rejected.<br/>"
      ).dispatch!      
      flash[:ok] = "User has been rejected for this event"
    else
      @attendance.destroy
      flash[:ok] = "User has been removed"
    end
    redirect_to :back
  end  

  protected
  
    def find_event
      @event = Event.find(params[:event_id])
    end
  
    def find_attendance
      @attendance = @event.attendances.find(params[:id])
    end
    
    def check_moderator
      unless @event.owner == current_user
        flash[:ok] = "Ey!. Please!"
        redirect_to member_conclave_attendances_path
      end
    end
    
end
