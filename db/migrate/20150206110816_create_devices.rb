class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :key
      t.string :token
      t.string :model
      t.string :version
      t.integer :owner_id

      t.timestamps null: false
    end

    add_index :devices, [:key, :token],      unique: true
    add_index :devices, :owner_id
  end
end