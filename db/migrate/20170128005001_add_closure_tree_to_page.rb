class AddClosureTreeToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :parent_id, :integer
    add_column :pages, :sort_order, :integer
  end
end
