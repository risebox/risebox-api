class AddSettingsQueriedAtToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :settings_queried_at, :datetime
  end
end
