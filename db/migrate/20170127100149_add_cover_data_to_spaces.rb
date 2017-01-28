class AddCoverDataToSpaces < ActiveRecord::Migration[5.0]
  def change
    add_column :spaces, :cover_data, :jsonb
  end
end
