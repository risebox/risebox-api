class AddMeaningfulToMeasure < ActiveRecord::Migration
  def change
    add_column :measures, :meaningful, :boolean, default: true
  end
end
