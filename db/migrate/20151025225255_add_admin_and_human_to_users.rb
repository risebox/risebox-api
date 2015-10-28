class AddAdminAndHumanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :human, :boolean, default: true
  end
end
