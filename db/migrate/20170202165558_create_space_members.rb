class CreateSpaceMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :space_members do |t|
      t.references :team_member, foreign_key: true
      t.references :space, foreign_key: true

      t.timestamps
    end
  end
end
