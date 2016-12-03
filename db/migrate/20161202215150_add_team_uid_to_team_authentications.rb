class AddTeamUIDToTeamAuthentications < ActiveRecord::Migration[5.0]
  def change
    add_column :team_authentications, :team_uid, :string
  end
end
