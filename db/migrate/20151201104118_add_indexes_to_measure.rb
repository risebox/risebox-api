class AddIndexesToMeasure < ActiveRecord::Migration
  def change
  	remove_index :measures, :device_id
  	remove_index :measures, :metric_id
  	add_index :measures, [:device_id, :metric_id, :taken_at], name: :raw_measures_index
  	add_index :measures, [:device_id, :metric_id, :taken_at, :meaningful], name: :meaningful_measures_index
  end
end
