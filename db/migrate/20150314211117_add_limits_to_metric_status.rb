class AddLimitsToMetricStatus < ActiveRecord::Migration
  def change
    add_column :metric_statuses, :limit_min, :float
    add_column :metric_statuses, :limit_max, :float
  end
end
