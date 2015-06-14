class ChangeMeasureValueToFloat < ActiveRecord::Migration
  def change
    change_column :measures, :value, 'float USING CAST(value AS float)'
  end
end
