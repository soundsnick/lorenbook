class Comments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :postid
      t.integer :author
      t.text :comment

      t.timestamps
    end
  end
end
