class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string      :nickname
      t.references  :scene

      t.timestamps
    end

    add_index :characters, :scene_id
  end
end
