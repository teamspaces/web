class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :token
      t.integer :recipient_team_member_id
      t.integer :sender_team_member_id

      t.timestamps
    end
  end
end
