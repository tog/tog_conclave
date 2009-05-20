class Member::Conclave::EventsController < Member::BaseController
   
  before_filter :find_event, :except => [:index, :new, :create]
  
  def index
    @order = params[:order] || 'title'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'asc'
    @events = current_user.events.paginate :per_page => 10,
                                           :page => @page,
                                           :order => @order + " " + @asc
  end
  
  def show
  end

  def new
    @event = Event.new(:url => "http://")
    @event.capacity = 0
  end
    
  def create
    @event = Event.new(params[:event])
    @event.owner = current_user
    @event.save!
    redirect_to(member_conclave_events_path)
    flash[:ok] = I18n.t("tog_conclave.member.event_created", :title => @event.title)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = I18n.t("tog_conclave.member.error")
    render :action => 'new'
  end

  def update
    @event.update_attributes!(params[:event])
    redirect_to(member_conclave_events_url)
    flash[:ok] = I18n.t("tog_conclave.member.event_updated", :title => @event.title)    
  rescue ActiveRecord::RecordInvalid
    flash[:error] = I18n.t("tog_conclave.member.error")
    render :action => 'edit'
  end
  
  def destroy
    @event.destroy
    flash[:ok]= I18n.t("tog_conclave.member.deleted")
    redirect_to member_conclave_events_path
  end
  
  protected

    def find_event
      @event = current_user.events.find(params[:id]) rescue nil
      if @event.nil?
        flash[:error] = I18n.t("tog_conclave.page_not_found")
        redirect_to member_conclave_events_path
      end
    end
end