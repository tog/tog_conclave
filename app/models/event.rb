class Event < ActiveRecord::Base
  acts_as_taggable
  seo_urls
  
  belongs_to :owner, :class_name =>'User', :foreign_key =>'author_id'
  has_many   :attendances,      :dependent => :destroy
  has_many   :attendees,        :through => :attendances, :source => :user
  
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
  
  def available_places
    if(self.total_places)
      return self.total_places - self.attendances.size
    else
      return 0
    end
  end
end
