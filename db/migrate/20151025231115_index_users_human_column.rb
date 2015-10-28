class IndexUsersHumanColumn < ActiveRecord::Migration
  def change
  	add_index :users, :human
  end
end
