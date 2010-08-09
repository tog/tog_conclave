class AddInvitationsSupport < ActiveRecord::Migration
  def self.up
    add_column :attendances, :status,   :string, :default => 'accepted'
    add_column :attendances, :invitation, :boolean, :default => false
    add_column :events,      :moderated, :boolean, :default => false
    Event.update_all(:moderated => false)
    Attendance.update_all(:invitation => false)
    Attendance.update_all(:status => 'accepted')
  end

  def self.down
    remove_column :attendances, :accepted
    remove_column :attendances, :invitation
    remove_column :events, :moderated
  end
end
