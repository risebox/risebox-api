class CreateDevicePermissions < ActiveRecord::Migration
  def change
    create_table :device_permissions do |t|
      t.integer :device_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
    add_index :device_permissions, [:device_id, :user_id], unique: true
  end
end
