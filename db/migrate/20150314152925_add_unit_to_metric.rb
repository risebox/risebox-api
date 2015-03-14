class AddUnitToMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :unit, :string
  end
end
