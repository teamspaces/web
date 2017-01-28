class AddWordCountToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :word_count, :integer, default: 0
  end
end
