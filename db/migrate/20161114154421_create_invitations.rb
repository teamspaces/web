class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :invitee_user_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
