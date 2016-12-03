class AddSlackUserIdToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :slack_user_id, :string
  end
end
