class CreateTeamAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :team_authentications do |t|
      t.references :team, foreign_key: true
      t.string :provider
      t.string :token
      t.string :foreign_team_id
      t.string :foreign_user_id
      t.string :scopes, array: true, default: []

      t.timestamps
    end
  end
end
