class AddAvatarDataToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_data, :json
  end
end
