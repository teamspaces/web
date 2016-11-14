class CreatePageRevisionAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :page_revision_authors do |t|
      t.references :page_revision, foreign_key: { on_delete: :cascade }
      t.references :user, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
