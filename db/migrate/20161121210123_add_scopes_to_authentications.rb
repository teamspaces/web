class AddScopesToAuthentications < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :scopes, :string, array: true, default: []
  end
end
