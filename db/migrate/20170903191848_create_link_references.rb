class CreateLinkReferences < ActiveRecord::Migration[5.0]
  def change
    create_table :link_references do |t|
      t.references :page, foreign_key: true
      t.integer :reference_id
      t.string :reference_model

      t.timestamps
    end

    add_index :link_references, [:reference_id, :reference_model]
  end
end
