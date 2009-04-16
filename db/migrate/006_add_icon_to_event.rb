

class AddIconToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :icon_file_name,    :string
    add_column :events, :icon_content_type, :string
    add_column :events, :icon_file_size,    :integer
    add_column :events, :icon_updated_at,   :datetime
    
    Event.find(:all).each do |e|
      default_event_icon = File.join(RAILS_ROOT, 'public', 'tog_conclave', 'images', Tog::Config["plugins.tog_conclave.event.image.default"])
      e.icon = File.new(default_event_icon)
      e.save
    end
  end

  def self.down
    remove_column :events, :icon_file_name
    remove_column :events, :icon_content_type
    remove_column :events, :icon_file_size
    remove_column :events, :icon_updated_at
  end
end
