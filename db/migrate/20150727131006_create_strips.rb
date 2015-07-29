class CreateStrips < ActiveRecord::Migration
  def change
    create_table :strips do |t|
      t.integer :device_id
      t.datetime :tested_at
      t.datetime :computed_at
      t.string :model
      t.string :upload_key
      t.string :no2
      t.string :no3
      t.string :gh
      t.string :ph
      t.string :kh

      t.timestamps
    end
    add_index :strips, :device_id
  end
end
