class AddCascadeDeleteOnInvitationUserForeignKey < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :invitations, :users
    add_foreign_key :invitations, :users, on_delete: :cascade
  end
end
