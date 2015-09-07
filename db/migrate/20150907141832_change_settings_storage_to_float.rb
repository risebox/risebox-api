class ChangeSettingsStorageToFloat < ActiveRecord::Migration
  def change
    change_column :device_settings, :value, 'float USING CAST(value AS float)'
  end
end
