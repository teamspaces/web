class RemoveUserIdReferenceFromInvitations < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :invitations, :users
    remove_index :invitations, column: :user_id
    rename_column :invitations, :user_id, :invited_by_user_id
    rename_column :invitations, :invitee_user_id, :invited_user_id
    rename_column :invitations, :slack_user_id, :invited_slack_user_uid
  end
end
