class AddAllowEmailLoginToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :allow_email_login, :boolean, :default => true
  end
end
