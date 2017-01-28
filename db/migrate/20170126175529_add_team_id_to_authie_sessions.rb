class AddTeamIdToAuthieSessions < ActiveRecord::Migration[5.0]
  def change
    add_column :authie_sessions, :team_id, :integer
    add_index :authie_sessions, [:browser_id, :team_id]
  end
end
