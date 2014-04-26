class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :user_id
      t.string :friend

      t.timestamps
    end
  end
end
