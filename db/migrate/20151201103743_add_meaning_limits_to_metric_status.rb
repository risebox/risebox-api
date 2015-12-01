class AddMeaningLimitsToMetricStatus < ActiveRecord::Migration
  def change
    add_column :metric_statuses, :meaning_min, :float
    add_column :metric_statuses, :meaning_max, :float
  end
end
