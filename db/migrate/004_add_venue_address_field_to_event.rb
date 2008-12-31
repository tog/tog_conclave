class AddVenueAddressFieldToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :venue_address, :string  #field used for geolocation
  end

  def self.down
    remove_column :events, :venue_address
  end
end
