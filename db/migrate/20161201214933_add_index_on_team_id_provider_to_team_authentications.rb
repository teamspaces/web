class AddIndexOnTeamIdProviderToTeamAuthentications < ActiveRecord::Migration[5.0]
  def change
    add_index :team_authentications, [:team_id, :provider]
  end
end
