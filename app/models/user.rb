class User < ActiveRecord::Base
  has_many :attendances, :class_name => "Attendance", :dependent => :destroy
  has_many :events,      :class_name => "Event",       :through => :attendances
  
  def registered?(event)
    @event = events.find(event.id) rescue nil
    @event ? true : false
  end
end
