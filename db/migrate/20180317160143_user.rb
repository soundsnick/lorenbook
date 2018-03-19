class User < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.text :password
      t.integer :status

      t.timestamps
    end
  end
end
