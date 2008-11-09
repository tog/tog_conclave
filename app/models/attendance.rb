class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
  record_activity_of :user
  
end
