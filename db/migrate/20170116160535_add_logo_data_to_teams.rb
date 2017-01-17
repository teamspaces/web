class AddLogoDataToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :logo_data, :jsonb
  end
end
