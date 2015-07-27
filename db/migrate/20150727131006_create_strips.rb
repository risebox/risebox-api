class CreateStrips < ActiveRecord::Migration
  def change
    create_table :strips do |t|
      t.integer :device_id
      t.datetime :tested_at
      t.datetime :computed_at
      t.string :model
      t.string :raw_photo_path
      t.string :wb_photo_path
      t.string :NO2
      t.string :NO3
      t.string :GH
      t.string :PH
      t.string :KH

      t.timestamps
    end
    add_index :strips, :device_id
  end
end
