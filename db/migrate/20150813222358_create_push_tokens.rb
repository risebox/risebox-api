class CreatePushTokens < ActiveRecord::Migration
  def change
    create_table :push_tokens do |t|
      t.string :token
      t.integer :registration_id
      t.datetime :registered_at
      t.string :platform

      t.timestamps
    end
    add_index :push_tokens, :token
    add_index :push_tokens, :registration_id
  end
end
