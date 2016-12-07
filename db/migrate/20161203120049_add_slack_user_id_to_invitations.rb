class AddSlackUserIdToInvitations < ActiveRecord::Migration[5.0]
  def change
    remove_column :invitations, :slack_id, :string
    add_column :invitations, :slack_user_id, :string
  end
end
