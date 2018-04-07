class AddUserIdToCharacter < ActiveRecord::Migration[5.1]
  def change
    change_table :characters do |t|
      t.references :user
    end
  end
end
