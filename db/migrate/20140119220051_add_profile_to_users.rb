class AddProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :favmovie, :string
    add_column :users, :favactor, :string
    add_column :users, :about, :string
  end
end
