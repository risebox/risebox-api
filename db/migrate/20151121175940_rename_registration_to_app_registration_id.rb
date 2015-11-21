class RenameRegistrationToAppRegistrationId < ActiveRecord::Migration
  def change
    remove_index    :push_tokens, :registration_id
    rename_column :push_tokens, :registration_id, :app_registration_id
    add_index  :push_tokens, :app_registration_id
  end
end
