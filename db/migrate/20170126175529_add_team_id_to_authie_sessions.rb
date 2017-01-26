class AddTeamIdToAuthieSessions < ActiveRecord::Migration[5.0]
  def change
    add_column :authie_sessions, :team_id, :integer
  end
end
