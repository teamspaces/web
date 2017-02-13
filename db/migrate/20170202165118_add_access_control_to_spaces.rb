class AddAccessControlToSpaces < ActiveRecord::Migration[5.0]
  def change
    add_column :spaces, :access_control, :string
  end
end
