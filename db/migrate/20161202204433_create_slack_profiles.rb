class CreateSlackProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_profiles do |t|
      t.string :user_id
      t.string :team_id
      t.string :name
      t.boolean :deleted
      t.string :color
      t.string :first_name
      t.string :last_name
      t.string :real_name
      t.string :email
      t.string :skype
      t.string :phone
      t.string :image_24
      t.string :image_32
      t.string :image_48
      t.string :image_72
      t.string :image_192
      t.string :image_512
      t.boolean :is_admin
      t.boolean :is_owner
      t.boolean :is_primary_owner
      t.boolean :is_restricted
      t.boolean :is_ultra_restricted
      t.boolean :has_2fa
      t.string :two_factor_type
      t.boolean :has_files

      t.timestamps
    end
  end
end
