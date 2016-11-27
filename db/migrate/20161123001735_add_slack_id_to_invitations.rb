class AddSlackIdToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :slack_id, :string
  end
end
