class RenameRegistrationToAppRegistration < ActiveRecord::Migration
  def change
  	rename_table :registrations, :app_registrations
  end
end
