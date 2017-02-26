class RebuildPageTree < ActiveRecord::Migration[5.0]
  def change
    Page.rebuild!
  end
end
