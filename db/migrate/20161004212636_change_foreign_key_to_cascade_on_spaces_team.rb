class ChangeForeignKeyToCascadeOnSpacesTeam < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :spaces, :teams
    add_foreign_key :spaces, :teams, on_delete: :cascade
  end
end
