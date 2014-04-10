class AddUserIdToCharacter < ActiveRecord::Migration
  def change
    change_table :characters do |t|
      t.references :user
    end
  end
end
