class AddMetricIdToMeasure < ActiveRecord::Migration
  def change
    remove_index :measures, :metric
    remove_column :measures, :metric

    add_column :measures, :metric_id, :integer
    add_index  :measures, :metric_id
  end
end
