class ChangeForeignKeyTypeOnPageContents < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :page_contents, :pages
    add_foreign_key :page_contents, :pages, on_delete: :cascade
  end
end
