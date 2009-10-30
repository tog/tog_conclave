class User < ActiveRecord::Base

  has_many :attendances, :class_name => "Attendance", :dependent => :destroy
  has_many :attended_events, :through => :attendances
  
  has_many :events, :dependent => :destroy
  
end
