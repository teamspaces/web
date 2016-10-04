class DestroySpacesAndCreateSpaces < ActiveRecord::Migration[5.0]
  def change
    drop_table :spaces
    create_table :spaces do |t|
      t.references :team, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
