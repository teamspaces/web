class CreatePageContents < ActiveRecord::Migration[5.0]
  def up
    create_table :page_contents do |t|
      t.references :page, foreign_key: true
      t.text :contents
      t.integer :byte_size, default: 0

      t.timestamps
    end

    Page.with_deleted.find_each { |page| page.send(:create_page_content) }
  end

  def down
    drop_table :page_contents
  end
end
