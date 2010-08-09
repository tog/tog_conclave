class Member::Conclave::InvitationsController < Member::BaseController

  before_filter :find_event, :except => [:new]
  before_filter :check_moderator, :only => [:create]  

  before_filter :find_attendance, :only => [:accept, :reject]
  before_filter :check_invited_user, :only => [:accept, :reject]

  def new
    @user = User.find(params[:user_id])
    @events = current_user.events.upcoming
  end
  
  def create
    att = @event.register(User.find(params[:user]), true)
    Message.new(
      :from => current_user,
      :to   => att.user,
      :subject => "You've been invited to attend #{@event.title}",
      :content => "Hi #{att.user.profile.full_name},<br/><br/>" +
                  "You have been invited to attend <a href=\"#{conclave_event_url(@event)}\">#{@event.title}<a>.<br/>" +
                  "<a href=\"#{accept_member_conclave_event_invitation_path(@event, att)}\">accept<a> <a href=\"#{reject_member_conclave_event_invitation_path(@event, att)}\">reject<a>.<br/><br/>"
    ).dispatch! if att
    flash[:ok] = "User has been invited to #{@event.title}"
    redirect_to :back
  end
  
  def accept
    @attendance.accept!
    Message.new(
      :from => current_user,
      :to   => @event.owner,
      :subject => "#{current_user.profile.full_name} has accepted your invitation to #{@event.title}",
      :content => "Hi #{@event.owner.profile.full_name},<br/><br/>" +
                  "<a href=\"#{profile_path(current_user.profile)}\">#{current_user.profile.full_name}<a> says he is going to attend <a href=\"#{conclave_event_url(@event)}\">#{@event.title}<a>.<br/>"
    ).dispatch!
    flash[:ok] = "You have accepted the invitation"    
    redirect_to :back
  end
  
  def reject
    @attendance.reject!
    Message.new(
      :from => current_user,
      :to   => @event.owner,
      :subject => "#{current_user.profile.full_name} has rejected your invitation to #{@event.title}",
      :content => "Hi #{@event.owner.profile.full_name},<br/><br/>" +
                  "<a href=\"#{profile_path(current_user.profile)}\">#{current_user.profile.full_name}<a> says he can't attentd <a href=\"#{conclave_event_url(@event)}\">#{@event.title}<a>.<br/>"
    ).dispatch!
    flash[:ok] = "You have rejected the invitation"
    redirect_to :back    
  end
  
  protected
  
    def find_event
      @event = Event.find(params[:event_id])
    end
  
    def find_attendance
      @attendance = @event.attendances.find(params[:id])
    end
    
    def check_invited_user
      unless @attendance.user == current_user
        flash[:ok] = "Ey!. Please!"
        redirect_to :back
      end
    end    
    
    def check_moderator
      unless @event.owner == current_user
        flash[:ok] = "Ey!. Please!"
        redirect_to :back
      end
    end  
  
end