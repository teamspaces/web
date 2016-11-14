class CreatePageRevisions < ActiveRecord::Migration[5.0]
  def change
    create_table :page_revisions do |t|
      t.references :page, foreign_key: { on_delete: :cascade }
      t.integer :increment_id
      t.boolean :published
      t.datetime :published_at
      t.text :contents

      t.timestamps
    end
  end
end
