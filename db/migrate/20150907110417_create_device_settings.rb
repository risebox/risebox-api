class CreateDeviceSettings < ActiveRecord::Migration
  def change
    create_table :device_settings do |t|
      t.integer :device_id
      t.string :key
      t.string :data_type
      t.string :value
      t.datetime :changed_at

      t.timestamps null: false
    end

    add_index :device_settings, :device_id
    add_index :device_settings, [:device_id, :changed_at]
    add_index :device_settings, [:device_id, :key]
  end
end
