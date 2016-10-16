class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.references :space, foreign_key: { on_delete: :cascade }
      t.string :title

      t.timestamps
    end
  end
end
