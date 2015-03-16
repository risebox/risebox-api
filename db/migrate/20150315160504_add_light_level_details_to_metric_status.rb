class AddLightLevelDetailsToMetricStatus < ActiveRecord::Migration
  def change
    add_column :metric_statuses, :level, :string
    add_column :metric_statuses, :light, :string
    add_column :metric_statuses, :description, :string
  end
end
