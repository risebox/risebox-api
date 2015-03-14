class ChangeMeasureValueToFloat < ActiveRecord::Migration
  def change
    change_column :measures, :value, :float
  end
end
