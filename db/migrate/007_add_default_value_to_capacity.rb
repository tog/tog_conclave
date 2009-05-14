class AddDefaultValueToCapacity < ActiveRecord::Migration
  def self.up
    change_column :events, :capacity, :integer, :default => -1
  end

  def self.down
  end
end
