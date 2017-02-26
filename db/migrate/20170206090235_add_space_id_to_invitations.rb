class AddSpaceIdToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :space_id, :integer
    add_foreign_key :invitations, :spaces
  end
end
