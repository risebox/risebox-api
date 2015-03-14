class CreateMetricStatuses < ActiveRecord::Migration
  def change
    create_table :metric_statuses do |t|
      t.integer :device_id
      t.integer :metric_id
      t.float   :value
      t.datetime :taken_at

      t.timestamps null: false
    end

    add_index :metric_statuses, :device_id
    add_index :metric_statuses, [:device_id, :metric_id], unique: true
  end
end
