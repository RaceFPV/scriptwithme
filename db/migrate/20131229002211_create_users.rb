class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :remember_token
      t.boolean :admin
      t.timestamps
    end
    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
    add_index :users, :remember_token
  end
end
