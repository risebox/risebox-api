class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.string :metric
      t.string :value
      t.timestamp :taken_at
      t.integer :device_id

      t.timestamps null: false
    end
    add_index :measures, :metric
    add_index :measures, :device_id
  end
end
