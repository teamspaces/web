class RemoveUserIdReferenceFromInvitations < ActiveRecord::Migration[5.0]
  def change
    remove_reference :invitations, :user, foreign_key: true
    add_foreign_key :invitations, :users, column: :invitee_user_id
  end
end
