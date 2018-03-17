class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.text :description
      t.text :img
      t.text :tags
      t.string :category
      t.text :file

      t.string :timestamps
    end
  end
end