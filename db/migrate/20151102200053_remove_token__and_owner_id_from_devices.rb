class RemoveTokenAndOwnerIdFromDevices < ActiveRecord::Migration
  def change
  	remove_index  :devices, [:key, :token]
  	remove_index  :devices, :owner_id
    remove_column :devices, :token
    remove_column :devices, :owner_id
    add_index     :devices, :key
  end
end
