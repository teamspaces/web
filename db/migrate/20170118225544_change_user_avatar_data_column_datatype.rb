class ChangeUserAvatarDataColumnDatatype < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :avatar_data, :jsonb
  end
end
