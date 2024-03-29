# This migration comes from authie (originally 20141012174250)
class CreateAuthieSessions < ActiveRecord::Migration
  def change
    create_table :authie_sessions do |t|
      t.string :token, :browser_id
      t.integer :user_id
      t.boolean :active, :default => true
      t.datetime :expires_at
      t.datetime :login_at
      t.string :login_ip
      t.datetime :last_activity_at
      t.string :last_activity_ip, :last_activity_path
      t.string :user_agent
      t.integer :requests, :default => 0
      t.timestamps :null => true
    end
  end
end
