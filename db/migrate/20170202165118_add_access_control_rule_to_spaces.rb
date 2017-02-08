class AddAccessControlRuleToSpaces < ActiveRecord::Migration[5.0]
  def change
    add_column :spaces, :access_control_rule, :string
  end
end
