class AddAllowedEmailDomainsToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :allowed_email_domains, :text, array:true, default: []
  end
end
