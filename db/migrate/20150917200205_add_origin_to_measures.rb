class AddOriginToMeasures < ActiveRecord::Migration
  def change
    add_column :measures, :origin, :string
  end
end
