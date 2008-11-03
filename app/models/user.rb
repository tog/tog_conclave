class User < ActiveRecord::Base
  has_many :attendances, :class_name => "Attendance", :dependent => :destroy
  has_many :events,      :class_name => "Event",       :through => :attendances
end
