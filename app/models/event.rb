class Event < ActiveRecord::Base
  
  include GG
  acts_as_taggable
  seo_urls
  belongs_to :owner, :class_name =>'User', :foreign_key =>'user_id'
  has_many   :attendances,      :dependent => :destroy
  has_many   :attendees,        :through => :attendances, :source => :user
  validates_presence_of :title, :description, :venue
  
  def validate
    loc = gg.locate self.venue_address rescue nil
    errors.add("venue_address", "Event Address not found on map") if loc.nil?
  end
  
  record_activity_of :user
  
  def register(user)
    att = Attendance.find(:first, :conditions => ["user_id = ? and event_id = ?", user.id, self.id])   

    if att.nil?
      registration = Attendance.new
      registration.event = self
      registration.user = user
      registration.save
      return true
    else
      return false
    end
  end
  
  def unregister(user)
    Attendance.delete_all( ["user_id = ? and event_id = ?", user.id, self.id])
  end
  
  def opening_time
    result = "From #{self.start_date.strftime('%m/%d/%Y')} #{self.start_time.strftime('%H:%m')}" 
    result << " to #{self.end_date.strftime('%m/%d/%Y')} #{self.end_time.strftime('%H:%m')}"
    result
  end
  
  def available_capacity
    if(self.capacity)
      return self.capacity - self.attendances.size
    else
      return 0
    end
  end
  
end
