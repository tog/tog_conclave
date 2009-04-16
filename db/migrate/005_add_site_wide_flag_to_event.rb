class AddSiteWideFlagToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :site_wide, :boolean, :default => false
    Event.find(:all).each do |e|
      e.site_wide = true
      e.save
    end
  end

  def self.down
    remove_column :events, :site_wide
  end
end
