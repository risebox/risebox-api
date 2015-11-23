class AddAveragesToMetricStatus < ActiveRecord::Migration
  def change
    add_column :metric_statuses, :hourly_average, :float
    add_column :metric_statuses, :daily_average, :float
    add_column :metric_statuses, :weekly_average, :float
    add_column :metric_statuses, :monthly_average, :float
  end
end
