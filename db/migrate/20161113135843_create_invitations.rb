class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :team_member, foreign_key: true
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :token

      t.timestamps
    end
  end
end
