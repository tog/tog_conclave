# == Schema Information
# Schema version: 20100614194418
#
# Table name: attendances
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  status     :string(255)     default("pendiente")
#  invitation :boolean
#
class Attendance < ActiveRecord::Base
  
  STATUS_REJECTED = 'rejected'
  STATUS_ACCEPTED = 'accepted'
  STATUS_PENDING  = 'pending'
  
  belongs_to :event
  belongs_to :user
  
  record_activity_of :user
  
  def accept!
    self.status = STATUS_ACCEPTED
    self.save!
  end
  
  def reject!
    self.status = STATUS_REJECTED
    self.save!    
  end
  
  def pending?
    self.status == STATUS_PENDING
  end
  def accepted?
    self.status == STATUS_ACCEPTED
  end
    
end
