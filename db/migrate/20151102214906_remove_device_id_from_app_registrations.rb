class RemoveDeviceIdFromAppRegistrations < ActiveRecord::Migration
  def change
  	remove_column :app_registrations, :device_id
  end
end
