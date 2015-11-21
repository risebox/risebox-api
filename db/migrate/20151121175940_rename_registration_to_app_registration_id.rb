class RenameRegistrationToAppRegistrationId < ActiveRecord::Migration
  def change
    rename_column :push_tokens, :registration_id, :app_registration_id
    rename_index :push_tokens, 'index_push_tokens_on_registration_id', 'index_push_tokens_on_app_registration_id'
  end
end
