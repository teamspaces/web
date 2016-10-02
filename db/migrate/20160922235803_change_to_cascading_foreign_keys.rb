class ChangeToCascadingForeignKeys < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :authentications, :users
    remove_foreign_key :team_members, :teams
    remove_foreign_key :team_members, :users

    add_foreign_key :authentications, :users, on_delete: :cascade
    add_foreign_key :team_members, :teams, on_delete: :cascade
    add_foreign_key :team_members, :users, on_delete: :cascade
  end
end
