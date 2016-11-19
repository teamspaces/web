class AddSubdomainToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :subdomain, :string
  end
end
