class AddParanoiaToModels < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :deleted_at, :datetime
    add_index :authentications, :deleted_at

    add_column :team_authentications, :deleted_at, :datetime
    add_index :team_authentications, :deleted_at

    add_column :invitations, :deleted_at, :datetime
    add_index :invitations, :deleted_at

    add_column :team_members, :deleted_at, :datetime
    add_index :team_members, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at

    add_column :teams, :deleted_at, :datetime
    add_index :teams, :deleted_at

    add_column :spaces, :deleted_at, :datetime
    add_index :spaces, :deleted_at

    add_column :pages, :deleted_at, :datetime
    add_index :pages, :deleted_at

    add_column :page_contents, :deleted_at, :datetime
    add_index :page_contents, :deleted_at
  end
end
