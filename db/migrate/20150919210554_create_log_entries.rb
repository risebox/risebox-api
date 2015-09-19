class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.integer :level
      t.text :body
      t.integer :device_id
      t.datetime :logged_at

      t.timestamps null: false
    end

    add_index :log_entries, :device_id
    add_index :log_entries, [:device_id, :logged_at]
  end
end
