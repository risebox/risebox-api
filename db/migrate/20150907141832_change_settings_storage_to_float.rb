class ChangeSettingsStorageToFloat < ActiveRecord::Migration
  def change
    change_column :device_settings, :value, :float
  end
end
