class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :device_id
      t.integer :user_id
      t.string :token
      t.string :origin
      t.timestamp :made_at

      t.timestamps
    end
    add_index :registrations, :token
  end
end
