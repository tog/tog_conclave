class Event < ActiveRecord::Base
  
  include GG
  acts_as_taggable
  seo_urls
  belongs_to :owner, :class_name =>'User', :foreign_key =>'user_id'
  has_many   :attendances,      :dependent => :destroy
  has_many   :attendees,        :through => :attendances, :source => :user
  validates_presence_of :title, :description, :venue
  
  record_activity_of :user
  
  def register(user)
    params = {:user_id => user.id} 
    return false if self.attendances.find :first, :conditions => params
    self.attendances.create params.merge!({:event => self})
    return true    
  end
  
  def unregister(user)
    Attendance.delete_all( ["user_id = ? and event_id = ?", user.id, self.id])
  end
  
  def available_capacity
    if(self.capacity)
      return self.capacity - self.attendances.size
    else
      return 0
    end
  end
  
  def places_left?
    return available_capacity > 0
  end
  
  protected
    def validate
      if(start_date>end_date or (start_date==end_date and start_time>end_time))
        errors.add("end_date", I18n.t("tog_conclave.fields.errors.end_date_before_start_date"))
      end
      loc = gg.locate self.venue_address rescue nil
      errors.add("venue_address", I18n.t("tog_conclave.fields.errors.venue_address_error")) if loc.nil?
    end

end
