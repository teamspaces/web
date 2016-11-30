class AddIndexToTeamSubdomain < ActiveRecord::Migration[5.0]
  def change
    add_index :teams, :subdomain
  end
end
